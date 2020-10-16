foreach ($DisabledUser in $DisabledUsers) {
    try {
        Move-ADObject -Identity $DisabledUser.DistinguishedName -TargetPath "OU=Disabled Accounts,OU=Example,DC=Example,DC=local" -WhatIf
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        Write-Warning "Move-ADObject : Directory object not found $DisabledUser.Name" -OutVariable $Global:MoveErrors
    }
    Out-File -InputObject $MoveErrors -FilePath "C:\RemovedUsers\Move-DisabledUsersError.txt" -Append
}
