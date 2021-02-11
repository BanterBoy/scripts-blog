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
    & (Join-Path $PSScriptRoot + "\Connect-Office365Services.ps1")
}
