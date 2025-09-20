---
layout: post
title: Schedule-Shutdown.ps1
date: 2025-09-19
permalink: /useradminmodule/shutdowncommands/schedule-shutdown/
categories:
  - UserAdminModule
  - ShutdownCommands
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Executes a shutdown, restart, or hibernate command on a remote computer using shutdown.exe.

#### Detailed Description

This function provides a PowerShell wrapper around the shutdown.exe command-line utility to perform remote shutdown, restart, or hibernate operations. It includes comprehensive error handling, parameter validation, and security features.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Invoke-RemoteShutdown -ComputerName "Server01" -Action "Restart" -Timeout 60 -Comment "Planned maintenance restart"
```

**Example 2**

```powershell
Invoke-RemoteShutdown -ComputerName "192.168.1.100" -Action "Shutdown" -Force -UseDirectMethod
```

**Example 3**

```powershell
Invoke-RemoteShutdown -ComputerName "Server01" -Abort
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: PowerShell Automation Team Version: 2.0 Requires: PowerShell 5.1 or later

This function requires appropriate permissions on the target computer and may require PowerShell remoting (WinRM) to be enabled unless UseDirectMethod is specified.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Executes a shutdown, restart, or hibernate command on a remote computer using shutdown.exe.

.DESCRIPTION
    This function provides a PowerShell wrapper around the shutdown.exe command-line utility to perform
    remote shutdown, restart, or hibernate operations. It includes comprehensive error handling, parameter
    validation, and security features.

.PARAMETER ComputerName
    The name or IP address of the target computer. Must be a valid computer name or IP address format.

.PARAMETER Action
    The action to perform. Valid values are "Shutdown", "Restart", or "Hibernate".

.PARAMETER Timeout
    The timeout in seconds before the action is executed. Must be between 0 and 315360000 (10 years).
    Default is 30 seconds.

.PARAMETER Comment
    A comment to display to users on the target computer. Limited to 512 characters and special characters
    are escaped for security.

.PARAMETER Force
    Forces running applications to close without saving. Use with caution.

.PARAMETER Abort
    Cancels a previously scheduled shutdown/restart operation.

.PARAMETER Credential
    Credentials to use for the remote operation. If not specified, current user credentials are used.

.PARAMETER UseDirectMethod
    Uses direct shutdown.exe execution instead of PowerShell remoting. Useful when WinRM is not available.

.EXAMPLE
    Invoke-RemoteShutdown -ComputerName "Server01" -Action "Restart" -Timeout 60 -Comment "Planned maintenance restart"

.EXAMPLE
    Invoke-RemoteShutdown -ComputerName "192.168.1.100" -Action "Shutdown" -Force -UseDirectMethod

.EXAMPLE
    Invoke-RemoteShutdown -ComputerName "Server01" -Abort

.NOTES
    Author: PowerShell Automation Team
    Version: 2.0
    Requires: PowerShell 5.1 or later
    
    This function requires appropriate permissions on the target computer and may require
    PowerShell remoting (WinRM) to be enabled unless UseDirectMethod is specified.

.LINK
    https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/shutdown
