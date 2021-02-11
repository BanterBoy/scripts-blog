# Connect to Microsoft Teams
 
Connect-MicrosoftTeams
 
# List all Teams and all Channels
 
$ErrorAction = "SilentlyContinue"
 
$allteams = Get-Team | Where-Object { $_.DisplayName -eq 'IT' }
$object = @()
 
foreach ($t in $allteams) {
 
    $members = Get-TeamUser -GroupId $t.GroupId
 
    $owner = Get-TeamUser -GroupId $t.GroupId -Role Owner
 
    $channels = Get-TeamChannel -GroupId $t.GroupId 
 
    $object += New-Object -TypeName PSObject -Property ([ordered]@{
 
            'Team'     = $t.DisplayName
            'GroupId'  = $t.GroupId
            'Owner'    = $owner.User
            'Members'  = $members.user -join "`r`n"
            'Channels' = $channels.displayname -join "`r`n"
     
        })
         
}
Write-Output $object
