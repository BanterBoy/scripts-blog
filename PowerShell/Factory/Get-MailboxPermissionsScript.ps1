function Select-FolderLocation {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $true
    $browse.Description = "Select a directory for your report"

    $loop = $true
    while ($loop) {
        if ($browse.ShowDialog() -eq "OK") {
            $loop = $false
        }
        else {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if ($res -eq "Cancel") {
                #Ends script
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}


$directoryPath = Select-FolderLocation
if (![string]::IsNullOrEmpty($directoryPath)) {
    Write-Host "You selected the directory: $directoryPath"
}
else {
    "You did not select a directory."
}

Get-Mailbox |
Get-MailboxPermission |
Where-Object {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false} |
Select-Object Identity,User,@{Name='Access Rights';Expression={[string]::join(', ', $_.AccessRights)}} |
Export-Csv -NoTypeInformation $directoryPath\mailboxpermissions.csv
