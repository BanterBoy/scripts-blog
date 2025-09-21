---
layout: post
title: Get-ADGroupNames.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/adfunctions/get-adgroupnames/
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

Extracts members of an Active Directory group based on the group name.

#### Detailed Description

The Get-ADGroupNames function extracts members of an Active Directory group based on the group name. It supports wildcards in the group name.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-ADGroupNames -GroupName "Domain Admins"
```

Extracts members of the "Domain Admins" group.

**Example 2**

```powershell
Get-ADGroupNames -GroupName "Sales*"
```

Extracts members of all groups starting with "Sales".

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date:   Today's date

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Extracts members of an Active Directory group based on the group name.

.DESCRIPTION
    The Get-ADGroupNames function extracts members of an Active Directory group based on the group name. 
    It supports wildcards in the group name.

.PARAMETER GroupName
    Specifies the name of the group to search for. This field supports wildcards.

.EXAMPLE
    Get-ADGroupNames -GroupName "Domain Admins"
    Extracts members of the "Domain Admins" group.

.EXAMPLE
    Get-ADGroupNames -GroupName "Sales*"
    Extracts members of all groups starting with "Sales".

.INPUTS
    None.

.OUTPUTS
    Returns a list of members of the specified group.

.NOTES
    Author: Your Name
    Date:   Today's date
#>
function Get-ADGroupNames {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the group name that you want to search for. This field supports wildcards.')]
        [String]$GroupName = '*'
    )

    begin {
        # Update-FormatData -PrependPath "$PSScriptRoot\Get-ADGroupNames.Format.ps1xml"
    }

    process {
        if ($PSCmdlet.ShouldProcess("$GroupName", "Extract members of group")) {
            Get-ADGroup -Filter "Name -like '$GroupName'" -Properties *
        }
    }

    end {
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADGroupNames.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADGroupNames.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

