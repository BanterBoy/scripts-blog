Function Log-Event {
    <#
    .SYNOPSIS
    A function to log events.

    .DESCRIPTION
    This function writes an event to the event log.

    .PARAMETER logName
    The name of the log where the event will be written. Default is "NinjaOneDeployments".

    .PARAMETER source
    The source of the event. Default is "NinjaOneScripts".

    .PARAMETER entryType
    The type of the event. Must be one of "Error", "Warning", "Information", "SuccessAudit", "FailureAudit". Default is "Information".

    .PARAMETER eventId
    The ID of the event. Default is 1847.

    .PARAMETER message
    The message of the event. This parameter is mandatory.

    .EXAMPLE
    Log-Event -message "This is a test event."
    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$logName = "NinjaOneDeployments",

        [Parameter(Mandatory = $false)]
        [string]$source = "NinjaOneScripts",
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("Error", "Warning", "Information", "SuccessAudit", "FailureAudit")]
        [string]$entryType = "Information",
        
        [Parameter(Mandatory = $false)]
        [int]$eventId = 1847,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$message
    )

    try {
        Write-EventLog -LogName $logName -Source $source -EntryType $entryType -EventId $eventId -Message $message
    }
    catch {
        Write-Error "Failed to write to event log: $_"
    }
}
