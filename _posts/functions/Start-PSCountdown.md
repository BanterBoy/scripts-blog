---
layout: post
title: Start-PSCountdown.ps1
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
#requires -version 4.0

<#
Inspired from code originally published at:
https://github.com/Windos/powershell-depot/blob/master/livecoding.tv/StreamCountdown/StreamCountdown.psm1

This should work in Windows PowerShell and PowerShell Core, although not in VS Code.
The ProgressStyle parameter is dynamic and only appears if you are running the command in a Windows console.

Even though are is no comment-based help or examples, if you run: help Start-PSCountdown -full you'll get the
help descriptions.
#>
function Start-PSCountdown {

    [cmdletbinding()]
    [OutputType("None")]
    Param(
        [Parameter(Position = 0, HelpMessage = "Enter the number of minutes to countdown (1-60). The default is 5.")]
        [ValidateRange(1, 60)]
        [int32]$Minutes = 5,
        [Parameter(HelpMessage = "Enter the text for the progress bar title.")]
        [ValidateNotNullorEmpty()]
        [string]$Title = "Counting Down ",
        [Parameter(Position = 1, HelpMessage = "Enter a primary message to display in the parent window.")]
        [ValidateNotNullorEmpty()]
        [string]$Message = "Starting soon.",
        [Parameter(HelpMessage = "Use this parameter to clear the screen prior to starting the countdown.")]
        [switch]$ClearHost
    )
    DynamicParam {
        #this doesn't appear to work in PowerShell core on Linux
        if ($host.PrivateData.ProgressBackgroundColor -And ( $PSVersionTable.Platform -eq 'Win32NT' -OR $PSEdition -eq 'Desktop')) {

            #define a parameter attribute object
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.ValueFromPipelineByPropertyName = $False
            $attributes.Mandatory = $false
            $attributes.HelpMessage = @"
Select a progress bar style. This only applies when using the PowerShell console or ISE.

Default - use the current value of `$host.PrivateData.ProgressBarBackgroundColor
Transparent - set the progress bar background color to the same as the console
Random - randomly cycle through a list of console colors
"@

            #define a collection for attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)
            #define the validate set attribute
            $validate = [System.Management.Automation.ValidateSetAttribute]::new("Default", "Random", "Transparent")
            $attributeCollection.Add($validate)

            #add an alias
            $alias = [System.Management.Automation.AliasAttribute]::new("style")
            $attributeCollection.Add($alias)

            #define the dynamic param
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("ProgressStyle", [string], $attributeCollection)
            $dynParam1.Value = "Default"

            #create array of dynamic parameters
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add("ProgressStyle", $dynParam1)
            #use the array
            return $paramDictionary

        } #if
    } #dynamic parameter
    Begin {
        $loading = @(
            'Waiting for someone to hit enter',
            'Warming up processors',
            'Downloading the Internet',
            'Trying common passwords',
            'Commencing infinite loop',
            'Injecting double negatives',
            'Breeding bits',
            'Capturing escaped bits',
            'Dreaming of electric sheep',
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
            'Perturbing Matrices',
            'Initializing flux capacitors',
            'Brushing up on my Dothraki',
            'Preparing second breakfast',
            'Preparing the jump to lightspeed',
            'Initiating self-destruct sequence',
            'Mining cryptocurrency',
            'Aligning Heisenberg compensators',
            'Setting phasers to stun',
            'Deciding...blue pill or yellow?',
            'Bringing Skynet online',
            'Learning PowerShell',
            'On hold with Comcast customer service',
            'Waiting for Godot',
            'Folding proteins',
            'Searching for infinity stones',
            'Restarting the ARC reactor',
            'Learning regular expressions',
            'Trying to quit vi',
            'Waiting for the last Game_of_Thrones book',
            'Watching paint dry',
            'Aligning warp coils'
        )
        if ($ClearHost) {
            Clear-Host
        }
        $PSBoundParameters | out-string | Write-Verbose
        if ($psboundparameters.ContainsKey('progressStyle')) {

            if ($PSBoundParameters.Item('ProgressStyle') -ne 'default') {
                $saved = $host.PrivateData.ProgressBackgroundColor
            }
            if ($PSBoundParameters.Item('ProgressStyle') -eq 'transparent') {
                $host.PrivateData.progressBackgroundColor = $host.ui.RawUI.BackgroundColor
            }
        }
        $startTime = Get-Date
        $endTime = $startTime.AddMinutes($Minutes)
        $totalSeconds = (New-TimeSpan -Start $startTime -End $endTime).TotalSeconds

        $totalSecondsChild = Get-Random -Minimum 4 -Maximum 30
        $startTimeChild = $startTime
        $endTimeChild = $startTimeChild.AddSeconds($totalSecondsChild)
        $loadingMessage = $loading[(Get-Random -Minimum 0 -Maximum ($loading.Length - 1))]

        #used when progress style is random
        $progcolors = "black", "darkgreen", "magenta", "blue", "darkgray"

    } #begin
    Process {
        #this does not work in VS Code
        if ($host.name -match 'Visual Studio Code') {
            Write-Warning "This command will not work in VS Code."
            #bail out
            Return
        }
        Do {
            $now = Get-Date
            $secondsElapsed = (New-TimeSpan -Start $startTime -End $now).TotalSeconds
            $secondsRemaining = $totalSeconds - $secondsElapsed
            $percentDone = ($secondsElapsed / $totalSeconds) * 100

            Write-Progress -id 0 -Activity $Title -Status $Message -PercentComplete $percentDone -SecondsRemaining $secondsRemaining

            $secondsElapsedChild = (New-TimeSpan -Start $startTimeChild -End $now).TotalSeconds
            $secondsRemainingChild = $totalSecondsChild - $secondsElapsedChild
            $percentDoneChild = ($secondsElapsedChild / $totalSecondsChild) * 100

            if ($percentDoneChild -le 100) {
                Write-Progress -id 1 -ParentId 0 -Activity $loadingMessage -PercentComplete $percentDoneChild -SecondsRemaining $secondsRemainingChild
            }

            if ($percentDoneChild -ge 100 -and $percentDone -le 98) {
                if ($PSBoundParameters.ContainsKey('ProgressStyle') -AND $PSBoundParameters.Item('ProgressStyle') -eq 'random') {
                    $host.PrivateData.progressBackgroundColor = ($progcolors | Get-Random)
                }
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
    } #progress

    End {
        if ($saved) {
            #restore value if it has been changed
            $host.PrivateData.ProgressBackgroundColor = $saved
        }
    } #end

} #end function

#define an optional alias
Set-Alias -Name spc -Value Start-PSCountdown
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Start-PSCountdown.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Start-PSCountdown.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
