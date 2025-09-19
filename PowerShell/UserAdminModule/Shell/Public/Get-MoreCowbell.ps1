function Get-MoreCowbell
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$Introduction,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$Repeat = 10,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$CowbellUrl = 'http://emmanuelprot.free.fr/Drums%20kit%20Manu/Cowbell.wav',
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$IntroUrl = 'http://www.innervation.com/crap/cowbell.wav'
		
		
	)
	begin {
		$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
	}
	process {
		try
		{
			$sound = New-Object System.Media.SoundPlayer

			# Resolve a stable base path for resources (module base -> script root -> script path -> current directory)
			$basePath = $null
			if ($PSScriptRoot) {
				$basePath = $PSScriptRoot
			} elseif ($MyInvocation.MyCommand.Module -and $MyInvocation.MyCommand.Module.ModuleBase) {
				$basePath = $MyInvocation.MyCommand.Module.ModuleBase
			} elseif ($MyInvocation.MyCommand.Path) {
				$basePath = Split-Path -Parent $MyInvocation.MyCommand.Path
			} else {
				$basePath = (Get-Location).Path
			}

			# Ensure the resources directory exists
			$resourceDir = Join-Path $basePath 'resources'
			if (-not (Test-Path -Path $resourceDir -PathType Container)) {
				New-Item -Path $resourceDir -ItemType Directory -Force | Out-Null
			}

			$CowBellLoc = Join-Path $resourceDir 'Cowbell.wav'
			if (-not (Test-Path -Path $CowBellLoc -PathType Leaf)) {
				Invoke-WebRequest -Uri $CowbellUrl -OutFile $CowBellLoc -ErrorAction Stop
			}

			if ($Introduction.IsPresent) {
				$IntroLoc = Join-Path $resourceDir 'CowbellIntro.wav'
				if (-not (Test-Path -Path $IntroLoc -PathType Leaf)) {
					Invoke-WebRequest -Uri $IntroUrl -OutFile $IntroLoc -ErrorAction Stop
				}
				$sound.SoundLocation = $IntroLoc
				$sound.Load()
				$sound.Play()
				Start-Sleep -Seconds 2
			}

			$sound.SoundLocation = $CowBellLoc
			for ($i = 0; $i -lt $Repeat; $i++) {
				$sound.Play()
				Start-Sleep -Milliseconds 500
			}
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}