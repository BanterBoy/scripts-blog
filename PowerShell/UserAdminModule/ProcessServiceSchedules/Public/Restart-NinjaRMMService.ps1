#requires -PSEdition Desktop
function Restart-NinjaRMMService {

    <#
    .SYNOPSIS
        Restarts the NinjaRMM service and related processes.

    .DESCRIPTION
        This function stops the NinjaRMMAgentPatcher process and the NinjaRMMAgent service,
        then restarts the NinjaRMMAgent service. It includes error handling to manage cases
        where the process or service is not found.

    .PARAMETER None
        This function does not require any parameters.

    .EXAMPLE
        Restart-NinjaRMMService
        This example stops and restarts the NinjaRMM service and related processes.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding()]
    param ()

    # Attempt to stop the Ninja Patcher process
    try {
        Write-Output "Stopping Ninja Patcher process"
        Write-Verbose "Attempting to stop process: NinjaRMMAgentPatcher"
        Get-Process -Name NinjaRMMAgentPatcher -ErrorAction Stop | Stop-Process -Force
        Write-Verbose "Ninja Patcher process stopped successfully"
    }
    catch {
        Write-Output "Ninja process not found"
        Write-Verbose "NinjaRMMAgentPatcher process not found"
    }

    # Attempt to stop and restart the Ninja services
    try {
        Write-Output "Stopping Ninja services"
        Write-Verbose "Attempting to stop service: NinjaRMMAgent"
        Get-Service -Name NinjaRMMAgent -ErrorAction Stop | Stop-Service -Force -PassThru
        Write-Output "Ninja services stopped"
        Write-Verbose "NinjaRMMAgent service stopped successfully"

        Start-Sleep -Seconds 5

        Write-Verbose "Attempting to start service: NinjaRMMAgent"
        Start-Service -Name NinjaRMMAgent -PassThru
        Write-Output "Ninja services started"
        Write-Verbose "NinjaRMMAgent service started successfully"
    }
    catch {
        Write-Output "Ninja services not found"
        Write-Verbose "NinjaRMMAgent service not found"
    }
}

# Example Usage:
# Restart-NinjaRMMService -Verbose
