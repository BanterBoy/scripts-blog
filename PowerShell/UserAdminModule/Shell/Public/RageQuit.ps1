function RageQuit {
    <#
    .SYNOPSIS
        Forcefully shuts down or restarts the computer immediately.

    .DESCRIPTION
        Stops or restarts the computer without confirmation. Use with caution—may result in data loss if unsaved changes exist. Logs all actions to the Windows Application event log. Requires administrative privileges.

    .PARAMETER Force
        If specified, the computer will be shut down or restarted without asking for user confirmation.

    .PARAMETER Restart
        If specified, the computer will be restarted instead of shut down.

    .INPUTS
        System.String. You can pipe a string that specifies the action ("Restart" or "Shutdown") to the function.

    .OUTPUTS
        None. This function does not produce any output.

    .NOTES
        Author: RDGScripts Maintainers
        Date: 2025-09-02
        Requires: Administrative privileges for shutdown/restart operations.

    .EXAMPLE
        RageQuit -Force
        # Forcefully shuts down the computer without confirmation.

    .EXAMPLE
        RageQuit -Restart -Force
        # Forcefully restarts the computer without confirmation.

    .EXAMPLE
        "Restart" | RageQuit -Force
        # Pipes the action and forcefully restarts the computer.

    .EXAMPLE
        "Shutdown" | RageQuit
        # Pipes the action and prompts for confirmation before shutting down.
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Force the shutdown or restart without asking for user confirmation.")]
        [switch]$Force,

        [Parameter(Mandatory = $false, HelpMessage = "Restart the computer instead of shutting it down.")]
        [switch]$Restart
    )

    begin {
        # Check for administrative privileges
        $isElevated = $false
        try {
            $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
            $isElevated = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
        } catch {
            Write-Error "Could not determine elevation status: $($_.Exception.Message)"
            return
        }
        if (-not $isElevated) {
            Write-Error "This function requires administrative privileges to perform shutdown or restart operations."
            return
        }

        function Write-EventLogEntry {
            param (
                [string]$Message,
                [string]$EventType = "Information"
            )
            $eventID = 1001
            $source = "RageQuit"
            $username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
            try {
                if (-not (Get-EventLog -LogName Application -Source $source -ErrorAction SilentlyContinue)) {
                    New-EventLog -LogName Application -Source $source -ErrorAction Stop
                }
                Write-EventLog -LogName Application -Source $source -EventID $eventID -EntryType $EventType -Message "$Message`nUser: $username"
            }
            catch {
                Write-Warning "Failed to write to event log: $($_.Exception.Message)"
            }
        }
    }

    process {
        # Handle pipeline input
        if ($input) {
            $pipedAction = $input.ToString().ToLower()
            if ($pipedAction -eq "restart") {
                $Restart = $true
            } elseif ($pipedAction -eq "shutdown") {
                $Restart = $false
            } else {
                Write-Error "Invalid piped input: $input. Use 'Restart' or 'Shutdown'."
                return
            }
        }

        $action = if ($Restart) { "restart" } else { "shutdown" }
        if ($Force -or $PSCmdlet.ShouldContinue("This will forcefully $action your computer and may result in data loss. Do you want to continue?", "Confirm $action")) {
            if ($PSCmdlet.ShouldProcess("The computer", "Forceful $action")) {
                try {
                    Write-EventLogEntry -Message "$action initiated by RageQuit function." -EventType "Information"
                    if ($Restart) {
                        Restart-Computer -Force
                    }
                    else {
                        Stop-Computer -Force
                    }
                }
                catch {
                    Write-EventLogEntry -Message "Failed to $action the computer: $($_.Exception.Message)" -EventType "Error"
                    Write-Error "Failed to $action the computer: $($_.Exception.Message)"
                }
            }
        }
        else {
            Write-EventLogEntry -Message "$action cancelled by user." -EventType "Warning"
            Write-Output "$action cancelled by user."
        }
    }
}
