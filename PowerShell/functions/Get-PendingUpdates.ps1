Function Get-PendingUpdates {
    <#
  .SYNOPSIS
    Retrieves the updates waiting to be installed from WSUS
  .DESCRIPTION
    Retrieves the updates waiting to be installed from WSUS
  .PARAMETER Computer
    Computer or computers to find updates for.
  .EXAMPLE
   Get-PendingUpdates

   Description
   -----------
   Retrieves the updates that are available to install on the local system
  .NOTES
  Author: Boe Prox
  Date Created: 05Mar2011
#>

    #Requires -version 2.0
    [CmdletBinding(
        DefaultParameterSetName = 'computer'
    )]
    param(
        [Parameter(
            Mandatory = $False,
            ParameterSetName = '',
            ValueFromPipeline = $True)]
        [string[]]$Computer
    )
    Begin {
        $scriptdir = { Split-Path $MyInvocation.ScriptName -Parent }
        Write-Verbose "Location of function is: $(&$scriptdir)"
        $psBoundParameters.GetEnumerator() | ForEach-Object { Write-Verbose "Parameter: $_" }
        If (!$PSBoundParameters['computer']) {
            Write-Verbose "No computer name given, using local computername"
            [string[]]$computer = $Env:Computername
        }
        #Create container for Report
        Write-Verbose "Creating report collection"
        $report = @()
    }
    Process {
        ForEach ($c in $Computer) {
            Write-Verbose "Computer: $($c)"
            If (Test-Connection -ComputerName $c -Count 1 -Quiet) {
                Try {
                    #Create Session COM object
                    Write-Verbose "Creating COM object for WSUS Session"
                    $updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session", $c))
                }
                Catch {
                    Write-Warning "$($Error[0])"
                    Break
                }

                #Configure Session COM Object
                Write-Verbose "Creating COM object for WSUS update Search"
                $updatesearcher = $updatesession.CreateUpdateSearcher()

                #Configure Searcher object to look for Updates awaiting installation
                Write-Verbose "Searching for WSUS updates on client"
                $searchresult = $updatesearcher.Search("IsInstalled=0")

                #Verify if Updates need installed
                Write-Verbose "Verifing that updates are available to install"
                If ($searchresult.Updates.Count -gt 0) {
                    #Updates are waiting to be installed
                    Write-Verbose "Found $($searchresult.Updates.Count) update\s!"
                    #Cache the count to make the For loop run faster
                    $count = $searchresult.Updates.Count

                    #Begin iterating through Updates available for installation
                    Write-Verbose "Iterating through list of updates"
                    For ($i = 0; $i -lt $Count; $i++) {
                        #Create object holding update
                        $update = $searchresult.Updates.Item($i)

                        #Verify that update has been downloaded
                        Write-Verbose "Checking to see that update has been downloaded"
                        If ($update.IsDownLoaded -eq "True") {
                            Write-Verbose "Auditing updates"
                            $temp = "" | Select Computer, Title, KB, IsDownloaded
                            $temp.Computer = $c
                            $temp.Title = ($update.Title -split ('\('))[0]
                            $temp.KB = (($update.title -split ('\('))[1] -split ('\)'))[0]
                            $temp.IsDownloaded = "True"
                            $report += $temp
                        }
                        Else {
                            Write-Verbose "Update has not been downloaded yet!"
                            $temp = "" | Select Computer, Title, KB, IsDownloaded
                            $temp.Computer = $c
                            $temp.Title = ($update.Title -split ('\('))[0]
                            $temp.KB = (($update.title -split ('\('))[1] -split ('\)'))[0]
                            $temp.IsDownloaded = "False"
                            $report += $temp
                        }
                    }

                }
                Else {
                    #Nothing to install at this time
                    Write-Verbose "No updates to install."

                    #Create Temp collection for report
                    $temp = "" | Select Computer, Title, KB, IsDownloaded
                    $temp.Computer = $c
                    $temp.Title = "NA"
                    $temp.KB = "NA"
                    $temp.IsDownloaded = "NA"
                    $report += $temp
                }
            }
            Else {
                #Nothing to install at this time
                Write-Warning "$($c): Offline"

                #Create Temp collection for report
                $temp = "" | Select Computer, Title, KB, IsDownloaded
                $temp.Computer = $c
                $temp.Title = "NA"
                $temp.KB = "NA"
                $temp.IsDownloaded = "NA"
                $report += $temp
            }
        }
    }
    End {
        Write-Output $report
    }
}
