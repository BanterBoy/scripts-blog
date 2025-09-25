#requires -PSEdition Desktop
function Start-RansomcareServices {
    <#
    .SYNOPSIS
        Starts the Ransomcare services in a specific order.

    .DESCRIPTION
        This function starts the Ransomcare services in a specified order. It waits for each service to start before proceeding to start the next service. If a service fails to start, it logs an error message.

    .NOTES
        Author: Luke Leigh
        Date: [Date]
        This function requires administrative privileges.

    .EXAMPLE
        Start-RansomcareServices
        Starts all the Ransomcare services in order, waiting for each to start before proceeding to the next.

    .PARAMETER None
        This function does not accept any parameters.
    #>

    [CmdletBinding()]
    param ()

    # List of Ransomcare services to be started in order
    $services = @(
        "Ransomcare Admin Service",
        "Ransomcare Accumulative Sensors Service",
        "Ransomcare Database Service",
        "Ransomcare Hub Service",
        "Ransomcare ML Service",
        "Ransomcare Share Service",
        "Ransomcare Sharepoint Service",
        "Ransomcare Validation Service"
    )

    foreach ($service in $services) {
        try {
            Write-Verbose "Attempting to start $service..."
            Start-Service -Name $service -ErrorAction Stop
            
            # Wait for the service to start
            do {
                Start-Sleep -Milliseconds 500
                $status = (Get-Service -Name $service).Status
            } until ($status -eq "Running")

            Write-Output "$service - started successfully."
            Write-Verbose "$service is now running."
        }
        catch {
            Write-Error "Failed to start {$service}: $($_.Exception.Message)"
        }
    }
}

# Example usage:
# Start-RansomcareServices -Verbose
