---
layout: post
title: Convert-AzuretoOnPrem.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/azure/convert-azuretoonprem/
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

Converts Azure AD users to on-premises AD users.

#### Detailed Description

This script converts Azure AD users to on-premises AD users by performing the following steps: 1. Retrieves the Azure AD user based on the provided UserPrincipalName. 2. Converts the Azure AD user to an on-premises AD user. 3. Creates the on-premises AD user. 4. Exports the on-premises AD user details. 5. Sets the ImmutableId of the Azure AD user to match the ObjectGuid of the on-premises AD user.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Convert-AzuretoOnPrem -AzureADUser "john.doe@contoso.com" -AccountPassword (ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force)
```

This example converts the Azure AD user with the UserPrincipalName "john.doe@contoso.com" to an on-premises AD user with the specified account password.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

This script requires the AzureAD module to be imported.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
<#
.SYNOPSIS
Converts Azure AD users to on-premises AD users.

.DESCRIPTION
This script converts Azure AD users to on-premises AD users by performing the following steps:
1. Retrieves the Azure AD user based on the provided UserPrincipalName.
2. Converts the Azure AD user to an on-premises AD user.
3. Creates the on-premises AD user.
4. Exports the on-premises AD user details.
5. Sets the ImmutableId of the Azure AD user to match the ObjectGuid of the on-premises AD user.

.PARAMETER AzureADUser
Specifies the UserPrincipalName for the Azure AD account to be converted. This parameter is mandatory.

.PARAMETER AccountPassword
Specifies the password for the converted Azure AD account. This parameter is optional and defaults to 'ThisIsMyPassword.1234'.

.EXAMPLE
Convert-AzuretoOnPrem -AzureADUser "john.doe@contoso.com" -AccountPassword (ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force)

This example converts the Azure AD user with the UserPrincipalName "john.doe@contoso.com" to an on-premises AD user with the specified account password.

.NOTES
This script requires the AzureAD module to be imported.

.LINK
https://docs.microsoft.com/en-us/powershell/module/azuread/
#>
function Convert-AzuretoOnPrem {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the Azure Account to be converted.'
        )]
        [string[]]$AzureADUser,

        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a password for the converted Azure Account or pipe input. This is not a mandatory field and defaults to ThisIsMyPassword.1234'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $AccountPassword = (New-Object System.Management.Automation.PSCredential 'dummy', (ConvertTo-SecureString -String 'ThisIsMyPassword.1234' -AsPlainText -Force))
    )

    begin {
        Import-Module AzureAD
    }

    process {
        
        $users = Get-AzureADUser -ObjectId $AzureADUser
        foreach ($user in $users) {
            if ($PSCmdlet.ShouldProcess("$User", "Convertion of Azure AD user to on-premises AD user")) {
                $adUser = ConvertTo-ADUser -AzureADUser $user -AccountPassword $AccountPassword
                New-OnPremADUser -ADUser $adUser
                Export-ADUser -ADUser $adUser
                Set-AzureADUserImmutableId -AzureADUser $user -ADUser $adUser
            }
        }
    }

    end {
        Write-Output "Script completed."
    }
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Azure/Public/Convert-AzuretoOnPrem.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Convert-AzuretoOnPrem.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

