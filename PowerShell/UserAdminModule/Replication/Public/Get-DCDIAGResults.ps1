<#
.SYNOPSIS
    Collects diagnostic results for domain controllers using various tools.

.DESCRIPTION
    The Get-DCDiagResults function collects diagnostic results for domain controllers using various tools such as DCDiag, DSQuery, RepAdmin, and ADReplication. It generates reports for each domain controller and saves them to the specified output directory.

.PARAMETER Domain
    Specifies the domain for which to collect diagnostic results.

.PARAMETER OutputDirectory
    Specifies the directory where the diagnostic reports will be saved.

.PARAMETER All
    Indicates whether to collect diagnostic results for all domain controllers in the domain. If not specified, only the current domain controller will be processed.

.PARAMETER DCDiag
    Indicates whether to run DCDiag tool for each domain controller.

.PARAMETER DSQuery
    Indicates whether to run DSQuery tool for each domain controller.

.PARAMETER RepAdmin
    Indicates whether to run RepAdmin tool for each domain controller.

.PARAMETER ADReplication
    Indicates whether to run ADReplication tool for each domain controller.

.EXAMPLE
    Get-DCDiagResults -Domain "contoso.com" -OutputDirectory "C:\Reports" -All

    This example collects diagnostic results for all domain controllers in the "contoso.com" domain and saves the reports to the "C:\Reports" directory.

.NOTES
    Author: Your Name
    Date:   Current Date
#>

function Get-DCDiagResults {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Domain,

        [Parameter(Mandatory=$true)]
        [string]$OutputDirectory,

        [switch]$All,
        [switch]$DCDiag,
        [switch]$DSQuery,
        [switch]$RepAdmin,
        [switch]$ADReplication
    )

    # Rest of the code...
}
function Get-DCDiagResults {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Domain,

        [Parameter(Mandatory=$true)]
        [string]$OutputDirectory,

        [switch]$All,
        [switch]$DCDiag,
        [switch]$DSQuery,
        [switch]$RepAdmin,
        [switch]$ADReplication
    )

    # Ensure output directory exists
    if (-not (Test-Path -Path $OutputDirectory)) {
        try {
            New-Item -Path $OutputDirectory -ItemType Directory -Force | Out-Null
        }
        catch {
            Write-Error "Failed to create output directory: $_"
            return
        }
    }

    $DCList = Get-ADDomainController -Filter * -Server $Domain
    $totalDCs = $DCList.Count
    $currentIndex = 0

    foreach ($DC in $DCList) {
        $currentIndex++
        $percentComplete = [math]::Round(($currentIndex / $totalDCs) * 100)
        $FileDate = Get-Date -Format "dd-MM-yyyy-HH-mm-ss"
        $ServerName = $DC.Name

        Write-Progress -Activity "Processing domain controllers" -Status "$currentIndex out of $totalDCs" -PercentComplete $percentComplete

        if ($All -or $DCDiag) {
            Write-Progress -Activity "Running DCDiag for $ServerName" -Status "Processing DCDiag" -PercentComplete $percentComplete
            try {
                dcdiag.exe /s:$ServerName /c /e /v | Out-File -FilePath "$OutputDirectory\AD-dcdiag-report-$ServerName-$FileDate.txt"
                dcdiag.exe /s:$ServerName /test:dns /v | Out-File -FilePath "$OutputDirectory\DCDIAGdns-$ServerName-$FileDate.txt"
            }
            catch {
                Write-Error "Failed to run DCDiag on $($ServerName): $_"
            }
        }

        if ($All -or $DSQuery) {
            Write-Progress -Activity "Running DSQuery for $ServerName" -Status "Processing DSQuery" -PercentComplete $percentComplete
            try {
                dsquery server -o rdn | Out-File -FilePath "$OutputDirectory\list-all-DCs-$ServerName-$FileDate.txt"
            }
            catch {
                Write-Error "Failed to run DSQuery on $($ServerName): $_"
            }
        }

        if ($All -or $RepAdmin) {
            Write-Progress -Activity "Running RepAdmin for $ServerName" -Status "Processing RepAdmin" -PercentComplete $percentComplete
            $repAdminCommands = @(
                "/showrepl *",
                "/replsummary",
                "/showbackup *",
                "/queue *",
                "/bridgeheads * /verbose",
                "/istg * /verbose",
                "/failcache *",
                "/showtrust *",
                "/bind *",
                "/kcc *",
                "/syncall /APed"
            )
            foreach ($cmd in $repAdminCommands) {
                try {
                    $outputFile = "$OutputDirectory\$($cmd -replace '[/\*]', '')-$ServerName-$FileDate.txt"
                    repadmin $cmd | Out-File -FilePath $outputFile
                }
                catch {
                    Write-Error "Failed to run RepAdmin command '$cmd' on $($ServerName): $_"
                }
            }
        }

        if ($All -or $ADReplication) {
            Write-Progress -Activity "Running ADReplication for $ServerName" -Status "Processing ADReplication" -PercentComplete $percentComplete
            try {
                $ADReplicationResult = Get-ADReplicationUpToDatenessVectorTable -Target $ServerName
                $ADReplicationResult | Out-File -FilePath "$OutputDirectory\ADReplication-$ServerName-$FileDate.txt"
                $ADReplicationResult | Sort-Object LastReplicationSuccess | Out-File -FilePath "$OutputDirectory\ADReplicationSorted-$ServerName-$FileDate.txt"
            }
            catch {
                Write-Error "Failed to get ADReplication results for $($ServerName): $_"
            }
        }
    }

    Write-Verbose "Completed diagnostic results collection."
    Write-Progress -Activity "Processing complete" -Status "All tasks completed" -Completed
}
