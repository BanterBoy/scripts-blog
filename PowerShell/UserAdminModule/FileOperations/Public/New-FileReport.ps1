function New-FileReport {

    <#
    .SYNOPSIS
        Creates an HTML report.

    .DESCRIPTION
        This function creates an HTML report that displays information about old files, including the number of files found, the newest and oldest file ages, and a table of the files with their last write time and file name. The report also includes a summary message.

    .PARAMETER OldFiles
        Specifies an array of old files to include in the report.

    .PARAMETER Summary
        Specifies a summary message to include in the report.

    .PARAMETER SaveReport
        Saves the report to the user's temporary folder if this switch is specified.

    .EXAMPLE
        PS C:\> $OldFiles = Get-ChildItem -Path C:\Logs -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
        PS C:\> $Summary = "Old log files have been cleaned up."
        PS C:\> New-FileReport -OldFiles $OldFiles -Summary $Summary -SaveReport

        This example creates an HTML report that displays information about old log files in the C:\Logs directory that were last modified more than 30 days ago. The report includes a summary message and is saved to the user's temporary folder.

    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$OldFiles,
        [Parameter(Mandatory = $true)]
        [string]$Summary,
        [switch]$SaveReport
    )

    $OldestFileAge = (Get-Date) - ($OldFiles | Sort-Object -Property LastWriteTime | Select-Object -First 1).LastWriteTime
    $NewestFileAge = (Get-Date) - ($OldFiles | Sort-Object -Property LastWriteTime | Select-Object -Last 1).LastWriteTime
    $OldestFileAgeDays = $OldestFileAge.Days
    $NewestFileAgeDays = $NewestFileAge.Days

    $Report = @"
<!DOCTYPE html>
<html>
<head>
    <style>
        h1 {
            color: blue;
            font-family: Calibri;
            font-size: 20px;
        }

        p {
            color: black;
            font-family: Calibri;
            font-size: 15px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            text-align: left;
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <div style="background-color:white;black:white;padding:20px;">
        <h1>Old Files Cleanup Report</h1>
        <hr>
        <p>Found $($OldFiles.Count) files</p>
        <p>The newest file is $NewestFileAgeDays days old</p>
        <p>The oldest file is $OldestFileAgeDays days old</p>
        <table>
            <tr>
                <th>Last Write Time</th>
                <th>File Name</th>
            </tr>
            $($OldFiles | Sort-Object -Property LastWriteTime | ForEach-Object -Process { "<tr><td>$($_.LastWriteTime)</td><td>$($_.FullName)</td></tr>" })
        </table>
        <hr>
        <p><strong><span style="border: 1px solid black;padding:4px;color:red;"> $Summary</span></strong></p>
    </div>
</body>
</html>
"@

    return $Report
    if ($SaveReport) {
        $Report | Out-File -FilePath $Env:TEMP\Report.html -Force
    }
}
