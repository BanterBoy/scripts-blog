$FolderPath = Get-ChildItem -Directory -Path "E:\Desktops" -Recurse -Force

$Output = @()

ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
        $Properties = [ordered]@{'Folder Name' = $Folder.FullName; 'Group/User' = $Access.IdentityReference; 'Permissions' = $Access.FileSystemRights; 'Inherited' = $Access.IsInherited }
        $Output += New-Object -TypeName PSObject -Property $Properties            
    }
}

$Output | ConvertTo-Csv -Delimiter ',' -NoTypeInformation | Out-File C:\Temp\Desktops.csv
