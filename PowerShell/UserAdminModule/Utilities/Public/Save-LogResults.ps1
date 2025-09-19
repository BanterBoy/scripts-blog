function Save-LogResults {

    <#
    .SYNOPSIS
        Logs results to a file.

    .DESCRIPTION
        This function logs the results of a script to a file. It takes an array of old files, a report path, 
        and a summary as input parameters. The function generates a report file with the name "FileReport-yyyy-MM-dd.txt" 
        in the specified report path. The report file contains the last write time, directory, name, and length of each 
        old file in the array, followed by the summary.

    .PARAMETER OldFiles
        An array of old files to be logged.

    .PARAMETER ReportPath
        The path where the report file will be saved.

    .PARAMETER Summary
        A summary of the script results to be logged.

    .EXAMPLE
        PS C:\> Save-LogResults -OldFiles $OldFiles -ReportPath "C:\Reports" -Summary "Script completed successfully."

        This example logs the results of a script to a report file named "FileReport-yyyy-MM-dd.txt" in the 
        "C:\Reports" directory. The report file contains the last write time, directory, name, and length of 
        each old file in the $OldFiles array, followed by the summary "Script completed successfully."

    .NOTES
        Author: John Doe
        Date: 01/01/2022
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$OldFiles,
        [Parameter(Mandatory = $true)]
        [string]$ReportPath,
        [Parameter(Mandatory = $true)]
        [string]$Summary
    )

    begin {
        # Get the current date in yyyy-MM-dd format
        $Date = [datetime]::Now.ToString("yyyy-MM-dd")
        # Generate the report file name
        $ReportName = "FileReport-$Date.txt"
        # Create the full path for the report file
        $Report = Join-Path -Path $ReportPath -ChildPath $ReportName

        Write-Verbose -Message "Starting to log results to $Report"
    }

    process {
        # Check if the report path exists, if not create it
        if (-not (Test-Path -Path $ReportPath)) {
            Write-Verbose -Message "Report path '$ReportPath' does not exist. Creating..."
            New-Item -Path $ReportPath -ItemType Directory | Out-Null
        }

        # Log details of old files to the report file
        Write-Verbose -Message "Logging details of old files to the report"
        $OldFiles | Select-Object -Property LastWriteTime, Directory, Name, Length | Out-File -FilePath $Report -Encoding utf8

        # Log the summary to the report file
        Write-Verbose -Message "Logging summary to the report"
        $Summary | Out-File -FilePath $Report -Encoding utf8 -Append
    }

    end {
        Write-Verbose -Message "Finished logging results to $Report"
    }
}

# Example Usage:
# Save-LogResults -OldFiles $OldFiles -ReportPath "C:\Reports" -Summary "Script completed successfully." -Verbose
