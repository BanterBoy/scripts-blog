function Initialize-EventLogging {
    <#
    .SYNOPSIS
        Initializes event logging by creating a new event log source if it does not exist.
    
    .PARAMETER logName
        Specifies the name of the event log. The default value is "NinjaOneDeployments".
        Valid values are "Application", "System", "NinjaOneDeployments", and "AutomatedDeployment".
    
    .PARAMETER source
        Specifies the name of the event log source. The default value is "NinjaOneScripts".
        Valid values are "NinjaOneScripts" and "AutomatedDeployment".
    
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet("Application", "System", "NinjaOneDeployments", "AutomatedDeployment")]
        [string]$logName = "NinjaOneDeployments",

        [Parameter(Mandatory = $false)]
        [ValidateSet("NinjaOneScripts", "AutomatedDeployment")]
        [string]$source = "NinjaOneScripts"
    )

    if (![string]::IsNullOrWhiteSpace($logName) -and ![string]::IsNullOrWhiteSpace($source)) {
        try {
            # Create the source if it does not exist
            if (![System.Diagnostics.EventLog]::SourceExists($source)) {
                $Message = "Initialize-EventLogging @ " + (Get-Date) + ": Creating LogSource for EventLog..."
                Write-Verbose $message
                [System.Diagnostics.EventLog]::CreateEventSource($source, $logName)
            }
            else {
                $Message = "Initialize-EventLogging @ " + (Get-Date) + ": LogSource exists already."
                Write-Verbose $message
            }
        }
        catch {
            Write-Error "An error occurred while initializing logging: $_"
        }
    }
    else {
        Write-Error "Invalid parameters. LogName and Source cannot be empty."
    }
}
