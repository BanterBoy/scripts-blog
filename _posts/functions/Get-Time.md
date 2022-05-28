---
layout: post
title: Get-Time.ps1
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
function Get-Time {
    <#
      .SYNOPSIS
         Gets the time of a windows server

      .DESCRIPTION
         Uses WMI to get the time of a remote server

      .PARAMETER  ServerName
         The Server to get the date and time from

      .EXAMPLE
         PS C:\> Get-Time localhost

      .EXAMPLE
         PS C:\> Get-Time server01.domain.local -Credential (Get-Credential)

   #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ServerName,

        $Credential

    )
    try {
        If ($Credential) {
            $DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $servername -Credential $Credential
        }
        Else {
            $DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $servername
        }
    }
    catch {
        throw
    }

    $Times = New-Object PSObject -Property @{
        'ServerName' = $DT.__Server
        'DateTime'   = (Get-Date -Day $DT.Day -Month $DT.Month -Year $DT.Year -Minute $DT.Minute -Hour $DT.Hour -Second $DT.Second)
    }
    $Times

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/time/Get-Time.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Time.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
