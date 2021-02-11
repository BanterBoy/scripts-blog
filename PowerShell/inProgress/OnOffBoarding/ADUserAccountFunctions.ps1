function Set-ADUserPassword {
	
    Set-ADAccountPassword -Identity $User.text -NewPassword (ConvertTo-SecureString -AsPlainText $Password.text -Force)
    [System.Windows.MessageBox]::Show('Password Changed')
}

function Test-ADUserAccountLock {
	$Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | select Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled 
	$Result
}

function Set-ADUserAccountUnLock { 
    Unlock-ADAccount -Identity $User.text
    $Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | select Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled 
    $Result
}

function Set-ADUserAccountLocked {
	if ($LockoutBadCount = ((([xml](Get-GPOReport -Name "Default Domain Policy" -ReportType Xml)).GPO.Computer.ExtensionData.Extension.Account |
		Where-Object name -eq LockoutBadCount).SettingNumber)) {
			$Password = ConvertTo-SecureString 'NotMyPassword' -AsPlainText -Force
			Get-ADUser -Identity $User.text -Properties SamAccountName, UserPrincipalName, LockedOut |
			ForEach-Object {
				for ($i = 1; $i -le $LockoutBadCount; $i++) {
				Invoke-Command -ComputerName dc01 {Get-Process
				} -Credential (New-Object System.Management.Automation.PSCredential ($($_.UserPrincipalName), $Password)) -ErrorAction SilentlyContinue
			}
			$Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | select Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled 
            $Result
		}
	}
}

function Enable-ADUserAccountLock {
    Enable-ADAccount -Identity $User.text
    $Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | select Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled 
    $Result
}


function Disable-ADUserAccountLock { 
    Disable-ADAccount -Identity $User.text
    $Result = Get-ADUser -Identity $User.text -Properties Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled | select Name, LastLogonDate, LockedOut, AccountLockOutTime, Enabled 
    $Result
}
