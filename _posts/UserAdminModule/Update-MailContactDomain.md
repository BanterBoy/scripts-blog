---
layout: post
title: Update-MailContactDomain.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/exchange/update-mailcontactdomain/
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

Updates the external email domain and alias for MailContacts.

#### Detailed Description

The Update-MailContacts function retrieves all MailContacts whose ExternalEmailAddress ends with the specified old domain. It constructs a new external email address by replacing the old domain with the new domain while preserving any SMTP prefix (e.g., "smtp:") and retaining the local part of the email address. The function also updates the MailContact's alias to match the local part of the email address.

This function supports ShouldProcess, so you can use the -WhatIf parameter to preview changes before making them, or -Confirm to prompt for confirmation.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk"
```

This command updates all MailContacts with an ExternalEmailAddress ending in "demo.com" so that their addresses now use "testchange.co.uk", preserving any SMTP prefix and the local-part of the email address.

**Example 2**

```powershell
Get-MailContact -Filter "ExternalEmailAddress -like '*@demo.com'" | ForEach-Object {
```

$_.ExternalEmailAddress } # Then run: Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk" to apply the changes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2025-05-23 This function requires the appropriate MailContact cmdlets, which are available in Exchange Online or on-premises Exchange environments. Test thoroughly with -WhatIf before running in production.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Updates the external email domain and alias for MailContacts.

.DESCRIPTION
    The Update-MailContacts function retrieves all MailContacts whose ExternalEmailAddress ends 
    with the specified old domain. It constructs a new external email address by replacing the old 
    domain with the new domain while preserving any SMTP prefix (e.g., "smtp:") and retaining the local 
    part of the email address. The function also updates the MailContact's alias to match the local part 
    of the email address.
    
    This function supports ShouldProcess, so you can use the -WhatIf parameter to preview changes 
    before making them, or -Confirm to prompt for confirmation.

.PARAMETER OldDomain
    Specifies the domain to change from (e.g., "demo.com"). Only MailContacts with an ExternalEmailAddress 
    ending in this domain will be processed.

.PARAMETER NewDomain
    Specifies the domain to change to (e.g., "testchange.co.uk"). The function updates the ExternalEmailAddress 
    for each MailContact accordingly.

.EXAMPLE
    Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk"
    This command updates all MailContacts with an ExternalEmailAddress ending in "demo.com" so that their addresses 
    now use "testchange.co.uk", preserving any SMTP prefix and the local-part of the email address.

.EXAMPLE
    Get-MailContact -Filter "ExternalEmailAddress -like '*@demo.com'" | ForEach-Object {
        $_.ExternalEmailAddress
    }
    # Then run:
    Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk"
    to apply the changes.

.NOTES
    Author: Your Name
    Date: 2025-05-23
    This function requires the appropriate MailContact cmdlets, which are available in Exchange Online 
    or on-premises Exchange environments. Test thoroughly with -WhatIf before running in production.
    
.LINK
    Set-MailContact
    Get-MailContact
#>
function Update-MailContacts {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = "The domain to change from, e.g., demo.com")]
        [string]$OldDomain,

        [Parameter(Mandatory = $true,
            HelpMessage = "The domain to change to, e.g., testchange.co.uk")]
        [string]$NewDomain
    )

    process {
        Get-MailContact -Filter "ExternalEmailAddress -like '*@$OldDomain'" | ForEach-Object {
            try {
                $raw = $_.ExternalEmailAddress.ToString()
                $prefix = ($raw -match '^[Ss][Mm][Tt][Pp]:') ? ($raw -replace '(^[Ss][Mm][Tt][Pp]:).*', '$1') : ''
                $emailNoPrefix = $raw -replace '^[Ss][Mm][Tt][Pp]:', ''
                $local = $emailNoPrefix.Split('@')[0]
                $newEmail = "$prefix$local@$NewDomain"

                if ($PSCmdlet.ShouldProcess($_.Identity, "Update ExternalEmailAddress to '$newEmail'")) {
                    Set-MailContact -Identity $_.Identity -ExternalEmailAddress $newEmail -Confirm:$false
                }
                if ($PSCmdlet.ShouldProcess($_.Identity, "Update Alias to '$local'")) {
                    Set-MailContact -Identity $_.Identity -Alias $local
                }
            }
            catch {
                Write-Error "Error updating mail contact $($_.Identity): $_"
            }
        }
    }
}

# To run the function:
# Update-MailContacts -OldDomain "demo.com" -NewDomain "testchange.co.uk"
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Update-MailContactDomain.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Update-MailContactDomain.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

