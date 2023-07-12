---
layout: post
title: Test-ServerExists.ps1
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
Function Test-ServerExists {
    param (
        [CmdletBinding()]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    begin {
        $SelectHash = @{
            'Property' = @('Name', 'ADObject', 'DNSEntry', 'PingResponse', 'RDPConnection')
        }
    }

    process {
        foreach ($CurrentComputer in $ComputerName) {
            # Create new Hash
            $HashProps = @{
                'Name'          = $CurrentComputer
                'ADObject'      = $false
                'DNSEntry'      = $false
                'RDPConnection' = $false
                'PingResponse'  = $false
            }

            # Perform Checks
            switch ($true) {
                { ([adsisearcher]"samaccountname=$CurrentComputer`$").findone() } { $HashProps.ADObject = $true }
                { $(try { [system.net.dns]::gethostentry($CurrentComputer) } catch {}) } { $HashProps.DNSEntry = $true }
                { $(try { $socket = New-Object Net.Sockets.TcpClient($CurrentComputer, 3389); if ($socket.Connected) { $true }; $socket.Close() } catch {}) } { $HashProps.RDPConnection = $true }
                { Test-Connection -ComputerName $CurrentComputer -Quiet -Count 1 } { $HashProps.PingResponse = $true }
                Default {}
            }

            # Output object
            New-Object -TypeName 'PSCustomObject' -Property $HashProps | Select-Object @SelectHash
        }
    }

    end {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Test-ServerExists.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-ServerExists.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
