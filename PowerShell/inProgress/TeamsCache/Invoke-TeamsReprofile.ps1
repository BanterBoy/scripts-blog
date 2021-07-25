Function Invoke-TeamsReprofile {

    <#
    .SYNOPSIS
    Invoke-TeamsReprofile is a simple function that will re-profile the MS Teams
    user profile for the Teams desktop client on a windows 10 pc.

    .DESCRIPTION
    This Function will test for MS Teams & MS Outlook running then will close them
    both in advance of re-naming the 'Teams' folder in %APPDATA%. Once the re-naming,
    or re-profiling has occurred it will restart MS Teams & MS Outlook if they were
    previously running

    .EXAMPLE
    PS C:\> Invoke-TeamsReprofile

    .NOTES

    Author:  AlanPs1
    Website: http://AlanPs1.io
    Twitter: @AlanO365

    #>

    [OutputType()]
    [CmdletBinding()]
    Param()

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
    
            # If 'Teams' process is running, stop it else do nothing
            $TeamsProcess | Stop-Process -Force
            Write-Host "MS Teams process was running, so we stopped it" -ForegroundColor Green

        }
        Else {

            Write-Host "MS Teams process was not running, so we ignored it" -ForegroundColor Yellow

        }

        If ($OutlookProcess) {
    
            # If 'Outlook' process is running, stop it else do nothing
            $OutlookProcess | Stop-Process -Force
            Write-Host "Outlook process was running, so we stopped it" -ForegroundColor Green

        }
        Else {

            Write-Host "Outlook process was not running, so we ignored it" -ForegroundColor Yellow

        }

        # Give the processes a little time to completely stop to avoid error
        Start-Sleep -Seconds 10

        If ($TeamsFolder) {
    
            # If 'Teams' folder exists in %APPDATA%\Microsoft\Teams, rename it
            Rename-Item "$LoggedOnUserHome\AppData\Roaming\Microsoft\Teams" "$LoggedOnUserHome\AppData\Roaming\Microsoft\$NewFolderName"
            Write-Host "Great news, 'Teams' folder has been renamed to '$NewFolderName'" -ForegroundColor Cyan
        }
        Else {

            # If 'Teams' folder does not exist notify user then break
            Write-Host "There is no folder called 'Teams'. Open MS Teams, it will create one then try again" -ForegroundColor Red
            break
        }

        # Give the folder a couple of seconds to fully rename to avoide error
        Start-Sleep -Seconds 2

        # Restart MS Teams desktop client
        If ($TeamsProcess) { 

            Start-Process -File "$LoggedOnUserHome\AppData\Local\Microsoft\Teams\Update.exe" -ArgumentList '--processStart "Teams.exe"'
            Write-Host "MS Teams was initially running, so we restarted it" -ForegroundColor Green
        }
        Else {

            Write-Host "MS Teams wasn't running initially, so no need to restart" -ForegroundColor Yellow

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

            Write-Host "Outlook was initially running, so we restarted it" -ForegroundColor Green

        }
        Else {

            Write-Host "Outlook wasn't running initially, so no need to restart" -ForegroundColor Yellow

        }

    }

    END {

        # Check for newly renamed folder
        $NewlyRenamedFolder = Get-Item "$LoggedOnUserHome\AppData\Roaming\Microsoft\$NewFolderName" -ErrorAction SilentlyContinue

        If ($NewlyRenamedFolder) { 

            # If newly renamed folder exists, output success message
            Write-Host
            Write-Host "Congratulations, you have successfully recreated the MS Teams profile for user: $($LoggedOnUser)" -ForegroundColor White
            Write-Host

        }
        Else {

            # If there is no newly renamed folder, output failure message
            Write-Host
            Write-Host "Uht oht, there was an issue re-profiling MS Teams for user: $($LoggedOnUser)" -ForegroundColor Red
            Write-Host

        }

        # Optional - clean up some variables etc ...
        Remove-Variable TeamsProcess
        Remove-Variable OutlookProcess
        Remove-Variable TeamsFolder

    }

}

Invoke-TeamsReprofile