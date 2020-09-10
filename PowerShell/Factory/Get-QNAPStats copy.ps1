#Requires -Module Transmission

Import-Module -Name Transmission

function PadOrTruncate([string]$s, [int]$length) {
    if ($s.length -le $length) {
        return $s.PadRight($length, " ")
    }

    $truncated = $s.Substring(0, ($length - 3))

    return "$truncated..."
}

function Get-DownloadPercent([decimal]$d) {
    $p = [math]::Round($d * 100)
    return "$p%"
}

function Get-FriendlySize {
    param($Bytes)
    $sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for ($i = 0; ($Bytes -ge 1kb) -and
        ($i -lt $sizes.Count); $i++) { $Bytes /= 1kb }
    $N = 2; if ($i -eq 0) { $N = 0 }
    "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
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

function Save-PasswordFile {
    <# Example

	.EXAMPLE
	Save-Password -Label UserName

	.EXAMPLE
	Save-Password -Label Password

	#>
    param([Parameter(Mandatory)]
        [string]$Label,
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
            if (![string]::IsNullOrEmpty($directoryPath)) {
                Write-Host "You selected the directory: $directoryPath"
            }
            else {
                "You did not select a directory."
            }
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

function Connect-Transmission {
    
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter password label")]
        [string]$Label,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Transmision host - e.g. 'http://deathstar.domain.leigh-services.com:49091/transmission/rpc'")]
        [string]$Host,
        
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $True,
            HelpMessage = "Toggle - Browse / Exists / Create - for your credentials file")]
        [ValidateSet('Browse', 'Exists', 'Create') ]
        [string[]]$Path

    )

    switch ($Path) {
        
        Browse {
            $directoryPath = Select-FolderLocation
            if (![string]::IsNullOrEmpty($directoryPath)) {
                Write-Host "You selected the directory: $directoryPath"
            }
            $filePath = "$directoryPath\$Label.txt"
            try {
                $password = Get-Content -Path "$filePath" -ErrorAction Stop | ConvertTo-SecureString
                $decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
                Set-TransmissionCredentials -Host $Host -User $Label -Password $decPassword
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_.Exception"
            }
        }

        Exists {
            try {
                $ProfilePath = ($PROFILE).Split('\Microsoft.PowerShell_profile.ps1')[0]
                $filePath = "$ProfilePath" + "\$Label.txt"
                $password = Get-Content -Path "$filePath" -ErrorAction Stop | ConvertTo-SecureString
                $decPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
                Set-TransmissionCredentials -Host $Host -User $Label -Password $decPassword
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_.Exception"
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
                Set-TransmissionCredentials -Host $Host -User $Label -Password $decPassword
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_.Exception"
            }
        }
    }
}

function Show-QNAPTorrentStats {
    Write-Host("")
    Write-Host("=====================================================================================")
    Write-Host("Current torrents in Transmission")

    Get-TransmissionTorrents | 
    Format-Table Id, 
    @{Label = "Name"; Expression = { PadOrTruncate -length 50 -s $_.Name } }, 
    @{Label = "% complete"; Expression = { Get-DownloadPercent -d $_.PercentDone } }, 
    @{Label = "Downloaded"; Expression = { Get-FriendlySize -bytes $_.DownloadedEver } }, 
    @{Label = "Total"; Expression = { Get-FriendlySize -bytes $_.TotalSize } }
        
    Write-Host("=====================================================================================")
}
