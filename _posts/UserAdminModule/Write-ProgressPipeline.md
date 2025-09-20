---
layout: post
title: Write-ProgressPipeline.ps1
date: 2025-09-19
last_modified_at: 2025-09-20 00:00:00
permalink: /_posts/UserAdminModule/Write-ProgressPipeline/
categories:
- UserAdminModule
- Utilities
tags:
- PowerShell
- User Admin Module
- Progress Pipeline
description: Provide a Write-Progress for a long-running pipeline for signs of life.
image: '{{ site.url }}/assets/images/PowerShell_5.0_icon.png'
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

Provide a Write-Progress for a long-running pipeline for signs of life.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
$kustoData | Write-Progress -Activity Get-KustoIpamAllocationsData -StatusSuffix 'IPAM allocation records processed' -TotalObjects $kustoData.Count -Interval 1000 -Id $writeProgressId
```

Writes the following as Write-Progress to update the user on current progres at a given point in the Get-KustoIpamAllocationsData function. Get-KustoIpamAllocationsData 26000 / 34973 (74%) IPAM allocation records processed [ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                          ] Current time: 15:23:46  Elapsed time: 00:08:21  Expected completion: 15:26:36 Writes the following as to [Verbose] stream (visible if user specified -Verbose) Get-KustoIpamAllocationsData 26000 / 34973 (74%) IPAM allocation records processed Current time: 15:23:46  Elapsed time: 00:08:21  Expected completion: 15:26:36

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Write-ProgressPipeline
{
    <#
        .SYNOPSIS
        Provide a Write-Progress for a long-running pipeline for signs of life.

        .PARAMETER InputObject
        Data stream to count.

        .PARAMETER Activity
        Write-Progress -Activity parameter value.

        .PARAMETER StatusSuffix
        Write-Progress -Status will be populated with a running count of objects passed through.
        This will be appened to give an indication of what type of objects are being counted.

        .PARAMETER TotalObjects
        If provided, this function will specify a -PercentComplete to Write-Progress

        .PARAMETER Interval
        How often to update the Write-Progress, expressed in terms of the count of objects
        to pass through before sending another Write-Progress call.

        .PARAMETER ID
        Write-Progress -Id Parameter value.

        .PARAMETER BreadCrumb
        Not used, but included so the function can accept -BreadCrumb parameter if called with it.

        .PARAMETER Initialize
        Output a 'starting condition' message: dummy Write-Verbose, dummy Write-Progress to indicate starting state.

        .EXAMPLE
        $kustoData | Write-Progress -Activity Get-KustoIpamAllocationsData -StatusSuffix 'IPAM allocation records processed' -TotalObjects $kustoData.Count -Interval 1000 -Id $writeProgressId

        Writes the following as Write-Progress to update the user on current progres at a given
        point in the Get-KustoIpamAllocationsData function.

        Get-KustoIpamAllocationsData
        26000 / 34973 (74%) IPAM allocation records processed
        [ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                          ]
        Current time: 15:23:46  Elapsed time: 00:08:21  Expected completion: 15:26:36

        Writes the following as to [Verbose] stream (visible if user specified -Verbose)

        Get-KustoIpamAllocationsData 26000 / 34973 (74%) IPAM allocation records processed
        Current time: 15:23:46  Elapsed time: 00:08:21  Expected completion: 15:26:36
    #>

    [CmdletBinding()]

    param
    (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [PSCustomObject[]]$InputObject,

        [string]$Activity = ' ',

        [string]$StatusSuffix = 'objects processed',

        [uint32]$TotalObjects = 0,

        [ValidateRange( 1, 1MB )]
        [uint16]$Interval = 1000,

        [uint16]$Id = 0,

        [string[]]$BreadCrumb,

        [switch]$Initialize
    )

    begin
    {
        # this is an internal function, so we don't need the $functionName nor $BreadCrumb
        [uint32]$i = 0

        [DateTime]$startTime = Get-Date

        if ( !$Initialize )
        {
            [HashTable]$writeProgressPipelineParameters =
            @{
                Initialize   = $true
                InputObject  = 1
                Activity     = $Activity
                StatusSuffix = $StatusSuffix
                TotalObjects = $TotalObjects
                Interval     = $Interval
                Id           = $Id
            }

            # start it off with a noop record so the screen doesn't freeze until the first
            # interval count is reached.
            Write-ProgressPipeline @writeProgressPipelineParameters
        }

        if ( $TotalObjects )
        {
            [uint16]$fieldWidth = "$TotalObjects".Length
        }
    }

    process
    {
        if ( $Initialize )
        {
            [DateTime]$now = Get-Date

            [TimeSpan]$elapsedTime = $now - $startTime

            # trying to set $elapsedTimeMessage works on interactive console, but when run as scheduled task:
            #
            # ForEach-Object : Cannot overwrite variable elapsedTimeMessage because the variable has
            # been optimized. Try using the New-Variable or Set-Variable cmdlet (without any aliases),
            # or dot-source the command that you are using to set the variable.
            #
            # ... so , we're going to call Set-Variable instead.
            ' Current time: {3}  Elapsed time: {0:00}:{1:00}:{2:00}' -f `
            @(
                $elapsedTime.TotalHours
                $elapsedTime.Minutes
                $elapsedTime.Seconds
                ( Get-Date -Format 'HH:mm:ss' )
            ) |
            Set-Variable -Force -Name elapsedTimeMessage

            [HashTable]$writeProgressParameters =
            @{
                Activity = "$Activity "
                Id       = $Id
            }

            if ( $TotalObjects )
            {
                $writeProgressParameters.Status = "{0,$fieldWidth} / $TotalObjects (0%) $StatusSuffix" -f $i
                $writeProgressParameters.PercentComplete = 0
            }
            else
            {
                $writeProgressParameters.Status = "$i $StatusSuffix"
            }

            $writeProgressParameters.CurrentOperation = "$elapsedTimeMessage  Expected completion: ??:??:??"

            Write-Verbose -Message ( "$Activity $( $writeProgressParameters.Status )`n    $elapsedTimeMessage " )
            Write-Progress @writeProgressParameters

            return

        } #  if ( $Initialize )

        $InputObject |
        ForEach-Object -Process `
        {
            $i++

            if ( !( $i % $Interval ) )
            {
                [DateTime]$now = Get-Date

                [TimeSpan]$elapsedTime = $now - $startTime

                ' Current time: {3}  Elapsed time: {0:00}:{1:00}:{2:00}' -f `
                @(
                    $elapsedTime.TotalHours
                    $elapsedTime.Minutes
                    $elapsedTime.Seconds
                    ( Get-Date -Format 'HH:mm:ss' )
                ) |
                Set-Variable -Force -Name elapsedTimeMessage

                [HashTable]$writeProgressParameters =
                @{
                    Activity = "$Activity "
                    Id       = $Id
                }

                if ( $TotalObjects )
                {
                    # if we have a count of the total objects in the pipeline, we can estimate
                    # when we'll be done

                    # -PercentComplete
                    [int]$percentComplete = ( 100 * $i / $TotalObjects ) % 101
                    $writeProgressParameters.Status = "{0,$fieldWidth} / $TotalObjects ($percentComplete%) $StatusSuffix" -f $i
                    $writeProgressParameters.PercentComplete = $percentComplete

                    # -CurrentOperation will give an estimate as to when it completes
                    [double]$totalMilliSeconds = $elapsedTime.TotalMilliseconds

                    [int]$toDoCount = $TotalObjects - $i

                    if ( $toDoCount )
                    {
                        if ( $toDoCount -le 0 )
                        {
                            return
                        }

                        # this is an empirical formula (translation: trial and error) to try to
                        # compensate for irregularities in sampling data. the theory behind it
                        # is that the larger the individual operation takes to do, the greater
                        # the chance that the aggregation of the remaining operations will take
                        # longer than the single sample. however, the fewer remaining operations
                        # remain to do, the lower the overall effect of this estimated skew.
                        #
                        # or, you can just treat it like I do: it works, so I don't care why.
                        #
                        # for pulling IPAM records, it allows 35 samples of 1000 records per sample
                        # across ~35000 records to have an estimated end-of-processing [DateTime]
                        # to be consistent within 2 minutes of the actual time.
                        [double]$fudgeFactor = ( 1 + [Math]::Log10( [Math]::Log10( [Math]::Log( $toDoCount ) ) ) ) / $i / 1000

                        [double]$secondsToAdd = $totalMilliSeconds * $toDoCount * $fudgeFactor

                        if ( $secondsToAdd -gt 0 )
                        {
                            # usually, we'll need to update the banner

                            try
                            {
                                [DateTime]$expectedCompletion = $now.AddSeconds( $secondsToAdd )
                            }
                            catch
                            {
                                Write-Debug -Message $secondsToAdd
                                $_ |
                                Write-Warning
                                $secondsToAdd = 0
                            }

                        } # if ( $secondsToAdd -gt 0 )
                        else
                        {
                            [DateTime]$expectedCompletion = $now
                        }

                    } # if ( $toDoCount )
                    else
                    {
                        $secondsToAdd = 0
                        [DateTime]$expectedCompletion = $now
                    }

                    if ( $secondsToAdd -le 0 )
                    {
                        [DateTime]$expectedCompletion = $now
                    }

                    $elapsedTimeMessage += '  Expected completion: {0:00}:{1:00}:{2:00}' -f `
                    @(
                        $expectedCompletion.Hour
                        $expectedCompletion.Minute
                        $expectedCompletion.Second
                    )

                } # if ( $TotalObjects )
                else
                {
                    $writeProgressParameters.Status = "$i $StatusSuffix"
                }

                $writeProgressParameters.CurrentOperation = $elapsedTimeMessage

                Write-Verbose -Message ( "$Activity $( $writeProgressParameters.Status )`n    $elapsedTimeMessage " )
                Write-Progress @writeProgressParameters

            } # if ( !( $i % $Interval ) )

            $_

        } # $InputObject |

    }

    end
    {
        if ( !$Initialize )
        {
            # we want the Write-Progress bar to persist after we initialize it
            Write-Progress -Status ' ' -Activity ' ' -Id $Id -Completed
        }
    }

    #> # function Write-ProgressPipeline
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Write-ProgressPipeline.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Write-ProgressPipeline.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

