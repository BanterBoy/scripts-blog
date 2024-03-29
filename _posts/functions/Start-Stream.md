---
layout: post
title: Start-Stream.ps1
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
function Start-Stream {
    param(
        $countdownTime = 5
    )
    $loading = @('Waiting for Windos to hit enter',
        'Warming up processors',
        'Downloading the internet',
        'Trying common passwords',
        'Commencing infinite loop',
        'Injecting double negatives',
        'Breeding bits',
        'Capturing escaped bits',
        'Dreaming of a faster computer',
        'Calculating gravitational constant',
        'Adding Hidden Agendas',
        'Adjusting Bell Curves',
        'Aligning Covariance Matrices',
        'Attempting to Lock Back-Buffer',
        'Building Data Trees',
        'Calculating Inverse Probability Matrices',
        'Calculating Llama Expectoration Trajectory',
        'Compounding Inert Tessellations',
        'Concatenating Sub-Contractors',
        'Containing Existential Buffer',
        'Deciding What Message to Display Next',
        'Increasing Accuracy of RCI Simulators',
        'Perturbing Matrices')

    $startTime = Get-Date
    $endTime = $startTime.AddMinutes($countdownTime)
    $totalSeconds = (New-TimeSpan -Start $startTime -End $endTime).TotalSeconds

    $totalSecondsChild = Get-Random -Minimum 4 -Maximum 30
    $startTimeChild = $startTime
    $endTimeChild = $startTimeChild.AddSeconds($totalSecondsChild)
    $loadingMessage = $loading[(Get-Random -Minimum 0 -Maximum ($loading.Length - 1))]


    Do {
        $now = Get-Date
        $secondsElapsed = (New-TimeSpan -Start $startTime -End $now).TotalSeconds
        $secondsRemaining = $totalSeconds - $secondsElapsed
        $percentDone = ($secondsElapsed / $totalSeconds) * 100

        Write-Progress -id 0 -Activity Start-Stream -Status 'Stream starting soon' -PercentComplete $percentDone -SecondsRemaining $secondsRemaining

        $secondsElapsedChild = (New-TimeSpan -Start $startTimeChild -End $now).TotalSeconds
        $secondsRemainingChild = $totalSecondsChild - $secondsElapsedChild
        $percentDoneChild = ($secondsElapsedChild / $totalSecondsChild) * 100

        if ($percentDoneChild -le 100) {
            Write-Progress -id 1 -ParentId 0 -Activity $loadingMessage -PercentComplete $percentDoneChild -SecondsRemaining $secondsRemainingChild
        }

        if ($percentDoneChild -ge 100 -and $percentDone -le 98) {
            $totalSecondsChild = Get-Random -Minimum 4 -Maximum 30
            $startTimeChild = $now
            $endTimeChild = $startTimeChild.AddSeconds($totalSecondsChild)
            if ($endTimeChild -gt $endTime) {
                $endTimeChild = $endTime
            }
            $loadingMessage = $loading[(Get-Random -Minimum 0 -Maximum ($loading.Length - 1))]
        }

        Start-Sleep 0.2
    } Until ($now -ge $endTime)
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Start-Stream.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-Stream.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
