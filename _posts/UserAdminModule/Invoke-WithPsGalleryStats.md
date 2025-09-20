---
layout: post
title: Invoke-WithPsGalleryStats.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Invoke-WithPsGalleryStats/
categories:
  - UserAdminModule
  - Utilities
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

Starts a docker container using the microsoft Powershell image and installs one or more modules as many times as you like.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Fuck-WithPsGalleryStats -ModuleName Transmission -DownloadCount 99
```

**Example 2**

```powershell
Fuck-WithPsGalleryStats -ModuleNames @('Transmission', 'JsonToPowershellClass') -DownloadCount 99
```

**Example 3**

```powershell
Fuck-WithPsGalleryStats -ModuleNames @('Transmission', 'JsonToPowershellClass') -DownloadCount 99 -MinIntervalSeconds 10 -MaxIntervalSeconds 120
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
<#
    .SYNOPSIS
        Starts a docker container using the microsoft Powershell image and installs one or more modules as many times as you like.
        
    .PARAMETER DownloadCount
        The number of times to install each module.

    .PARAMETER ModuleName
        PS Gallery module name to install. Must be supplied if only running for one module, otherwise supply a ModuleNames array.

    .PARAMETER ModuleNames
        PS Gallery module names to install. Must be supplied if running for multiple modules, otherwise supply a ModuleName.

    .PARAMETER MinIntervalSeconds
        Minimum duration of a random interval to sleep between each module install. Must be less than MaxIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.

    .PARAMETER MaxIntervalSeconds
        Maximum duration of a random interval to sleep between each module install. Must be greater than MinIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.

    .PARAMETER IntervalSeconds
        Static interval to sleep between each module install. Use MinIntervalSeconds and MaxIntervalSeconds to randomise the sleep interval, or set no intervals for no sleep.

    .PARAMETER MultipleInstallsPerSession
        If supplied then all modules supplied will be installed in the same Powershell session, otherwise only one module from the supplied modules will be installed in each docker container.

    .EXAMPLE
    Fuck-WithPsGalleryStats -ModuleName Transmission -DownloadCount 99

    .EXAMPLE
    Fuck-WithPsGalleryStats -ModuleNames @('Transmission', 'JsonToPowershellClass') -DownloadCount 99

    .EXAMPLE
    Fuck-WithPsGalleryStats -ModuleNames @('Transmission', 'JsonToPowershellClass') -DownloadCount 99 -MinIntervalSeconds 10 -MaxIntervalSeconds 120
