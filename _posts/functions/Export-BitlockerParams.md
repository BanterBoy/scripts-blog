---
layout: post
title: Export-BitlockerParams.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
#Requires -RunAsAdministrator
#Requires -Modules @{ModuleName="BitLocker";ModuleVersion="1.0.0.0"}

[CmdletBinding(
    DefaultParameterSetName = "BitEncrypt",
    SupportsShouldProcess = $True,
    ConfirmImpact = 'High'
)]

param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        HelpMessage = "Please enter the ComputerName or Pipe in from another command.")]
    [Alias('Hostname', 'cn')]
    [string[]]$ComputerName
)

BEGIN {

}

PROCESS {
    foreach ($Computer in $ComputerName) {
        try {
            $Volumes = Invoke-Command -ComputerName $computer { Get-Volume }
            $TPMKey = Invoke-Command -computername $computer { (Get-BitLockerVolume).KeyProtector }
            foreach ($Volume in $Volumes) {
                $properties = @{ComputerName = $Computer
                    KeyProtectorType         = $TPMKey.KeyProtectorType
                    KeyProtectorId           = $TPMKey.KeyProtectorId
                    RecoveryPassword         = $TPMKey.RecoveryPassword
                }
            }
        }
        catch {
            Write-Verbose "Couldn't connect to $Computer"
            foreach ($property in $properties) {
                $properties = @{ComputerName = $Computer
                    KeyProtectorType         = $TPMKey.KeyProtectorType
                    KeyProtectorId           = $TPMKey.KeyProtectorId
                    RecoveryPassword         = $TPMKey.RecoveryPassword
                }
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj | Format-List -Property $obj.ComputerName, $obj.KeyProtectorId, $obj.RecoveryPassword
        }
    }
}
END {

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/bitLocker/Export-BitlockerParams.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Export-BitlockerParams.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
