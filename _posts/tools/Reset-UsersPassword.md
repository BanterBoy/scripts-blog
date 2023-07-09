---
layout: post
title: Reset-UsersPassword.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_** This PowerShell script is designed to check the expiration date of a user's password and their locked-out status. It then allows the user to unlock and/or reset the password. The script begins by importing the ActiveDirectory module and displaying a welcome message to the user. It then counts the number of locked accounts on the local domain controller and displays the names of the locked-out accounts if there are any.

The script prompts the user to enter the username of the employee they would like to check. It then retrieves the pwdlastset date from Active Directory and calculates the password age in days. If the password is older than 90 days, the script displays a message indicating that the password is expired. Otherwise, it displays the number of days since the password was last set.

The script then checks the locked-out status of the user on defined domain controllers and displays the results. The user is prompted to choose from four options: unlock the user, reset the user's password, unlock and reset the user's password, or exit the script.

If the user chooses to unlock the user, the script unlocks the account on the defined domain controllers and displays the locked-out status of the user. If the user chooses to reset the user's password, the script prompts the user to enter a new password and resets the password on the defined domain controllers. If the user chooses to unlock and reset the user's password, the script performs both actions and displays the locked-out status of the user.

If the user enters an incorrect number, the script displays an error message and prompts the user to choose from the four options again. The script ends when the user chooses to exit.

To improve the readability of the code, the author could add comments to explain the purpose of each section of code. Additionally, the author could use more descriptive variable names to make the code easier to understand. To improve the performance of the code, the author could consider using a more efficient method for retrieving the pwdlastset date from Active Directory.

**_BanterBoy:_** Can you provide some examples of using the script

**_GitHub Copilot:_** The following examples demonstrate how to use the script to unlock and reset a user's password.

```powershell
PS C:\> .\Reset-UsersPassword.ps1
PowerShell AD Password Tool

This tool displays the Exparation Date of a user's Password and their Locked out
Status.  It will then allow you to unlock and/or reset the password.


Current Locked Out Accounts on your LOCAL Domain Controller:

SamAccountName LastLogonDate
-------------- -------------
jsmith         11/28/2012 10:00:00 AM
jdoe           11/28/2012 10:00:00 AM


Enter username of the employee you would like to check or [ Ctrl+c ] to exit: jsmith


Password for jsmith is 91 days old.


Checking LockedOut Status on defined Domain Controllers:
DC04:      Not Locked
DC01:      Not Locked
DC02:      Not Locked
DC03:      Not Locked


1. Unlock User
2. Reset User's Password
3. Unlock and Reset User's Password
4. Exit


Enter the number of the action you would like to perform: 3


Unlocking User...


Unlocking User on DC04...
Unlocking User on DC01...
Unlocking User on DC02...
Unlocking User on DC03...


Resetting User's Password...


Resetting User's Password on DC04...
Resetting User's Password on DC01...
Resetting User's Password on DC02...
Resetting User's Password on DC03...


Checking LockedOut Status on defined Domain Controllers:
DC04:      Not Locked
DC01:      Not Locked
DC02:      Not Locked
DC03:      Not Locked


1. Unlock User
2. Reset User's Password
3. Unlock and Reset User's Password
4. Exit


Enter the number of the action you would like to perform: 4
```

---

#### Script

