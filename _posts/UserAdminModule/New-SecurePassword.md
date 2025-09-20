---
layout: post
title: New-SecurePassword.ps1
date: 2025-09-19
permalink: /useradminmodule/replication/new-securepassword/
categories:
  - UserAdminModule
  - Replication
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

Generates a secure password with specified complexity requirements.

#### Detailed Description

This function generates a secure password of a specified length with a minimum number of uppercase letters, lowercase letters, digits, and special characters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
PS C:\> New-SecurePassword -length 16 -minUpperCase 2 -minLowerCase 2 -minDigits 2 -minSpecialChars 2 -Verbose
```

Generates a secure password with a length of 16 characters, including at least 2 uppercase letters, 2 lowercase letters, 2 digits, and 2 special characters.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Your Name Date: 2024-06-30

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
.SYNOPSIS
    Generates a secure password with specified complexity requirements.

.DESCRIPTION
    This function generates a secure password of a specified length with a minimum number of uppercase letters, lowercase letters, digits, and special characters.

.PARAMETER length
    The total length of the generated password. Default is 12.

.PARAMETER minUpperCase
    The minimum number of uppercase letters in the generated password. Default is 1.

.PARAMETER minLowerCase
    The minimum number of lowercase letters in the generated password. Default is 1.

.PARAMETER minDigits
    The minimum number of digits in the generated password. Default is 1.

.PARAMETER minSpecialChars
    The minimum number of special characters in the generated password. Default is 1.

.EXAMPLE
    PS C:\> New-SecurePassword -length 16 -minUpperCase 2 -minLowerCase 2 -minDigits 2 -minSpecialChars 2 -Verbose
    Generates a secure password with a length of 16 characters, including at least 2 uppercase letters, 2 lowercase letters, 2 digits, and 2 special characters.

.NOTES
    Author: Your Name
    Date: 2024-06-30
#>

function New-SecurePassword {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]$length = 12,

        [Parameter(Mandatory = $false)]
        [int]$minUpperCase = 1,

        [Parameter(Mandatory = $false)]
        [int]$minLowerCase = 1,

        [Parameter(Mandatory = $false)]
        [int]$minDigits = 1,

        [Parameter(Mandatory = $false)]
        [int]$minSpecialChars = 1
    )

    begin {
        Write-Verbose "Starting password generation with length $length and minimum requirements: UpperCase=$minUpperCase, LowerCase=$minLowerCase, Digits=$minDigits, SpecialChars=$minSpecialChars"

        # Check if the total minimum character requirements exceed the specified length
        if ($length -lt ($minUpperCase + $minLowerCase + $minDigits + $minSpecialChars)) {
            throw "The length of the password must be greater than or equal to the sum of the minimum number of uppercase, lowercase, digit, and special characters."
        }
    }

    process {
        # Define character sets
        $upperCase = 65..90 | ForEach-Object { [char]$_ }
        $lowerCase = 97..122 | ForEach-Object { [char]$_ }
        $digits = 48..57 | ForEach-Object { [char]$_ }
        $specialChars = "!@#$%&*()-=+[{]}|;:"

        Write-Verbose "Generating random characters from each character set"

        # Generate required characters from each set
        $passwordChars = @(
            ($upperCase | Get-Random -Count $minUpperCase)
            ($lowerCase | Get-Random -Count $minLowerCase)
            ($digits | Get-Random -Count $minDigits)
            ($specialChars.ToCharArray() | Get-Random -Count $minSpecialChars)
        ) + (($upperCase + $lowerCase + $digits + $specialChars.ToCharArray()) | Get-Random -Count ($length - $minUpperCase - $minLowerCase - $minDigits - $minSpecialChars))

        Write-Verbose "Randomizing the final password characters"
        
        # Join and randomize the final password characters
        $password = -join ($passwordChars | Get-Random -Count $length)

        Write-Verbose "Generated password: $password"
        return $password
    }

    end {}
}

# Example call to the function with verbose output
# New-SecurePassword -length 16 -minUpperCase 2 -minLowerCase 2 -minDigits 2 -minSpecialChars 2 -Verbose
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Replication/Public/New-SecurePassword.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-SecurePassword.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

