# Capture RSAT Tools install state in a Variable
$RSATtools = Get-WindowsCapability -Name "Rsat*" -Online

# Process each RSAT tool in the Variable
$RSATtools | Foreach-Object -Process {
    # If the tool is installed, display message
    if ( $_.State -eq "Installed" ) { 
        Write-Output "$($_.DisplayName) - Installed"
    }
    # In not installed, download and install RSAT suite of tools.
    elseif ( $_.State -eq "NotPresent" ) {
        # Disable Windows Update registry keys, to download direct from Microsoft
        Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -Value 0
        # Restart Windows Update Service
        Get-Service wuauserv | Restart-Service
        # Download and install tools
        Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
        # Re-enable Windows Update Registry keys
        Set-ItemProperty "REGISTRY::HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" UseWUserver -Value 1
    }
}
