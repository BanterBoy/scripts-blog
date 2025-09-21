---
layout: post
title: GitHubCopilotAlias.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/shell/githubcopilotalias/
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function ghcs {
        # Debug support provided by common PowerShell function parameters, which is natively aliased as -d or -db
        # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4#-debug
        param(
                [ValidateSet('gh', 'git', 'shell')]
                [String]$Target = 'shell',

                [Parameter(Position=0, ValueFromRemainingArguments)]
                [string]$Prompt
        )
        begin {
                # Create temporary file to store potential command user wants to execute when exiting
                $executeCommandFile = New-TemporaryFile

                # Store original value of GH_DEBUG environment variable
                $envGhDebug = $Env:GH_DEBUG
        }
        process {
                if ($PSBoundParameters['Debug']) {
                        $Env:GH_DEBUG = 'api'
                }

                gh copilot suggest -t $Target -s "$executeCommandFile" $Prompt
        }
        end {
                # Execute command contained within temporary file if it is not empty
                if ($executeCommandFile.Length -gt 0) {
                        # Extract command to execute from temporary file
                        $executeCommand = (Get-Content -Path $executeCommandFile -Raw).Trim()

                        # Insert command into PowerShell up/down arrow key history
                        [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($executeCommand)

                        # Insert command into PowerShell history
                        $now = Get-Date
                        $executeCommandHistoryItem = [PSCustomObject]@{
                                CommandLine = $executeCommand
                                ExecutionStatus = [Management.Automation.Runspaces.PipelineState]::NotStarted
                                StartExecutionTime = $now
                                EndExecutionTime = $now.AddSeconds(1)
                        }
                        Add-History -InputObject $executeCommandHistoryItem

                        # Execute command
                        Write-Host "`n"
                        Invoke-Expression $executeCommand
                }
        }
        clean {
                # Clean up temporary file used to store potential command user wants to execute when exiting
                Remove-Item -Path $executeCommandFile

                # Restore GH_DEBUG environment variable to its original value
                $Env:GH_DEBUG = $envGhDebug
        }
}

function ghce {
        # Debug support provided by common PowerShell function parameters, which is natively aliased as -d or -db
        # https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters?view=powershell-7.4#-debug
        param(
                [Parameter(Position=0, ValueFromRemainingArguments)]
                [string[]]$Prompt
        )
        begin {
                # Store original value of GH_DEBUG environment variable
                $envGhDebug = $Env:GH_DEBUG
        }
        process {
                if ($PSBoundParameters['Debug']) {
                        $Env:GH_DEBUG = 'api'
                }

                gh copilot explain $Prompt
        }
        clean {
                # Restore GH_DEBUG environment variable to its original value
                $Env:GH_DEBUG = $envGhDebug
        }
}
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/GitHubCopilotAlias.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=GitHubCopilotAlias.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

