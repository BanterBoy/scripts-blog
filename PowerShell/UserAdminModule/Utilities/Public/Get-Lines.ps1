function Get-Lines {
    <#
    .SYNOPSIS
    Counts the number of lines in a file.

    .DESCRIPTION
    The Get-Lines function counts the number of lines in a file or multiple files. It accepts either a path or a literal path as input and returns an object with the file name and the number of lines in each file.

    .PARAMETER Path
    Specifies the path(s) to the file(s) for which the number of lines should be counted. Wildcards are supported.

    .PARAMETER LiteralPath
    Specifies the literal path(s) to the file(s) for which the number of lines should be counted. This parameter is an alias for the Path parameter.

    .EXAMPLE
    Get-Lines -Path "C:\Files\file.txt"
    Counts the number of lines in the file "C:\Files\file.txt" and returns an object with the file name and the number of lines.

    .EXAMPLE
    Get-ChildItem -Path "C:\Files" -Recurse | Get-Lines
    Counts the number of lines in all files in the "C:\Files" directory and its subdirectories, and returns an object with the file name and the number of lines for each file.

    .NOTES
    Author: Your Name
    Date:   Current Date
    #>

    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [parameter(
            Mandatory,
            ParameterSetName = 'Path',
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]$Path,

        [parameter(
            Mandatory,
            ParameterSetName = 'LiteralPath',
            Position = 0,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$LiteralPath
    )

    process {
        # Resolve path(s)
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $resolvedPaths = Resolve-Path -Path $Path | Select-Object -ExpandProperty Path
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'LiteralPath') {
            $resolvedPaths = Resolve-Path -LiteralPath $LiteralPath | Select-Object -ExpandProperty Path
        }

        # Process each item in resolved paths
        foreach ($item in $resolvedPaths) {
            $fileItem = Get-Item -LiteralPath $item
            $content = $fileItem | Get-Content
            [pscustomobject]@{
                Path  = $fileItem.Name
                Lines = $content.Count
            }
        }
    }
}
