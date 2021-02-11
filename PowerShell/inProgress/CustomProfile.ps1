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

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

#--------------------
# Configure PowerShell Console Window Size/Preferences
Format-Console -WindowHeight 45 -WindowWidth 170 -BufferHeight 9000 -BufferWidth 170

#--------------------
# Profile Starts here!
Show-IsAdminOrNot
Write-Host ""
New-Greeting
Write-Host ""
