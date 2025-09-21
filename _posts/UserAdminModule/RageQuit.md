---
layout: post
title: RageQuit.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/ragequit/
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

Forcefully shuts down or restarts the computer immediately.

#### Detailed Description

Stops or restarts the computer without confirmation. Use with caution—may result in data loss if unsaved changes exist. Logs all actions to the Windows Application event log. Requires administrative privileges.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
RageQuit -Force
```

# Forcefully shuts down the computer without confirmation.

**Example 2**

```powershell
RageQuit -Restart -Force
```

# Forcefully restarts the computer without confirmation.

**Example 3**

```powershell
"Restart" | RageQuit -Force
```

# Pipes the action and forcefully restarts the computer.

**Example 4**

```powershell
"Shutdown" | RageQuit
```

# Pipes the action and prompts for confirmation before shutting down.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: RDGScripts Maintainers Date: 2025-09-02 Requires: Administrative privileges for shutdown/restart operations.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/RageQuit.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=RageQuit.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

