<#
	Google
	8.8.8.8
	8.8.4.4

	Control D
	76.76.2.0
	76.76.10.0

	Quad9
	9.9.9.9
	149.112.112.112

	OpenDNS Home
	208.67.222.222
	208.67.220.220

	Cloudflare
	1.1.1.1
	1.0.0.1

	CleanBrowsing
	185.228.168.9
	185.228.169.9

	Alternate DNS
	76.76.19.19
	76.223.122.150

	AdGuard DNS
	94.140.14.14
	94.140.15.15
#>

Function Set-DnsForwarder {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage = "Enter one or more computer names separated by commas.")]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("CN", "MachineName")]
        [String]
        $ComputerName
    )
    
    begin {
        
    }
    
    process {
        try {
            Set-DnsServerForwarder -ComputerName $ComputerName -IPAddress '8.8.8.8', '8.8.4.4', '76.76.2.0', '76.76.10.0', '9.9.9.9', '149.112.112.112', '208.67.222.222', '208.67.220.220', '1.1.1.1', '1.0.0.1', '185.228.168.9', '185.228.169.9', '76.76.19.19', '76.223.122.150', '94.140.14.14', '94.140.15.15' -PassThru
        }
        catch {
            $theError = $_
            $theError.Exception
        }
    }
    
    end {
        
    }
}
