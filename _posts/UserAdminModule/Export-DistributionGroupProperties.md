---
layout: post
title: Export-DistributionGroupProperties.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/export-distributiongroupproperties/
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

Exports the properties of a distribution group.

#### Detailed Description

The Export-DistributionGroupProperties function retrieves the properties of a distribution group and its members. It returns the properties as a PSObject.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$groupProperties = Export-DistributionGroupProperties -GroupIdentity "Rars Comms"
```

This example exports the properties of the distribution group with the identity "Rars Comms" and assigns the result to the $groupProperties variable.

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
Exports the properties of a distribution group.

.DESCRIPTION
The Export-DistributionGroupProperties function retrieves the properties of a distribution group and its members. It returns the properties as a PSObject.

.PARAMETER GroupIdentity
Specifies the identity of the distribution group. This parameter is mandatory.

.EXAMPLE
$groupProperties = Export-DistributionGroupProperties -GroupIdentity "Rars Comms"
This example exports the properties of the distribution group with the identity "Rars Comms" and assigns the result to the $groupProperties variable.

#>
function Export-DistributionGroupProperties {
    param(
        [Parameter(Mandatory = $true)]
        [string]$GroupIdentity
    )

    # Get the distribution group
    $group = Get-DistributionGroup -Identity $GroupIdentity

    # Get the group's properties
    $properties = Get-Recipient $group.Identity | Select-Object RecipientTypeDetails, Name, Alias, DisplayName, PrimarySmtpAddress, SMTPDomain, MemberJoinRestriction, MemberDepartRestriction, RequireSenderAuthenticationEnabled, ManagedBy, AcceptMessagesOnlyFrom, AcceptMessagesOnlyFromDLMembers, AcceptMessagesOnlyFromSendersOrMembers, ModeratedBy, BypassModerationFromSendersOrMembers, GrantSendOnBehalfTo, ModerationEnabled, SendModerationNotifications, LegacyExchangeDN, EmailAddresses

    # Get the members of the group
    $members = Get-DistributionGroupMember -Identity $GroupIdentity | ForEach-Object { Get-Recipient $_.Identity | Select-Object -ExpandProperty PrimarySmtpAddress }

    # Add the members to the properties object
    $properties | Add-Member -Type NoteProperty -Name Members -Value $members

    # Return the properties as a PSObject
    return $properties
}

# $groupProperties = Export-DistributionGroupProperties -GroupIdentity "Rars Comms"
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Export-DistributionGroupProperties.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-DistributionGroupProperties.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

