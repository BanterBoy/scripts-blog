function Select-FolderLocation {
    <#
    .SYNOPSIS
        Prompts the user to select a folder location using a graphical user interface.

    .DESCRIPTION
        This function displays a FolderBrowserDialog to prompt the user to select a folder location.
        It ensures that the user selects a folder and provides options to retry or cancel if the selection is not made.

    .EXAMPLE
        $directoryPath = Select-FolderLocation
        if (![string]::IsNullOrEmpty($directoryPath)) {
            Write-Host "You selected the directory: $directoryPath"
        }
        else {
            Write-Host "You did not select a directory."
        }

        This example prompts the user to select a folder location and displays the selected directory path.

    .OUTPUTS
        System.String

        The function returns the selected directory path as a string. If the user cancels the selection, it returns $null.

    .NOTES
        Author: Luke Leigh
        Date: [Date]

    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.folderbrowserdialog?view=windowsdesktop-6.0
    #>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "Loading System.Windows.Forms assembly."
        [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
        [System.Windows.Forms.Application]::EnableVisualStyles()
    }

    process {
        Write-Verbose "Initializing FolderBrowserDialog."
        $browse = New-Object System.Windows.Forms.FolderBrowserDialog
        $browse.SelectedPath = "C:\"
        $browse.ShowNewFolderButton = $true
        $browse.Description = "Select a directory for your report"

        $loop = $true

        while ($loop) {
            Write-Verbose "Displaying FolderBrowserDialog."
            if ($browse.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                Write-Verbose "User selected directory: $($browse.SelectedPath)"
                $loop = $false
            }
            else {
                Write-Verbose "User clicked Cancel."
                $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
                if ($res -eq [System.Windows.Forms.DialogResult]::Cancel) {
                    Write-Verbose "User chose to exit."
                    return $null
                }
                else {
                    Write-Verbose "User chose to retry."
                }
            }
        }
    }

    end {
        Write-Verbose "Returning selected path: $($browse.SelectedPath)"
        $selectedPath = $browse.SelectedPath
        $browse.Dispose()
        return $selectedPath
    }
}
