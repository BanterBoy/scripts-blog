function Get-ComputerReplicationStatus {
    param (
        [string]$ComputerName,
        [string[]]$ExcludeDomainControllers
    )

    # Ensure the ActiveDirectory module is available
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        Write-Error "The ActiveDirectory module is not available. Please install it to use this function."
        return
    }

    # Get all domain controllers
    $domainControllers = Get-AllDomainControllers

    # Filter out excluded domain controllers if specified
    if ($ExcludeDomainControllers) {
        $domainControllers = $domainControllers | Where-Object {
            $exclude = $false
            foreach ($pattern in $ExcludeDomainControllers) {
                if ($_.Hostname -like "*$pattern*") {
                    $exclude = $true
                    break
                }
            }
            -not $exclude
        }
    }

    # Initialize an array to hold the results
    $results = @()

    # Iterate over each domain controller and get the computer account details
    foreach ($dc in $domainControllers) {
        try {
            $computer = Get-ADComputer -Identity $ComputerName -Properties * -Server $dc.Hostname
            $result = [PSCustomObject]@{
                Server                 = $dc.Hostname
                Name                   = $computer.Name
                DNSHostName            = $computer.DNSHostName
                OperatingSystem        = $computer.OperatingSystem
                OperatingSystemVersion = $computer.OperatingSystemVersion
                LastLogonDate          = $computer.LastLogonDate
                PasswordLastSet        = $computer.PasswordLastSet
                Enabled                = $computer.Enabled
                DistinguishedName      = $computer.DistinguishedName
                Description            = $computer.Description
                WhenCreated            = $computer.WhenCreated
                WhenChanged            = $computer.WhenChanged
                ManagedBy              = $computer.ManagedBy
                ServicePrincipalNames  = $computer.ServicePrincipalNames -join "; "
            }

            $result.PSObject.TypeNames.Insert(0, 'Custom.ComputerReplicationStatus')
            $results += $result
        }
        catch {
            Write-Warning "Failed to get computer information from server $($dc.Hostname): $_"
        }
    }

    # Return the results
    return $results
}

# Example usage:
# Exclude domain controllers with "NYC" in their name:
# $computerStatus = Get-ComputerReplicationStatus -ComputerName "Workstation01" -ExcludeDomainControllers "NYC"
# $computerStatus | Format-Table -AutoSize