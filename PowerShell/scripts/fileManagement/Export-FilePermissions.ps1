$OutFile = "C:\temp\FilePermissions.csv" # Insert folder path where you want to save your file and its name

$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"

$FileExist = Test-Path $OutFile 

If ($FileExist -eq $True) { Remove-Item $OutFile } 

Add-Content -Value $Header -Path $OutFile 

$RootPath = "E:\Data\Accounts" # Insert your share path

$Folders = Get-ChildItem $RootPath -recurse | Where-Object { $_.psiscontainer -eq $true }
    foreach($Folder in $Folders) {
        $ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access }
    foreach ($ACL in $ACLs) {
        $OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
        Add-Content -Value $OutInfo -Path $OutFile 
    }
}
