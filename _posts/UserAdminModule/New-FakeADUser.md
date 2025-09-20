---
layout: post
title: New-FakeADUser.ps1
date: 2025-09-19
permalink: /useradminmodule/adfunctions/new-fakeaduser/
categories:
  - UserAdminModule
  - ADFunctions
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

Creates a new fake Active Directory user.

#### Detailed Description

This function creates a new fake Active Directory user with the specified parameters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> New-FakeADUser -Name "John Doe" -Title "Manager" -GivenName "John" -Surname "Doe" -DisplayName "John Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@contoso.com" -StreetAddress "123 Main St" -State "CA" -City "Los Angeles" -Country "USA" -PostalCode "90001" -AccountPassword "P@ssw0rd" -Path "OU=Users,DC=contoso,DC=com"
```

This example creates a new fake Active Directory user with the specified parameters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

General notes about the function.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function New-FakeADUser {

    <#
    .SYNOPSIS
        Creates a new fake Active Directory user.
    
    .DESCRIPTION
        This function creates a new fake Active Directory user with the specified parameters.
    
    .EXAMPLE
        PS C:\> New-FakeADUser -Name "John Doe" -Title "Manager" -GivenName "John" -Surname "Doe" -DisplayName "John Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@contoso.com" -StreetAddress "123 Main St" -State "CA" -City "Los Angeles" -Country "USA" -PostalCode "90001" -AccountPassword "P@ssw0rd" -Path "OU=Users,DC=contoso,DC=com"
    
        This example creates a new fake Active Directory user with the specified parameters.
    
    .INPUTS
        None.
    
    .OUTPUTS
        None.
    
    .NOTES
        General notes about the function.
    #>
        
    [CmdletBinding(
        SupportsShouldProcess = $true,
        DefaultParameterSetName = "Default")]
    param (
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the name of the user."
        )]
        [string]
        $Name,
            
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the title of the user."
        )]
        [string]
        $Title,
    
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the given name of the user."
        )]
        [string]
        $GivenName,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the surname of the user."
        )]
        [string]
        $Surname,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the display name of the user."
        )]
        [string]
        $DisplayName,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the SamAccountName of the user."
        )]
        [string]
        $SamAccountName,

        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the street address of the user."
        )]
        [string]
        $StreetAddress,
        
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the state of the user."
        )]
        [string]
        $State,
            
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the city of the user."
        )]
        [string]
        $City,
            
        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the country of the user."
        )]
        [string]
        $Country,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the postal code of the user."
        )]
        [string]
        $PostalCode,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the user principal name of the user."
        )]
        [string]
        $UserPrincipalName,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the path of the user."
        )]
        [string]
        $Path,

        [Parameter(
            Mandatory = $false,
            ParameterSetName = "Default",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Please enter the account password of the user."
        )]
        [string]
        $AccountPassword
            
    )
            
    begin {
                
    }
    
    process {

        $userUserSettings = @{
            Name                  = $_.Name
            Title                 = $_.Title
            GivenName             = $_.GivenName
            Surname               = $_.Surname
            DisplayName           = $_.DisplayName
            SamAccountName        = $_.SamAccountName
            UserPrincipalName     = $_.UserPrincipalName
            StreetAddress         = $_.StreetAddress
            State                 = $_.State
            City                  = $_.City
            Country               = $_.Country
            PostalCode            = $_.PostalCode
            AccountPassword       = (ConvertTo-SecureString -String $AccountPassword -AsPlainText -Force)
            Enabled               = $true
            ChangePasswordAtLogon = $true
            Path                  = $_.Path
        }
        
        New-ADUser @userUserSettings -verbose
        
    }
        
    end {
        
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/New-FakeADUser.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-FakeADUser.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

