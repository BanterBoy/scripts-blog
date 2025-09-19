Function Initialize-TeamsLocalUploadFolder {
    <#
    .SYNOPSIS
        Initializes the local upload folder for Microsoft Teams backgrounds.
    
    .DESCRIPTION
        This function checks if the local upload folder for Microsoft Teams backgrounds exists and creates it if it doesn't. 
        It also checks if the local folder for new Teams exists and sets a flag accordingly.
    
    .PARAMETER IncludeNewTeams
        Specifies whether to include the local folder for new Teams in the check. Default is $false.
    
    .EXAMPLE
        Initialize-TeamsLocalUploadFolder -IncludeNewTeams $true
    
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    param (
        [Parameter(Mandatory = $false)] [boolean]$IncludeNewTeams
    )

    $TeamsBackgroundBasePath = $env:APPDATA + "\Microsoft\Teams\Backgrounds\"
    $TeamsBackgroundUploadPath = $TeamsBackgroundBasePath + "\Uploads\"

    If (!(Test-Path $TeamsBackgroundUploadPath)) {
        $Message = "Initialize-TeamsLocalUploadFolder  @ " + (Get-Date) + ": Local AppData\Microsoft\Teams\Backgrounds\ folder does not exist. Trying to create it..."
        Log-Event -message $Message
        try {
            New-Item -ItemType Directory -Path $TeamsBackgroundBasePath -Name "Uploads"
            $Message = "Initialize-TeamsLocalUploadFolder  @ " + (Get-Date) + ": Successfully created Uploads folder in AppData\Microsoft\Teams\Backgrounds\."
            Log-Event -message $Message

            $teamsLocalUploadFolderExists = $true
        }
        catch {
            $Message = "Initialize-TeamsLocalUploadFolder @ " + (Get-Date) + ": ERROR trying to create local Upload Folder: " + $_.Exception.Message
            Log-Event -message $message
            $teamsLocalUploadFolderExists = $false
        }
    }
    else {
        $teamsLocalUploadFolderExists = $true 
    }
    if ($IncludeNewTeams -eq $true) {
        $NewTeamsBackgroundBasePath = $env:LOCALAPPDATA + "\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\"
        $NewTeamsBackgroundUploadPath = $NewTeamsBackgroundBasePath + "\Uploads\"
        If (!(Test-Path $NewTeamsBackgroundUploadPath)) {
            $Message = "Initialize-TeamsLocalUploadFolder  @ " + (Get-Date) + ": Local folder for new Teams does not exist. Indicates New Teams is not present on this system."
            Log-Event -message $Message
            $NewTeamsLocalUploadFolderExists = $false
        }
        else {
            $NewTeamsLocalUploadFolderExists = $true
        }
    }
    return $NewTeamsLocalUploadFolderExists
}
