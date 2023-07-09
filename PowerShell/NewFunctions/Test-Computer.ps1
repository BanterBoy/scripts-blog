Function Test-Computer {
    
    <#
	.SYNOPSIS
    The function Test-Computer can be used to test a computer and return the current status of the computer. This includes DNS, RDP, AD, and DHCP IP address information. 
	
	.DESCRIPTION
    The function Test-Computer can be used to test a computer and return the current status of the computer. The function performs a number of tests to retrieve the DNS, RDP, AD, and DHCP IP address information. The tests performed are as follows:
        - Test-Connection
        - Get-ADComputer
        - Resolve-DnsName
        - Test-OpenPorts
        - Get-NetIPAddress
    Each test is performed and the results are returned in a custom object.
    The first test performed is a Test-Connection to the computer. If the computer is not online, the function will return a custom object with the computer name and the status of "Inactive" andd will not perform any further tests.
	
	.PARAMETER ComputerName
    The ComputerName parameter is used to specify the name of the computer you would like to test.
    This can be entered as a string or an array of strings. The format of the string can be either the computer name or the FQDN.
	
	.EXAMPLE
    Test-Computer -ComputerName "Computer01"

    This will test and return the current status of the computer using the computer name. This includes DNS, RDP, AD, and DHCP IP address information.
	
	.EXAMPLE
    Test-Computer -ComputerName "Computer01.contoso.com"

    This will test and return the current status of the computer using the FQDN. This includes DNS, RDP, AD, and DHCP IP address information.

    .OUTPUTS
    System.String. Test-Computer returns an object of type System.String.
	
	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
    You can pipe objects to these perameters.
    - ComputerName [string[]]
	
	.LINK
    https://scripts.lukeleigh.com
    Test-Connection
    Get-ADComputer
    Resolve-DnsName
    Test-OpenPorts
    Get-NetIPAddress
        
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to test.')]
        [Alias('cn')]
        [string[]]$ComputerName

    )

    begin {
    }
    
    process {
        foreach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$Computer", "Performing DNS, RDP, AD and Status tests")) {
                $ConnectionResult = Test-Connection -ComputerName $Computer -Ping -Count 1 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                if ($ConnectionResult) {
                    try {
                        $ADResultFQDN = Get-ADComputer -Filter 'DNSHostName -like $Computer ' -Properties IPv4Address -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        $ADResult = Get-ADComputer -Filter 'Name -like $Computer ' -Properties IPv4Address -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        $DNSResult = Resolve-DnsName $Computer -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        $RDPResult = Test-OpenPorts -ComputerName $Computer -Ports 3389 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        $PwshResult = Test-OpenPorts -ComputerName $Computer -Ports 5985 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        $LocalIPResult = Get-NetIPAddress -CimSession $Computer -AddressFamily IPv4 -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Where-Object -Property PrefixOrigin -eq "Dhcp"
                        if ($ConnectionResult -and $RDPResult) {
                            if ($ADResult) {
                                $properties = [ordered]@{
                                    ComputerName         = $ADResult.DNSHostName
                                    'Active ADOBJect'    = $ADResult.Enabled
                                    'DNS Registration'   = $DNSResult.IP4Address
                                    'RDP Enabled'        = $RDPResult.Status
                                    'Powershell Enabled' = $PwshResult.Status
                                    'DHCP IP'            = $LocalIPResult.IPAddress
                                    Online               = $ConnectionResult.Status
                                }
                            }
                            if ($ADResultFQDN) {
                                $properties = [ordered]@{
                                    ComputerName         = $ADResultFQDN.DNSHostName
                                    'Active ADOBJect'    = $ADResultFQDN.Enabled
                                    'DNS Registration'   = $DNSResult.IP4Address
                                    'RDP Enabled'        = $RDPResult.Status
                                    'Powershell Enabled' = $PwshResult.Status
                                    'DHCP IP'            = $LocalIPResult.IPAddress
                                    Online               = $ConnectionResult.Status
                                }
                            }
                        }
                    }
                    catch {
                        Write-Error -Message $_.Exception.Message
                    }
                    finally {
                        Write-Output -InputObject $properties
                    }
                }
                else {
                    $properties = [ordered]@{
                        ComputerName         = $Computer
                        'ActiveADOBJect'     = "NoObject"
                        'DNSRegistration'    = "NoRegistration"
                        'RDPEnabled'         = "Unavailable"
                        'Powershell Enabled' = "Unavailable"
                        'DHCP IP'            = "Unavailable"
                        Online               = "Inactive"
                    }
                    Write-Output -InputObject $properties
                }
            }
        }
    }
    end {
    }

}
