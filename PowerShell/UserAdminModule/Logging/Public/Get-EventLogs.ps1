<#
.SYNOPSIS
Retrieves event logs from a specified computer.

.DESCRIPTION
The Get-EventLogs function retrieves event logs from a specified computer. It uses the Get-WinEvent cmdlet to retrieve the logs and returns the log information as a collection of custom objects.

.PARAMETER ComputerName
The name of the computer from which to retrieve the event logs.

.PARAMETER LogName
The name of the event log to retrieve. By default, all event logs are retrieved.

.EXAMPLE
Get-EventLogs -ComputerName "Server01" -LogName "Application"
Retrieves the "Application" event log from the "Server01" computer.

.EXAMPLE
Get-EventLogs -ComputerName "Server02"
Retrieves all event logs from the "Server02" computer.

#>
function Get-EventLogs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $false)]
        [string]$LogName = '*'
    )

    try {
        $logs = Get-WinEvent -ComputerName $ComputerName -ListLog $LogName -ErrorAction Stop
        $logs | ForEach-Object {
            [PSCustomObject]@{
                LogName            = $_.LogName
                LogType            = $_.LogType
                LogIsolation       = $_.LogIsolation
                IsEnabled          = $_.IsEnabled
                IsClassicLog       = $_.IsClassicLog
                LogFilePath        = $_.LogFilePath
                LogMode            = $_.LogMode
                MaximumSizeInBytes = $_.MaximumSizeInBytes
                RecordCount        = $_.RecordCount
                OldestRecordNumber = $_.OldestRecordNumber
                ProviderNames      = $_.ProviderNames
            }
        }
    }
    catch {
        Write-Output $_.Exception.Message
    }
}
