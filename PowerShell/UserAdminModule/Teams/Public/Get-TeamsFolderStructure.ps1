function Get-TeamsFolderStructure {
    <#
    .SYNOPSIS
        Gets the folder structure for Microsoft Teams backgrounds.
    
    .DESCRIPTION
        This function retrieves the folder structure for Microsoft Teams backgrounds. It determines whether the old or new folder structure is being used and returns the appropriate base path and upload path.
    
    .OUTPUTS
        Returns a hashtable with the following keys:
        - "Structure": Indicates whether the old or new folder structure is being used.
        - "BasePath": The base path for the Microsoft Teams backgrounds.
        - "UploadPath": The upload path for the Microsoft Teams backgrounds.
    
    .EXAMPLE
        PS C:\> Get-TeamsFolderStructure
        Returns a hashtable with the folder structure for Microsoft Teams backgrounds.
    
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    $TeamsBackgroundBasePath = $env:APPDATA + "\Microsoft\Teams\Backgrounds\"
    $TeamsBackgroundUploadPath = $TeamsBackgroundBasePath + "Uploads\"

    $NewTeamsBackgroundBasePath = $env:LOCALAPPDATA + "\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\"
    $NewTeamsBackgroundUploadPath = $NewTeamsBackgroundBasePath + "Uploads\"

    $TeamsFolderStructure = @{
        "Structure"  = "Old";
        "BasePath"   = $TeamsBackgroundBasePath;
        "UploadPath" = $TeamsBackgroundUploadPath;
    }

    if (Test-Path $NewTeamsBackgroundUploadPath) {
        $TeamsFolderStructure["Structure"] = "New"
        $TeamsFolderStructure["BasePath"] = $NewTeamsBackgroundBasePath
        $TeamsFolderStructure["UploadPath"] = $NewTeamsBackgroundUploadPath
    }

    return $TeamsFolderStructure
}
