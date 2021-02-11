# PSPing written by Ryan Risley
# Version 1.4
# =======================
# Change Log
# -----------------------
# [1.4]
#  - Scrapped workflow and instead leveraged Invoke-Ping by Warren F, modified and included.  This dramatically improves overall speed.  References:
#		http://ramblingcookiemonster.github.io/Invoke-Ping/
#		https://gallery.technet.microsoft.com/scriptcenter/Invoke-Ping-Test-in-b553242a
#  - Updated email reports
#  - Include both IP and HostNames in display.
# [1.3]
#  - Fixed report displaying correctly.
# [1.2]
#  - Fixed Up Report not coming through.
# [1.1]
#  - Added a version number
#  - Added reporting computers that were still down, but only when a computer goes up or down.
#    This should aid in knowing the current status of all computers instead of keeping track yourself.


#-----[Update these values to fit your organization]-----
$Computers = import-csv ".\PSPing.csv"
$AlertByEmail = $true
$SleepSeconds = 15
$TimesDown = 2

if ($AlertByEmail) {
    $emailFrom = "PSPing@YourCompany.com"
    $emailTo = "systemalert@YourCompany.com"
    $subject = "PSPing Notification"
    $smtpServer = "10.0.0.2"
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
}
#-----[\Update these values to fit your organization]-----

