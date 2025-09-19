function Get-UsersTeamsFolders {
    <#
    .SYNOPSIS
        Gets the Teams folders for all users on the local machine.
    
    .DESCRIPTION
        This function retrieves the Teams folders for all users on the local machine. It returns an array of objects that contains the user name, Teams folder path, Teams upload folder path, new Teams folder path, and new Teams upload folder path.
    
    .EXAMPLE
        PS C:\> Get-UsersTeamsFolders
    
        User      : User1
        TeamsFolder : C:\Users\User1\AppData\Roaming\Microsoft\Teams\Backgrounds\
        TeamsUploadFolder : C:\Users\User1\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads\
        NewTeamsFolder : C:\Users\User1\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\
        NewTeamsUploadFolder : C:\Users\User1\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads\
    
        User      : User2
        TeamsFolder : C:\Users\User2\AppData\Roaming\Microsoft\Teams\Backgrounds\
        TeamsUploadFolder : C:\Users\User2\AppData\Roaming\Microsoft\Teams\Backgrounds\Uploads\
        NewTeamsFolder : C:\Users\User2\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\
        NewTeamsUploadFolder : C:\Users\User2\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads\
    
    .INPUTS
        None
    
    .OUTPUTS
        Array of objects that contains the user name, Teams folder path, Teams upload folder path, new Teams folder path, and new Teams upload folder path.
    
    .NOTES
        Author: Your Name
        Date:   Today's date
    #>
    $SystemAccounts = @("Administrator", "Default", "Public", "All Users", "Default User", "LocalService", "NetworkService", "rdgservice", "ADAxes_SVC", ".admin")
    $Users = Get-ChildItem 'C:\Users\' | Where-Object { ( $_.PSIsContainer -and $SystemAccounts -notcontains $_.Name ) }
    # remove users that are in the format *.admin
    $Users = $Users | Where-Object { $_.Name -notmatch '\.admin$' }
    $UsersTeamsFolders = @()
    foreach ($User in $Users) {
        $TeamsFolder = $User.FullName + "\AppData\Roaming\Microsoft\Teams\Backgrounds\"
        $TeamsUploadFolder = $TeamsFolder + "Uploads\"
        $NewTeamsFolder = $User.FullName + "\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\"
        $NewTeamsUploadFolder = $NewTeamsFolder + "Uploads\"
        $UsersTeamsFolders += [pscustomobject]@{
            User                 = $User.Name
            TeamsFolder          = $TeamsFolder
            TeamsUploadFolder    = $TeamsUploadFolder
            NewTeamsFolder       = $NewTeamsFolder
            NewTeamsUploadFolder = $NewTeamsUploadFolder
        }
    }
    return $UsersTeamsFolders
}