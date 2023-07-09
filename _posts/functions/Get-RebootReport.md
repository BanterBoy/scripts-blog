---
layout: post
title: Get-RebootReport.ps1
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
function Get-RebootReport {
    [cmdletbinding(DefaultParameterSetName = 'default')]

    param(
        [Parameter(Mandatory = $True,
            ParameterSetName = 'Default',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter a ComputerName or Pipe in from another command.")]
        [string[]]$Computer
    )

    BEGIN {}

    PROCESS {
        $collection = Get-WinEvent -ComputerName "$Computer" -FilterHashtable @{logname = 'System'; id = 1074 }

        foreach ($item in $collection) {
            try {
                $properties = @{
                    "Date"        = $item.TimeCreated
                    "User"        = $item.Properties[6].Value
                    "Process"     = $item.Properties[0].Value
                    "Action"      = $item.Properties[4].Value
                    "Reason"      = $item.Properties[2].Value
                    "Reason Code" = $item.Properties[3].Value
                    "Comment"     = $item.Properties[5].Value
                }
            }
            catch {
                $properties = @{
                    "Date"        = $item.TimeCreated
                    "User"        = $item.Properties[6].Value
                    "Process"     = $item.Properties[0].Value
                    "Action"      = $item.Properties[4].Value
                    "Reason"      = $item.Properties[2].Value
                    "Reason Code" = $item.Properties[3].Value
                    "Comment"     = $item.Properties[5].Value
                }
            }
            Finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Get-RebootReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-RebootReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
