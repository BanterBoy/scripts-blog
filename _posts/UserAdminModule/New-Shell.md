---
layout: post
title: New-Shell.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/New-Shell/
categories:
  - UserAdminModule
  - Shell
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

Opens a new PowerShell or Windows Terminal session with elevated or alternate user context.

#### Detailed Description

This function launches a new shell session in various contexts:

- Standard or elevated (Administrator) PowerShell/PowerShell Core

- As a different user (with credentials)

- In Windows Terminal (optionally elevated)

If the current session is already elevated, a warning is displayed. Robust error handling is included for all launch scenarios.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
New-Shell -User pwsh
```

# Launches a new PowerShell Core shell.

**Example 2**

```powershell
New-Shell -RunAs PowerShellRunAs
```

# Launches a new elevated Windows PowerShell shell.

**Example 3**

```powershell
New-Shell -RunAsUser pwshRunAsUser -Credentials (Get-Credential)
```

# Launches a new PowerShell Core shell as a specified user.

**Example 4**

```powershell
New-Shell -Terminal pwshTerminal
```

# Launches a new PowerShell Core shell in Windows Terminal.

**Example 5**

```powershell
New-Shell -TerminalRunAs pwshTerminalRunAs
```

# Launches a new elevated PowerShell Core shell in Windows Terminal.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: RDGScripts Maintainers Date: 2025-09-02 Prerequisites: PowerShell Core (pwsh.exe) and Windows Terminal (wt.exe) must be installed for respective options.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Opens a new PowerShell or Windows Terminal session with elevated or alternate user context.

.DESCRIPTION
    This function launches a new shell session in various contexts:
    - Standard or elevated (Administrator) PowerShell/PowerShell Core
    - As a different user (with credentials)
    - In Windows Terminal (optionally elevated)
    If the current session is already elevated, a warning is displayed. Robust error handling is included for all launch scenarios.

.PARAMETER User
    Specifies the type of shell to start. Valid values: 'PowerShell' (Windows PowerShell), 'pwsh' (PowerShell Core).

.PARAMETER RunAs
    Launches the shell as Administrator. Valid values: 'PowerShellRunAs', 'pwshRunAs'.

.PARAMETER RunAsUser
    Launches the shell as a different user. Valid values: 'PowerShellRunAsUser', 'pwshRunAsUser'.

.PARAMETER Credentials
    Credentials object for RunAsUser. Mandatory when using RunAsUser.

.PARAMETER ForceNewWindow
    Forces the RunAsUser shell to launch in a dedicated console window, which is useful when invoked from hosts that hide child
    process windows such as Stream Deck scripts.

.PARAMETER ShellArgumentList
    Provides additional arguments for the shell executable when using RunAsUser. Combine with ForceNewWindow to control the star
    ted session.

.PARAMETER WindowTitle
    Sets a custom console window title when ForceNewWindow is specified. Defaults to an empty title when omitted.

.PARAMETER Terminal
    Launches the shell in Windows Terminal. Valid values: 'PowerShellTerminal', 'pwshTerminal'.

.PARAMETER TerminalRunAs
    Launches Windows Terminal as Administrator with the specified profile. Valid values: 'PowerShellTerminalRunAs', 'pwshTerminalRunAs'.

.EXAMPLE
    New-Shell -User pwsh
    # Launches a new PowerShell Core shell.

.EXAMPLE
    New-Shell -RunAs PowerShellRunAs
    # Launches a new elevated Windows PowerShell shell.

.EXAMPLE
    New-Shell -RunAsUser pwshRunAsUser -Credentials (Get-Credential)
    # Launches a new PowerShell Core shell as a specified user.

.EXAMPLE
    New-Shell -Terminal pwshTerminal
    # Launches a new PowerShell Core shell in Windows Terminal.

.EXAMPLE
    New-Shell -TerminalRunAs pwshTerminalRunAs
    # Launches a new elevated PowerShell Core shell in Windows Terminal.

.NOTES
    Author: RDGScripts Maintainers
    Date: 2025-09-02
    Prerequisites: PowerShell Core (pwsh.exe) and Windows Terminal (wt.exe) must be installed for respective options.
#>

function New-Shell {
    [CmdletBinding(DefaultParameterSetName = 'User')]
    param (
        [Parameter(ParameterSetName = 'User', Mandatory = $false, Position = 0, HelpMessage = 'Specifies the type of shell to start.')]
        [ValidateSet('PowerShell', 'pwsh')]
        [string]
        $User,

        [Parameter(ParameterSetName = 'RunAs', Mandatory = $false, Position = 0, HelpMessage = 'Specifies to run the shell as an administrator.')]
        [ValidateSet('PowerShellRunAs', 'pwshRunAs')]
        [string]
        $RunAs,

        [Parameter(ParameterSetName = 'RunAsUser', Mandatory = $false, Position = 0, HelpMessage = 'Specifies to run the shell as a different user.')]
        [ValidateSet('PowerShellRunAsUser', 'pwshRunAsUser')]
        [string]
        $RunAsUser,

        [Parameter(ParameterSetName = 'RunAsUser', Mandatory = $true, Position = 1, HelpMessage = 'Specifies the credentials to use for the RunAsUser parameter.')]
        [pscredential]
        $Credentials,

        [Parameter(ParameterSetName = 'RunAsUser', Mandatory = $false, HelpMessage = 'Forces the shell to launch in a new window when running as another user.')]
        [switch]
        $ForceNewWindow,

        [Parameter(ParameterSetName = 'RunAsUser', Mandatory = $false, HelpMessage = 'Specifies additional arguments for the shell when running as another user.')]
        [string[]]
        $ShellArgumentList,

        [Parameter(ParameterSetName = 'RunAsUser', Mandatory = $false, HelpMessage = 'Specifies the window title when a new window is launched for another user.')]
        [string]
        $WindowTitle,

        [Parameter(ParameterSetName = 'Terminal', Mandatory = $false, Position = 0, HelpMessage = 'Specifies to launch the shell in Windows Terminal.')]
        [ValidateSet('PowerShellTerminal', 'pwshTerminal')]
        [string]
        $Terminal,

        [Parameter(ParameterSetName = 'TerminalRunAs', Mandatory = $false, Position = 0, HelpMessage = 'Specifies to run Windows Terminal as an administrator with the specified profile.')]
        [ValidateSet('PowerShellTerminalRunAs', 'pwshTerminalRunAs')]
        [string]
        $TerminalRunAs
    )

    begin {
        $parameters = @{}
        if ($PSBoundParameters.ContainsKey('User')) { $parameters['User'] = $User }
        if ($PSBoundParameters.ContainsKey('RunAs')) { $parameters['RunAs'] = $RunAs }
        if ($PSBoundParameters.ContainsKey('RunAsUser')) { $parameters['RunAsUser'] = $RunAsUser }
        if ($PSBoundParameters.ContainsKey('Terminal')) { $parameters['Terminal'] = $Terminal }
        if ($PSBoundParameters.ContainsKey('TerminalRunAs')) { $parameters['TerminalRunAs'] = $TerminalRunAs }
        if ($PSBoundParameters.ContainsKey('ForceNewWindow')) { $parameters['ForceNewWindow'] = $ForceNewWindow }
        if ($PSBoundParameters.ContainsKey('ShellArgumentList')) { $parameters['ShellArgumentList'] = $ShellArgumentList }
        if ($PSBoundParameters.ContainsKey('WindowTitle')) { $parameters['WindowTitle'] = $WindowTitle }

        Write-Verbose "Starting New-Shell function with parameters: $($parameters | Out-String)"
    }

    process {
        # Check for elevation if relevant
        $isElevated = $false
        try {
            $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
            $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
            $isElevated = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
        } catch {
            Write-Verbose "Could not determine elevation status: $_"
        }

        # Helper function to check executable
        function Test-Executable {
            param ([string]$Path)
            try {
                $null = Get-Command $Path -ErrorAction Stop
                return $true
            } catch {
                return $false
            }
        }

        try {
            switch ($PSCmdlet.ParameterSetName) {
                'User' {
                    if ($isElevated) {
                        Write-Warning "Current session is already elevated."
                    }
                    switch ($User) {
                        'PowerShell' {
                            if (-not (Test-Executable 'PowerShell.exe')) {
                                Write-Error "PowerShell.exe not found."
                                return
                            }
                            try {
                                Start-Process -FilePath "PowerShell.exe" -PassThru
                                Write-Verbose "Launched PowerShell."
                            }
                            catch {
                                Write-Error "Failed to launch PowerShell: $($_.Exception.Message)"
                            }
                        }
                        'pwsh' {
                            if (-not (Test-Executable 'pwsh.exe')) {
                                Write-Error "pwsh.exe not found."
                                return
                            }
                            try {
                                Start-Process -FilePath "pwsh.exe" -PassThru
                                Write-Verbose "Launched PowerShell Core."
                            }
                            catch {
                                Write-Error "Failed to launch PowerShell Core: $($_.Exception.Message)"
                            }
                        }
                        default {
                            Write-Error "Invalid value for -User parameter: $User"
                        }
                    }
                }
                'RunAs' {
                    if ($isElevated) {
                        Write-Warning "Current session is already elevated."
                    }
                    switch ($RunAs) {
                        'PowerShellRunAs' {
                            if (-not (Test-Executable 'PowerShell.exe')) {
                                Write-Error "PowerShell.exe not found."
                                return
                            }
                            try {
                                Start-Process -FilePath "PowerShell.exe" -Verb RunAs -PassThru
                                Write-Verbose "Launched elevated PowerShell."
                            }
                            catch {
                                Write-Error "Failed to launch elevated PowerShell: $($_.Exception.Message)"
                            }
                        }
                        'pwshRunAs' {
                            if (-not (Test-Executable 'pwsh.exe')) {
                                Write-Error "pwsh.exe not found."
                                return
                            }
                            try {
                                Start-Process -FilePath "pwsh.exe" -Verb RunAs -PassThru
                                Write-Verbose "Launched elevated PowerShell Core."
                            }
                            catch {
                                Write-Error "Failed to launch elevated PowerShell Core: $($_.Exception.Message)"
                            }
                        }
                        default {
                            Write-Error "Invalid value for -RunAs parameter: $RunAs"
                        }
                    }
                }
                'RunAsUser' {
                    if (-not $PSBoundParameters.ContainsKey('Credentials') -or -not $Credentials) {
                        Write-Error "-Credentials parameter is required for -RunAsUser."
                        return
                    }

                    $shellExecutable = $null
                    $shellDescription = $null

                    switch ($RunAsUser) {
                        'PowerShellRunAsUser' {
                            if (-not (Test-Executable 'PowerShell.exe')) {
                                Write-Error "PowerShell.exe not found."
                                return
                            }
                            $shellExecutable = 'PowerShell.exe'
                            $shellDescription = 'Windows PowerShell'
                        }
                        'pwshRunAsUser' {
                            if (-not (Test-Executable 'pwsh.exe')) {
                                Write-Error "pwsh.exe not found."
                                return
                            }
                            $shellExecutable = 'pwsh.exe'
                            $shellDescription = 'PowerShell Core'
                        }
                        default {
                            Write-Error "Invalid value for -RunAsUser parameter: $RunAsUser"
                            return
                        }
                    }

                    $process = $null
                    $useForceNewWindow = $PSBoundParameters.ContainsKey('ForceNewWindow') -and $ForceNewWindow.IsPresent

                    try {
                        if ($useForceNewWindow) {
                            if (-not (Test-Executable 'cmd.exe')) {
                                Write-Error "cmd.exe not found. Unable to launch a new window."
                                return
                            }

                            $titleValue = '""'
                            if ($PSBoundParameters.ContainsKey('WindowTitle') -and -not [string]::IsNullOrWhiteSpace($WindowTitle)) {
                                $sanitizedTitle = $WindowTitle.Replace('"', "'")
                                $titleValue = '"' + $sanitizedTitle + '"'
                            }

                            $argumentList = New-Object -TypeName 'System.Collections.Generic.List[string]'
                            [void]$argumentList.Add('/c')
                            [void]$argumentList.Add('start')
                            [void]$argumentList.Add($titleValue)
                            [void]$argumentList.Add($shellExecutable)

                            if ($PSBoundParameters.ContainsKey('ShellArgumentList') -and $ShellArgumentList) {
                                foreach ($argument in $ShellArgumentList) {
                                    if ([string]::IsNullOrWhiteSpace($argument)) {
                                        continue
                                    }

                                    [void]$argumentList.Add($argument)
                                }
                            }

                            $startProcessParameters = @{
                                FilePath          = 'cmd.exe'
                                ArgumentList      = $argumentList.ToArray()
                                Credential        = $Credentials
                                LoadUserProfile   = $true
                                UseNewEnvironment = $true
                                PassThru          = $true
                            }

                            $process = Start-Process @startProcessParameters
                            Write-Verbose "Launched $shellDescription as specified user in a new console window."
                        }
                        else {
                            $startProcessParameters = @{
                                FilePath          = $shellExecutable
                                Credential        = $Credentials
                                LoadUserProfile   = $true
                                UseNewEnvironment = $true
                                PassThru          = $true
                            }

                            if ($PSBoundParameters.ContainsKey('ShellArgumentList') -and $ShellArgumentList) {
                                $startProcessParameters['ArgumentList'] = $ShellArgumentList
                            }

                            $process = Start-Process @startProcessParameters
                            Write-Verbose "Launched $shellDescription as specified user."
                        }
                    }
                    catch {
                        Write-Error "Failed to launch $shellDescription as specified user: $($_.Exception.Message)"
                    }

                    if ($null -ne $process) {
                        $process
                    }
                }
                'Terminal' {
                    if (-not (Test-Executable 'wt.exe')) {
                        Write-Error "wt.exe (Windows Terminal) not found."
                        return
                    }
                    switch ($Terminal) {
                        'PowerShellTerminal' {
                            try {
                                Start-Process -FilePath "wt.exe" -ArgumentList "new-tab -p 'Windows PowerShell'" -PassThru
                                Write-Verbose "Launched Windows PowerShell in Windows Terminal."
                            }
                            catch {
                                Write-Error "Failed to launch Windows PowerShell in Windows Terminal: $($_.Exception.Message)"
                            }
                        }
                        'pwshTerminal' {
                            try {
                                Start-Process -FilePath "wt.exe" -ArgumentList "new-tab -p 'PowerShell'" -PassThru
                                Write-Verbose "Launched PowerShell Core in Windows Terminal."
                            }
                            catch {
                                Write-Error "Failed to launch PowerShell Core in Windows Terminal: $($_.Exception.Message)"
                            }
                        }
                        default {
                            Write-Error "Invalid value for -Terminal parameter: $Terminal"
                        }
                    }
                }
                'TerminalRunAs' {
                    if (-not (Test-Executable 'wt.exe')) {
                        Write-Error "wt.exe (Windows Terminal) not found."
                        return
                    }
                    switch ($TerminalRunAs) {
                        'PowerShellTerminalRunAs' {
                            try {
                                Start-Process -FilePath "wt.exe" -ArgumentList "new-tab -p 'Windows PowerShell'" -Verb RunAs -PassThru
                                Write-Verbose "Launched elevated Windows PowerShell in Windows Terminal."
                            }
                            catch {
                                Write-Error "Failed to launch elevated Windows PowerShell in Windows Terminal: $($_.Exception.Message)"
                            }
                        }
                        'pwshTerminalRunAs' {
                            try {
                                Start-Process -FilePath "wt.exe" -ArgumentList "new-tab -p 'PowerShell'" -Verb RunAs -PassThru
                                Write-Verbose "Launched elevated PowerShell Core in Windows Terminal."
                            }
                            catch {
                                Write-Error "Failed to launch elevated PowerShell Core in Windows Terminal: $($_.Exception.Message)"
                            }
                        }
                        default {
                            Write-Error "Invalid value for -TerminalRunAs parameter: $TerminalRunAs"
                        }
                    }
                }
                default {
                    Write-Error "Unknown parameter set: $($PSCmdlet.ParameterSetName)"
                }
            }
        }
        catch {
            Write-Error "An error occurred while processing the New-Shell function: $($_.Exception.Message)"
        }
    }

    end {
        Write-Verbose "New-Shell function execution completed."
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/New-Shell.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-Shell.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