#region Invoke-Ping Function
Function Invoke-Ping {
    [cmdletbinding(DefaultParameterSetName = 'Ping')]
    param(
        [Parameter( ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, 
            Position = 0)]
        [string[]]$ComputerName,
        [int]$Timeout = 20,
        [int]$Throttle = 100,
        [switch]$NoCloseOnTimeout
    )
    Begin {
        #http://gallery.technet.microsoft.com/Run-Parallel-Parallel-377fd430
        function Invoke-Parallel {
            [cmdletbinding(DefaultParameterSetName = 'ScriptBlock')]
            Param (   
                [Parameter(Mandatory = $false, position = 0, ParameterSetName = 'ScriptBlock')]
                [System.Management.Automation.ScriptBlock]$ScriptBlock,
                [Parameter(Mandatory = $false, ParameterSetName = 'ScriptFile')]
                [ValidateScript( { test-path $_ -pathtype leaf })]
                $ScriptFile,
                [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                [Alias('CN', '__Server', 'IPAddress', 'Server', 'ComputerName')]	
                [PSObject]$InputObject,
                [PSObject]$Parameter,
                [int]$Throttle = 20,
                [int]$SleepTimer = 200,
                [int]$RunspaceTimeout = 0,
                [switch]$NoCloseOnTimeout = $false,
                [int]$MaxQueue
            )	
            Begin {				
                #No max queue specified?  Estimate one.
                #We use the script scope to resolve an odd PowerShell 2 issue where MaxQueue isn't seen later in the function
                if ( -not $PSBoundParameters.ContainsKey('MaxQueue') ) {
                    if ($RunspaceTimeout -ne 0) { $script:MaxQueue = $Throttle }
                    else { $script:MaxQueue = $Throttle * 3 }
                }
                else {
                    $script:MaxQueue = $MaxQueue
                }
                Write-Verbose "Throttle: '$throttle' SleepTimer '$sleepTimer' runSpaceTimeout '$runspaceTimeout' maxQueue '$maxQueue'"
                #region functions
                Function Get-RunspaceData {
                    [cmdletbinding()]
                    param( [switch]$Wait )
                    #loop through runspaces
                    #if $wait is specified, keep looping until all complete
                    Do {
                        #set more to false for tracking completion
                        $more = $false
                        #Progress bar if we have inputobject count (bound parameter)
                        Write-Progress  -Activity "Running Query" -Status "Starting threads"`
                            -CurrentOperation "$startedCount threads defined - $totalCount input objects - $script:completedCount input objects processed"`
                            -PercentComplete $( Try { $script:completedCount / $totalCount * 100 } Catch { 0 } )
                        #run through each runspace.		   
                        Foreach ($runspace in $runspaces) {					
                            #get the duration - inaccurate
                            $currentdate = Get-Date
                            $runtime = $currentdate - $runspace.startTime
                            $runMin = [math]::Round( $runtime.totalminutes , 2 )
                            #If runspace completed, end invoke, dispose, recycle, counter++
                            If ($runspace.Runspace.isCompleted) {							
                                $script:completedCount++
                                #check if there were errors
                                if ($runspace.powershell.Streams.Error.Count -gt 0) {								
                                    #set the logging info and move the file to completed
                                    foreach ($ErrorRecord in $runspace.powershell.Streams.Error) {
                                        Write-Error -ErrorRecord $ErrorRecord
                                    }
                                }								   
                                #clean up the runspace
                                $runspace.powershell.EndInvoke($runspace.Runspace)
                                $runspace.powershell.dispose()
                                $runspace.Runspace = $null
                                $runspace.powershell = $null
                            }
                            #If runtime exceeds max, dispose the runspace
                            ElseIf ( $runspaceTimeout -ne 0 -and $runtime.totalseconds -gt $runspaceTimeout) {
                                $script:completedCount++
                                $timedOutTasks = $true
                                #cleanup
                                Write-Error "Runspace timed out at $($runtime.totalseconds) seconds for the object:`n$($runspace.object | out-string)"
                                #Depending on how it hangs, we could still get stuck here as dispose calls a synchronous method on the powershell instance
                                if (!$noCloseOnTimeout) { $runspace.powershell.dispose() }
                                $runspace.Runspace = $null
                                $runspace.powershell = $null
                                $completedCount++
                            }
                            #If runspace isn't null set more to true  
                            ElseIf ($null -ne $runspace.Runspace ) {
                                $more = $true
                            }								
                        }
                        #Clean out unused runspace jobs
                        $temphash = $runspaces.clone()
                        $temphash | Where-Object { $Null -eq $_.runspace } | ForEach-Object {
                            $Runspaces.remove($_)
                        }
                        #sleep for a bit if we will loop again
                        if ($PSBoundParameters['Wait']) {
                            Start-Sleep -milliseconds $SleepTimer
                        }
                        #Loop again only if -wait parameter and there are more runspaces to process
                    }
                    while ($more -and $PSBoundParameters['Wait'])				
                    #End of runspace function
                }
                #endregion functions
                #region Init
                if ($PSCmdlet.ParameterSetName -eq 'ScriptFile') {
                    $ScriptBlock = [scriptblock]::Create( $(Get-Content $ScriptFile | out-string) )
                }
                elseif ($PSCmdlet.ParameterSetName -eq 'ScriptBlock') {
                    #Start building parameter names for the param block
                    [string[]]$ParamsToAdd = '$_'
                    if ( $PSBoundParameters.ContainsKey('Parameter') ) {
                        $ParamsToAdd += '$Parameter'
                    }
                    $UsingVariableData = $Null
                    # This code enables $Using support through the AST.
                    # This is entirely from  Boe Prox, and his https://github.com/proxb/PoshRSJob module; all credit to Boe!
                    if ($PSVersionTable.PSVersion.Major -gt 2) {
                        #Extract using references
                        $UsingVariables = $ScriptBlock.ast.FindAll( { $args[0] -is [System.Management.Automation.Language.UsingExpressionAst] }, $True)	
                        If ($UsingVariables) {
                            $List = New-Object 'System.Collections.Generic.List`1[System.Management.Automation.Language.VariableExpressionAst]'
                            ForEach ($Ast in $UsingVariables) {
                                [void]$list.Add($Ast.SubExpression)
                            }
                            $UsingVar = $UsingVariables | Group-Object Parent | ForEach-Object { $_.Group | Select-Object -First 1 }
                            #Extract the name, value, and create replacements for each
                            $UsingVariableData = ForEach ($Var in $UsingVar) {
                                Try {
                                    $Value = Get-Variable -Name $Var.SubExpression.VariablePath.UserPath -ErrorAction Stop
                                    $NewName = ('$__using_{0}' -f $Var.SubExpression.VariablePath.UserPath)
                                    [pscustomobject]@{
                                        Name       = $Var.SubExpression.Extent.Text
                                        Value      = $Value.Value
                                        NewName    = $NewName
                                        NewVarName = ('__using_{0}' -f $Var.SubExpression.VariablePath.UserPath)
                                    }
                                    $ParamsToAdd += $NewName
                                }
                                Catch {
                                    Write-Error "$($Var.SubExpression.Extent.Text) is not a valid Using: variable!"
                                }
                            }
                            $NewParams = $UsingVariableData.NewName -join ', '
                            $Tuple = [Tuple]::Create($list, $NewParams)
                            $bindingFlags = [Reflection.BindingFlags]"Default,NonPublic,Instance"
                            $GetWithInputHandlingForInvokeCommandImpl = ($ScriptBlock.ast.gettype().GetMethod('GetWithInputHandlingForInvokeCommandImpl', $bindingFlags))
                            $StringScriptBlock = $GetWithInputHandlingForInvokeCommandImpl.Invoke($ScriptBlock.ast, @($Tuple))
                            $ScriptBlock = [scriptblock]::Create($StringScriptBlock)
                            Write-Verbose $StringScriptBlock
                        }
                    }
                    $ScriptBlock = $ExecutionContext.InvokeCommand.NewScriptBlock("param($($ParamsToAdd -Join ", "))`r`n" + $Scriptblock.ToString())
                }
                else {
                    Throw "Must provide ScriptBlock or ScriptFile"; Break
                }
                Write-Debug "`$ScriptBlock: $($ScriptBlock | Out-String)"
                Write-Verbose "Creating runspace pool and session states"
                #If specified, add variables and modules/snapins to session state
                $sessionstate = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
                #Create runspace pool
                $runspacepool = [runspacefactory]::CreateRunspacePool(1, $Throttle, $sessionstate, $Host)
                $runspacepool.Open() 
                Write-Verbose "Creating empty collection to hold runspace jobs"
                $Script:runspaces = New-Object System.Collections.ArrayList		
                #If inputObject is bound get a total count and set bound to true
                $global:__bound = $false
                $allObjects = @()
                if ( $PSBoundParameters.ContainsKey("inputObject") ) {
                    $global:__bound = $true
                }
                $timedOutTasks = $false
                #endregion INIT
            }
            Process {
                #add piped objects to all objects or set all objects to bound input object parameter
                if ( -not $global:__bound ) {
                    $allObjects += $inputObject
                }
                else {
                    $allObjects = $InputObject
                }
            }
            End {
                #Use Try/Finally to catch Ctrl+C and clean up.
                Try {
                    #counts for progress
                    $totalCount = $allObjects.count
                    $script:completedCount = 0
                    $startedCount = 0
                    foreach ($object in $allObjects) {		
                        #region add scripts to runspace pool
                        #Create the powershell instance, set verbose if needed, supply the scriptblock and parameters
                        $powershell = [powershell]::Create()
                        if ($VerbosePreference -eq 'Continue') {
                            [void]$PowerShell.AddScript( { $VerbosePreference = 'Continue' })
                        }
                        [void]$PowerShell.AddScript($ScriptBlock).AddArgument($object)
                        if ($parameter) {
                            [void]$PowerShell.AddArgument($parameter)
                        }
                        # $Using support from Boe Prox
                        if ($UsingVariableData) {
                            Foreach ($UsingVariable in $UsingVariableData) {
                                Write-Verbose "Adding $($UsingVariable.Name) with value: $($UsingVariable.Value)"
                                [void]$PowerShell.AddArgument($UsingVariable.Value)
                            }
                        }
                        #Add the runspace into the powershell instance
                        $powershell.RunspacePool = $runspacepool
                        #Create a temporary collection for each runspace
                        $temp = "" | Select-Object PowerShell, StartTime, object, Runspace
                        $temp.PowerShell = $powershell
                        $temp.StartTime = Get-Date
                        $temp.object = $object
                        #Save the handle output when calling BeginInvoke() that will be used later to end the runspace
                        $temp.Runspace = $powershell.BeginInvoke()
                        $startedCount++
                        #Add the temp tracking info to $runspaces collection
                        Write-Verbose ( "Adding {0} to collection at {1}" -f $temp.object, $temp.starttime.tostring() )
                        $runspaces.Add($temp) | Out-Null
                        #loop through existing runspaces one time
                        Get-RunspaceData
                        #If we have more running than max queue (used to control timeout accuracy)
                        #Script scope resolves odd PowerShell 2 issue
                        $firstRun = $true
                        while ($runspaces.count -ge $Script:MaxQueue) {
                            #give verbose output
                            if ($firstRun) {
                                Write-Verbose "$($runspaces.count) items running - exceeded $Script:MaxQueue limit."
                            }
                            $firstRun = $false
                            #run get-runspace data and sleep for a short while
                            Get-RunspaceData
                            Start-Sleep -Milliseconds $sleepTimer
                        }
                        #endregion add scripts to runspace pool
                    }
                    Write-Verbose ( "Finish processing the remaining runspace jobs: {0}" -f ( @($runspaces | Where-Object { $Null -ne $_.Runspace }).Count) )
                    Get-RunspaceData -wait
                    Write-Progress -Activity "Running Query" -Status "Starting threads" -Completed
                }
                Finally {
                    #Close the runspace pool, unless we specified no close on timeout and something timed out
                    if ( ($timedOutTasks -eq $false) -or ( ($timedOutTasks -eq $true) -and ($noCloseOnTimeout -eq $false) ) ) {
                        Write-Verbose "Closing the runspace pool"
                        $runspacepool.close()
                    }
                    #collect garbage
                    [gc]::Collect()
                }	   
            }
        }
        Write-Verbose "PSBoundParameters = $($PSBoundParameters | Out-String)"
        $bound = $PSBoundParameters.keys -contains "ComputerName"
        if (-not $bound) {
            [System.Collections.ArrayList]$AllComputers = @()
        }
    }
    Process {
        #Handle both pipeline and bound parameter.  We don't want to stream objects, defeats purpose of parallelizing work
        if ($bound) {
            $AllComputers = $ComputerName
        }
        Else {
            foreach ($Computer in $ComputerName) {
                $AllComputers.add($Computer) | Out-Null
            }
        }
    }
    End {
        #Run everything in parallel
        $splat = @{
            Throttle        = $Throttle
            RunspaceTimeout = $Timeout
            InputObject     = $AllComputers
        }
        if ($NoCloseOnTimeout) {
            $splat.add('NoCloseOnTimeout', $True)
        }
        Invoke-Parallel @splat -ScriptBlock {		
            $computer = $_.trim()
            $result = $null
            $result = @(Test-Connection -ComputerName $computer -Count 1 -erroraction SilentlyContinue)
            if ($null -eq $result.ResponseTime) {
                $ResponseTime = -1
                $Address = $computer
            }
            else {
                $ResponseTime = $Result.ResponseTime
            }
            $Output = "" | Select-Object Address, ResponseTime
            $Output.Address = $computer
            $Output.ResponseTime = $ResponseTime
            $Output
        }
    }
}
#end region Invoke-Ping Function

$HostHistory = @()
foreach ($computer in $computers) {
    $HostHistory += , @($computer.ip, 0)
}

Clear-Host
$spaceadd = @("", " ", "  ", "   ", "    ", "     ", "      ")
while ($true) {
    $Time = Get-Date
    $pingresult = $computers.IP | invoke-ping
    $upreport = @()
    $downreport = @()
    $stilldownreport = @()
    clear-host
    foreach ($item in $pingresult) {
        #re-associate with computer name
        foreach ($computer in $computers) {
            if ($computer.ip -eq $item.Address) {
                $ThisHost = $computer.systemname
                break
            }
        }
        $downcount = 0
        $responsetimetext = $spaceadd[6 - $item.responsetime.tostring().length] + $item.responsetime + " ms"	
        if ($item.responsetime -eq -1) {
            for ($i = 0; $i -le $HostHistory.count - 1; $i++) {
                if ($item.Address -eq $HostHistory[$i][0]) {
                    $HostHistory[$i][1] += 1
                    $downcount = $HostHistory[$i][1]
                    if ($HostHistory[$i][1] -eq $TimesDown) {
                        $downreport += $item.Address
                    }
                    elseif ($HostHistory[$i][1] -gt $TimesDown) {
                        $stilldownreport += $item.Address
                    }
                    break
                }			
            }		
            write-host $Time `t "  -!-" `t $downcount `t $item.Address `t $ThisHost -foregroundcolor "red"
        }
        else {
            for ($i = 0; $i -le $HostHistory.count - 1; $i++) {
                if ($item.Address -eq $HostHistory[$i][0]) {
                    if ($HostHistory[$i][1] -ge $timesdown) {
                        $upreport += $item.Address
                    }
                    $HostHistory[$i][1] = 0					
                    break
                }			
            }		
            write-host $Time $responsetimetext `t "0" `t $item.Address `t $ThisHost -foregroundcolor "white"
        }			
    }
    if (($AlertByEmail) -and (($null -ne $upreport) -or ($null -ne $downreport))) {
        $report = ""
        if ($null -ne $upreport) {
            $report += "The following computers are now responding:`n================================================="
            foreach ($up in $upreport) {
                $report += "`n" + $up
            }
            $report += "`n`n"
        }
        if ($null -ne $downreport) {	
            $report += "The following computers are no longer responding:`n================================================="
            foreach ($down in $downreport) {
                $report += "`n" + $down
            }
            $report += "`n`n"
        }
        $report += "The following computers are still not responding:`n================================================="
        foreach ($still in $stilldownreport) {
            $report += "`n" + $still
        }
        $smtp.Send($emailFrom, $emailTo, $subject, $report)
    }
    write-host "================================================================================"
    $CurPos = $host.UI.RawUI.CursorPosition 
    for ($i = $SleepSeconds; $i -gt 0; $i--) {
        $host.UI.RawUI.CursorPosition = $CurPos
        Write-output "                        "
        $host.UI.RawUI.CursorPosition = $CurPos
        Write-output "Next round in $i seconds"
        Start-Sleep 1
    }
    $host.UI.RawUI.CursorPosition = $CurPos
    Write-output "                        "
    $host.UI.RawUI.CursorPosition = $CurPos
    Write-output "Update in progress..."
}