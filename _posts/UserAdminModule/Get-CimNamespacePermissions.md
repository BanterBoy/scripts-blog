---
layout: post
title: Get-CimNamespacePermissions.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Get-CimNamespacePermissions/
categories:
- UserAdminModule
- Security
tags:
- PowerShell
- User Admin Module
- Cim Namespace Permissions
description: No synopsis provided.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-CimNamespacePermissions {
    param (
        [string]$namespace
    )

    try {
        # Get the security descriptor for the namespace
        $cimSession = New-CimSession
        $security = Get-CimInstance -Namespace $namespace -ClassName __SystemSecurity -CimSession $cimSession

        $securityDescriptor = $security | Invoke-CimMethod -MethodName GetSecurityDescriptor
        $dacl = $securityDescriptor.Descriptor.DACL

        # Function to interpret AccessMask values
        function Interpret-AccessMask {
            param ([int]$accessMask)
            $permissions = @()
            if ($accessMask -band 1) { $permissions += "Remote Enable" }
            if ($accessMask -band 2) { $permissions += "Method Execute" }
            if ($accessMask -band 4) { $permissions += "Full Write" }
            if ($accessMask -band 8) { $permissions += "Partial Write" }
            if ($accessMask -band 16) { $permissions += "Provider Write" }
            if ($accessMask -band 32) { $permissions += "Subscribe" }
            if ($accessMask -band 64) { $permissions += "Reserved1" }
            if ($accessMask -band 128) { $permissions += "Reserved2" }
            if ($accessMask -band 256) { $permissions += "Read Security" }
            if ($accessMask -band 512) { $permissions += "Write Security" }
            if ($accessMask -band 1024) { $permissions += "Change Owner" }
            if ($accessMask -band 2048) { $permissions += "Full Control" }
            return [string]::Join(", ", $permissions)
        }

        # Function to interpret AceType values
        function Interpret-AceType {
            param ([int]$aceType)
            switch ($aceType) {
                0 { return "Allow" }
                1 { return "Deny" }
                2 { return "Audit Success" }
                3 { return "Audit Failure" }
                default { return "Unknown" }
            }
        }

        # Function to interpret AceFlags values
        function Interpret-AceFlags {
            param ([int]$aceFlags)
            $flags = @()
            if ($aceFlags -band 1) { $flags += "Object Inherit" }
            if ($aceFlags -band 2) { $flags += "Container Inherit" }
            if ($aceFlags -band 4) { $flags += "No Propagate Inherit" }
            if ($aceFlags -band 8) { $flags += "Inherit Only" }
            if ($aceFlags -band 16) { $flags += "Inherited" }
            if ($aceFlags -band 32) { $flags += "Successful Access Audit" }
            if ($aceFlags -band 64) { $flags += "Failed Access Audit" }
            return [string]::Join(", ", $flags)
        }

        # Display each ACE (Access Control Entry)
        foreach ($ace in $dacl) {
            $sid = New-Object System.Security.Principal.SecurityIdentifier($ace.Trustee.SIDString)
            $accountName = $sid.Translate([System.Security.Principal.NTAccount])
            [PSCustomObject]@{
                Namespace           = $namespace
                Account             = $accountName
                AccessMask          = $ace.AccessMask
                InterpretedAccess   = Interpret-AccessMask $ace.AccessMask
                AceType             = $ace.AceType
                InterpretedAceType  = Interpret-AceType $ace.AceType
                AceFlags            = $ace.AceFlags
                InterpretedAceFlags = Interpret-AceFlags $ace.AceFlags
                Inherited           = $ace.IsInherited
            }
        }
    }
    catch {
        Write-Error "Failed to retrieve WMI permissions for namespace ${namespace}: $_"
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Get-CimNamespacePermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-CimNamespacePermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

