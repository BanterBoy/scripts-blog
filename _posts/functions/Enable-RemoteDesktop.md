---
layout: post
title: Export-BitlockerParams.ps1
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
function Enable-RemoteDesktop {

    <#

    .SYNOPSIS
    Enable-RemoteDesktop enables Remote Desktop on remote computers.

    .DESCRIPTION
    Enable-RemoteDesktop edits the registry and enables all required firwall rules for RDP.

    .PARAMETER Target
    Provide the target computer name.

    .EXAMPLE
    Enable-RemoteDesktop -Target server01,server02,server03
    Enable-RemoteDesktop -Target client01

    .NOTES
    Author: Patrick Gruenauer
    Web: https://sid-500.com

    #>

    param

    (
        [Parameter ()]
        $Target
    )

    Write-Warning "This command works only on English and German OS.`nMake sure WinRM is enabled on target computers. (default: Windows Server OS)"

    foreach ($t in $Target) {

        Invoke-Command -ComputerName $t -ScriptBlock {

            # Enable RDP on english OS

            If ((Get-WinSystemLocale).Name -like "*en-*") {

                Set-ItemProperty `
                    -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'`
                    -Name "fDenyTSConnections" -Value 0; `
                    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

                Write-Output "$t : Operation completed successfully."

            }

            If ((Get-WinSystemLocale).Name -like "*de-*") {

                Set-ItemProperty `
                    -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'`
                    -Name "fDenyTSConnections" -Value 0; `
                    Enable-NetFirewallRule -DisplayGroup "RemoteDesktop"

            }
        }
        Write-Output "$t : Operation completed successfully."
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Enable-RemoteDesktop.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Enable-RemoteDesktop.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
