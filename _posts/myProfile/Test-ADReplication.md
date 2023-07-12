---
layout: post
title: Test-ADReplication.ps1
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
function Test-ADReplication {
    Param(
        [Parameter(Mandatory = $False,
        Position = 1)]
        [string]$serverName,

        [Parameter(Mandatory = $False,
        Position = 2)]
        [int]$waitingTime = 600,

        [Parameter(Mandatory = $False,
        Position = 3)]
        [string]$testOU = 'OU=People,OU=Test,DC=domain,DC=local'
    )

    ## Init section
    Write-Output "Start DC server sync test"
    if (!$serverName) {
        $serverName = hostname
    }
    Write-Output "DC name: " $serverName
    $dCList = ((Get-ADForest).Domains | ForEach-Object { Get-ADDomainController -Filter * -Server $_ }).name
    if ( $dCList -notcontains $servername) {
        Write-Error "The server $serverName is not a Domain Controller"
        Break
    }

    $testUserName = "DC_" + $servername + "_test"
    $randomDC = $dCList | Where-Object { $_ -ne $servername } | Get-Random
    ## End of init section

    # Script body
    Write-Output "The test user name is $testUserName"
    New-AdUser -Name $testUserName -Server $randomDC -path $testOU
    if (Get-AdUser $testUserName -server $randomDC) {
        Write-Output "test user $testUserName successfully created"
    }
    else {
        Write-Error "There is an issue with the test account $testUserName creation on $serverName"
        Break
    }
    Get-Date
    Write-Output "Waiting for $waitingtime seconds for sync"
    Start-Sleep -Seconds $waitingtime
    Get-Date
    if (Get-AdUser $testUserName -server $servername) {
        Write-Output "$serverName test successful. Deleting the test user $testUserName"
        Remove-ADUser $testUserName -Confirm:$false
        if (Get-AdUser $testUserName -server $servername) {
            Write-Output "There is an issue with deleting the test user. Please check manually."
        }
        else {
            Write-Output "The $testUserName have been successfully deleted"
        }
    }
    else {
        Write-Error "Cant find the test user $testUserName . There might be AD sync issue"
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Test-ADReplication.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-ADReplication.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
