---
layout: post
title: Get-WmiADEvent.ps1
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
Function Get-WmiADEvent {
    Param([string]$query)

    $Path="root\directory\ldap"
    $EventQuery  = New-Object System.Management.WQLEventQuery $query
    $Scope       = New-Object System.Management.ManagementScope $Path
    $Watcher     = New-Object System.Management.ManagementEventWatcher $Scope,$EventQuery
    $Options     = New-Object System.Management.EventWatcherOptions
    $Options.TimeOut = [timespan]"0.0:0:1"
    $Watcher.Options = $Options
    cls
    Write-Host ("Waiting for events in response to: {0}" -F $EventQuery.querystring)  -backgroundcolor cyan -foregroundcolor black
    $Watcher.Start()
    while ($true) {
       trap [System.Management.ManagementException] {continue}

       $Evt=$Watcher.WaitForNextEvent()
        if ($Evt) {
           $Evt.TargetInstance | select *
        Clear-Variable evt
        }
    }
}

# Sample usage

# $query="Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_USER'"
# $query="Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'DS_GROUP'"
# $query="Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_USER'"
# $query="Select * from __InstanceModificationEvent Within 10 where TargetInstance ISA 'DS_COMPUTER'"
# Get-WmiADEvent $query
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/functions/myProfile/Get-WmiADEvent.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-WmiADEvent.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
