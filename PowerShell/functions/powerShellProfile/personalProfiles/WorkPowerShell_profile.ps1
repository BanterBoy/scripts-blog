<#
	Script Name		: WorkPowerShell_profile.ps1
	Author			: Luke Leigh
#>

# Function		Restart-Profile
function global:Restart-Profile {
	@(
		$Profile.AllUsersAllHosts,
		$Profile.AllUsersCurrentHost,
		$Profile.CurrentUserAllHosts,
		$Profile.CurrentUserCurrentHost
	) |
	ForEach-Object {
		if (Test-Path $_) {
			Write-Verbose "Running $_"
			. $_
		}
	}
}


# Function		New-O365Session
function global:New-O365Session {
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential (Get-Credential) -Authentication Basic -AllowRedirection
	Import-PSSession $Session
}


# Function		Remove-O365Session
function global:Remove-O365Session {
	Get-PSSession | Remove-PSSession
}


# Function		Get-GoogleSearch
function global:Get-GoogleSearch {
	Start-Process "https://www.google.co.uk/search?q=$args"
}

# Function		Get-GoogleDirections
function global:Get-GoogleDirections {
	param([string] $From, [String] $To)

	process {
		Start-Process "https://www.google.com/maps/dir/$From/$To/"
	}
}


# Function		Get-DuckDuckGoSearch
function global:Get-DuckDuckGoSearch {
	Start-Process "https://duckduckgo.com/?q=$args"
}


# Function		Test-IsAdmin
function global:Test-IsAdmin {
	<#
	.Synopsis
	Tests if the user is an administrator
	.Description
	Returns true if a user is an administrator, false if the user is not an administrator
	.Example
	Test-IsAdmin
	#>
	$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal = New-Object Security.Principal.WindowsPrincipal $identity
	$principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}


# Function		Format-Console
function global:Format-Console {
	param (
		[int]$WindowHeight,
		[int]$WindowWidth,
		[int]$BufferHeight,
		[int]$BufferWidth
	)
	[System.Console]::SetWindowSize($WindowWidth, $WindowHeight)
	[System.Console]::SetBufferSize($BufferWidth, $BufferHeight)
}


# Function		Show-IsAdminOrNot
function global:Show-IsAdminOrNot {
	$IsAdmin = Test-IsAdmin
	if ( $IsAdmin -eq "False") {
		Write-Warning -Message "Admin Privileges!"
	}
	else {
		Write-Warning -Message "User Privileges"
	}
}


# Function		New-Greeting
function global:New-Greeting {
	$Today = $(Get-Date)
	Write-Host "   Day of Week  -"$Today.DayOfWeek " - Today's Date -"$Today.ToShortDateString() "- Current Time -"$Today.ToShortTimeString()
	Switch ($Today.dayofweek) {
		Monday { Write-host "   Don't want to work today" }
		Friday { Write-host "   Almost the weekend" }
		Saturday { Write-host "   Everyone loves a Saturday ;-)" }
		Sunday { Write-host "   A good day to rest, or so I hear." }
		Default { Write-host "   Business as usual." }
	}
}


# Function		Set-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force


#--------------------
# Display running as Administrator in WindowTitle

$whoami = whoami /Groups /FO CSV | ConvertFrom-Csv -Delimiter ','
$MSAccount = $whoami."Group Name" | Where-Object { $_ -like 'MicrosoftAccount*' }
$LocalAccount = $whoami."Group Name" | Where-Object { $_ -like 'Local' }
if ((Test-IsAdmin) -eq $true) {
	if (($MSAccount)) {
		$host.UI.RawUI.WindowTitle = "$($MSAccount.Split('\')[1]) - Admin Privileges"
	}
	else {
		$host.UI.RawUI.WindowTitle = "$($LocalAccount) - Admin Privileges"
	}
}	
else {
	if (($LocalAccount)) {
		$host.UI.RawUI.WindowTitle = "$($MSAccount.Split('\')[1]) - User Privileges"
	}
	else {
		$host.UI.RawUI.WindowTitle = "$($LocalAccount) - User Privileges"
	}
}	


#--------------------
# Configure PowerShell Console Window Size/Preferences
Format-Console -WindowHeight 45 -WindowWidth 170 -BufferHeight 9000 -BufferWidth 170


#--------------------
# Aliases
New-Alias -Name 'Notepad++' -Value 'C:\Program Files\Notepad++\notepad++.exe' -Description 'Launch Notepad++'


#--------------------
# Profile Starts here!
Show-IsAdminOrNot
Write-Host ""
New-Greeting
Write-Host ""
Set-Location -Path C:\GitRepos
