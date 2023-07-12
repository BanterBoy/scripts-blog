---
layout: post
title: HomePowerShell_profile.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
<#
	Script Name		: HomePowerShell_profile.ps1
	Author			: Luke Leigh
#>
# Function		Get-ContainedCommand
function global:Get-ContainedCommand {
	param
	(
		[Parameter(Mandatory)][string]
		$Path,

		[string][ValidateSet('FunctionDefinition', 'Command' )]
		$ItemType
	)

	$Token = $Err = $null
	$ast = [Management.Automation.Language.Parser]::ParseFile( $Path, [ref] $Token, [ref] $Err)

	$ast.FindAll( { $args[0].GetType(). Name -eq "${ItemType}Ast" }, $true )

}
# Function		New-Password
function global:New-Password {
	<# Example

	.EXAMPLE
	Save-Password -Label UserName

	.EXAMPLE
	Save-Password -Label Password

	#>
	param([Parameter(Mandatory)]
		[string]$Label)
	$securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
	$directoryPath = Select-FolderLocation
	if (![string]::IsNullOrEmpty($directoryPath)) {
		Write-Host "You selected the directory: $directoryPath"
	}
	else {
		"You did not select a directory."
	}
	$securePassword | Out-File -FilePath "$directoryPath\$Label.txt"
}
# Function		Get-Password
function global:Get-Password {
	<#
	.EXAMPLE
	$user = Get-Password -Label UserName
	$pass = Get-Password -Label password

	.OUTPUTS
	$user | Format-List

	.OUTPUTS
	Label           : UserName
	EncryptedString : domain\administrator

	.OUTPUTS
	$pass | Format-List
	Label           : password
	EncryptedString : SomeSecretPassword

	.OUTPUTS
	$user.EncryptedString
	domain\administrator

	.OUTPUTS
	$pass.EncryptedString
	SomeSecretPassword

	#>
	param([Parameter(Mandatory)]
		[string]$Label)
	$directoryPath = Select-FolderLocation
	if (![string]::IsNullOrEmpty($directoryPath)) {
		Write-Host "You selected the directory: $directoryPath"
	}
	$filePath = "$directoryPath\$Label.txt"
	if (-not (Test-Path -Path $filePath)) {
		throw "The password with Label [$($Label)] was not found!"
	}
	$password = Get-Content -Path $filePath | ConvertTo-SecureString
	$decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
	[pscustomobject]@{
		Label           = $Label
		EncryptedString = $decPassword
	}
}
# Function		Get-PatchTue
function global:Get-PatchTue {
	<#
	.SYNOPSIS
	Get the Patch Tuesday of a month
	.PARAMETER month
	The month to check
	.PARAMETER year
	The year to check
	.EXAMPLE
	Get-PatchTue -month 6 -year 2015
	.EXAMPLE
	Get-PatchTue June 2015
	#>
	param(
		[string]$month = (get-date).month,
		[string]$year = (get-date).year)
	$firstdayofmonth = [datetime] ([string]$month + "/1/" + [string]$year)
	(0..30 | ForEach-Object {
			$firstdayofmonth.adddays($_)
		} |
		Where-Object {
			$_.dayofweek -like "Tue*"
		})[1]
}
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
# Function		New-GitDrives
function global:New-GitDrives {
	$PSRootFolder = Select-FolderLocation
	$Exist = Test-Path -Path $PSRootFolder
	if (($Exist) = $true) {
		$PSDrivePaths = Get-ChildItem -Path "$PSRootFolder\"
		foreach ($item in $PSDrivePaths) {
			$paths = Test-Path -Path $item.FullName
			if (($paths) = $true) {
				New-PSDrive -Name $item.Name -PSProvider "FileSystem" -Root $item.FullName
			}
		}
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
# Function		New-ObjectToHashTable
function global:New-ObjectToHashTable {
	param([
		Parameter(Mandatory , ValueFromPipeline)]
		$object)
	process	{
		$object |
		Get-Member -MemberType *Property |
		Select-Object -ExpandProperty Name |
		Sort-Object |
		ForEach-Object { [PSCustomObject ]@{
				Item  = $_
				Value = $object. $_
			}
		}
	}
}
# Function		New-PSDrives
function global:New-PSDrives {
	$PSRootFolder = Select-FolderLocation
	$PSDrivePaths = Get-ChildItem -Path "$PSRootFolder\"
	foreach ($item in $PSDrivePaths) {
		$paths = Test-Path -Path $item.FullName
		if (($paths) = $true) {
			New-PSDrive -Name $item.Name -PSProvider "FileSystem" -Root $item.FullName
		}
	}
}
# Function		Select-FolderLocation
function global:Select-FolderLocation {
	<#
        Example.
        $directoryPath = Select-FolderLocation
        if (![string]::IsNullOrEmpty($directoryPath)) {
            Write-Host "You selected the directory: $directoryPath"
        }
        else {
            "You did not select a directory."
        }
    #>
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
# Function		Show-ProfileFunctions
function global:Show-ProfileFunctions {
	$Path = Join-Path $PSScriptRoot "/HomePowerShell_profile.ps1"
	$functionNames = Get-ContainedCommand $Path -ItemType FunctionDefinition |	Select-Object -ExpandProperty Name
	$functionNames | Sort-Object
}
# Function		Show-PSDrive
function global:Show-PSDrive {
	Get-PSDrive | Format-Table -AutoSize
}
# Function		Stop-Outlook
function global:Stop-Outlook {
	$OutlookRunning = Get-Process -ProcessName "Outlook"
	if (($OutlookRunning) = $true) {
		Stop-Process -ProcessName Outlook
	}
}
# Function		New-AdminShell
function global:New-AdminShell {
	<#
	.Synopsis
	Starts an Elevated PowerShell Console.

	.Description
	Opens a new PowerShell Console Elevated as Administrator. If the user is already running an elevated
	administrator shell, a message is displayed in the console session.

	.Example
	New-AdminShell

	#>

	$Process = Get-Process | Where-Object { $_.Id -eq "$($PID)" }
	if (Test-IsAdmin = $True) {
		Write-Warning -Message "Admin Shell already running!"
	}
	else {
		if ($Process.Name -eq "PowerShell") {
			Start-Process -FilePath "PowerShell.exe" -Verb runas -PassThru
		}
		if ($Process.Name -eq "pwsh") {
			Start-Process -FilePath "pwsh.exe" -Verb runas -PassThru
		}
	}
}
# Function		New-AdminTerminal
function global:New-AdminTerminal {
	<#
	.Synopsis
	Starts an Elevated Microsoft Terminal.

	.Description
	Opens a new Microsoft Terminal Elevated as Administrator. If the user is already running an elevated
	Microsoft Terminal, a message is displayed in the console session.

	.Example
	New-AdminShell

	#>

	if (Test-IsAdmin = $True) {
		Write-Warning -Message "Admin Shell already running!"
	}
	else {
		Start-Process "wt.exe" -ArgumentList "-p pwsh" -Verb runas -PassThru
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
# Function		Start-Blogging
function global:Start-Blogging {
	if (Test-IsAdmin = $True) {
		New-BlogServer
	}
	else {
		Write-Warning -message "Starting Admin Shell"
		Start-Process -FilePath "pwsh.exe" -Verb runas -PassThru
	}
}
# Function		New-BlogServer
function global:New-BlogServer {
	[CmdletBinding(DefaultParameterSetName = 'default')]
	param(
		[Parameter(Mandatory = $True,
			ValueFromPipeline = $True,
			HelpMessage = "Enter path or Browse to select dockerfile")]
		[ValidateSet('Select', 'Blog')]
		[string]$BlogPath,
		[string]$Path

	)
	switch ($BlogPath) {
		Select {
			try {
				$PSRootFolder = Select-FolderLocation
				New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
				Set-Location -Path BlogDrive:
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Blog {
			try {
				New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root "$Path"
				Set-Location -Path BlogDrive:
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Default {
			try {
				$PSRootFolder = Select-FolderLocation
				New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
				Set-Location -Path BlogDrive:
				docker-compose.exe up
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
	}
}
# Function		New-BlogSession
function global:New-BlogSession {
	$PSRootFolder = Select-FolderLocation
	New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
	code ($PSRootFolder) -n
}
# Function		Show-LocalBlogSite
function global:Show-LocalBlogSite {
	$ComputerDNSName = $env:COMPUTERNAME + '.' + (Get-NetIPConfiguration).NetProfile.Name
	$URL = "http://" + $ComputerDNSName + ":4000"
	Start-Process $URL
}
# Function		Get-DockerStatsSnapshot
function global:Get-DockerStatsSnapshot {
	$running = docker images -q
	if ($null -eq $running) {
		Write-Warning -Message "No Docker Containers are running"
	}
	else {
		docker container stats --no-stream
	}
}
# Function		Remove-BlogServer
function global:Remove-BlogServer {
	$title = 'Clean Blog Environment'
	$question = 'Are you sure you want to proceed?'
	$choices = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
	if ($decision -eq 0) {
		$PSRootFolder = Select-FolderLocation
		New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
		Set-Location -Path BlogDrive:
		Write-Host 'Cleaning Environment - Removing Images'
		$images = docker images -q
		foreach ($image in $images) {
			docker rmi $image -f
			docker rm $(docker ps -a -f status=exited -q)
		}
		$vendor = Test-Path $PSRootFolder\vendor
		$site = Test-Path $PSRootFolder\_site
		$gemfile = Test-Path -Path $psrootfolder\gemfile.lock
		$jekyllmetadata = Test-Path -Path $psrootfolder\.jekyll-metadata
		Write-Warning -Message 'Cleaning Environment - Removing Vendor Bundle'
		if ($vendor = $true) {
			try {
				Remove-Item -Path $PSRootFolder\vendor -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message 'Vendor Bundle removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message 'Vendor Bundle does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing _site Folder'
		if ($site = $true) {
			try {
				Remove-Item -Path $psrootfolder\_site -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message '_site folder removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message '_site folder does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing Gemfile.lock File'
		if ($gemfile = $true) {
			try {
				Remove-Item -Path $psrootfolder\gemfile.lock -Force -ErrorAction Stop
				Write-Verbose -Message 'gemfile.lock removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message 'gemfile.lock does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing .jekyll-metadata File'
		if ($jekyllmetadata = $true) {
			try {
				Remove-Item -Path $psrootfolder\.jekyll-metadata -Force -ErrorAction Stop
				Write-Verbose -Message '.jekyll-metadata removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message '.jekyll-metadata does not exist.' -Verbose

			}
			Set-Location -Path C:\GitRepos
		}
	}
	else {
		Write-Warning -Message 'Images left intact.'
	}
}
Import-Module -Name Transmission
# Function		PadOrTruncate
function global:PadOrTruncate([string]$s, [int]$length) {
	if ($s.length -le $length) {
		return $s.PadRight($length, " ")
	}

	$truncated = $s.Substring(0, ($length - 3))

	return "$truncated..."
}
# Function		Get-FriendlySize
function global:Get-FriendlySize {
	param($Bytes)
	$sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
	for ($i = 0; ($Bytes -ge 1kb) -and
		($i -lt $sizes.Count); $i++) { $Bytes /= 1kb }
	$N = 2; if ($i -eq 0) { $N = 0 }
	"{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}
# Function		Get-DownloadPercent
function global:Get-DownloadPercent([decimal]$d) {
	$p = [math]::Round($d * 100)
	return "$p%"
}
# Function		Save-PasswordFile
function global:Save-PasswordFile {
	<# Example

	.EXAMPLE
	Save-Password -Label UserName

	.EXAMPLE
	Save-Password -Label Password

	#>
	param(
		[Parameter(Mandatory = $true,
			HelpMessage = "Enter password label")]
		[string]$Label,

		[Parameter(Mandatory = $false,
			HelpMessage = "Enter file path.")]
		[ValidateSet('Profile', 'Select') ]
		[string]$Path
	)

	switch ($Path) {
		Profile {
			$ProfilePath = ($PROFILE).Split('\Microsoft.PowerShell_profile.ps1')[0]
			$filePath = "$ProfilePath" + "\$Label.txt"
			$securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
			$securePassword | Out-File -FilePath "$filePath"
		}
		Select {
			$directoryPath = Select-FolderLocation
			$securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
			$securePassword | Out-File -FilePath "$directoryPath\$Label.txt"

		}
		Default {
			$ProfilePath = ($PROFILE).Split('\Microsoft.PowerShell_profile.ps1')[0]
			$filePath = "$ProfilePath" + "\$Label.txt"
			$securePassword = Read-host -Prompt 'Input password' -AsSecureString | ConvertFrom-SecureString
			$securePassword | Out-File -FilePath "$filePath"
		}
	}
}
# Function		Connect-Transmission
function global:Connect-Transmission {
	param(
		[Parameter(Mandatory = $True,
			ValueFromPipeline = $True,
			HelpMessage = "Enter password label")]
		[string]$Label,

		[Parameter(Mandatory = $false,
			ValueFromPipeline = $True,
			HelpMessage = "Toggle - Browse / Exists / Create - for your credentials file")]
		[ValidateSet('Browse', 'Exists', 'Create') ]
		[string[]]$Type
	)
	switch ($Type) {
		Browse {
			$directoryPath = Select-FolderLocation
			$filePath = "$directoryPath\$Label.txt"
			try {
				$password = Get-Content -Path "$filePath" -ErrorAction Stop | ConvertTo-SecureString
				$decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
				Set-TransmissionCredentials -Host 'http://DEATHSTAR.domain.leigh-services.com:49091/transmission/rpc' -User $Label -Password $decPassword
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Exists {
			try {
				$ProfilePath = ($PROFILE).Split('\Microsoft.PowerShell_profile.ps1')[0]
				$filePath = "$ProfilePath" + "\$Label.txt"
				$password = Get-Content -Path "$filePath" -ErrorAction Stop | ConvertTo-SecureString
				$decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
				Set-TransmissionCredentials -Host 'http://DEATHSTAR.domain.leigh-services.com:49091/transmission/rpc' -User $Label -Password $decPassword
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
		Create {
			Save-PasswordFile -Label $Label
		}
		Default {
			try {
				$ProfilePath = ($PROFILE).Split('\Microsoft.PowerShell_profile.ps1')[0]
				$filePath = "$ProfilePath" + "\$Label.txt"
				$password = Get-Content -Path "$filePath" -ErrorAction Stop | ConvertTo-SecureString
				$decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
				Set-TransmissionCredentials -Host 'http://DEATHSTAR.domain.leigh-services.com:49091/transmission/rpc' -User $Label -Password $decPassword
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Warning -Message "$_"
			}
		}
	}
}
# Function		Show-TorrentInfo
function global:Show-TorrentInfo {
	try {
		Write-Host("")
		Write-Host("=====================================================================================")
		Write-Host("Current torrents in Transmission")

		Get-TransmissionTorrents -ErrorAction Stop |
		Format-Table Id,
		@{Label = "Name"; Expression = { PadOrTruncate -length 50 -s $_.Name } },
		@{Label = "% complete"; Expression = { Get-DownloadPercent -d $_.PercentDone } },
		@{Label = "Downloaded"; Expression = { Get-FriendlySize -bytes $_.DownloadedEver } },
		@{Label = "Total"; Expression = { Get-FriendlySize -bytes $_.TotalSize } }

		Write-Host("=====================================================================================")
	}
	catch {
		Write-Warning -Message "$_"
	}
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
#requires -version 4.0
<#
Inspired from code originally published at:
https://github.com/Windos/powershell-depot/blob/master/livecoding.tv/StreamCountdown/StreamCountdown.psm1

This should work in Windows PowerShell and PowerShell Core, although not in VS Code.
The ProgressStyle parameter is dynamic and only appears if you are running the command in a Windows console.

Even though are is no comment-based help or examples, if you run: help Start-PSCountdown -full you'll get the
help descriptions.
#>
function global:Start-PSCountdown {

	[cmdletbinding()]
	[OutputType("None")]
	Param(
		[Parameter(Position = 0, HelpMessage = "Enter the number of minutes to countdown (1-60). The default is 5.")]
		[ValidateRange(1, 60)]
		[int32]$Minutes = 5,
		[Parameter(HelpMessage = "Enter the text for the progress bar title.")]
		[ValidateNotNullorEmpty()]
		[string]$Title = "Counting Down ",
		[Parameter(Position = 1, HelpMessage = "Enter a primary message to display in the parent window.")]
		[ValidateNotNullorEmpty()]
		[string]$Message = "Starting soon.",
		[Parameter(HelpMessage = "Use this parameter to clear the screen prior to starting the countdown.")]
		[switch]$ClearHost
	)
	DynamicParam {
		#this doesn't appear to work in PowerShell core on Linux
		if ($host.PrivateData.ProgressBackgroundColor -And ( $PSVersionTable.Platform -eq 'Win32NT' -OR $PSEdition -eq 'Desktop')) {

			#define a parameter attribute object
			$attributes = New-Object System.Management.Automation.ParameterAttribute
			$attributes.ValueFromPipelineByPropertyName = $False
			$attributes.Mandatory = $false
			$attributes.HelpMessage = @"
Select a progress bar style. This only applies when using the PowerShell console or ISE.

Default - use the current value of `$host.PrivateData.ProgressBarBackgroundColor
Transparent - set the progress bar background color to the same as the console
Random - randomly cycle through a list of console colors
"@

			#define a collection for attributes
			$attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
			$attributeCollection.Add($attributes)
			#define the validate set attribute
			$validate = [System.Management.Automation.ValidateSetAttribute]::new("Default", "Random", "Transparent")
			$attributeCollection.Add($validate)

			#add an alias
			$alias = [System.Management.Automation.AliasAttribute]::new("style")
			$attributeCollection.Add($alias)

			#define the dynamic param
			$dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("ProgressStyle", [string], $attributeCollection)
			$dynParam1.Value = "Default"

			#create array of dynamic parameters
			$paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
			$paramDictionary.Add("ProgressStyle", $dynParam1)
			#use the array
			return $paramDictionary

		} #if
	} #dynamic parameter
	Begin {
		$loading = @(
			'Waiting for someone to hit enter',
			'Warming up processors',
			'Downloading the Internet',
			'Trying common passwords',
			'Commencing infinite loop',
			'Injecting double negatives',
			'Breeding bits',
			'Capturing escaped bits',
			'Dreaming of electric sheep',
			'Calculating gravitational constant',
			'Adding Hidden Agendas',
			'Adjusting Bell Curves',
			'Aligning Covariance Matrices',
			'Attempting to Lock Back-Buffer',
			'Building Data Trees',
			'Calculating Inverse Probability Matrices',
			'Calculating Llama Expectoration Trajectory',
			'Compounding Inert Tessellations',
			'Concatenating Sub-Contractors',
			'Containing Existential Buffer',
			'Deciding What Message to Display Next',
			'Increasing Accuracy of RCI Simulators',
			'Perturbing Matrices',
			'Initializing flux capacitors',
			'Brushing up on my Dothraki',
			'Preparing second breakfast',
			'Preparing the jump to lightspeed',
			'Initiating self-destruct sequence',
			'Mining cryptocurrency',
			'Aligning Heisenberg compensators',
			'Setting phasers to stun',
			'Deciding...blue pill or yellow?',
			'Bringing Skynet online',
			'Learning PowerShell',
			'On hold with Comcast customer service',
			'Waiting for Godot',
			'Folding proteins',
			'Searching for infinity stones',
			'Restarting the ARC reactor',
			'Learning regular expressions',
			'Trying to quit vi',
			'Waiting for the last Game_of_Thrones book',
			'Watching paint dry',
			'Aligning warp coils'
		)
		if ($ClearHost) {
			Clear-Host
		}
		$PSBoundParameters | out-string | Write-Verbose
		if ($psboundparameters.ContainsKey('progressStyle')) {

			if ($PSBoundParameters.Item('ProgressStyle') -ne 'default') {
				$saved = $host.PrivateData.ProgressBackgroundColor
			}
			if ($PSBoundParameters.Item('ProgressStyle') -eq 'transparent') {
				$host.PrivateData.progressBackgroundColor = $host.ui.RawUI.BackgroundColor
			}
		}
		$startTime = Get-Date
		$endTime = $startTime.AddMinutes($Minutes)
		$totalSeconds = (New-TimeSpan -Start $startTime -End $endTime).TotalSeconds

		$totalSecondsChild = Get-Random -Minimum 4 -Maximum 30
		$startTimeChild = $startTime
		$endTimeChild = $startTimeChild.AddSeconds($totalSecondsChild)
		$loadingMessage = $loading[(Get-Random -Minimum 0 -Maximum ($loading.Length - 1))]

		#used when progress style is random
		$progcolors = "black", "darkgreen", "magenta", "blue", "darkgray"

	} #begin
	Process {
		#this does not work in VS Code
		if ($host.name -match 'Visual Studio Code') {
			Write-Warning "This command will not work in VS Code."
			#bail out
			Return
		}
		Do {
			$now = Get-Date
			$secondsElapsed = (New-TimeSpan -Start $startTime -End $now).TotalSeconds
			$secondsRemaining = $totalSeconds - $secondsElapsed
			$percentDone = ($secondsElapsed / $totalSeconds) * 100

			Write-Progress -id 0 -Activity $Title -Status $Message -PercentComplete $percentDone -SecondsRemaining $secondsRemaining

			$secondsElapsedChild = (New-TimeSpan -Start $startTimeChild -End $now).TotalSeconds
			$secondsRemainingChild = $totalSecondsChild - $secondsElapsedChild
			$percentDoneChild = ($secondsElapsedChild / $totalSecondsChild) * 100

			if ($percentDoneChild -le 100) {
				Write-Progress -id 1 -ParentId 0 -Activity $loadingMessage -PercentComplete $percentDoneChild -SecondsRemaining $secondsRemainingChild
			}

			if ($percentDoneChild -ge 100 -and $percentDone -le 98) {
				if ($PSBoundParameters.ContainsKey('ProgressStyle') -AND $PSBoundParameters.Item('ProgressStyle') -eq 'random') {
					$host.PrivateData.progressBackgroundColor = ($progcolors | Get-Random)
				}
				$totalSecondsChild = Get-Random -Minimum 4 -Maximum 30
				$startTimeChild = $now
				$endTimeChild = $startTimeChild.AddSeconds($totalSecondsChild)
				if ($endTimeChild -gt $endTime) {
					$endTimeChild = $endTime
				}
				$loadingMessage = $loading[(Get-Random -Minimum 0 -Maximum ($loading.Length - 1))]
			}

			Start-Sleep 0.2
		} Until ($now -ge $endTime)
	} #progress

	End {
		if ($saved) {
			#restore value if it has been changed
			$host.PrivateData.ProgressBackgroundColor = $saved
		}
	} #end

} #end function
# Set-ExecutionPolicy
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
# Fresh Start
# Clear-Host

#--------------------
# Profile Starts here!
Show-IsAdminOrNot
Write-Host ""
New-Greeting
Write-Host ""
Set-Location -Path C:\GitRepos
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/powerShellProfile/personalProfiles/HomePowerShell_profile.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=HomePowerShell_profile.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
