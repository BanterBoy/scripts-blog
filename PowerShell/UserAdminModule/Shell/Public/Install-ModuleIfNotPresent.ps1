<#
.SYNOPSIS
Installs a PowerShell module if it is not already present and imports it.

.DESCRIPTION
The Install-ModuleIfNotPresent function checks if a specified PowerShell module is already installed. If the module is installed, it imports the module. If the module is not installed, it installs the module from a specified repository, and then imports the module.

.PARAMETER ModuleName
The name of the PowerShell module to install and import.

.PARAMETER Repository
The repository from which to install the PowerShell module.

.EXAMPLE
Install-ModuleIfNotPresent -ModuleName "AzureRM" -Repository "PSGallery"
This example installs the "AzureRM" module from the "PSGallery" repository if it is not already installed, and then imports the module.

.INPUTS
None.

.OUTPUTS
None.

.NOTES
Author: Your Name
Date: Today's Date
#>

function Install-ModuleIfNotPresent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$Repository
    )

    try {
        if ((Get-Module -Name $ModuleName -ListAvailable)) {
            Write-Verbose "Importing module - $($ModuleName)"
            Import-Module -Name $ModuleName
        }
        Else {
            Write-Verbose "Installing module - $($ModuleName)"
            Install-Module -Name $ModuleName -Repository $Repository -Force -ErrorAction Stop
            Import-Module -Name $ModuleName
        }
    }
    catch {
        Write-Error -Message $_.Exception.Message
    }
}
