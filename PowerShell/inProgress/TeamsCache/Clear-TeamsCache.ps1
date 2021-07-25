Function Clear-TeamsCache {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param(
        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = ""
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Some")]
        [string]$ComputerName,

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = ""
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("Some")]
        [string]$Something
    )

    $env:UserName
    $env:UserDomain

    BEGIN {
        # Create a small guid type value to help avoid folder re-naming clashes
        $Guid = (New-Guid).Guid.Split('-')[4]

        # Populate $Date variable to suit either UK or US format
        If ((Get-Culture).LCID -eq "1033") {
            $Date = (Get-Date).tostring("MM_dd_yy")
        }
        Else {
            $Date = (Get-Date).tostring("dd_MM_yy")
        }
        # Build the unique name for the folder re-naming
        $NewFolderName = "Teams.Old_$($Date)_$($Guid)"

        # Capture logged on user's username
        $LoggedOnUser = (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName).UserName.Split('\')[1]

        # Construct the logged on user's equivelant to $Home variable
        $LoggedOnUserHome = "$($Home.Split($($LoggedOnUser))[0])$($LoggedOnUser)"

        # Get MS Teams process. Only using 'SilentlyContinue' as we test this below
        $TeamsProcess = Get-Process Teams -ErrorAction SilentlyContinue

        # Get Outlook process. Only using 'SilentlyContinue' as we test this below
        $OutlookProcess = Get-Process Outlook -ErrorAction SilentlyContinue

        # Get Teams Folder
        $TeamsFolder = Get-Item "$LoggedOnUserHome\AppData\Roaming\Microsoft\Teams" -ErrorAction SilentlyContinue
    }

    PROCESS {

        If ($TeamsProcess) {
            try {
                # If 'Teams' process is running, stop it else do nothing
                $TeamsProcess | Stop-Process -Force
                Write-Output "MS Teams process was running, so we stopped it"
            }
            catch {
                Write-Warning "MS Teams process was not running, so we ignored it"
            }
        }

        If ($OutlookProcess) {
            try {
                # If 'Outlook' process is running, stop it else do nothing
                $OutlookProcess | Stop-Process -Force
                Write-Output "Outlook process was running, so we stopped it"
            }
            catch {
                Write-Output "Outlook process was not running, so we ignored it"
            }
        }
        # Give the processes a little time to completely stop to avoid error
        Start-Sleep -Seconds 10

        If ($TeamsFolder) {
            # If 'Teams' folder exists in %APPDATA%\Microsoft\Teams, rename it
            Rename-Item "$LoggedOnUserHome\AppData\Roaming\Microsoft\Teams" "$LoggedOnUserHome\AppData\Roaming\Microsoft\$NewFolderName"
            Write-Output "Great news, 'Teams' folder has been renamed to '$NewFolderName'"
        }
        Else {
            # If 'Teams' folder does not exist notify user then break
            Write-Output "There is no folder called 'Teams'. Open MS Teams, it will create one then try again"
            break
        }

        # Give the folder a couple of seconds to fully rename to avoide error
        Start-Sleep -Seconds 2

        # Restart MS Teams desktop client
        If ($TeamsProcess) { 
            Start-Process -File "$LoggedOnUserHome\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList '--processStart "Teams.exe"'
            Write-Output "MS Teams was initially running, so we restarted it"
        }
        Else {
            Write-Output "MS Teams wasn't running initially, so no need to restart"
        }
    
        # Restart Outlook
        If ($OutlookProcess) {
            $OutlookExe = Get-ChildItem -Path 'C:\Program Files\Microsoft Office\root\Office16' -Filter Outlook.exe -Recurse -ErrorAction SilentlyContinue -Force | 
            Where-Object { $_.Directory -notlike "*Updates*" } | 
            Select-Object Name, Directory

            If (!$OutlookExe) {
                $OutlookExe = Get-ChildItem -Path 'C:\Program Files (x86)\Microsoft Office\root\Office16' -Filter Outlook.exe -Recurse -ErrorAction SilentlyContinue -Force | 
                Where-Object { $_.Directory -notlike "*Updates*" } | 
                Select-Object Name, Directory
            }
            Write-Output "Outlook was initially running, so we restarted it"
        }
        Else {
            Write-Output "Outlook wasn't running initially, so no need to restart"
        }
    }

    END {
        # Check for newly renamed folder
        $NewlyRenamedFolder = Get-Item "$LoggedOnUserHome\AppData\Roaming\Microsoft\$NewFolderName" -ErrorAction SilentlyContinue

        If ($NewlyRenamedFolder) { 
            # If newly renamed folder exists, output success message
            Write-Output "Congratulations, you have successfully recreated the MS Teams profile for user: $($LoggedOnUser)" -ForegroundColor White
        }
        Else {
            # If there is no newly renamed folder, output failure message
            Write-Output "Uht oht, there was an issue re-profiling MS Teams for user: $($LoggedOnUser)"
        }
        # Optional - clean up some variables etc ...
        Remove-Variable TeamsProcess
        Remove-Variable OutlookProcess
        Remove-Variable TeamsFolder
    }

}

Clear-TeamsCache