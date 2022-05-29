---
layout: post
title: New-DummyFile.ps1
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
function New-DummyFile {

    <#

    .SYNOPSIS
    New-DummyFile.ps1 - [1-LINE-DESC]

    .NOTES
    Author	: Luke Leigh
    Website	: https://blog.lukeleigh.com
    Twitter	: https://twitter.com/luke_leighs

    Additional Credits: [REFERENCE]
    Website: [URL]
    Twitter: [URL]

    Change Log
    [VERSIONS]

    .PARAMETER


    .INPUTS
    None. Does not accepted piped input.

    .OUTPUTS
    None. Returns no objects or output.
    System.Boolean  True if the current Powershell is elevated, false if not.
    [use a | get-member on the script to see exactly what .NET obj TypeName is being returning for the info above]

    .EXAMPLE
    New-DummyFile -FilePath "C:\GitRepos\" -FileName "NewDummy.txt" -FileSize 32

    [use an .EXAMPLE keyword per syntax sample]

    .LINK


    .FUNCTIONALITY

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias('ngp')]
    [OutputType([String])]
    Param (
        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $FilePath,

        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $FileName,

        # Brief explanation of the parameter and its requirements/function
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false,
            ParameterSetName = 'Default',
            HelpMessage = "Brief explanation of the parameter and its requirements/function" )]
        [string]
        $FileSize

    )

    begin {

    }

    process {

        try {
            if ($PSCmdlet.ShouldProcess("$FilePath", "Create dummy file of size $sizeBytes")) {
                $File = "$FilePath" + "$FileName"
                $sizeBytes = "$($FileSize + "MB")"
                $File = [System.IO.File]::Create("$File")
                $File.SetLength($sizeBytes)
                Write-Output "$FileName created @ $sizeBytes in size."
                $File.Close()
                $File.Dispose()
            }
        }
        catch {
            Write-Error -Message "$_"
        }
    }

    end {

    }
}

# New-DummyFile -FilePath "C:\GitRepos\" -FileName "NewDummy.txt" -FileSize 32
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/functions/myProfile/New-DummyFile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-DummyFile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
