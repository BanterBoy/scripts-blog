<#
.SYNOPSIS
    Measures the number of lines, words, and characters in one or more files.

.DESCRIPTION
    The Measure-Lines function measures the number of lines, words, and characters in one or more files. It provides flexibility to measure specific aspects of the file content, such as lines, words, or characters, or measure all aspects at once.

.PARAMETER Path
    Specifies the path to one or more files. This parameter is mandatory when using the 'Path' parameter set.

.PARAMETER LiteralPath
    Specifies the literal path to a single file. This parameter is mandatory when using the 'LiteralPath' parameter set.

.PARAMETER Lines
    Indicates whether to measure the number of lines in the file(s). By default, this parameter is set to $false.

.PARAMETER Words
    Indicates whether to measure the number of words in the file(s). By default, this parameter is set to $false.

.PARAMETER Characters
    Indicates whether to measure the number of characters in the file(s). By default, this parameter is set to $false.

.PARAMETER All
    Indicates whether to measure all aspects (lines, words, and characters) of the file(s). When this parameter is used, the 'Lines', 'Words', and 'Characters' parameters are ignored.

.PARAMETER Recurse
    Indicates whether to search for files recursively in the specified path(s). This parameter is only applicable when using the 'Path' or 'PathAll' parameter set.

.EXAMPLE
    Measure-Lines -Path "C:\Files\File1.txt", "C:\Files\File2.txt" -Lines -Words
    Measure the number of lines and words in the specified files.

.EXAMPLE
    Measure-Lines -LiteralPath "C:\Files\File1.txt" -Characters -Recurse
    Measure the number of characters in the specified file and its subdirectories.

#>
function Measure-Lines {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Path',
            HelpMessage = 'Enter one or more filenames',
            Position = 0)]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'PathAll',
            Position = 0)]
        [string[]]$Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'LiteralPathAll')]
        [Parameter(Mandatory = $true,
            ParameterSetName = 'LiteralPath',
            HelpMessage = 'Enter a single filename',
            ValueFromPipeline = $true)]
        [string]$LiteralPath,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'LiteralPath')]
        [switch]$Lines,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'LiteralPath')]
        [switch]$Words,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'LiteralPath')]
        [switch]$Characters,

        [Parameter(Mandatory = $true, ParameterSetName = 'PathAll')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LiteralPathAll')]
        [switch]$All,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'PathAll')]
        [switch]$Recurse
    )

    begin {
        if ($All) {
            $Lines = $Words = $Characters = $true
        }
        elseif (($Words -eq $false) -and ($Characters -eq $false)) {
            $Lines = $true
        }

        if ($Path) {
            $Files = Get-ChildItem -Path $Path -Recurse:$Recurse
        }
        else {
            $Files = Get-ChildItem -LiteralPath $LiteralPath
        }
    }
    process {
        foreach ($file in $Files) {
            $result = [ordered]@{ }
            $result.Add('File', $file.fullname)

            $content = Get-Content -LiteralPath $file.fullname

            if ($Lines) { $result.Add('Lines', $content.Length) }

            if ($Words) {
                $wc = 0
                foreach ($line in $content) { $wc += $line.split(' ').Length }
                $result.Add('Words', $wc)
            }

            if ($Characters) {
                $cc = 0
                foreach ($line in $content) { $cc += $line.Length }
                $result.Add('Characters', $cc)
            }

            New-Object -TypeName psobject -Property $result
        }
    }
}