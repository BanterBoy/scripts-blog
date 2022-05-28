---
layout: post
title: Get-2amOfThirdMondayInMonth.ps1
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
function Get-2amOfThirdMondayInMonth ($Date) {
    #get the number of the current month
    $thisMonth = $date.Month
    # set the date to first of the current month,
    #the hours, minutes and the rest are taken from the current time,
    #so use the .Date to get midnight instead
    $midnightOfFirst = (Get-Date -Day 1 -Month $thisMonth).Date

    #What day of week is the first?
    $dayOfWeek = $midnightOfFirst.DayOfWeek

    #sunday is 0 in the WeekOfDay enum , but we need monday to be 0,
    #so we move the sunday at the end (6)
    #use [enum]::GetValues([dayofweek]) | foreach { "$_ : " + [int]$_ } to
    #see the values for yourself
    if ($dayOfWeek -eq "Sunday") {
        $dayOfWeek = 6
    }
    else {
        $dayOfWeek = [int]$dayOfWeek - 1
    }
    #add two weeks and number of days that remain from week to reach monday
    #(on monday we need 0 days to reach monday, on sunday we need one)
    $thirdMonday = New-TimeSpan -Days (2 * 7 + 7 - $dayofweek)

    #add the weeks + offset to the first of the month
    $thirdMonday = $midnightOfFirst.Add($thirdMonday)
    #add two hours to read 2 am
    $thirdMonday.AddHours(2)
}

<# test
$startDate = (Get-Date).AddYears(1)
1..20 | foreach {
Get-2amOfThirdMondayInMonth $startDate.AddMonths($_)
}
#>
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/time/Get-2amOfThirdMondayInMonth.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-2amOfThirdMondayInMonth.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
