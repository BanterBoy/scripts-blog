function Enable-RemoteDesktop {
 
    <# 
     
    .SYNOPSIS
    Enable-RemoteDesktop enables Remote Desktop on remote computers.
     
    .DESCRIPTION
    Enable-RemoteDesktop edits the registry and enables all required firwall rules for RDP.
     
    .PARAMETER Target
    Provide the target computer name.
      
    .EXAMPLE
    Enable-RemoteDesktop -Target server01,server02,server03
    Enable-RemoteDesktop -Target client01
      
    .NOTES
    Author: Patrick Gruenauer
    Web: https://sid-500.com
     
    #>
     
    param
      
    (
        [Parameter ()]
        $Target
    )

    Write-Warning "This command works only on English and German OS.`nMake sure WinRM is enabled on target computers. (default: Windows Server OS)"

    foreach ($t in $Target) {

        Invoke-Command -ComputerName $t -ScriptBlock {
     
            # Enable RDP on english OS
     
            If ((Get-WinSystemLocale).Name -like "*en-*") {
     
                Set-ItemProperty `
                    -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'`
                    -Name "fDenyTSConnections" -Value 0; `
                    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
     
                Write-Output "$t : Operation completed successfully."
     
            }
     
            If ((Get-WinSystemLocale).Name -like "*de-*") {
     
                Set-ItemProperty `
                    -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'`
                    -Name "fDenyTSConnections" -Value 0; `
                    Enable-NetFirewallRule -DisplayGroup "RemoteDesktop"
     
            }
        }
        Write-Output "$t : Operation completed successfully."
    }
}
