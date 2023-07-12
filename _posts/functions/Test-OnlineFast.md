---
layout: post
title: Test-OnlineFast.ps1
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
function Test-OnlineFast {
    param
    (
        # make parameter pipeline-aware
        [Parameter(Mandatory,
            ValueFromPipeline)]
        [string[]]
        $ComputerName,

        $TimeoutMillisec = 1000
    )

    begin {
        # use this to collect computer names that were sent via pipeline
        [Collections.ArrayList]$bucket = @()

        # hash table with error code to text translation
        $StatusCode_ReturnValue =
        @{
            0     = 'Success'
            11001 = 'Buffer Too Small'
            11002 = 'Destination Net Unreachable'
            11003 = 'Destination Host Unreachable'
            11004 = 'Destination Protocol Unreachable'
            11005 = 'Destination Port Unreachable'
            11006 = 'No Resources'
            11007 = 'Bad Option'
            11008 = 'Hardware Error'
            11009 = 'Packet Too Big'
            11010 = 'Request Timed Out'
            11011 = 'Bad Request'
            11012 = 'Bad Route'
            11013 = 'TimeToLive Expired Transit'
            11014 = 'TimeToLive Expired Reassembly'
            11015 = 'Parameter Problem'
            11016 = 'Source Quench'
            11017 = 'Option Too Big'
            11018 = 'Bad Destination'
            11032 = 'Negotiating IPSEC'
            11050 = 'General Failure'
        }


        # hash table with calculated property that translates
        # numeric return value into friendly text

        $statusFriendlyText = @{
            # name of column
            Name       = 'Status'
            # code to calculate content of column
            Expression = {
                # take status code and use it as index into
                # the hash table with friendly names
                # make sure the key is of same data type (int)
                $StatusCode_ReturnValue[([int]$_.StatusCode)]
            }
        }

        # calculated property that returns $true when status -eq 0
        $IsOnline = @{
            Name       = 'Online'
            Expression = { $_.StatusCode -eq 0 }
        }

        # do DNS resolution when system responds to ping
        $DNSName = @{
            Name       = 'DNSName'
            Expression = { if ($_.StatusCode -eq 0) {
                    if ($_.Address -like '*.*.*.*')
                    { [Net.DNS]::GetHostByAddress($_.Address).HostName }
                    else
                    { [Net.DNS]::GetHostByName($_.Address).HostName }
                }
            }
        }

        $IpSort = @{
            Name       = 'IpSort'
            Expression = {
                $paddedArray = $_.Address -split "." | Select-Object { ([int]$_).ToString("000") }

                [array]::Reverse($paddedArray)

                $paddedArray -join "."
            }
        }
    }

    process {
        # add each computer name to the bucket
        # we either receive a string array via parameter, or
        # the process block runs multiple times when computer
        # names are piped
        $ComputerName | ForEach-Object {
            $null = $bucket.Add($_)
        }
    }

    end {
        # convert list of computers into a WMI query string
        $query = $bucket -join "' or Address='"

        $collection = $null

        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $collection = Get-CimInstance -ClassName Win32_PingStatus -Filter "(Address='$query') and timeout=$TimeoutMillisec"
        }
        else {
            $collection = Get-WmiObject -Class Win32_PingStatus -Filter "(Address='$query') and timeout=$TimeoutMillisec"
        }

        $collection |
        Select-Object -Property Address, $IsOnline, $DNSName, $statusFriendlyText |
        Sort-Object { $IpSort } |
        Format-Table -AutoSize
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Test-OnlineFast.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-OnlineFast.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
