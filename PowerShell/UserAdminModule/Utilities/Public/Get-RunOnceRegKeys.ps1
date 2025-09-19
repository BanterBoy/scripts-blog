function Get-RunOnceRegKeys {
    <#
    .SYNOPSIS
        Retrieves the names and values of all RunOnce registry keys.
    .DESCRIPTION
        Retrieves the names and values of all RunOnce registry keys on the specified computer.
    .EXAMPLE
        Get-RunOnceRegKeys -ComputerName "RemoteComputer01" -Credential (Get-Credential)
        Retrieves the names and values of all RunOnce registry keys on the computer "RemoteComputer01" using the provided credentials.
    .EXAMPLE
        Get-RunOnceRegKeys
        Retrieves the names and values of all RunOnce registry keys on the local computer.
    .NOTES
        Author: Unknown
        Last Edit: Unknown
    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

    # Check if the computer is reachable
    if (-not (Test-NetConnection -ComputerName $ComputerName -InformationLevel Quiet)) {
        Write-Error "Cannot reach $ComputerName. Please check the computer name or network connection."
        return $false
    }

    try {
        if ($Credential -ne [System.Management.Automation.PSCredential]::Empty) {
            # Use the provided credentials for the remote connection
            $remoteSession = New-PSSession -ComputerName $ComputerName -Credential $Credential
            $result = Invoke-Command -Session $remoteSession -ScriptBlock {
                param ($remoteComputer)
                $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $remoteComputer)
                $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $true)
                if ($null -eq $regKey) {
                    throw "Cannot open registry key SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce on $remoteComputer."
                }
                $valueNames = $regKey.GetValueNames()
                $values = $valueNames | ForEach-Object { 
                    [PSCustomObject]@{
                        Name  = $_
                        Value = $regKey.GetValue($_)
                    }
                }
                return $values
            } -ArgumentList $ComputerName
            Remove-PSSession -Session $remoteSession
            return $result
        }
        else {
            # No credentials provided, direct registry access
            $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $ComputerName)
            $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $true)
            if ($null -eq $regKey) {
                Write-Error "Cannot open registry key SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce on $ComputerName."
                return $false
            }
            $valueNames = $regKey.GetValueNames()
            $values = $valueNames | ForEach-Object { 
                [PSCustomObject]@{
                    Name  = $_
                    Value = $regKey.GetValue($_)
                }
            }
            return $values
        }
    }
    catch {
        Write-Error "Failed to get RunOnce registry keys from $ComputerName. $_"
        return $false
    }
}
