---
layout: post
title: Invoke-FTPUpload.ps1
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
<#
    .SYNOPSIS
    Short function to upload files to an FTP Server (Incomplete)

    .DESCRIPTION
    Short function to upload files to an FTP Server (Incomplete)
    This function is not completed and is still being written.
    Currently adapting script to make a cmdlet

    .EXAMPLE
    This CmdLet is incomplete

    .INPUTS
    None

    .OUTPUTS


    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/PowerRepo/wiki

#>

[CmdletBinding(DefaultParameterSetName = 'default')]

param(
    [Parameter(Mandatory = $True,
        HelpMessage = "ftp://ftpserver.address/uploadfolder",
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('FTP')]
    [string[]]$FTPServer,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('usr')]
    [string[]]$Username,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('pwd')]
    [String[]]$Password,

    [Parameter(Mandatory = $True,
        HelpMessage = "Please enter an Email Address.",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('fpath')]
    [string[]]$UploadFolder

)

BEGIN {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Add-Type -AssemblyName System.Web
    Add-Type -AssemblyName System.Net
    $webclient = New-Object System.Net.WebClient
    $webclient.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
    $UploadFiles = Get-ChildItem $UploadFolder | Where-Object { !$_.PSIsContainer } | Sort-Object LastAccessTime, name -Descending | Select-Object -First 5 | Select-Object -ExpandProperty  fullname
}

PROCESS {

    foreach ($UploadFile in $UploadFiles) {
        "Uploading $UploadFile..."
        $name = $UploadFile
        $name = [System.Uri]::EscapeDataString($name)
        $uri = New-Object System.Uri($FTPServer + "/" + $name + "")
        $webclient.UploadFile($uri, $UploadFile)

        #     try {
        #         $properties = @{
        #             Email              = $Validation.email
        #         }
        #     }
        #     catch {
        #         $properties = @{
        #             Email              = $Validation.email
        #         }
        #     }
        #     Finally {
        #         $obj = New-Object -TypeName PSObject -Property $properties
        #         Write-Output $obj
        #     }
    }

}

END {}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/Invoke-UrlScan.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Invoke-FTPUpload.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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

```

```