#>
function Invoke-WithPsGalleryStats {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage="The number of times to install each module.")]
        [int]$DownloadCount,

        [Parameter(Mandatory = $false, ParameterSetName = 'SingleModule', HelpMessage="PS Gallery module name to install. Must be supplied if only running for one module, otherwise supply a ModuleNames array.")]
        [string]$ModuleName,

        [Parameter(Mandatory = $false, ParameterSetName = 'MultiModule', HelpMessage="PS Gallery module names to install. Must be supplied if running for multiple modules, otherwise supply a ModuleName.")]
        [string[]]$ModuleNames,

        [Parameter(Mandatory = $false, HelpMessage="Minimum duration of a random interval to sleep between each module install. Must be less than MaxIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.")]
        [int]$MinIntervalSeconds,

        [Parameter(Mandatory = $false, HelpMessage="Maximum duration of a random interval to sleep between each module install. Must be greater than MinIntervalSeconds if supplied. Use Interval for static duration, or set no intervals for no sleep.")]
        [int]$MaxIntervalSeconds,

        [Parameter(Mandatory = $false, HelpMessage="Static interval to sleep between each module install. Use MinIntervalSeconds and MaxIntervalSeconds to randomise the sleep interval, or set no intervals for no sleep.")]
        [int]$IntervalSeconds,

        [Parameter(Mandatory = $false, HelpMessage="If supplied then all modules supplied will be installed in the same Powershell session, otherwise only one module from the supplied modules will be installed in each docker container.")]
        [switch]$MultipleInstallsPerSession
    )

    begin {
                # validate parameters
        if ($null -eq $ModuleName -and $null -eq $ModuleNames) {
            throw "Either the ModuleName or ModuleNames parameter must be supplied."
        }

        if ($MinIntervalSeconds -gt 0 -or $MaxIntervalSeconds -gt 0) {
            if ($MinIntervalSeconds -ge $MaxIntervalSeconds) {
                throw "MinIntervalSeconds must be less than MaxIntervalSeconds, or both values should be excluded"
            }
        }

        # set up counts hashtable storage
        $hashCounts = @{}

        # constants
        $Container = "fuck-with-ps-gallery-stats"

        # make sure no existing container with the intended name exists or we'll get an error on the first create
        try {
            docker container rm $Container | Out-Null
        }
        catch {
            # no worries :)
        }

        function SleepyTime {
            # sleep for an interval if defined
            $interval = 0

            if ($IntervalSeconds -gt 0) {
                $interval = $IntervalSeconds
            } else {
                if ($MinIntervalSeconds -gt 0 -or $MaxIntervalSeconds -gt 0) {
                    $interval = Get-Random -Minimum $MinIntervalSeconds -Maximum $MaxIntervalSeconds
                }
            }

            if ($interval -gt 0) {
                Write-Host "Waiting $interval seconds..."
                Start-Sleep -Seconds $interval
            }
        }

        function RunProcess([string] $cmd) {
            # create the docker container, install the module, then remove the container
            docker run -it --name $Container `
                mcr.microsoft.com/powershell pwsh -c `
                $cmd

            docker container rm $Container | Out-Null

            SleepyTime
        }

        function RunSingleModulePerContainerProcess([string] $moduleName) {
            $cmd = "Write-Host 'installing module: $moduleName'; Install-Module -Name $moduleName -Force; Write-Host 'installed!'"

            RunProcess -cmd $cmd
        }

        function RunMultiModulePerContainerProcess {
            $cmd = $ModuleNames | ForEach-Object { "Write-Host 'installing module: $_'; Install-Module -Name $_ -Force; Write-Host 'installed!'" } | Join-String -Separator '; '

            RunProcess -cmd $cmd
        }
    }

    process {
        if ($null -eq $ModuleNames) {
            # standard single module process            
            # run the process the required number of times
            for ($i = 0; $i -lt $DownloadCount; $i++) {
                # run the process
                RunSingleModulePerContainerProcess -moduleName $ModuleName
            }

            # gtfo
            return
        }

        if ($MultipleInstallsPerSession) {
            # multi module process, one container for all module installs
            # run the process the required number of times
            for ($i = 0; $i -lt $DownloadCount; $i++) {
                # run the process
                RunMultiModulePerContainerProcess
            }

            # gtfo
            return
        }

        # multi module process, one container per module install
        # build a hash table of module names and counts
        foreach ($mn in $ModuleNames) {
            $hashCounts[$mn] = 0
        }

        $incomplete = $true;

        # loop until all modules have been downloaded the required number of times
        while ($incomplete) {
            # get a random module name
            $moduleName = $ModuleNames[(Get-Random -Minimum 0 -Maximum $ModuleNames.Length)]
            
            # run the process
            RunSingleModulePerContainerProcess -moduleName $moduleName

            # increment the count for the module
            $hashCounts[$moduleName]++

            Write-Host "$moduleName has been downloaded $($hashCounts[$moduleName]) times."

            # if the module has been downloaded the required number of times, remove it from the hash table
            if ($hashCounts[$moduleName] -eq $DownloadCount) {
                $hashCounts.Remove($moduleName)

                $ModuleNames = $ModuleNames | Where-Object { $_ -ne $moduleName }
            }
            
            Write-Host "Modules: $ModuleNames"

            # if the hash table is empty, we're done
            if ($hashCounts.Count -eq 0) {
                $incomplete = $false
            }
        }
    }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Invoke-WithPsGalleryStats.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Invoke-WithPsGalleryStats.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

