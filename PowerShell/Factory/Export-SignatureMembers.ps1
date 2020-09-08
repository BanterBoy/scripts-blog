$groups = Get-ADGroup -Filter { Name -like "signature*" }

foreach($group in $groups){

Write-Host "Users in Group "$group.SamAccountName""
Get-ADGroupMember $group.SamAccountName | Format-Table -Property Name,SamAccountName -AutoSize

}
