function Install-WinGet {
    $hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'

    if (!$hasPackageManager) {
        Add-AppxPackage -Path 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'

        $releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $releases = Invoke-RestMethod -uri $releases_url
        $latestRelease = $releases.assets | Where-Object -FilterScript { $_.browser_download_url.EndsWith('msixbundle') } | Select-Object -First 1

        "Installing winget from $($latestRelease.browser_download_url)"
        Add-AppxPackage -Path $latestRelease.browser_download_url
    }
}
