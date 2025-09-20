function New-O365Session {
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential (Get-Credential) -Authentication Basic -AllowRedirection
    Import-PSSession $Session
}
function Remove-O365Session {
    Get-PSSession | Remove-PSSession
}

New-O365Session

$UsersMailbox = Get-Mailbox -RecipientTypeDetails UserMailbox
foreach ($item in $UsersMailbox) {
    $Permissions = Get-MailboxFolderPermission -Identity ($item.alias + ':\calendar') -User email@example.com | Select-Object Identity, User, AccessRights
    if ($Permissions.User -like 'UserName') {
        $message = ($item.DisplayName) + ' - User Exists'
        Write-Warning -Message "$message" -ErrorAction Stop
    }
    else {
        Add-MailboxFolderPermission -Identity ($user.alias + ':\calendar') -User email@example.com -AccessRights Reviewer
        $message = ($item.DisplayName) + ' - User Added'
        Write-Verbose -Message "$message" -Verbose
    }
}

Remove-O365Session

Write-Verbose -Message "Job Complete, press any key to close this Window" -Verbose

pause
