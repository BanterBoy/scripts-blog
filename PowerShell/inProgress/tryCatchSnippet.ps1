try {
    $UserPath = "C:\Users\$Name\AppData\Roaming\Microsoft\Teams\*"
    $Files = Get-ChildItem -Path "$UserPath" -Directory  -ErrorAction Stop |
    Where-Object Name -in ('application cache', 'blob storage', 'databases', 'GPUcache', 'IndexedDB', 'Local Storage', 'tmp')
}
catch [Microsoft.PowerShell.Commands.WriteErrorException] {
    Write-Error -Message "Teams Cache is already cleared"
    continue
}
catch [Microsoft.PowerShell.Commands.GetChildItemCommand] {
    Write-Error -Message "$_.Name does not exist"
    continue
}
catch {
    Write-Error -Message "Unable to complete this action. Check ComputerName/Username/Permissions."
    continue
}
