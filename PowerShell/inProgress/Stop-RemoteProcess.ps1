#requires -version 5.1

Function Stop-RemoteProcess {

    #TODO: Create help documentation

    [cmdletbinding(DefaultParameterSetName = "computer")]
    Param(
        [Parameter(
            ParameterSetName = "computer",
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the name of a computer to query. The default is the local host."
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("cn")]
        [string[]]$ComputerName,
        [Parameter(
            ParameterSetName = "computer",
            HelpMessage = "Enter a credential object or username."
        )]
        [Alias("RunAs")]
        [PSCredential]$Credential,
        [Parameter(ParameterSetName = "computer")]
        [switch]$UseSSL,

        [Parameter(
            ParameterSetName = "session",
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Runspaces.PSSession[]]$Session,

        [ValidateScript( { $_ -ge 0 })]
        [int32]$ThrottleLimit = 32,

        [Parameter(Mandatory, HelpMessage = "Specify the process to stop.")]
        [ValidateNotNullOrEmpty()]
        [string]$ProcessName,

        [Parameter(HelpMessage = "Write the stopped process to the pipeline")]
        [switch]$Passthru,

        [Parameter(HelpMessage = "Run the remote command with -WhatIf")]
        [switch]$WhatIfRemote
    )
    DynamicParam {
        #Add an SSH dynamic parameter if in PowerShell 7
        if ($isCoreCLR) {

            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

            #a CSV file with dynamic parameters to create
            #this approach doesn't take any type of parameter validation into account
            $data = @"
Name,Type,Mandatory,Default,Help
HostName,string[],1,,"Enter the remote host name."
UserName,string,0,,"Enter the remote user name."
Subsystem,string,0,"powershell","The name of the ssh subsystem. The default is powershell."
Port,int32,0,,"Enter an alternate SSH port"
KeyFilePath,string,0,,"Specify a key file path used by SSH to authenticate the user"
SSHTransport,switch,0,,"Use SSH to connect."
"@

            $data | ConvertFrom-Csv | ForEach-Object -begin { } -process {
                $attributes = New-Object System.Management.Automation.ParameterAttribute
                $attributes.Mandatory = ([int]$_.mandatory) -as [bool]
                $attributes.HelpMessage = $_.Help
                $attributes.ParameterSetName = "SSH"
                $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
                $attributeCollection.Add($attributes)
                $dynParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter($_.name, $($_.type -as [type]), $attributeCollection)
                $dynParam.Value = $_.Default
                $paramDictionary.Add($_.name, $dynParam)
            } -end {
                return $paramDictionary
            }
        }
    } #dynamic param

    Begin {
        #capture the start time. The Verbose messages can display a timespan.
        $start = Get-Date
        #the first verbose message uses a pseudo timespan to reflect the idea we're just starting
        Write-Verbose "[00:00:00.0000000 BEGIN  ] Starting $($myinvocation.mycommand)"

        #a script block to be run remotely
        Write-Verbose "[$(New-TimeSpan -start $start) BEGIN  ] Defining the scriptblock to be run remotely"

        $sb = {
            param([string]$ProcessName, [bool]$Passthru, [string]$VerbPref = "SilentlyContinue", [bool]$WhatPref)

            $VerbosePreference = $VerbPref
            $WhatIfPreference = $WhatPref

            Try {
                Write-Verbose "[$(New-TimeSpan -start $using:start) REMOTE ] Getting Process $ProcessName on $([System.Environment]::MachineName)"
                $procs = Get-Process -Name $ProcessName -ErrorAction stop
                Try {
                    Write-Verbose "[$(New-TimeSpan -start $using:start) REMOTE ] Stopping $($procs.count) Processes on $([System.Environment]::MachineName)"
                    $procs | Stop-Process -ErrorAction Stop -PassThru:$Passthru
                }
                Catch {
                    Write-Warning "[$(New-TimeSpan -start $using:start) REMOTE ] Failed to stop Process $ProcessName on $([System.Environment]::MachineName). $($_.Exception.message)."
                }
            }
            Catch {
                Write-Verbose "[$(New-TimeSpan -start $using:start) REMOTE ] Process $ProcessName not found on $([System.Environment]::MachineName)"
            }

        } #scriptblock

        #parameters to splat to Invoke-Command
        Write-Verbose "[$(New-TimeSpan -start $start) BEGIN  ] Defining parameters for Invoke-Command"

        #remove my parameters from PSBoundparameters because they can't be used with New-PSSession
        $myparams = "ProcessName", "WhatIfRemote", "passthru"
        foreach ($my in $myparams) {
            if ($PSBoundParameters.ContainsKey($my)) {
                [void]($PSBoundParameters.remove($my))
            }
        }

        $icmParams = @{
            Scriptblock      = $sb
            #I added the relevant parameters from the function
            Argumentlist     = @($ProcessName, $Passthru, $VerbosePreference, $WhatIfRemote)
            HideComputerName = $False
            ThrottleLimit    = $ThrottleLimit
            ErrorAction      = "Stop"
            Session          = $null
        }

        #initialize an array to hold session objects
        [System.Management.Automation.Runspaces.PSSession[]]$All = @()

        If ($Credential.username) {
            Write-Verbose "[$(New-TimeSpan -start $start) BEGIN  ] Using alternate credential for $($credential.username)"
        }

    } #begin

    Process {
        Write-Verbose "[$(New-TimeSpan -start $start) PROCESS] Detected parameter set $($pscmdlet.ParameterSetName)."
        #Write-Verbose "[$(New-TimeSpan -start $start) PROCESS] Detected PSBoundParameters:`n$($PSBoundParameters | Out-String)"

        $remotes = @()
        if ($PSCmdlet.ParameterSetName -match "computer|ssh") {
            if ($pscmdlet.ParameterSetName -eq 'ssh') {
                $remotes += $PSBoundParameters.HostName
                $param = "HostName"
            }
            else {
                $remotes += $PSBoundParameters.ComputerName
                $param = "ComputerName"
            }

            foreach ($remote in $remotes) {
                $PSBoundParameters[$param] = $remote
                $PSBoundParameters["ErrorAction"] = "Stop"
                Try {
                    #create a session one at a time to better handle errors
                    Write-Verbose "[$(New-TimeSpan -start $start) PROCESS] Creating a temporary PSSession to $remote"
                    #save each created session to $tmp so it can be removed at the end
                    #TODO: If your function will add parameters they will need to be removed from $PSBoundParamters or you will need to adjust the the command to create the New-PSSession
                    $all += New-PSSession @PSBoundParameters -OutVariable +tmp
                } #Try
                Catch {
                    #TODO: Decide what you want to do when the new session fails
                    Write-Warning "Failed to create session to $remote. $($_.Exception.Message)."
                    #Write-Error $_
                } #catch
            } #foreach remote
        }
        Else {
            #only add open sessions
            foreach ($sess in $session) {
                if ($sess.state -eq 'opened') {
                    Write-Verbose "[$(New-TimeSpan -start $start) PROCESS] Using session for $($sess.ComputerName.toUpper())"
                    $all += $sess
                } #if open
            } #foreach session
        } #else sessions
    } #process

    End {

        $icmParams["session"] = $all

        Try {
            Write-Verbose "[$(New-TimeSpan -start $start) END    ] Querying $($all.count) computers"

            Invoke-Command @icmParams | ForEach-Object {
                #TODO: PROCESS RESULTS FROM EACH REMOTE CONNECTION IF NECESSARY
                $_
            } #foreach result
        } #try
        Catch {
            Write-Error $_
        } #catch

        if ($tmp) {
            Write-Verbose "[$(New-TimeSpan -start $start) END    ] Removing $($tmp.count) temporary PSSessions"
            $tmp | Remove-PSSession
        }
        Write-Verbose "[$(New-TimeSpan -start $start) END    ] Ending $($myinvocation.mycommand)"
    } #end
} #close function
