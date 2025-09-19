function New-LocalRunOnceRegKey {
    <#
    .SYNOPSIS
    Creates a new RunOnce registry key in the LocalMachine hive.
    
    .DESCRIPTION
    This function creates a new RunOnce registry key in the LocalMachine hive with the specified key name and value.
    
    .PARAMETER KeyName
    The name of the registry key to create.
    
    .PARAMETER KeyValue
    The value to set for the registry key.
    
    .EXAMPLE
    New-LocalRunOnceRegKey -KeyName "MyKey" -KeyValue "C:\MyApp.exe"
    
    This example creates a new RunOnce registry key named "MyKey" with the value "C:\MyApp.exe".
    
    .NOTES
    Author: GitHub Copilot
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]$KeyName,
        [Parameter(Mandatory = $true)]
        [string]$KeyValue
    )
    if ([string]::IsNullOrEmpty($KeyName) -or [string]::IsNullOrEmpty($KeyValue)) {
        Write-Error "KeyName and KeyValue cannot be null or empty."
        return $false
    }
    try {
        $reg = [Microsoft.Win32.RegistryKey]::OpenBaseKey('LocalMachine', [Microsoft.Win32.RegistryView]::Default)
        $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", $true)
        if ($null -ne $regKey.GetValue($KeyName, $null)) {
            Write-Error "A key with the name $KeyName already exists."
            return $false
        }
        $regKey.SetValue($KeyName, $KeyValue)
        $regKey.Close()
        $reg.Close()
        return $true
    }
    catch {
        Write-Error $_.Exception.Message
        return $false
    }
}
