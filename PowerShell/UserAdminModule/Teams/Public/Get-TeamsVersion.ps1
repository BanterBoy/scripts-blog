function Get-UserTeamsVersion {
    <#
    .SYNOPSIS
        This function retrieves the version of Microsoft Teams installed for the current user.
    .DESCRIPTION
        The function checks if Microsoft Teams is installed for the current user and retrieves its version if it is.
        If Microsoft Teams is not installed for the current user, the function returns a message indicating so.
    .EXAMPLE
        PS C:\> Get-UserTeamsVersion
        1.3.00.30866
    #>
    $TeamsExePath = "$env:LOCALAPPDATA\Microsoft\Teams\current\Teams.exe"
    if (Test-Path -Path $TeamsExePath) {
        $TeamsVersionInfo = Get-ItemProperty -Path $TeamsExePath
        return $TeamsVersionInfo.VersionInfo.ProductVersion
    }
    else {
        return "Teams not installed for this user"
    }
}

function Get-MachineTeamsVersion {
    <#
    .SYNOPSIS
        Gets the version of Microsoft Teams installed on a machine-wide basis.
    .DESCRIPTION
        This function retrieves the version of Microsoft Teams installed on a machine-wide basis by checking the registry key for Teams in the Uninstall subkey of HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion.
        If Teams is installed, the function returns the version number. Otherwise, it returns a message indicating that Teams is not installed on a machine-wide basis.
    .EXAMPLE
        PS C:\> Get-MachineTeamsVersion
        1.3.00.13565
    #>
    $TeamsVersionPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $TeamsVersionKey = Get-ItemProperty -Path $TeamsVersionPath | Where-Object { $_.DisplayName -like "Teams*" }

    if ($null -ne $TeamsVersionKey) {
        return $TeamsVersionKey.DisplayVersion
    }
    else {
        return "Teams not installed on a machine-wide basis"
    }
}

function Get-LatestTeamsVersion {
    <#
    .SYNOPSIS
        This function retrieves the latest version of Microsoft Teams from the Microsoft website.
    
    .DESCRIPTION
        The Get-LatestTeamsVersion function uses Invoke-WebRequest to retrieve the content of the Microsoft Teams download page.
        It then extracts the version number of the latest Windows x64 executable using a regular expression pattern.
        The function returns the latest version number as a string.
    
    .EXAMPLE
        PS C:\> Get-LatestTeamsVersion
        1.4.00.7556
    
    .NOTES
        Author: GitHub Copilot
    #>
    $url = "https://teams.microsoft.com/downloads"
    $webpage = Invoke-WebRequest -Uri $url
    $versionPattern = 'teams_windows_x64-(.*?).exe'
    $latestVersion = $webpage.Content | Select-String -Pattern $versionPattern -AllMatches | 
    ForEach-Object { $_.Matches } | 
    ForEach-Object { $_.Groups[1].Value } | 
    Sort-Object Version -Descending | 
    Select-Object -First 1
    return $latestVersion
}

function Get-TeamsInstallType {
    <#
    .SYNOPSIS
        Gets the installation type, version, and whether it is the latest version of Microsoft Teams.
    
    .DESCRIPTION
        This function gets the installation type (machine-wide or per-user), version, and whether it is the latest version of Microsoft Teams.
    
    .PARAMETER None
        This function does not accept any parameters.
    
    .EXAMPLE
        PS C:\> Get-TeamsInstallType
        Returns an object with the following properties:
            InstallType: Machine-wide or Per-user or Not installed
            Version: The version of Microsoft Teams installed
            IsLatest: True if the installed version is the latest version, False otherwise.
    
    .NOTES
        Author: GitHub Copilot
    #>
    $machineVersion = Get-MachineTeamsVersion
    $userVersion = Get-UserTeamsVersion
    $latestVersion = Get-LatestTeamsVersion
    $installType = $null
    $version = $null
    $isLatest = $false

    if ($machineVersion -ne "Teams not installed on a machine-wide basis") {
        $installType = "Machine-wide"
        $version = $machineVersion
    }
    elseif ($userVersion -ne "Teams not installed for this user") {
        $installType = "Per-user"
        $version = $userVersion
    }
    else {
        $installType = "Not installed"
    }

    if ($version -eq $latestVersion) {
        $isLatest = $true
    }

    # Create a custom PSObject
    $result = New-Object PSObject
    $result | Add-Member -MemberType NoteProperty -Name "InstallType" -Value $installType
    $result | Add-Member -MemberType NoteProperty -Name "Version" -Value $version
    $result | Add-Member -MemberType NoteProperty -Name "IsLatest" -Value $isLatest

    return $result
}

