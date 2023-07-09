function Test-OpenPorts {

    <#
	.SYNOPSIS
		A brief description of the Test-OpenPorts function.
	
	.DESCRIPTION
		A detailed description of the Test-OpenPorts function.
	
	.PARAMETER ComputerName
		A description of the ComputerName parameter.
	
	.PARAMETER Ports
		A description of the Ports parameter.
	
	.EXAMPLE
		PS C:\> Test-OpenPorts -ComputerName 'COMPUTERONE' -Ports 3389
		This will test COMPUTERONE to see if port 3389 is open.

	.EXAMPLE
		PS C:\> $Computers = Get-ADComputer -Filter { Name -like '*CRTP*' }
		foreach ($Computer in $Computers) {
			​Test-OpenPorts -ComputerName $Computer -Ports 80,443,445,3389,5985 | Format-Table -AutoSize
		}
		This will test all computers in the AD search scope to see if port 80, 443, 445, 3389, and 5985 are open.

	.EXAMPLE
		​PS C:\> Test-OpenPorts -ComputerName 'COMPUTERONE' -Ports 21,80,443,445,3389,5985 | Format-Table -AutoSize
		This will test COMPUTERONE to see if port 21, 80, 443, 445, 3389, and 5985 are open.
	
	.OUTPUTS
		System.String. Test-OpenPorts returns an object of type System.String.
	
	.NOTES
		Author:     Luke Leigh
		Website:    https://scripts.lukeleigh.com/
		LinkedIn:   https://www.linkedin.com/in/lukeleigh/
		GitHub:     https://github.com/BanterBoy/
		GitHubGist: https://gist.github.com/BanterBoy
	
	.INPUTS
		You can pipe objects to these perameters.
		
		- EmailAddress [string[]]
	
	.LINK
		https://scripts.lukeleigh.com
		Get-
#>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('ts')]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 1,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('po')]
        [int[]]$Ports,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [switch]$NASWakeup,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [switch]$RemoteAccess,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [switch]$top20,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [switch]$top200

    )
	
    begin {
        # preset ports for remote access
        $NASports = @(80, 443, 445, 7878, 8989, 9117, 49092)
    
        # preset ports for remote access
        $remoteAccessPorts = @(21, 80, 443, 445, 3389, 5985)
    
        # preset ports for standard services
        $top20ports = @(21, 22, 23, 25, 53, 80, 110, 111, 135, 139, 143, 443, 445, 993, 995, 1723, 3306, 3389, 5900, 8080)
    
        # preset ports for standard services
        $top200ports = @(1, 3, 7, 9, 13, 17, 19, 21, 22, 23, 25, 24, 26, 37, 53, 79, 80, 81, 82, 88, 100, 106, 110, 111, 113, 119, 135, 139, 143, 144, 179, 199, 254, 255, 280, 311, 389, 427, 443, 444, 445, 464, 465, 497, 513, 514, 515, 543, 544, 548, 554, 587, 593, 625, 631, 636, 646, 787, 808, 873, 902, 990, 993, 995, 1000, 1022, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1044, 1048, 1049, 1050, 1053, 1054, 1056, 1058, 1059, 1064, 1065, 1066, 1069, 1071, 1074, 1080, 1110, 1234, 1433, 1494, 1521, 1720, 1723, 1755, 1761, 1801, 1900, 1935, 1998, 2000, 2001, 2002, 2003, 2005, 2049, 2103, 2105, 2107, 2121, 2161, 2301, 2383, 2401, 2601, 2717, 2869, 2967, 3000, 3001, 3128, 3268, 3306, 3389, 3689, 3690, 3703, 3986, 4000, 4001, 4045, 4899, 5000, 5001, 5003, 5009, 5050, 5051, 5060, 5101, 5120, 5190, 5357, 5432, 5555, 5631, 5666, 5800, 5900, 5901, 6000, 6002, 6004, 6112, 6646, 6666, 7000, 7070, 7937, 7938, 8000, 8002, 8008, 8009, 8010, 8031, 8080, 8081, 8443, 8888, 9000, 9001, 9090, 9100, 9102, 9999, 10000, 10001, 10010, 32768, 32771, 49152, 49153, 49154, 49155, 49156, 49157, 50000)
    }
    process {
        # check if -NASWakeup switch is used
        if ($NASWakeup) {
            $Ports += $NASports
        }

        # check if -RemoteAccess switch is used
        if ($RemoteAccess) {
            $Ports += $remoteAccessPorts
        }

        # check if -top20 switch is used
        if ($top20) {
            $Ports += $top20ports
        }

        # check if -top200 switch is used
        if ($top200) {
            $Ports += $top200ports
        }

        # if no ports specified, test all ports
        if (!$Ports) {
            $Ports = 1..65535
        }

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            try {
                foreach ($Computer in $ComputerName) {
                    $ping = Test-Connection -ComputerName $Computer -Count 1 -Quiet
                    if ($ping) {
                        foreach ($port in $Ports) {
                            $result = Test-NetConnection -ComputerName $Computer -Port $port
                            $status = if ($result.TcpTestSucceeded) { "Open" } else { "Closed" }
                            $output = [PSCustomObject]@{
                                "ComputerName" = $Computer
                                "Port"         = $port
                                "Status"       = $status
                                "Timestamp"    = (Get-Date)
                            }
                            Write-Output $output
                        }
                    }
                    else {
                        Write-Output "Computer $($Computer) is not reachable"
                    }
                }
            }
            catch {
                Write-Output "An error occurred while trying to reach $($Computer)"
            }
        }
    }

    end {
    }
}