#>
function Invoke-RemoteShutdown {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the computer name or IP address")]
        [ValidateScript({
            if ($_ -match '^[a-zA-Z0-9\-\.]+$' -or $_ -match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
                $true
            } else {
                throw "ComputerName must be a valid computer name or IP address"
            }
        })]
        [string]$ComputerName,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Select the action to perform")]
        [ValidateSet("Shutdown", "Restart", "Hibernate")]
        [string]$Action,

        [Parameter(Position = 2, HelpMessage = "Timeout in seconds (0-315360000)")]
        [ValidateRange(0, 315360000)]
        [int]$Timeout = 30,

        [Parameter(Position = 3, HelpMessage = "Comment to display (max 512 characters)")]
        [ValidateLength(0, 512)]
        [string]$Comment = "Scheduled by PowerShell",

        [Parameter(HelpMessage = "Force applications to close without saving")]
        [switch]$Force,

        [Parameter(HelpMessage = "Cancel a previously scheduled operation")]
        [switch]$Abort,

        [Parameter(HelpMessage = "Credentials for remote access")]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(HelpMessage = "Use direct shutdown.exe instead of PowerShell remoting")]
        [switch]$UseDirectMethod
    )

    begin {
        Write-Verbose "Starting Invoke-RemoteShutdown for computer: $ComputerName"
        
        # Initialize error tracking
        $errorOccurred = $false
        $errorDetails = $null
        
        # Sanitize comment to prevent command injection
        $sanitizedComment = $Comment -replace '[&|<>^]', '_' -replace '"', '\"'
        Write-Verbose "Comment sanitized: $sanitizedComment"
    }

    process {
        try {
            # Step 1: Validate computer accessibility
            Write-Verbose "Testing network connectivity to $ComputerName"
            
            # Use Test-Connection for basic connectivity (cross-platform)
            if (-not (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
                throw "Computer '$ComputerName' is not reachable via ping. Check network connectivity and firewall settings."
            }
            
            # Additional RPC port check for Windows systems (when available)
            try {
                if ($PSVersionTable.PSVersion.Major -ge 6 -and $IsWindows -eq $false) {
                    Write-Verbose "Running on non-Windows system, skipping RPC port check"
                } else {
                    # Try to test RPC port if Test-NetConnection is available
                    if (Get-Command Test-NetConnection -ErrorAction SilentlyContinue) {
                        if (-not (Test-NetConnection -ComputerName $ComputerName -Port 135 -InformationLevel Quiet -WarningAction SilentlyContinue)) {
                            Write-Warning "RPC port (135) is not accessible on '$ComputerName'. This may cause issues with shutdown.exe remote execution."
                        }
                    } else {
                        Write-Verbose "Test-NetConnection not available, skipping RPC port check"
                    }
                }
            } catch {
                Write-Verbose "Could not test RPC connectivity: $($_.Exception.Message)"
            }

            # Step 2: Validate computer exists (if not IP address)
            if ($ComputerName -notmatch '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
                Write-Verbose "Attempting to resolve computer name: $ComputerName"
                try {
                    $null = [System.Net.Dns]::GetHostEntry($ComputerName)
                    Write-Verbose "Computer name resolved successfully"
                } catch {
                    Write-Warning "Could not resolve computer name '$ComputerName'. Proceeding anyway..."
                }
            }

            # Step 3: Determine the shutdown action
            $actionParam = switch ($Action) {
                "Shutdown" { "/s" }
                "Restart"  { "/r" }
                "Hibernate" { "/h" }
            }
            Write-Verbose "Action parameter set to: $actionParam"

            # Step 4: Build command parameters
            $forceParam = if ($Force) { "/f" } else { "" }
            
            # Step 5: Build the command
            if ($Abort) {
                $cmd = "shutdown.exe /m \\$ComputerName /a"
                $actionDescription = "Cancel Scheduled Operation"
            } else {
                $cmd = "shutdown.exe /m \\$ComputerName $actionParam /t $Timeout /c `"$sanitizedComment`" $forceParam".Trim()
                $actionDescription = "$Action (Timeout: $Timeout seconds)"
            }
            
            Write-Verbose "Command to execute: $cmd"

            # Step 6: Execute the command with proper error handling
            if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", $actionDescription)) {
                
                if ($UseDirectMethod) {
                    Write-Verbose "Using direct shutdown.exe method"
                    $result = & cmd /c $cmd 2>&1
                    $exitCode = $LASTEXITCODE
                } else {
                    Write-Verbose "Using PowerShell remoting method"
                    
                    # Prepare remoting parameters
                    $remotingParams = @{
                        ComputerName = $ComputerName
                        ScriptBlock = { 
                            param($command)
                            $result = & cmd /c $command 2>&1
                            return @{
                                Output = $result
                                ExitCode = $LASTEXITCODE
                            }
                        }
                        ArgumentList = $cmd
                        ErrorAction = 'Stop'
                    }
                    
                    if ($Credential) {
                        $remotingParams.Credential = $Credential
                        Write-Verbose "Using provided credentials for remote connection"
                    }
                    
                    $remoteResult = Invoke-Command @remotingParams
                    $result = $remoteResult.Output
                    $exitCode = $remoteResult.ExitCode
                }

                # Step 7: Process results and handle shutdown.exe specific error codes
                switch ($exitCode) {
                    0 { 
                        $successMessage = if ($Abort) {
                            "Scheduled shutdown/restart/hibernate on '$ComputerName' has been canceled successfully."
                        } else {
                            "Action '$Action' scheduled on '$ComputerName' successfully. Operation will execute in $Timeout seconds."
                        }
                        Write-Host $successMessage -ForegroundColor Green
                        Write-Verbose "Operation completed successfully with exit code 0"
                    }
                    1190 { 
                        throw "A shutdown operation is already in progress on '$ComputerName'. Use -Abort to cancel it first."
                    }
                    1115 { 
                        throw "A system shutdown has already been initiated on '$ComputerName'."
                    }
                    1312 { 
                        throw "No shutdown operation is scheduled on '$ComputerName' to abort."
                    }
                    5 { 
                        throw "Access denied. You do not have permission to perform this operation on '$ComputerName'. Try using -Credential parameter or run as administrator."
                    }
                    53 { 
                        throw "Network path not found. Computer '$ComputerName' may not exist or network connectivity issues."
                    }
                    1326 { 
                        throw "Invalid credentials or authentication failure for '$ComputerName'."
                    }
                    default { 
                        $errorMsg = "Shutdown command failed with exit code $exitCode on '$ComputerName'."
                        if ($result) {
                            $errorMsg += " Output: $($result -join ' ')"
                        }
                        throw $errorMsg
                    }
                }
            }
        }
        catch {
            $errorOccurred = $true
            $errorDetails = $_.Exception.Message
            
            Write-Error "Failed to execute '$Action' on '$ComputerName': $errorDetails"
            Write-Verbose "Full error details: $($_.Exception | Out-String)"
            
            # If remoting failed and not using direct method, suggest fallback
            if (-not $UseDirectMethod -and $_.Exception.Message -like "*remoting*") {
                Write-Warning "PowerShell remoting failed. Consider using -UseDirectMethod parameter as a fallback."
            }
        }
    }

    end {
        if ($errorOccurred) {
            Write-Verbose "Operation completed with errors: $errorDetails"
        } else {
            Write-Verbose "Operation completed successfully"
        }
    }
}

<#
.SYNOPSIS
    Schedules a shutdown, restart, or hibernate operation at a specific date and time.

.DESCRIPTION
    This function calculates the time difference between the current time and the specified shutdown time,
    then calls Invoke-RemoteShutdown to schedule the operation. Includes comprehensive validation and
    error handling.

.PARAMETER ComputerName
    The name or IP address of the target computer. Must be a valid computer name or IP address format.

.PARAMETER ShutdownTime
    The date and time when the operation should occur. Must be a future date/time.

.PARAMETER Action
    The action to perform. Valid values are "Shutdown", "Restart", or "Hibernate". Default is "Shutdown".

.PARAMETER Comment
    A comment to display to users on the target computer. Limited to 512 characters.

.PARAMETER Force
    Forces running applications to close without saving. Use with caution.

.PARAMETER Credential
    Credentials to use for the remote operation. If not specified, current user credentials are used.

.PARAMETER UseDirectMethod
    Uses direct shutdown.exe execution instead of PowerShell remoting. Useful when WinRM is not available.

.EXAMPLE
    Schedule-Shutdown -ComputerName "Server01" -ShutdownTime (Get-Date "23:00") -Action "Shutdown" -Comment "End of day shutdown"

.EXAMPLE
    Schedule-Shutdown -ComputerName "192.168.1.100" -ShutdownTime (Get-Date).AddHours(2) -Action "Restart" -Force

.EXAMPLE
    $cred = Get-Credential
    Schedule-Shutdown -ComputerName "Server01" -ShutdownTime (Get-Date "2023-12-31 23:59") -Credential $cred

.NOTES
    Author: PowerShell Automation Team
    Version: 2.0
    Requires: PowerShell 5.1 or later
    
    The maximum timeout supported by shutdown.exe is 315360000 seconds (approximately 10 years).

.LINK
    Invoke-RemoteShutdown
#>
function Schedule-Shutdown {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the computer name or IP address")]
        [ValidateScript({
            if ($_ -match '^[a-zA-Z0-9\-\.]+$' -or $_ -match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
                $true
            } else {
                throw "ComputerName must be a valid computer name or IP address"
            }
        })]
        [string]$ComputerName,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Enter the date and time for the operation")]
        [ValidateScript({
            if ($_ -gt (Get-Date)) {
                $true
            } else {
                throw "ShutdownTime must be a future date and time"
            }
        })]
        [datetime]$ShutdownTime,

        [Parameter(Position = 2, HelpMessage = "Select the action to perform")]
        [ValidateSet("Shutdown", "Restart", "Hibernate")]
        [string]$Action = "Shutdown",

        [Parameter(Position = 3, HelpMessage = "Comment to display (max 512 characters)")]
        [ValidateLength(0, 512)]
        [string]$Comment = "Scheduled by PowerShell",

        [Parameter(HelpMessage = "Force applications to close without saving")]
        [switch]$Force,

        [Parameter(HelpMessage = "Credentials for remote access")]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(HelpMessage = "Use direct shutdown.exe instead of PowerShell remoting")]
        [switch]$UseDirectMethod
    )

    begin {
        Write-Verbose "Starting Schedule-Shutdown for computer: $ComputerName at time: $ShutdownTime"
    }

    process {
        try {
            # Calculate the time difference in seconds
            $currentDateTime = Get-Date
            $timeDifference = ($ShutdownTime - $currentDateTime).TotalSeconds
            
            Write-Verbose "Current time: $currentDateTime"
            Write-Verbose "Scheduled time: $ShutdownTime"
            Write-Verbose "Time difference: $timeDifference seconds"

            # Validate the time difference is still positive (double-check)
            if ($timeDifference -le 0) {
                throw "The specified time has already passed. Please specify a future time. Current time: $currentDateTime, Specified time: $ShutdownTime"
            }

            # Validate the timeout is within shutdown.exe limits
            if ($timeDifference -gt 315360000) {
                throw "The timeout ($timeDifference seconds) exceeds the maximum allowed by shutdown.exe (315360000 seconds / ~10 years). Please specify a closer time."
            }

            # Round to nearest second for shutdown.exe
            $timeoutSeconds = [math]::Round($timeDifference)
            Write-Verbose "Rounded timeout: $timeoutSeconds seconds"

            # Prepare parameters for Invoke-RemoteShutdown
            $invokeParams = @{
                ComputerName = $ComputerName
                Action = $Action
                Timeout = $timeoutSeconds
                Comment = $Comment
                Force = $Force
                UseDirectMethod = $UseDirectMethod
                Verbose = $VerbosePreference
            }

            if ($Credential) {
                $invokeParams.Credential = $Credential
            }

            # Show what will happen
            $timeSpan = New-TimeSpan -Seconds $timeoutSeconds
            $friendlyTime = if ($timeSpan.Days -gt 0) {
                "{0} days, {1:D2}:{2:D2}:{3:D2}" -f $timeSpan.Days, $timeSpan.Hours, $timeSpan.Minutes, $timeSpan.Seconds
            } else {
                "{0:D2}:{1:D2}:{2:D2}" -f $timeSpan.Hours, $timeSpan.Minutes, $timeSpan.Seconds
            }

            $actionDescription = "$Action scheduled for $ShutdownTime (in $friendlyTime)"

            if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", $actionDescription)) {
                # Invoke the remote shutdown with the calculated timeout
                Invoke-RemoteShutdown @invokeParams
            }
        }
        catch {
            Write-Error "Failed to schedule '$Action' on '$ComputerName' for time '$ShutdownTime': $($_.Exception.Message)"
            Write-Verbose "Full error details: $($_.Exception | Out-String)"
        }
    }

    end {
        Write-Verbose "Schedule-Shutdown completed"
    }
}

# Example Usage:

# Basic shutdown with 30 second timeout
# Invoke-RemoteShutdown -ComputerName "Server01" -Action "Shutdown" -Timeout 30 -Comment "Maintenance shutdown"

# Immediate restart with force
# Invoke-RemoteShutdown -ComputerName "Server01" -Action "Restart" -Timeout 0 -Force

# Schedule a shutdown for tonight at 11 PM
# Schedule-Shutdown -ComputerName "Server01" -ShutdownTime (Get-Date "23:00") -Action "Shutdown" -Comment "End of day shutdown"

# Schedule with credentials and force flag
# $cred = Get-Credential
# Schedule-Shutdown -ComputerName "Server01" -ShutdownTime (Get-Date).AddHours(2) -Action "Restart" -Force -Credential $cred

# Cancel a scheduled operation
# Cancel-RemoteShutdown -ComputerName "Server01"

# Use direct method when PowerShell remoting is not available
# Invoke-RemoteShutdown -ComputerName "192.168.1.100" -Action "Shutdown" -UseDirectMethod

<#
.SYNOPSIS
    Tests if a computer is ready for shutdown operations.

.DESCRIPTION
    This helper function tests network connectivity and basic accessibility before attempting
    shutdown operations. Can be used to pre-validate targets.

.PARAMETER ComputerName
    The name or IP address of the target computer.

.PARAMETER Credential
    Credentials to use for testing access.

.EXAMPLE
    Test-ShutdownReadiness -ComputerName "Server01"

.EXAMPLE
    Test-ShutdownReadiness -ComputerName "Server01" -Credential (Get-Credential)
#>
function Test-ShutdownReadiness {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credential
    )

    $results = [PSCustomObject]@{
        ComputerName = $ComputerName
        NetworkConnectivity = $false
        RpcAccess = $false
        PowerShellRemoting = $false
        Overall = $false
    }

    try {
        # Test basic network connectivity
        Write-Verbose "Testing basic network connectivity to $ComputerName"
        if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
            $results.NetworkConnectivity = $true
            Write-Verbose "Network connectivity: SUCCESS"
        } else {
            Write-Verbose "Network connectivity: FAILED"
            return $results
        }

        # Test RPC access (required for shutdown.exe) - Windows only
        Write-Verbose "Testing RPC access to $ComputerName"
        try {
            if ($PSVersionTable.PSVersion.Major -ge 6 -and $IsWindows -eq $false) {
                Write-Verbose "Running on non-Windows system, skipping RPC port check"
                $results.RpcAccess = $true  # Assume available if we can't test
            } else {
                if (Get-Command Test-NetConnection -ErrorAction SilentlyContinue) {
                    if (Test-NetConnection -ComputerName $ComputerName -Port 135 -InformationLevel Quiet -WarningAction SilentlyContinue) {
                        $results.RpcAccess = $true
                        Write-Verbose "RPC access: SUCCESS"
                    } else {
                        Write-Verbose "RPC access: FAILED"
                    }
                } else {
                    Write-Verbose "Test-NetConnection not available, assuming RPC access is available"
                    $results.RpcAccess = $true
                }
            }
        } catch {
            Write-Verbose "RPC access test failed: $($_.Exception.Message)"
        }

        # Test PowerShell remoting
        Write-Verbose "Testing PowerShell remoting to $ComputerName"
        try {
            $testParams = @{
                ComputerName = $ComputerName
                ScriptBlock = { $env:COMPUTERNAME }
                ErrorAction = 'Stop'
            }
            if ($Credential) {
                $testParams.Credential = $Credential
            }
            
            $null = Invoke-Command @testParams
            $results.PowerShellRemoting = $true
            Write-Verbose "PowerShell remoting: SUCCESS"
        } catch {
            Write-Verbose "PowerShell remoting: FAILED - $($_.Exception.Message)"
        }

        # Overall assessment
        $results.Overall = $results.NetworkConnectivity -and $results.RpcAccess

        return $results
    }
    catch {
        Write-Error "Error testing shutdown readiness for '$ComputerName': $($_.Exception.Message)"
        return $results
    }
}

<#
.SYNOPSIS
    Gets the current shutdown status of a remote computer.

.DESCRIPTION
    This function attempts to determine if there's already a shutdown operation scheduled
    on the target computer by trying to cancel a non-existent shutdown.

.PARAMETER ComputerName
    The name or IP address of the target computer.

.PARAMETER Credential
    Credentials to use for the operation.

.EXAMPLE
    Get-ShutdownStatus -ComputerName "Server01"
#>
function Get-ShutdownStatus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credential
    )

    try {
        Write-Verbose "Checking shutdown status for $ComputerName"
        
        $cmd = "shutdown.exe /m \\$ComputerName /a"
        
        if ($Credential) {
            $result = Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock { 
                param($command)
                $output = & cmd /c $command 2>&1
                return @{
                    Output = $output
                    ExitCode = $LASTEXITCODE
                }
            } -ArgumentList $cmd
        } else {
            $result = Invoke-Command -ComputerName $ComputerName -ScriptBlock { 
                param($command)
                $output = & cmd /c $command 2>&1
                return @{
                    Output = $output
                    ExitCode = $LASTEXITCODE
                }
            } -ArgumentList $cmd
        }

        switch ($result.ExitCode) {
            0 { return "Shutdown operation was scheduled and has been canceled" }
            1312 { return "No shutdown operation is currently scheduled" }
            default { return "Unknown status (Exit code: $($result.ExitCode))" }
        }
    }
    catch {
        Write-Error "Failed to check shutdown status for '$ComputerName': $($_.Exception.Message)"
        return "Error checking status"
    }
}

<#
.SYNOPSIS
    Cancels a previously scheduled shutdown, restart, or hibernate operation on a remote computer.

.DESCRIPTION
    This function cancels any pending shutdown, restart, or hibernate operation on the specified computer
    using the shutdown.exe /a command. Includes comprehensive error handling and validation.

.PARAMETER ComputerName
    The name or IP address of the target computer. Must be a valid computer name or IP address format.

.PARAMETER Credential
    Credentials to use for the remote operation. If not specified, current user credentials are used.

.PARAMETER UseDirectMethod
    Uses direct shutdown.exe execution instead of PowerShell remoting. Useful when WinRM is not available.

.EXAMPLE
    Cancel-RemoteShutdown -ComputerName "Server01"

.EXAMPLE
    Cancel-RemoteShutdown -ComputerName "192.168.1.100" -UseDirectMethod

.EXAMPLE
    $cred = Get-Credential
    Cancel-RemoteShutdown -ComputerName "Server01" -Credential $cred

.NOTES
    Author: PowerShell Automation Team
    Version: 2.0
    Requires: PowerShell 5.1 or later
    
    This function can only cancel operations that were scheduled with a timeout. 
    Immediate shutdowns cannot be canceled.

.LINK
    Invoke-RemoteShutdown
    Schedule-Shutdown
#>
function Cancel-RemoteShutdown {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the computer name or IP address")]
        [ValidateScript({
            if ($_ -match '^[a-zA-Z0-9\-\.]+$' -or $_ -match '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$') {
                $true
            } else {
                throw "ComputerName must be a valid computer name or IP address"
            }
        })]
        [string]$ComputerName,

        [Parameter(HelpMessage = "Credentials for remote access")]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter(HelpMessage = "Use direct shutdown.exe instead of PowerShell remoting")]
        [switch]$UseDirectMethod
    )

    begin {
        Write-Verbose "Starting Cancel-RemoteShutdown for computer: $ComputerName"
    }

    process {
        try {
            # Prepare parameters for Invoke-RemoteShutdown with Abort flag
            $invokeParams = @{
                ComputerName = $ComputerName
                Action = "Shutdown"  # This will be ignored due to Abort flag
                Abort = $true
                UseDirectMethod = $UseDirectMethod
                Verbose = $VerbosePreference
            }

            if ($Credential) {
                $invokeParams.Credential = $Credential
            }

            if ($PSCmdlet.ShouldProcess("Computer: $ComputerName", "Cancel Scheduled Shutdown/Restart/Hibernate")) {
                # Use the improved Invoke-RemoteShutdown function with Abort parameter
                Invoke-RemoteShutdown @invokeParams
            }
        }
        catch {
            Write-Error "Failed to cancel scheduled operation on '$ComputerName': $($_.Exception.Message)"
            Write-Verbose "Full error details: $($_.Exception | Out-String)"
        }
    }

    end {
        Write-Verbose "Cancel-RemoteShutdown completed"
    }
}

# # Example usage
# Cancel-RemoteShutdown -ComputerName "RemotePC01"
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ShutdownCommands/Public/Schedule-Shutdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Schedule-Shutdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

