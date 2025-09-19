function Start-ServicesInOder {

    <#
    .SYNOPSIS
    Starts a list of services in the order they are provided.

    .DESCRIPTION
    This function starts a list of services in the order they are provided. It waits for each service to start before moving on to the next one.

    .PARAMETER ServiceNames
    The names of the services to start.

    .EXAMPLE
    Start-ServicesInOrder -ServiceNames "Service1", "Service2", "Service3"
    Starts Service1, waits for it to start, then starts Service2, waits for it to start, then starts Service3.

    .EXAMPLE
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

    Start-Services -ServiceNames $services

    .NOTES
    Author: Unknown
    Date: Unknown
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ServiceNames
    )

    foreach ($service in $ServiceNames) {
        try {
            Start-Service -Name $service -ErrorAction Stop
            do {
                Start-Sleep -Milliseconds 500
                $status = (Get-Service -Name $service).Status
            } until ($status -eq "Running")
            Write-Output "$service - started successfully."
        }
        catch {
            Write-Output "Failed to start $service - $($_.Exception.Message)"
        }
    }
}
