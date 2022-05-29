---
layout: post
title: Import-CSVCustom.ps1
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
This is a copy of:

CommandType Name       Version Source
----------- ----       ------- ------
Cmdlet      Import-Csv 3.1.0.0 Microsoft.PowerShell.Utility

Created: 17 May 2021
Author : Jeff Hicks

Learn more about PowerShell: https://jdhitsolutions.com/blog/essential-powershell-resources/

#>

<#
I am using a namespace to make defining a List[] object easier later
in the script.
#>
Using Namespace System.Collections.Generic

Function Import-CSVCustom {

    #TODO - Add comment-based help
    [CmdletBinding(DefaultParameterSetName = 'Delimiter')]
    Param(
        [Parameter(ParameterSetName = 'Delimiter', Position = 1)]
        [ValidateNotNull()]
        [char]$Delimiter,

        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "The path to the CSV file. Every path is treated as a literal path."
            )]
        [ValidateNotNullOrEmpty()]
        #Validate file exists
        [ValidateScript({
            If ((Test-Path $_) -AND ((Get-Item $_).PSProvider.Name -eq 'FileSystem')) {
                $True
            }
            else {
                Write-Warning "Failed to verify $($_.ToUpper()) or it is not a file system object."
                Throw "Failed to validate the path parameter."
                $False
            }
            })]
        [Alias("PSPath")]
        [string[]]$Path,

        [Parameter(ParameterSetName = 'UseCulture', Mandatory)]
        [ValidateNotNull()]
        [switch]$UseCulture,

        [ValidateNotNullOrEmpty()]
        [string[]]$Header,

        [ValidateSet('Unicode', 'UTF7', 'UTF8', 'ASCII', 'UTF32', 'BigEndianUnicode', 'Default', 'OEM')]
        [string]$Encoding,

        [Parameter(HelpMessage = "Add a custom property to reflect the import source file.")]
        [switch]$IncludeSource,

        [Parameter(HelpMessage = "Insert an optional custom type name.")]
        [ValidateNotNullOrEmpty()]
        [string]$PSTypeName
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"
        Write-Verbose "[BEGIN  ] Using parameter set $($PSCmdlet.ParameterSetName)"
        Write-Verbose ($PSBoundParameters | Out-String)

        #remove parameters that don't belong to the native Import-Csv command
        if ($PSBoundParameters.ContainsKey("IncludeSource")) {
            [void]$PSBoundParameters.Remove("IncludeSource")
        }
        if ($PSBoundParameters.ContainsKey("PSTypeName")) {
            [void]$PSBoundParameters.Remove("PSTypeName")
        }
    } #begin

    Process {
        <#
        Initialize a generic list to hold each imported object so it can be
        processed for CSVSource and/or typename
        #>
        $in = [List[object]]::New()

        #convert the path value to a complete filesystem path
        $cPath = Convert-Path -Path $Path
        #update the value of the PSBoundparameter
        $PSBoundParameters["Path"] = $cPath

        Write-Verbose "[PROCESS] Importing from $cPath"

        <#
        Add each imported item to the collection.

        It is theoretically possible to have a CSV file of 1 object, so
        instead of testing to determine whether to use Add() or AddRange(),
        I'll simply Add each item.

        I'm using the fully qualified cmdlet name in case I want this function
        to become my Import-Csv command.
        #>
        Microsoft.PowerShell.Utility\Import-Csv @PSBoundParameters | ForEach-Object { $in.Add($_) }

        Write-Verbose "[PROCESS] Post-processing $($in.count) objects"

        if ($IncludeSource) {
            Write-Verbose "[PROCESS] Adding CSVSource property"
            $in | Add-Member -MemberType NoteProperty -Name CSVSource -Value $cPath -Force
        }
        if ($PSTypeName) {
            Write-Verbose "[PROCESS] Adding PSTypename $PSTypeName"
            $($in).foreach({ $_.psobject.typenames.insert(0, $PSTypeName)})
        }
        #write the results to the pipeline
        $in
    } #process

    End {
        Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
    } #end

} #end Import-CsvCustom
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('http://agamar.domain.leigh-services.com:4000/powershell/functions/myProfile/Import-CSVCustom.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Import-CSVCustom.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
