---
layout: post
title: Amend-pwdLastSet.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
<#
Get-ADUser "ADUserName" -Properties PasswordExpired | Select-Object PasswordExpired

Set-ADUser "ADUserName" -Replace @{pwdLastSet='0'}

$users = Get-ADUser -Filter {name -like '*' } -Properties *
foreach($user in $users){ Set-ADUser -Replace @{pdwLastSet='0' -whatif }
#>

function Get-PasswordLastSetDate {
    [CmdletBinding(SupportsShouldProcess = $false)]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Enter username")]
        [Alias('un')]
        [string[]]$Identity,
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Enter Domain name")]
        [Alias('dom')]
        [string[]]$Domain
    )

    BEGIN {
    }

    PROCESS {
        foreach ($User in $Identity) {
            $PasswordTest = Get-ADUser -Identity $User -Server "$Domain" -Properties "pwdLastSet" | Select-Object -Property Name, @{name = "pwdLastSet"; expression = { [datetime]::FromFileTime($_.pwdLastSet) } }
            try {
                $Properties = @{
                    "Username"   = $PasswordTest.Name
                    "pwdLastSet" = $PasswordTest.pwdLastSet
                }
            }
            catch {
                $Properties = @{
                    "Username"   = $PasswordTest.Name
                    "pwdLastSet" = $PasswordTest.pwdLastSet
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $Properties
                Write-Output $obj
            }
        }
    }
    END {

    }

}

function Set-PasswordExpired {
    [CmdletBinding(SupportsShouldProcess = $false)]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Enter Username for account to be expired")]
        [Alias('id')]
        [string[]]$Identity
    )

    BEGIN {
    }

    PROCESS {

        foreach ($User in $Identity) {
            Set-ADUser $User -Replace @{pwdLastSet = '0' }
            $Reset = Get-ADUser $User -Properties PasswordExpired | Select-Object -Property Name, PasswordExpired
            try {
                $Properties = @{
                    "Username"        = $Reset.Name
                    "PasswordExpired" = $Reset.PasswordExpired
                }
            }
            catch {
                $Properties = @{
                    "Username"        = $Reset.Name
                    "PasswordExpired" = $Reset.PasswordExpired
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $Properties
                Write-Output $obj
            }
        }
    }
    END {

    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Amend-pwdLastSet.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Amend-pwdLastSet.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
