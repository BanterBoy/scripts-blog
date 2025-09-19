---
layout: post
title: Get-ADUserSearch2.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-ADUserSearch2/
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Get-ADUserSearch2 {
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$SamAccountName,

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$DisplayName,

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserPrincipalName,

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$proxyAddress,

        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [ValidateNotNullOrEmpty()]
        [string[]]$EmailAddress,

        [Parameter()]
        [switch]$PasswordDetailsOnly
    )

    BEGIN {
        Write-Verbose "Starting Get-ADUserSearch function"
        $filterParts = @()
        $properties = @(
            'SamAccountName','PasswordLastSet','PasswordExpired','PasswordNeverExpires',
            'PasswordNotRequired','AccountExpirationDate','Enabled'
        )
if (-not $PasswordDetailsOnly) {
    $properties += @(
        'GivenName','Surname','DisplayName','EmployeeID','Description','Title','Company',
        'Department','departmentNumber','Office','physicalDeliveryOfficeName','StreetAddress',
        'City','State','Country','PostalCode',
        # Replace this line:
        # 'extensionAttribute',
        # With the following:
        'extensionAttribute1','extensionAttribute2','extensionAttribute3','extensionAttribute4','extensionAttribute5',
        'extensionAttribute6','extensionAttribute7','extensionAttribute8','extensionAttribute9','extensionAttribute10',
        'extensionAttribute11','extensionAttribute12','extensionAttribute13','extensionAttribute14','extensionAttribute15',
        'Manager','distinguishedName',
        'HomePhone','OfficePhone','MobilePhone','Fax','mail','mailNickname','EmailAddress',
        'UserPrincipalName','proxyAddresses','HomePage','ProfilePath','HomeDirectory',
        'HomeDrive','ScriptPath','LockedOut','directReports','MemberOf'
    )
        }
    }

    PROCESS {
        # Build filter string for each parameter
        foreach ($param in @('SamAccountName','DisplayName','UserPrincipalName','proxyAddress','EmailAddress')) {
            $value = Get-Variable $param -ValueOnly
            if ($value) {
                foreach ($item in $value) {
                    switch ($param) {
                        'proxyAddress' { $filterParts += "(proxyAddresses -like '*$item*')" }
                        default        { $filterParts += "($param -like '$item')" }
                    }
                    Write-Verbose "Filtering by ${$param}: $item"
                }
            }
        }
        if (-not $filterParts) {
            Write-Error "No filter parameters provided. Please specify at least one search parameter."
            return
        }
        $filterString = $filterParts -join ' -or '
        Write-Verbose "Constructed filter: $filterString"

        try {
            $users = Get-ADUser -Filter $filterString -Properties $properties -ErrorAction Stop
            Write-Verbose "Retrieved $($users.Count) users"
        }
        catch {
            Write-Error "Failed to retrieve users: $($_.Exception.Message)"
            return
        }

        foreach ($user in $users) {
            try {
                if ($PasswordDetailsOnly) {
                    $output = [PSCustomObject]@{
                        SamAccountName        = $user.SamAccountName
                        PasswordAgeDays       = if ($user.PasswordLastSet) { [math]::Round((New-TimeSpan -Start $user.PasswordLastSet -End (Get-Date)).TotalDays, 2) } else { $null }
                        PasswordLastSet       = $user.PasswordLastSet
                        PasswordExpired       = $user.PasswordExpired
                        PasswordNeverExpires  = $user.PasswordNeverExpires
                        PasswordNotRequired   = $user.PasswordNotRequired
                        AccountExpirationDate = $user.AccountExpirationDate
                        Enabled               = [bool]$user.Enabled
                    }
                    $output.PSObject.TypeNames.Insert(0, 'Custom.ADUserPasswordDetails')
                }
                else {
                    $managerDisplayNames = if ($user.Manager) {
                        try {
                            (Get-ADUser -Identity $user.Manager -Properties DisplayName).DisplayName
                        } catch { $null }
                    }
                    $directReportsDisplayNames = if ($user.directReports) {
                        $user.directReports | ForEach-Object {
                            try {
                                (Get-ADUser -Identity $_ -Properties DisplayName).DisplayName
                            } catch { $null }
                        }
                    }
                    $memberOfGroupNames = if ($user.MemberOf) {
                        $user.MemberOf | ForEach-Object {
                            try {
                                (Get-ADGroup -Identity $_).Name
                            } catch { $null }
                        }
                    }
                    $passwordStatus = @{
                        PasswordAgeDays      = if ($user.PasswordLastSet) { [math]::Round((New-TimeSpan -Start $user.PasswordLastSet -End (Get-Date)).TotalDays, 2) } else { $null }
                        PasswordExpired      = $user.PasswordExpired
                        PasswordNeverExpires = $user.PasswordNeverExpires
                        PasswordNotRequired  = $user.PasswordNotRequired
                    }
                    # Build core output with known fields first
                    $coreFields = @{
                        SamAccountName             = $user.SamAccountName
                        GivenName                  = $user.GivenName
                        Surname                    = $user.Surname
                        DisplayName                = $user.DisplayName
                        EmployeeID                 = $user.EmployeeID
                        Description                = $user.Description
                        Title                      = $user.Title
                        Company                    = $user.Company
                        Department                 = $user.Department
                        departmentNumber           = $user.departmentNumber
                        Office                     = $user.Office
                        physicalDeliveryOfficeName = $user.physicalDeliveryOfficeName
                        StreetAddress              = $user.StreetAddress
                        City                       = $user.City
                        State                      = $user.State
                        Country                    = $user.Country
                        PostalCode                 = $user.PostalCode
                        Manager                    = $managerDisplayNames
                        distinguishedName          = $user.distinguishedName
                        HomePhone                  = $user.HomePhone
                        OfficePhone                = $user.OfficePhone
                        MobilePhone                = $user.MobilePhone
                        Fax                        = $user.Fax
                        mail                       = $user.mail
                        mailNickname               = $user.mailNickname
                        EmailAddress               = $user.EmailAddress
                        UserPrincipalName          = $user.UserPrincipalName
                        proxyAddresses             = $user.proxyAddresses
                        HomePage                   = $user.HomePage
                        ProfilePath                = $user.ProfilePath
                        HomeDirectory              = $user.HomeDirectory
                        HomeDrive                  = $user.HomeDrive
                        ScriptPath                 = $user.ScriptPath
                        AccountExpirationDate      = $user.AccountExpirationDate
                        PasswordLastSet            = $user.PasswordLastSet
                        LockedOut                  = ([bool]$user.LockedOut)
                        Enabled                    = ([bool]$user.Enabled)
                        directReports              = $directReportsDisplayNames
                        MemberOf                   = $memberOfGroupNames
                        PasswordStatus             = @{ PasswordAgeDays = $passwordStatus.PasswordAgeDays; PasswordExpired = ([bool]$passwordStatus.PasswordExpired); PasswordNeverExpires = ([bool]$passwordStatus.PasswordNeverExpires); PasswordNotRequired = ([bool]$passwordStatus.PasswordNotRequired) }
                    }

                    # Dynamically add any other properties returned by Get-ADUser (extensionAttribute*, custom attributes, booleans, etc.)
                    # Use MemberType 'Property' because AD user attributes are returned as properties, not NoteProperty
                    $allProps = ($user | Get-Member -MemberType Property | Select-Object -ExpandProperty Name)
                    foreach ($propName in $allProps) {
                        if ($coreFields.ContainsKey($propName)) { continue }
                        try {
                            $val = $user.$propName
                        } catch {
                            $val = $null
                        }

                        # If the source value is already a boolean type, preserve it.
                        if ($val -is [bool]) {
                            $coreFields[$propName] = [bool]$val
                        }
                        # If the value is a string exactly 'True'/'False' (case-insensitive), convert to bool
                        elseif ($val -is [string] -and $val -match '^(?i:true|false)$') {
                            $coreFields[$propName] = [bool]::Parse($val)
                        }
                        else {
                            # Preserve arrays and other types as-is (extensionAttribute may be empty/null)
                            $coreFields[$propName] = $val
                        }
                    }

                    # Create output object from the combined fields
                    $output = New-Object -TypeName PSCustomObject -Property $coreFields
                    $output.PSObject.TypeNames.Insert(0, 'Custom.ADUserDetails')
                }
                Write-Output $output
            }
            catch {
                Write-Error "Failed to process user '$($user.SamAccountName)': $($_.Exception.Message)"
                continue
            }
        }
    }

    END {
        Write-Verbose "Completed Get-ADUserSearch function"
    }
}

Update-FormatData -PrependPath "$PSScriptRoot\Get-ADUserSearch.UserDetails2.Format.ps1xml"
Update-FormatData -PrependPath "$PSScriptRoot\Get-ADUserSearch.PasswordDetails.Format.ps1xml"
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/ADFunctions/Public/Get-ADUserSearch2.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ADUserSearch2.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

