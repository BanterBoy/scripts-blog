# Pause to be able to press and hold a key
Start-Sleep -Seconds 1

# Key list
$Nokey = [System.Windows.Input.Key]::None
$key1 = [System.Windows.Input.Key]::LeftCtrl
$key2 = [System.Windows.Input.Key]::LeftShift

# Key presses
$isCtrl = [System.Windows.Input.Keyboard]::IsKeyDown($key1)
$isShift = [System.Windows.Input.Keyboard]::IsKeyDown($key2)

# If LeftCtrl key is pressed, launch User Work Profile
if ($isCtrl) {
    Write-Warning -Message "LeftCtrl key has been pressed - User Work Profile"
    & (Join-Path $PSScriptRoot "/Connect-Office365Services.ps1")

    function New-OnPremExchangeSession {
        param (
            [Parameter(ValueFromPipeline = $True,
                HelpMessage = "Enter preferred Exchange Server")]
            [ValidateSet('EACEX01', 'EACEX02') ]
            [string[]]$ComputerName
        )
        switch ($ComputerName) {
            EACEX01 {
                $Creds = Get-Credential
                $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
                Import-PSSession $OnPremSession -DisableNameChecking
            }
            EACEX02 {
                $Creds = Get-Credential
                $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
                Import-PSSession $OnPremSession -DisableNameChecking
            }
            default {
                $Creds = Get-Credential
                $OnPremSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://mail01.ventrica.local/PowerShell/ -Authentication Kerberos -Credential $creds
                Import-PSSession $OnPremSession -DisableNameChecking
            }
        }
    }

    function Remove-OnPremExchangeSession {
        Get-PSSession | Remove-PSSession
    }

    function Restart-Profile {
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

    function New-AdminShell {
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

    function New-AdminTerminal {
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

    function Get-GoogleSearch {
        Start-Process "https://www.google.co.uk/search?q=$args"
    }

    function Get-GoogleDirections {
        param([string] $From, [String] $To)

        process {
            Start-Process "https://www.google.com/maps/dir/$From/$To/"
        }
    }

    function Get-DuckDuckGoSearch {
        Start-Process "https://duckduckgo.com/?q=$args"
    }

    function Test-IsAdmin {
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

    function Format-Console {
        param (
            [int]$WindowHeight,
            [int]$WindowWidth,
            [int]$BufferHeight,
            [int]$BufferWidth
        )
        [System.Console]::SetWindowSize($WindowWidth, $WindowHeight)
        [System.Console]::SetBufferSize($BufferWidth, $BufferHeight)
    }

    function Show-IsAdminOrNot {
        $IsAdmin = Test-IsAdmin
        if ( $IsAdmin -eq "False") {
            Write-Warning -Message "Admin Privileges!"
        }
        else {
            Write-Warning -Message "User Privileges"
        }
    }

    function Get-ContainedCommand {
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

    function Show-ProfileFunctions {
        $Path = Join-Path $PSScriptRoot "/HomePowerShell_profile.ps1"
        $functionNames = Get-ContainedCommand $Path -ItemType FunctionDefinition |	Select-Object -ExpandProperty Name
        $functionNames | Sort-Object
    }

    function New-Greeting {
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
    # Profile Starts here!
    Show-IsAdminOrNot
    Write-Host ""
    New-Greeting
    Write-Host ""
    Set-Location -Path C:\GitRepos

}

# If LeftShift key is pressed, start PowerShell without a Profile
elseif ($isShift) {
    Write-Warning -Message "LeftShift key has been pressed - PowerShell without a Profile"
    Start-Process "pwsh.exe" -ArgumentList "-NoNewWindow -noprofile"
}

# If no key is pressed, launch User Home Profile
elseif ($Nokey -eq 'None') {
    Write-Warning -Message "No key has been pressed - User Home Profile"

    function Get-ContainedCommand {
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

    function New-Password {
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

    function Get-Password {
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

    function Get-PatchTue {
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

    function Restart-Profile {
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

    function New-GitDrives {
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

    function New-Greeting {
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

    function New-ObjectToHashTable {
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

    function New-PSDrives {
        $PSRootFolder = Select-FolderLocation
        $PSDrivePaths = Get-ChildItem -Path "$PSRootFolder\"
        foreach ($item in $PSDrivePaths) {
            $paths = Test-Path -Path $item.FullName
            if (($paths) = $true) {
                New-PSDrive -Name $item.Name -PSProvider "FileSystem" -Root $item.FullName
            }
        }
    }

    function Select-FolderLocation {
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

    function Show-IsAdminOrNot {
        $IsAdmin = Test-IsAdmin
        if ( $IsAdmin -eq "False") {
            Write-Warning -Message "Admin Privileges!"
        }
        else {
            Write-Warning -Message "User Privileges"
        }
    }

    function Show-ProfileFunctions {
        $Path = Join-Path $PSScriptRoot "/HomePowerShell_profile.ps1"
        $functionNames = Get-ContainedCommand $Path -ItemType FunctionDefinition |	Select-Object -ExpandProperty Name
        $functionNames | Sort-Object
    }

    function Show-PSDrive {
        Get-PSDrive | Format-Table -AutoSize
    }

    function Stop-Outlook {
        $OutlookRunning = Get-Process -ProcessName "Outlook"
        if (($OutlookRunning) = $true) {
            Stop-Process -ProcessName Outlook
        }
    }

    function New-AdminShell {
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

    function New-AdminTerminal {
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

    # Function		Get-GoogleSearch
    function Get-GoogleSearch {
        Start-Process "https://www.google.co.uk/search?q=$args"
    }

    function Get-GoogleDirections {
        param([string] $From, [String] $To)

        process {
            Start-Process "https://www.google.com/maps/dir/$From/$To/"
        }
    }

    function Get-DuckDuckGoSearch {
        Start-Process "https://duckduckgo.com/?q=$args"
    }

    function Test-IsAdmin {
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

    function PadOrTruncate([string]$s, [int]$length) {
        if ($s.length -le $length) {
            return $s.PadRight($length, " ")
        }

        $truncated = $s.Substring(0, ($length - 3))

        return "$truncated..."
    }

    function Get-FriendlySize {
        param($Bytes)
        $sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
        for ($i = 0; ($Bytes -ge 1kb) -and
            ($i -lt $sizes.Count); $i++) { $Bytes /= 1kb }
        $N = 2; if ($i -eq 0) { $N = 0 }
        "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
    }

    function Get-DownloadPercent([decimal]$d) {
        $p = [math]::Round($d * 100)
        return "$p%"
    }

    function Save-PasswordFile {
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

    function Format-Console {
        param (
            [int]$WindowHeight,
            [int]$WindowWidth,
            [int]$BufferHeight,
            [int]$BufferWidth
        )
        [System.Console]::SetWindowSize($WindowWidth, $WindowHeight)
        [System.Console]::SetBufferSize($BufferWidth, $BufferHeight)
    }

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
    # Profile Starts here!
    Show-IsAdminOrNot
    Write-Host ""
    New-Greeting
    Write-Host ""
    Set-Location -Path C:\GitRepos

}
#--------------------
# Profile Start
#--------------------
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
# Profile Starts here!
Show-IsAdminOrNot
Write-Host ""
New-Greeting
Write-Host ""
Set-Location -Path C:\GitRepos
