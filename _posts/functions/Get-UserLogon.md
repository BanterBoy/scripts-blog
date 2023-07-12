---
layout: post
title: Get-UserLogon.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
function Get-UserLogon {

    [CmdletBinding()]
    param
    (
        [Parameter ()]
        [String]$Computer,
        [Parameter ()]
        [String]$OU,
        [Parameter ()]
        [Switch]$All
    )
    $ErrorActionPreference = "SilentlyContinue"
    $result = @()
    If ($Computer) {
        Invoke-Command -ComputerName $Computer -ScriptBlock { quser } | Select-Object -Skip 1 | Foreach-Object {
            $b = $_.trim() -replace '\s+', ' ' -replace '>', '' -split '\s'
            If ($b[2] -like 'Disc*') {
                $array = ([ordered]@{
                        'User'     = $b[0]
                        'Computer' = $Computer
                        'Date'     = $b[4]
                        'Time'     = $b[5..6] -join ' '
                    })
                $result += New-Object -TypeName PSCustomObject -Property $array
            }
            else {
                $array = ([ordered]@{
                        'User'     = $b[0]
                        'Computer' = $Computer
                        'Date'     = $b[5]
                        'Time'     = $b[6..7] -join ' '
                    })
                $result += New-Object -TypeName PSCustomObject -Property $array
            }
        }
    }
    If ($OU) {
        $comp = Get-ADComputer -Filter * -SearchBase "$OU" -Properties operatingsystem
        $count = $comp.count
        If ($count -gt 20) {
            Write-Warning "Search $count computers. This may take some time ... About 4 seconds for each computer"
        }
        foreach ($u in $comp) {
            Invoke-Command -ComputerName $u.Name -ScriptBlock { quser } | Select-Object -Skip 1 | ForEach-Object {
                $a = $_.trim() -replace '\s+', ' ' -replace '>', '' -split '\s'
                If ($a[2] -like '*Disc*') {
                    $array = ([ordered]@{
                            'User'     = $a[0]
                            'Computer' = $u.Name
                            'Date'     = $a[4]
                            'Time'     = $a[5..6] -join ' '
                        })
                    $result += New-Object -TypeName PSCustomObject -Property $array
                }
                else {
                    $array = ([ordered]@{
                            'User'     = $a[0]
                            'Computer' = $u.Name
                            'Date'     = $a[5]
                            'Time'     = $a[6..7] -join ' '
                        })
                    $result += New-Object -TypeName PSCustomObject -Property $array
                }
            }
        }
    }
    If ($All) {
        $comp = Get-ADComputer -Filter * -Properties operatingsystem
        $count = $comp.count
        If ($count -gt 20) {
            Write-Warning "Search $count computers. This may take some time ... About 4 seconds for each computer ..."
        }
        foreach ($u in $comp) {
            Invoke-Command -ComputerName $u.Name -ScriptBlock { quser } | Select-Object -Skip 1 | ForEach-Object {
                $a = $_.trim() -replace '\s+', ' ' -replace '>', '' -split '\s'
                If ($a[2] -like '*Disc*') {
                    $array = ([ordered]@{
                            'User'     = $a[0]
                            'Computer' = $u.Name
                            'Date'     = $a[4]
                            'Time'     = $a[5..6] -join ' '
                        })
                    $result += New-Object -TypeName PSCustomObject -Property $array
                }
                else {
                    $array = ([ordered]@{
                            'User'     = $a[0]
                            'Computer' = $u.Name
                            'Date'     = $a[5]
                            'Time'     = $a[6..7] -join ' '
                        })
                    $result += New-Object -TypeName PSCustomObject -Property $array
                }
            }
        }
    }
    Write-Output $result
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/Get-UserLogon.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-UserLogon.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
