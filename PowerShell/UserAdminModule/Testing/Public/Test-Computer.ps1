function Test-Computer {
    <#
    .SYNOPSIS
    Tests a computer and returns its current status including DNS, RDP, AD, and DHCP IP address information.

    .DESCRIPTION
    The function performs a series of tests on the specified computer(s) to retrieve DNS, RDP, AD, and DHCP IP address information. 
    The tests include:
        - Test-Connection
        - Get-ADComputer
        - Resolve-DnsName
        - Test-NetConnection
        - Get-NetIPAddress
    Each test's results are returned in a custom object.
    If the computer is not online, the function will return a custom object with the computer name and the status "Offline" and will not perform further tests.

    .PARAMETER ComputerName
    Specifies the name(s) of the computer(s) to test. Can be a single string or an array of strings. Supports both computer names and FQDNs.

    .EXAMPLE
    Test-Computer -ComputerName "Computer01"

    Tests and returns the status of "Computer01" including DNS, RDP, AD, and DHCP IP address information.

    .EXAMPLE
    Test-Computer -ComputerName "Computer01.contoso.com"

    Tests and returns the status of "Computer01.contoso.com" including DNS, RDP, AD, and DHCP IP address information.

    .OUTPUTS
    PSCustomObject. Test-Computer returns a custom object with the test results.

    .NOTES
    Author: Luke Leigh
    Website: https://scripts.lukeleigh.com/
    LinkedIn: https://www.linkedin.com/in/lukeleigh/
    GitHub: https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .INPUTS
    You can pipe objects to this parameter.
    - ComputerName [string[]]

    .LINK
    https://scripts.lukeleigh.com
    Test-Connection
    Get-ADComputer
    Resolve-DnsName
    Test-NetConnection
    Get-NetIPAddress
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('cn')]
        [string[]]$ComputerName
    )

    begin {
        $results = @()
        $total = $ComputerName.Count
        $count = 0
    }

    process {
        foreach ($Computer in $ComputerName) {
            $count++
            $percentComplete = ($count / $total) * 100

            $properties = [ordered]@{
                ComputerName       = $Computer
                Online             = $false
                ActiveADObject     = "NotChecked"
                DNSRegistration    = "NotChecked"
                RDPEnabled         = "NotChecked"
                PowerShellEnabled  = "NotChecked"
                DHCPIP             = "NotChecked"
            }

            Write-Progress -Activity "Testing Computers" -Status "Pinging $Computer ($count of $total)" -PercentComplete $percentComplete
            Write-Verbose "Pinging $Computer to check if it is online."
            
            try {
                $ConnectionResult = Test-Connection -ComputerName $Computer -Count 1 -Quiet
                if ($ConnectionResult) {
                    Write-Verbose "$Computer is online."
                    $properties.Online = $true
                } else {
                    Write-Verbose "$Computer is offline."
                    $properties.Online = $false
                    $results += [PSCustomObject]$properties
                    continue
                }
            } catch {
                Write-Error "Failed to ping {$Computer}: $_"
                $results += [PSCustomObject]$properties
                continue
            }

            Write-Progress -Activity "Testing Computers" -Status "Fetching AD information for $Computer ($count of $total)" -PercentComplete $percentComplete
            Write-Verbose "Fetching Active Directory information for $Computer."
            try {
                $ADResult = Get-ADComputer -Filter { Name -eq $Computer } -Properties Enabled, DNSHostName -ErrorAction SilentlyContinue
                if ($ADResult) {
                    Write-Verbose "Active Directory object found for $Computer."
                    $properties.ActiveADObject = $ADResult.Enabled
                } else {
                    Write-Verbose "No Active Directory object found for $Computer."
                    $properties.ActiveADObject = "NotFound"
                }
            } catch {
                Write-Error "Failed to get AD information for {$Computer}: $_"
            }

            Write-Progress -Activity "Testing Computers" -Status "Resolving DNS for $Computer ($count of $total)" -PercentComplete $percentComplete
            Write-Verbose "Resolving DNS for $Computer."
            try {
                $DNSResult = Resolve-DnsName -Name $Computer -ErrorAction SilentlyContinue
                if ($DNSResult) {
                    Write-Verbose "DNS resolution successful for $Computer."
                    $properties.DNSRegistration = ($DNSResult | Where-Object { $_.QueryType -eq 'A' }).IPAddress -join ", "
                } else {
                    Write-Verbose "DNS resolution failed for $Computer."
                    $properties.DNSRegistration = "NotFound"
                }
            } catch {
                Write-Error "Failed to resolve DNS for {$Computer}: $_"
            }

            Write-Progress -Activity "Testing Computers" -Status "Checking RDP and PowerShell ports for $Computer ($count of $total)" -PercentComplete $percentComplete
            Write-Verbose "Checking RDP and PowerShell ports for $Computer."
            try {
                $RDPResult = Test-NetConnection -ComputerName $Computer -Port 3389 -ErrorAction SilentlyContinue
                $PwshResult = Test-NetConnection -ComputerName $Computer -Port 5985 -ErrorAction SilentlyContinue
                $properties.RDPEnabled = if ($RDPResult.TcpTestSucceeded) { "Open" } else { "Closed" }
                $properties.PowerShellEnabled = if ($PwshResult.TcpTestSucceeded) { "Open" } else { "Closed" }
                Write-Verbose "RDP port status: $($properties.RDPEnabled), PowerShell port status: $($properties.PowerShellEnabled) for $Computer."
            } catch {
                Write-Error "Failed to check RDP/PowerShell ports for {$Computer}: $_"
            }

            Write-Progress -Activity "Testing Computers" -Status "Fetching DHCP IP for $Computer ($count of $total)" -PercentComplete $percentComplete
            Write-Verbose "Fetching DHCP IP for $Computer."
            try {
                $LocalIPResult = Get-NetIPAddress -CimSession $Computer -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.PrefixOrigin -eq "Dhcp" }
                if ($LocalIPResult) {
                    Write-Verbose "DHCP IP found for $Computer."
                    $properties.DHCPIP = $LocalIPResult.IPAddress -join ", "
                } else {
                    Write-Verbose "No DHCP IP found for $Computer."
                    $properties.DHCPIP = "NotFound"
                }
            } catch {
                Write-Error "Failed to get DHCP IP for {$Computer}: $_"
            }

            $results += [PSCustomObject]$properties
        }
    }

    end {
        Write-Progress -Activity "Testing Computers" -Completed
        return $results
    }
}
