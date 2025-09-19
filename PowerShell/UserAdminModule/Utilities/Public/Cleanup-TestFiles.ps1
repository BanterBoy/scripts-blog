function Cleanup-TestFiles {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$LogFiles
    )

    foreach ($logFile in $LogFiles) {
        Write-Verbose "Processing log file: $logFile"

        if (-not (Test-Path -Path $logFile)) {
            Write-Warning "Log file not found: $logFile"
            continue
        }

        $logData = Get-Content -Path $logFile | ConvertFrom-Json

        foreach ($entry in $logData) {
            $server = $entry.ServerName
            $filePath = $entry.FullName

            if (-not $filePath) {
                Write-Warning "No file path specified in log entry for server: $server"
                continue
            }

            $destinationPath = "\\$server\C$\Temp\$($entry.FileName)"
            Write-Verbose "Attempting to remove file: $destinationPath on server: $server"

            if ($PSCmdlet.ShouldProcess($destinationPath, "Remove file")) {
                try {
                    Remove-Item -Path $destinationPath -Force -ErrorAction Stop
                    Write-Verbose "File removed successfully: $destinationPath"
                } catch [System.Management.Automation.ItemNotFoundException] {
                    Write-Warning "File not found: $destinationPath. It may have already been deleted."
                } catch {
                    Write-Error "Failed to remove file: $destinationPath. $_"
                }
            }
        }
    }
}

# Example usage
# $logFiles = Get-ChildItem -Path "C:\Temp\TrainingGround" -Filter "CopyLog-*.json" | Select-Object -ExpandProperty FullName
# Cleanup-TestFiles -LogFiles $logFiles -Verbose -WhatIf
