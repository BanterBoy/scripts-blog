$Folder = "$HOME\desktop\testing"
$User = Read-Host "Input the sAMAccountName of user"
$permission = (Get-Acl $Folder).Access | Where-Object { $_.IdentityReference -match $User } | Select-Object IdentityReference, FileSystemRights
If ($permission) {
    $permission | ForEach-Object { Write-Host "User $($_.IdentityReference) has '$($_.FileSystemRights)' rights on folder $folder" }
}
Else {
    Write-Host "$User Doesn't have any permission on $Folder"
}
