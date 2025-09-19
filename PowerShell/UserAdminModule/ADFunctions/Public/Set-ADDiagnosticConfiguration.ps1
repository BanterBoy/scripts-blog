function Set-ADDiagnosticLogging {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("DomainController", "LDS")]
        [string]$InstanceType,

        [Parameter(Mandatory = $true)]
        [ValidateSet(0, 1, 2, 3, 4, 5)]
        [int]$Level,

        [Parameter(Mandatory = $true)]
        [string[]]$LoggingLevels,

        [Parameter(Mandatory = $false)]
        [string]$LDSInstanceName,

        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )

    $scriptBlock = {
        param (
            $InstanceType,
            $Level,
            $LoggingLevels,
            $LDSInstanceName
        )

        $basePath = "HKLM:\SYSTEM\CurrentControlSet\Services"
        $diagnosticsPath = if ($InstanceType -eq "DomainController") {
            "$basePath\NTDS\Diagnostics"
        } elseif ($InstanceType -eq "LDS" -and $LDSInstanceName) {
            "$basePath\$LDSInstanceName\Diagnostics"
        } else {
            throw "LDS instance name is required for LDS instance type."
        }

        # Ensure the diagnostics path exists
        if (-not (Test-Path -Path $diagnosticsPath)) {
            New-Item -Path $diagnosticsPath -Force | Out-Null
        }

        $loggings = @{
            "Knowledge Consistency Checker (KCC)" = 1
            "Security Events" = 2
            "ExDS Interface Events" = 3
            "MAPI Interface Events" = 4
            "Replication Events" = 5
            "Garbage Collection" = 6
            "Internal Configuration" = 7
            "Directory Access" = 8
            "Internal Processing" = 9
            "Performance Counters" = 10
            "Initialization/Termination" = 11
            "Service Control" = 12
            "Name Resolution" = 13
            "Backup" = 14
            "Field Engineering" = 15
            "LDAP Interface Events" = 16
            "Setup" = 17
            "Global Catalog" = 18
            "Inter-site Messaging" = 19
            "Group Caching" = 20
            "Linked-Value Replication" = 21
            "DS RPC Client" = 22
            "DS RPC Server" = 23
            "DS Schema" = 24
            "Transformation Engine" = 25
            "Claims-Based Access Control" = 26
            "PDC Password Update Notifications" = 27
        }

        foreach ($LoggingLevel in $LoggingLevels) {
            if ($loggings.ContainsKey($LoggingLevel)) {
                $registryKey = $loggings[$LoggingLevel]
                Set-ItemProperty -Path $diagnosticsPath -Name "$registryKey $LoggingLevel" -Value $Level
                Write-Output "Set logging level for $LoggingLevel to $Level"
            } else {
                throw "Invalid logging level specified: $LoggingLevel."
            }
        }

        if ($LoggingLevels -contains "Field Engineering" -and $Level -eq 5) {
            # Increase the size of Directory Services event logs to 200 MB.
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Directory Service" -Name "MaxSize" -Value 209715200

            # Enable the Field Engineering diagnostics registry key.
            Set-ItemProperty -Path "$diagnosticsPath" -Name "15 Field Engineering" -Value 5

            # Configure registry-based filters for expensive, inefficient, and long-running searches.
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "Expensive Search Results Threshold" -Value 1
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "Inefficient Search Results Threshold" -Value 1
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "Search Time Threshold (msecs)" -Value 1
        }
    }

    Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -ArgumentList $InstanceType, $Level, $LoggingLevels, $LDSInstanceName
}

# Example usage:
# $InstanceType = "DomainController"
# $ComputerName = Get-AllDomainControllers # This should be defined in your environment
# $LoggingLevels = @(
#     "Knowledge Consistency Checker (KCC)",
#     "Security Events",
#     "ExDS Interface Events",
#     "MAPI Interface Events",
#     "Replication Events",
#     "Garbage Collection",
#     "Internal Configuration",
#     "Directory Access",
#     "Internal Processing",
#     "Performance Counters",
#     "Initialization/Termination",
#     "Service Control",
#     "Name Resolution",
#     "Backup",
#     "Field Engineering",
#     "LDAP Interface Events",
#     "Setup",
#     "Global Catalog",
#     "Inter-site Messaging",
#     "Group Caching",
#     "Linked-Value Replication",
#     "DS RPC Client",
#     "DS RPC Server",
#     "DS Schema",
#     "Transformation Engine",
#     "Claims-Based Access Control",
#     "PDC Password Update Notifications"
# )
# $ComputerName | ForEach-Object -Process { Set-ADDiagnosticLogging -InstanceType $InstanceType -LoggingLevels $LoggingLevels -Level 2 -ComputerName $_ }

# Example usage:
# Set-ADDiagnosticLogging -InstanceType DomainController -LoggingLevels "Replication Events", "Security Events", "Directory Access" -Level 3 -ComputerName "RemoteDC"
# Set-ADDiagnosticLogging -InstanceType LDS -LDSInstanceName "ADLDSInstance" -LoggingLevels "Security Events", "Directory Access", "LDAP Interface Events" -Level 2 -ComputerName "RemoteLDS"
# Set-ADDiagnosticLogging -InstanceType DomainController -LoggingLevels "Field Engineering" -Level 5 -ComputerName "RemoteDC"
