---
layout: post
title: Remove-RunOnceRegKey.ps1
date: 2025-09-19
permalink: /useradminmodule/utilities/remove-runonceregkey/
categories:
  - UserAdminModule
  - Utilities
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

Removes a specified registry key from the RunOnce registry path.

#### Detailed Description

This function removes a specified registry key from the "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" path on the local or remote computers. It can accept computer names and credentials as input and uses PowerShell remoting to execute the task on remote systems.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Remove-RunOnceRegKey -KeyName "MyRunOnceKey"
```

Removes the "MyRunOnceKey" from the RunOnce path on the local computer.

**Example 2**

```powershell
Remove-RunOnceRegKey -ComputerName "Server01" -Credential (Get-Credential) -KeyName "MyRunOnceKey"
```

Removes the "MyRunOnceKey" from the RunOnce path on the remote computer "Server01" using the provided credentials.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Date: [Today's Date]

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Remove-RunOnceRegKey {
    <#
    .SYNOPSIS
        Removes a specified registry key from the RunOnce registry path.

    .DESCRIPTION
        This function removes a specified registry key from the "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" path on the local or remote computers. 
        It can accept computer names and credentials as input and uses PowerShell remoting to execute the task on remote systems.

    .PARAMETER ComputerName
        The name of the computer(s) to perform the action on. Defaults to the local computer if not specified.

    .PARAMETER Credential
        The credential to use for remote connections.

    .PARAMETER KeyName
        The name of the registry key to remove from the RunOnce path.

    .EXAMPLE
        Remove-RunOnceRegKey -KeyName "MyRunOnceKey"
        Removes the "MyRunOnceKey" from the RunOnce path on the local computer.

    .EXAMPLE
        Remove-RunOnceRegKey -ComputerName "Server01" -Credential (Get-Credential) -KeyName "MyRunOnceKey"
        Removes the "MyRunOnceKey" from the RunOnce path on the remote computer "Server01" using the provided credentials.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        HelpUri = 'https://github.com/BanterBoy'
    )]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter credential for remote connections'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Enter the name of the registry key to remove'
        )]
        [string]$KeyName
    )

    # ScriptBlock to execute on remote computers
    $scriptBlock = {
        param($KeyName)
        $path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
        try {
            Write-Verbose "Attempting to get the item property for key: $KeyName"
            Get-ItemProperty -Path $path -Name $KeyName -ErrorAction Stop
            Write-Verbose "Removing item property for key: $KeyName"
            Remove-ItemProperty -Path $path -Name $KeyName -ErrorAction Stop
            Write-Output "Key $KeyName removed successfully."
        }
        catch {
            Write-Warning "Key $KeyName does not exist or could not be removed. Error: $_"
        }
    }

    foreach ($Computer in $ComputerName) {
        if ($PSCmdlet.ShouldProcess($Computer, "Remove RunOnce key $KeyName")) {
            Write-Verbose "Processing computer: $Computer"
            if ($Credential) {
                Write-Verbose "Using credentials for remote connection."
                Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock $scriptBlock -ArgumentList $KeyName -Verbose
            }
            else {
                Write-Verbose "Connecting without credentials."
                Invoke-Command -ComputerName $Computer -ScriptBlock $scriptBlock -ArgumentList $KeyName -Verbose
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Remove-RunOnceRegKey.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Remove-RunOnceRegKey.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

