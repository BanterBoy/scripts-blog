---
layout: post
title: Set-DistributionGroupProperties.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Set-DistributionGroupProperties/
categories:
  - UserAdminModule
  - Exchange
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

Sets properties for distribution groups in Exchange.

#### Detailed Description

This function sets various properties for distribution groups in Exchange. It takes a PSObject representing a distribution group and modifies its properties based on the provided values. It can handle setting names, aliases, primary SMTP addresses, and additional email addresses including x500 addresses.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Import-Csv -Path 'path_to_your_csv_file.csv' | Set-DistributionGroupProperties
```

This example reads a CSV file and pipes the results to the Set-DistributionGroupProperties function. The CSV file should contain columns that match the properties expected by the function.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Last Edit: 2024-06-30

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Set-DistributionGroupProperties {
    <#
    .SYNOPSIS
        Sets properties for distribution groups in Exchange.

    .DESCRIPTION
        This function sets various properties for distribution groups in Exchange. It takes a PSObject representing a distribution group and modifies its properties based on the provided values. It can handle setting names, aliases, primary SMTP addresses, and additional email addresses including x500 addresses.

    .PARAMETER DistributionGroup
        The distribution group object containing the properties to be set. This object should have the properties: PrimarySmtpAddress, Name, NEWName, Alias, DisplayName, NEWPrimarySmtpAddress, FULLADDRESS, and LegacyExchangeDN.

    .EXAMPLE
        Import-Csv -Path 'path_to_your_csv_file.csv' | Set-DistributionGroupProperties

        This example reads a CSV file and pipes the results to the Set-DistributionGroupProperties function. The CSV file should contain columns that match the properties expected by the function.

    .NOTES
        Author: Luke Leigh
        Last Edit: 2024-06-30

    .LINK
        https://github.com/BanterBoy

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [PSObject]$DistributionGroup
    )

    begin {
        Write-Verbose "Starting Set-DistributionGroupProperties function"
    }

    process {
        try {
            $PrimarySmtpAddress = $DistributionGroup.PrimarySmtpAddress
            Write-Verbose "Working on Group: $($DistributionGroup.Name)"

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Set properties")) {
                Write-Verbose "Setting properties for Group: $($DistributionGroup.Name)"
                Set-DistributionGroup -Identity $DistributionGroup.NEWName -Name $DistributionGroup.Name -Alias $DistributionGroup.Alias -DisplayName $DistributionGroup.DisplayName -PrimarySmtpAddress $PrimarySmtpAddress -HiddenFromAddressListsEnabled $false
                Write-Verbose "Properties set for Group: $($DistributionGroup.Name)"
            }

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Remove new primary SMTP address")) {
                Write-Verbose "Removing new primary SMTP address for Group: $($DistributionGroup.Name)"
                Set-DistributionGroup -Identity $DistributionGroup.PrimarySmtpAddress -EmailAddresses @{remove = $DistributionGroup.NEWPrimarySmtpAddress }
                Write-Verbose "New primary SMTP address removed for Group: $($DistributionGroup.Name)"
            }

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Add full address")) {
                Write-Verbose "Adding full address for Group: $($DistributionGroup.Name)"
                Set-DistributionGroup -Identity $DistributionGroup.PrimarySmtpAddress -EmailAddresses @{Add = $DistributionGroup.FULLADDRESS }
                Write-Verbose "Full address added for Group: $($DistributionGroup.Name)"
            }

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Add x500 address")) {
                Write-Verbose "Adding x500 address for Group: $($DistributionGroup.Name)"
                $LegacyExchangeDN = "x500:" + $DistributionGroup.LegacyExchangeDN
                Set-DistributionGroup -Identity $DistributionGroup.PrimarySmtpAddress -EmailAddresses @{Add = $LegacyExchangeDN }
                Write-Verbose "x500 address added for Group: $($DistributionGroup.Name)"
            }
        }
        catch {
            Write-Error "An error occurred while processing Group: $($DistributionGroup.Name). Error: $_"
        }
    }

    end {
        Write-Verbose "Ending Set-DistributionGroupProperties function"
    }
}

# Example usage:
# Import-Csv -Path 'path_to_your_csv_file.csv' | Set-DistributionGroupProperties -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Exchange/Public/Set-DistributionGroupProperties.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Set-DistributionGroupProperties.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

