---
layout: post
title: Get-RunRegKeys.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-RunRegKeys/
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

Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path.

#### Detailed Description

The Get-RunRegKeys function retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the specified computer(s). It can be used to check the programs that are set to run automatically when the computer starts up.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-RunRegKeys
```

Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the local computer.

**Example 2**

```powershell
Get-RunRegKeys -ComputerName 'Server01', 'Server02' -Credential $cred
```

Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the specified remote computers using the specified credentials.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path.

.DESCRIPTION
The Get-RunRegKeys function retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the specified computer(s). It can be used to check the programs that are set to run automatically when the computer starts up.

.PARAMETER ComputerName
Specifies the name(s) of the computer(s) to retrieve the registry keys from. If not specified, the function will use the local computer.

.PARAMETER Credential
Specifies the credentials to use when connecting to remote computers. This parameter is optional.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.String
The function outputs the registry keys as strings.

.EXAMPLE
Get-RunRegKeys
Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the local computer.

.EXAMPLE
Get-RunRegKeys -ComputerName 'Server01', 'Server02' -Credential $cred
Retrieves the registry keys under the "Run" subkey of the HKLM:\Software\Microsoft\Windows\CurrentVersion registry path on the specified remote computers using the specified credentials.

.LINK
https://github.com/BanterBoy

#>
function Get-RunRegKeys {
    [CmdletBinding(DefaultParameterSetName = 'Default',
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
            HelpMessage = 'Enter computer name or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    $scriptBlock = {
        $path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
        Get-ItemProperty -Path $path
    }

    foreach ($Computer in $ComputerName) {
        if ($Credential) {
            Invoke-Command -ComputerName $Computer -Credential $Credential -ScriptBlock $scriptBlock
        }
        else {
            Invoke-Command -ComputerName $Computer -ScriptBlock $scriptBlock
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-RunRegKeys.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RunRegKeys.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

