# Report on Affected Accounts
$StatusLog = @()
Get-ADUser -Filter 'useraccountcontrol -band 32' -Properties "passwordnotrequired", "useraccountcontrol", "msDS-LastSuccessfulInteractiveLogonTime", "lastLogonTimestamp" |
Select-Object -Property DistinguishedName, Enabled, PasswordNotRequired, "msDS-LastSuccessfulInteractiveLogonTime", "lastLogonTimestamp" |
Out-GridView -Wait

# Attempt to remediate and log output
$Response = Read-Host "`nDo you want to attempt to remove PASSWD_NOTREQD from the listed accounts?"
If ($Response.ToLower() -eq "y") {
	ForEach ($Account in (Get-ADUser -Filter 'useraccountcontrol -band 32')) {
		$Status = "" | Select-Object Status, Account
		$Status.Account = $Account
		Get-ADUser $Account | Set-ADUser -PasswordNotRequired $False -ErrorAction SilentlyContinue
		If ($?) {
			Write-Host "Succesfully removed PASSWD_NOTREQD from $Account" -ForeGroundColor Green
			$Status.Status = "Success"
		}
		Else {
			Write-Host "Failed to remove PASSWD_NOTREQD from $Account" -ForeGroundColor Red
			$Status.Status = "Failure"
		}
		$StatusLog += $Status
	}
}
Write-Host $StatusLog.Count "accounts processed. Refer to FIX_PASSWD_NOTREQD.csv for full details"
$StatusLog | Export-CSV -NoTypeInformation C:\GitRepos\FIX_PASSWD_NOTREQD.csv

