---
layout: post
title: Get-OutlookAppointments.ps1
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
Function Get-OutlookAppointments {
   param (
      [Int] $NumDays = 7,
      [DateTime] $Start = [DateTime]::Now ,
      [DateTime] $End = [DateTime]::Now.AddDays($NumDays)
   )

   Process {
      $outlook = New-Object -ComObject Outlook.Application

      $session = $outlook.Session
      $session.Logon()

      $apptItems = $session.GetDefaultFolder(9).Items
      $apptItems.Sort("[Start]")
      $apptItems.IncludeRecurrences = $true
      $apptItems = $apptItems

      $restriction = "[End] >= '{0}' AND [Start] <= '{1}'" -f $Start.ToString("g"), $End.ToString("g")

      foreach ($appt in $apptItems.Restrict($restriction)) {
         If (([DateTime]$Appt.Start - [DateTime]$appt.End).Days -eq "-1") {
            "All Day Event : {0} Organized by {1}" -f $appt.Subject, $appt.Organizer
         }
         Else {
            "{0:dd/MM/yyyy @ hh:mmtt} - {1:hh:mmtt} : {2} Organized by {3}" -f [DateTime]$appt.Start, [DateTime]$appt.End, $appt.Subject, $appt.Organizer
         }

      }

      $outlook = $session = $null;
   }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-OutlookAppointments.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-OutlookAppointments.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