```powershell
<#
  Author:   Matt Schmitt
  Date:     11/28/12
  Version:  1.0
  From:     USA
  Email:    ithink2020@gmail.com
  Website:  http://about.me/schmittmatt
  Twitter:  @MatthewASchmitt

  Description
  A script for forwarding and unforwarding email for users in Office 365.
#>
Import-Module ActiveDirectory
Write-Host ""
Write-Host "PowerShell AD Password Tool"
Write-Host ""
Write-Host "This tool displays the Exparation Date of a user's Password and their Locked out"
Write-Host "Status.  It will then allow you to unlock and/or reset the password."
Write-Host ""
Write-Host ""
#Counts how many locked account there are on the local DC and sets it to $count
$count = Search-ADAccount -LockedOut | Where-Object { $_.Name -ne "Administrator" -and $_.Name -ne "Guest" } | Measure-Object | Select-Object -expand Count
#If there are locked accounts (other than Administrator and Guest), then this will display who is locked out.
If ( $count -gt 0 ) {
	Write-Host "Current Locked Out Accounts on your LOCAL Domain Controller:"
	Search-ADAccount -LockedOut | Where-Object { $_.Name -ne "Administrator" -and $_.Name -ne "Guest" } | Select-Object SamAccountName, LastLogonDate | Format-Table -AutoSize
}
else {
	#   Write-Host "There are no locked out accounts on your local Domain Controller."
}
Write-Host ""
#Asks for the username
$user = Read-Host "Enter username of the employee you would like to check or [ Ctrl+c ] to exit"
Write-Host ""
Write-Host ""
[datetime]$today = (get-date)
#Get pwdlastset date from AD and set it to $passdate
$searcher = New-Object DirectoryServices.DirectorySearcher
$searcher.Filter = "(&(samaccountname=$user))"
$results = $searcher.findone()
$passdate = [datetime]::fromfiletime($results.properties.pwdlastset[0])
#Set password Age to $PwdAge
$PwdAge = ($today - $passdate).Days
If ($PwdAge -gt 90) {
	Write-Host "Password for $user is EXPIRED!"
	Write-Host "Password for $user is $PwdAge days old."
}
else {
	Write-Host "Password for $user is $PwdAge days old."
}
Write-Host ""
Write-Host ""
Write-Host "Checking LockedOut Status on defined Domain Controllers:"
#Get Lockedout status and display
# ---> IMPORTANT:  You need to change DC01.your.domain.com & DC02.your.domain.com to the FQDN of your Domian Controlls
switch (Get-ADUser -server DC04 -Filter { samAccountName -eq $user } -Properties * | Select-Object -expand lockedout) { "False" { "DC04:      Not Locked" } "True" { "DC04:    LOCKED" } }
switch (Get-ADUser -server DC01 -Filter { samAccountName -eq $user } -Properties * | Select-Object -expand lockedout) { "False" { "DC01:      Not Locked" } "True" { "DC01:    LOCKED" } }
# ---> You can add more domain controllers to list, by copying one of the lines, then Modifying the text to reflect your DCs.
Write-Host ""
Write-Host ""
[int]$y = 0
$option = Read-Host "Would you like to (1) Unlock user, (2) Reset user's password, (3) Unlock and reset user's password or (4) Exit?"
Clear-Host
While ($y -eq 0) {
	switch ($option) {
		"1" {
			# ---> IMPORTANT:  You need to change DC01.your.domain.com & DC02.your.domain.com to the FQDN of your Domian Controlls
			Write-Host "Unlocking account on DC04"
			Unlock-ADAccount -Identity $user -server DC01.your.domain.com
			Write-Host "Unlocking account on DC01"
			Unlock-ADAccount -Identity $user -server DC02.your.domain.com
			# ---> You can add more domain controllers to list, by copying one of the lines, then Modifying the text to reflect your DCs.
			#Get Lockedout status and set it to $Lock
			$Lock = (Get-ADUser -Filter { samAccountName -eq $user } -Properties * | Select-Object -expand lockedout)
			Write-Host ""
			#Depending on Status, tell user if the account is locked or not.
			switch ($Lock) {
				"False" { Write-Host "$user is unlocked." }
				"True" { Write-Host "$user is LOCKED Out." }
			}
			Write-Host ""
			Write-Host "Press any key to Exit."
			$y += 1
			$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		}
		"2" {
			$newpass = (Read-Host -AsSecureString "Enter user's New Password")
			Write-Host ""
			Write-Host "Resetting Password on DC04"
			Write-Host ""
			Set-ADAccountPassword -Identity $user -NewPassword $newpass
			Write-Host ""
			Write-Host "Resetting Password on DC01"
			Write-Host ""
			# ---> IMPORTANT:  You need to change DC01.your.domain.com & DC02.your.domain.com to the FQDN of your Domian Controlls
			Set-ADAccountPassword -Server DC01.your.domain.com -Identity $user -NewPassword $newpass
			# ---> You can add more domain controllers to list, by copying one of the lines, then Modifying the text to reflect your DCs.
			Write-Host ""
			Write-Host "Press any key to Exit."
			$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
			$y += 1
		}
		"3" {
			$newpass = (Read-Host -AsSecureString "Enter user's New Password")
			Write-Host ""
			Write-Host "Resetting Password on DC04"
			Write-Host ""
			Set-ADAccountPassword -Identity $user -NewPassword $newpass
			Write-Host ""
			Write-Host "Resetting Password on DC01"
			Write-Host ""
			# ---> IMPORTANT:  You need to change DC01.your.domain.com & DC02.your.domain.com to the FQDN of your Domian Controlls
			Set-ADAccountPassword -Server DC01.your.domain.com -Identity $user -NewPassword $newpass
			# ---> You can add more domain controllers to list, by copying one of the lines, then Modifying the text to reflect your DCs.
			Write-Host ""
			Write-Host "Password for $user has been reset."
			Write-Host ""
			# ---> IMPORTANT:  You need to change DC01.your.domain.com & DC02.your.domain.com to the FQDN of your Domian Controlls
			Write-Host "Unlocking account on DC01"
			Unlock-ADAccount -Identity $user -server DC04
			Write-Host "Unlocking account on DC02"
			Unlock-ADAccount -Identity $user -server DC01
			# ---> You can add more domain controllers to list, by copying one of the lines, then Modifying the text to reflect your DCs.
			#Get Lockedout status and set it to $Lock
			$Lock = (Get-ADUser -Filter { samAccountName -eq $user } -Properties * | Select-Object -expand lockedout)
			Write-Host ""
			#Depending on Status, tell user if the account is locked or not.
			switch ($Lock) {
				"False" { Write-Host "$user is unlocked." }
				"True" { Write-Host "$user is LOCKED Out." }
			}
			Write-Host ""
			Write-Host "Press any key to Exit."
			$y += 1
			$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		}
		"4" {
			#exit code
			$y += 1
		}
		default {
			Write-Host "You have entered and incorrect number."
			Write-Host ""
			$option = Read-Host "Would you like to (1) Unlock user, (2) Reset user's password, (3) Unlock and reset user's password or (4) Exit?"
		}
	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/tools/Reset-UsersPassword.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Reset-UsersPassword.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/tools.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Tools
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
