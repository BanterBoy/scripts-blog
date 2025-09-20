#Requires -PSEdition Core

<#
    .DESCRIPTION
        Installs FFMpeg using Chocolatey. Requires admin privileges.
#>
function FFMpeg-Install {
    # test if admin
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "You must run this script as an administrator."

        return
    }

    choco install ffmpeg -y
}