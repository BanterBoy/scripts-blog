<#
.SYNOPSIS
    Adds Office 365 PowerShell modules to the current session.

.DESCRIPTION
    The Add-Office365Functions function is used to import the necessary Office 365 PowerShell modules into the current session. It checks if the modules are already installed and imports them if they are available. If a module is not installed, it installs the module from the PowerShell Gallery.

.PARAMETER None
    This function does not accept any parameters.

.EXAMPLE
    Add-Office365Functions
    This example demonstrates how to use the Add-Office365Functions function to import the Office 365 PowerShell modules into the current session.

.NOTES
    Author: Your Name
    Date:   Current Date
#>

function Add-Office365Functions {
    $Modules = "AADRM", "AzureAD", "AzureADPreview", "Microsoft.Online.SharePoint.PowerShell", "MicrosoftTeams", "MSOnline", "SharePointPnPPowerShellOnline", "ActiveDirectory"
    foreach ($Module in $Modules) { 
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        if ( Get-Module -Name $Module ) {
            Import-Module -Name $Module
            Write-Warning "Module Import - Imported $Module"
        }
        else {
            Write-Warning "Installing $Module"
            $execpol = Get-ExecutionPolicy -List
            if ( $execpol -ne 'Unrestricted' ) {
                Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
            }
            Install-Module -Name $Module -Scope AllUsers -AllowClobber
        }
        Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
    }
    # & (Join-Path ($PROFILE).TrimEnd('Microsoft.PowerShell_profile.ps1') "\Connect-Office365Services.ps1")
}