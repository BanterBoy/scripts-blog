function Update-PowerShell {

    # Test if PowerShellForGitHub module is installed and if not, install module.
    $Module = "PowerShellForGitHub"

    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    if ( Get-Module -Name $Module ) {
        Import-Module -Name $Module
        Write-Warning "Module Import - Imported $Module"
    }

    else {
        Write-Warning "Installing $Module"
        $execpol = Get-ExecutionPolicy -Scope Process
        if ( $execpol -ne 'Unrestricted' ) {
            Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
        }
        Install-Module -Name $Module -Scope CurrentUser
    }

    Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted

    $GitRelease = (Get-GitHubRelease -OwnerName PowerShell -RepositoryName PowerShell -Latest -ErrorAction Continue).tag_name
    $LocalVersion = $PSVersionTable.GitCommitId

    # Test current version installed and update if not latest release
    if ($GitRelease -like "*" + $LocalVersion) {
        Write-Warning "Up-to-date!"
    }

    else {
        $Protocols = [System.Net.SecurityProtocolType]'Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $Protocols
        Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"
    }

}

Update-PowerShell