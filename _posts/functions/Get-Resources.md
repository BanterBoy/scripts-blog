---
layout: post
title: Get-Resources.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_**

---

#### Script

```powershell
function Get-Resources {
    param(
        $ComputerName = $env:ComputerName
    )
    # Processor utilization
    # Get-WmiObject -ComputerName $computer -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object *
    $cpu = Get-WmiObject win32_perfformatteddata_perfos_processor -ComputerName $ComputerName | Where-Object { $_.name -eq "_total" } | Select-Object -ExpandProperty PercentProcessorTime -ErrorAction silentlycontinue
    # Memory utilization
    $ComputerMemory = Get-WmiObject -ComputerName $ComputerName -Class win32_operatingsystem -ErrorAction Stop
    $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory) * 100) / $ComputerMemory.TotalVisibleMemorySize)
    $RoundMemory = [math]::Round($Memory, 2)
    # Free disk space
    $disks = get-wmiobject -class "Win32_LogicalDisk" -namespace "root\CIMV2" -ComputerName $ComputerName
    $results = foreach ($disk in $disks) {
        if ($disk.Size -gt 0) {
            $size = [math]::round($disk.Size / 1GB, 0)
            $free = [math]::round($disk.FreeSpace / 1GB, 0)
            [PSCustomObject]@{
                Drive             = $disk.Name
                Name              = $disk.VolumeName
                "Total Disk Size" = $size
                "Free Disk Size"  = "{0:N0} ({1:P0})" -f $free, ($free / $size)
            }
        }
    }

    # Write results
    Write-host "Resources on" $ComputerName "- RAM Usage:"$RoundMemory"%, CPU:"$cpu"%, Free" $free "GB"
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Get-Resources.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-Resources.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
