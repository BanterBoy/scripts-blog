function Get-ADDiagnosticLogging {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("DomainController", "LDS")]
        [string]$InstanceType,

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

        $results = @()

        foreach ($LoggingLevel in $LoggingLevels) {
            if ($loggings.ContainsKey($LoggingLevel)) {
                $registryKey = $loggings[$LoggingLevel]
                $value = Get-ItemProperty -Path $diagnosticsPath -Name "$registryKey $LoggingLevel" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "$registryKey $LoggingLevel" -ErrorAction SilentlyContinue
                if ($null -eq $value) {
                    $value = 0
                }
                $results += [PSCustomObject]@{
                    LoggingLevel = $LoggingLevel
                    Level = $value
                }
            } else {
                throw "Invalid logging level specified: $LoggingLevel."
            }
        }

        return $results
    }

    Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -ArgumentList $InstanceType, $LoggingLevels, $LDSInstanceName
}

# Example usage:
# $InstanceType = "DomainController"
# $ComputerName = Get-AllDomainControllers | Select-Object -First 1 -ExpandProperty Name
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
# $ComputerName |ForEach-Object -Process { Get-ADDiagnosticLogging -InstanceType $InstanceType -LoggingLevels $LoggingLevels -ComputerName $_ }
