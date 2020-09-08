#This should point to the root of a home folder/FR share. Subfolders in this folder match AD account usernames. 
$Folders = get-childitem \\SERVER\SHARE\FOLDER\
 
$NamesToIgnore = "Username"
 
 
$FoldersToBeRemoved = @()
foreach ($Folder in $Folders) {
    $Username = $Folder.Name
 
    if ($NamesToIgnore -notcontains $Username) {
 
        $UsernameCheck = Get-ADUser -Identity $Username  -Properties * -ErrorAction SilentlyContinue
        if ($? -eq $false -and $Username -notlike $NamesToIgnore) {
            
            $FoldersInformation = @{"Folder Name" = $Username; "Folder Path" = $Folder.FullName; "Last Write Time" = $Folder.LastWriteTime}
            $FoldersToBeRemoved += New-Object -TypeName psobject -Property $FoldersInformation
            
 
            Write-Host $Username
            pause
            Remove-Item $Folder.FullName -Recurse -Force -Verbose -WhatIf
        }
    }
}
 
$FoldersToBeRemoved | Out-GridView