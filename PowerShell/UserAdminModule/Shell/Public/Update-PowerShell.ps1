<#
.SYNOPSIS
    Installs the latest version of PowerShell 7.

.DESCRIPTION
    This function checks for the existing installation of PowerShell 7 and installs the latest version if it's not already installed.

.NOTES
    Author: Your Name
    Date: Today's Date

.EXAMPLE
    Update-PowerShell -Verbose
#>

function Update-PowerShell {
    [CmdletBinding()]
    param ()

    begin {
        Write-Verbose "Checking for existing installation of PowerShell 7..."
    }

    process {
        $installedVersion = $null
        $latestVersion = $null

        # Check for existing installation
        if (Get-Command pwsh -ErrorAction SilentlyContinue) {
            $installedVersion = (pwsh --version).Split(" ")[-1]
            Write-Verbose "Installed PowerShell 7 version: $installedVersion"

            try {
                $latestVersion = (Invoke-RestMethod https://api.github.com/repos/PowerShell/PowerShell/releases/latest).tag_name.Replace("v", "")
                Write-Verbose "Latest PowerShell 7 version available: $latestVersion"
            }
            catch {
                Write-Error "Failed to retrieve the latest version of PowerShell 7: $_"
                return
            }

            if ($installedVersion -eq $latestVersion) {
                Write-Output "The latest version of PowerShell 7 ($latestVersion) is already installed."
                return
            }
            else {
                Write-Output "An older version of PowerShell 7 ($installedVersion) is installed. The latest version is $latestVersion."
            }
        }

        # Attempt to install PowerShell 7
        try {
            Write-Verbose "Attempting to install PowerShell 7..."
            if ($IsWindows) {
                Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
            }
            elseif ($IsLinux) {
                curl -sSL https://aka.ms/install-powershell.sh | sudo bash
            }
            elseif ($IsMacOS) {
                brew install --cask powershell
            }
            else {
                Write-Error "Unsupported platform. This script supports Windows, Linux, and macOS only."
                return
            }
            Write-Verbose "PowerShell 7 installed successfully."
        }
        catch {
            Write-Error "Failed to install PowerShell 7: $_"
        }
    }
}
