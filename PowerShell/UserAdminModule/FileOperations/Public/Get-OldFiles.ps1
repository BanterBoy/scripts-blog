function Get-OldFiles {

    <#
    .SYNOPSIS
        Gets files that are older than a specified number of days.

    .DESCRIPTION
        The Get-OldFiles function gets files that are older than a specified number of days. It accepts a mandatory parameter Path, which specifies the path to search for files. It also accepts an optional parameter Days, which specifies the number of days to look back for files. By default, it looks back 1 day. The function also accepts an optional parameter FileName, which specifies the name of the file to search for. By default, it searches for all files. The function also accepts optional switches Recurse and Summarize, which specify whether to search recursively and whether to summarize the results, respectively.

    .PARAMETER Path
        Specifies the path to search for files.

    .PARAMETER Days
        Specifies the number of days to look back for files. By default, it looks back 1 day.

    .PARAMETER FileName
        Specifies the name of the file to search for. By default, it searches for all files.

    .PARAMETER Recurse
        Specifies whether to search recursively.

    .PARAMETER Summarize
        Specifies whether to summarize the results.

    .EXAMPLE
        PS C:\> Get-OldFiles -Path "C:\Logs" -Days 7 -FileName "*.log" -Recurse -Summarize
        Found 10 *.log files older than 7 days with a total size of 1.23 GB

        This example gets all *.log files in the C:\Logs directory and its subdirectories that are older than 7 days. It summarizes the results by displaying the number of files found and their total size.

    .INPUTS
        None.

    .OUTPUTS
        System.IO.FileInfo

    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [int]$Days = 1,
        [string]$FileName = "*.*",
        [switch]$Recurse,
        [switch]$Summarize
    )

    begin {
        Write-Verbose -Message "Starting processing of $($FileName) files older than $($Days) days"
        $TotalSize = 0
    }

    process {
        $ChildItemParams = @{
            LiteralPath = $Path
            File        = $true
            Recurse     = $Recurse.IsPresent
            Filter      = $FileName
        }

        $OldFiles = Get-ChildItem @ChildItemParams | Where-Object -FilterScript {
            $_.LastWriteTime -lt (Get-Date).AddDays(-$Days)
        }

        if ($Summarize) {
            $TotalSize = $OldFiles | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum
            $FriendlySize = Get-FriendlySize -Bytes $TotalSize
            Write-Verbose -Message "Found $($OldFiles.Count) $($FileName) files older than $($Days) days with a total size of $($FriendlySize.FriendlySize)"
            return "Found $($OldFiles.Count) $($FileName) files older than $($Days) days with a total size of $($FriendlySize.FriendlySize)"
        }
        else {
            Write-Verbose -Message "Found $($OldFiles.Count) $($FileName) files older than $($Days) days"
            return $OldFiles
        }
    }
}