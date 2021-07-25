# Connect to Microsoft Teams
 
Connect-MicrosoftTeams
 
# List all Teams and all Channels
 
$ErrorAction = "SilentlyContinue"
 
$allteams = Get-Team | Where-Object { $_.DisplayName -eq 'IT' }
$object = @()
 
foreach ($team in $allteams) {
 
    $members = Get-TeamUser -GroupId $team.GroupId
 
    $owner = Get-TeamUser -GroupId $team.GroupId -Role Owner
 
    $channels = Get-TeamChannel -GroupId $team.GroupId 
 
    $object += New-Object -TypeName PSObject -Property ([ordered]@{
 
            'Team'     = $team.DisplayName
            'GroupId'  = $team.GroupId
            'Owner'    = $owner.User
            'Members'  = $members.user -join "`r`n"
            'Channels' = $channels.displayname -join "`r`n"
     
        })
         
}
Write-Output $object
