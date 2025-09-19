function Test-OpenPorts {

    <#
	.SYNOPSIS
		The Test-OpenPorts function utilises the Test-NetConnection cmdlet to make it easier to test multiple ports on multiple computers. It has been created with a number of preset ports that can be tested by selecting the relevant switches.
	
	.DESCRIPTION
		The Test-OpenPorts function utilises the Test-NetConnection cmdlet to make it easier to test multiple ports on multiple computers. It has been created with a number of preset ports that can be tested by selecting the relevant switches.
	
	.PARAMETER ComputerName
		This parameter accepts a string for the name of the computer you would like to test. This parameter accepts values from the pipeline.

	.PARAMETER Ports
		This parameter accepts an integer representing the TCP port/s number you would like to test. This parameter accepts values from the pipeline.

	.PARAMETER QnapSites
		This parameter is a switch that is configured with a preset for QNAP Nas Websites/Open ports

	.PARAMETER RemoteAccess
		This parameter is a switch that is configured with a preset for remote access ports

	.PARAMETER top20
		This parameter is a switch that is configured with a preset for Top 20 standard ports

	.PARAMETER top200
		This parameter is a switch that is configured with a preset for Top 200 standard ports

	.PARAMETER ActiveDirectory
		This parameter is a switch that is configured with a preset for Active Directory TCP ports

	.PARAMETER PowerShell
		This parameter is a switch that is configured with a preset for PowerShell ports

	.PARAMETER RDP
		This parameter is a switch that is configured with a preset for RDP ports
	
	.EXAMPLE
    Test-OpenPorts -ComputerName COMPUTER -RDP -PowerShell -Ports 445

    ComputerName Port Status Timestamp
    ------------ ---- ------ ---------
    COMPUTER     445 Open   20/03/2023 20:21:06
    COMPUTER    5985 Open   20/03/2023 20:21:06
    COMPUTER    3389 Open   20/03/2023 20:21:06

    This command tests the computer named 'COMPUTER', RDP and Powershell ports using the preset switches and also tests the specified port 445.

	.EXAMPLE
    $Computers = Get-ADComputer -Filter { Name -like '*Server*' }
    foreach ($Computer in $Computers) {
        ​Test-OpenPorts -ComputerName $Computer -Ports 80, 443, 445, 3389, 5985 | Format-Table -AutoSize
    }
		
    This command tests all computers in the AD search scope to see if port 80, 443, 445, 3389, and 5985 are open.

	.EXAMPLE
    Test-OpenPorts -ComputerName 'COMPUTER' -Ports 21, 80, 443, 445, 3389, 5985 | Format-Table -AutoSize

    This will test COMPUTER to see if port 21, 80, 443, 445, 3389, and 5985 are open.
	
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
		
		- ComputerName [string[]]
        - Ports [int[]]
	
	.LINK
		https://scripts.lukeleigh.com

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
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 1,
            HelpMessage = 'Enter the TCP port/s number you would like to test.')]
        [int[]]$Ports,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for QNAP Nas Websites/Open ports')]
        [switch]$QnapSites,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for remote access ports')]
        [switch]$RemoteAccess,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Top 20 standard ports')]
        [switch]$top20,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Top 200 standard ports')]
        [switch]$top200,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Active Directory TCP ports')]
        [switch]$ActiveDirectory,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for PowerShell ports')]
        [switch]$PowerShell,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for RDP ports')]
        [switch]$RDP,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Websites/Open ports')]
        [switch]$Websites,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Websites/Open ports')]
        [switch]$SMTP

    )
	
    begin {
        # preset for QNAP Nas Websites/Open ports
        $QnapPorts = @(80, 443, 445, 7878, 8989, 9117, 49092)
    
        # preset for remote access ports
        $remoteAccessPorts = @(21, 80, 443, 445, 3389, 5985)
    
        # preset for Top 20 standard ports
        $top20ports = @(21, 22, 23, 25, 53, 80, 110, 111, 135, 139, 143, 443, 445, 993, 995, 1723, 3306, 3389, 5900, 8080)
    
        # preset for Top 200 standard ports
        $top200ports = @(1, 3, 7, 9, 13, 17, 19, 21, 22, 23, 25, 24, 26, 37, 53, 79, 80, 81, 82, 88, 100, 106, 110, 111, 113, 119, 135, 139, 143, 144, 179, 199, 254, 255, 280, 311, 389, 427, 443, 444, 445, 464, 465, 497, 513, 514, 515, 543, 544, 548, 554, 587, 593, 625, 631, 636, 646, 787, 808, 873, 902, 990, 993, 995, 1000, 1022, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1044, 1048, 1049, 1050, 1053, 1054, 1056, 1058, 1059, 1064, 1065, 1066, 1069, 1071, 1074, 1080, 1110, 1234, 1433, 1494, 1521, 1720, 1723, 1755, 1761, 1801, 1900, 1935, 1998, 2000, 2001, 2002, 2003, 2005, 2049, 2103, 2105, 2107, 2121, 2161, 2301, 2383, 2401, 2601, 2717, 2869, 2967, 3000, 3001, 3128, 3268, 3306, 3389, 3689, 3690, 3703, 3986, 4000, 4001, 4045, 4899, 5000, 5001, 5003, 5009, 5050, 5051, 5060, 5101, 5120, 5190, 5357, 5432, 5555, 5631, 5666, 5800, 5900, 5901, 6000, 6002, 6004, 6112, 6646, 6666, 7000, 7070, 7937, 7938, 8000, 8002, 8008, 8009, 8010, 8031, 8080, 8081, 8443, 8888, 9000, 9001, 9090, 9100, 9102, 9999, 10000, 10001, 10010, 32768, 32771, 49152, 49153, 49154, 49155, 49156, 49157, 50000)

        # preset for Active Directory TCP ports
        $ActiveDirectoryTCPPorts = @(25, 42, 53, 88, 135, 137, 139, 389, 445, 464, 636, 3268, 3269, 5722, 9389)

        # preset for PowerShell ports
        $PowerShellPorts = @(5985)

        # preset for RDP ports
        $RDPPorts = @(3389)

        # preset for Websites Open ports
        $WebsitesPorts = @(80, 443)


        # preset for SMTP Open ports
        $SMTPPorts = @(25, 465, 587, 2525)

    }
    process {
        # check if -QnapSites switch is used
        if ($QnapSites) {
            $Ports += $QnapPorts
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

        # check if -ActiveDirectory switch is used
        if ($ActiveDirectory) {
            $Ports += $ActiveDirectoryTCPPorts
        }

        # check if -PowerShell switch is used
        if ($PowerShell) {
            $Ports += $PowerShellPorts
        }

        # check if -PowerShell switch is used
        if ($RDP) {
            $Ports += $RDPPorts
        }
        
        # check if -Websites switch is used
        if ($Websites) {
            $Ports += $WebsitesPorts
        }

        # check if -SMTP switch is used
        if ($SMTP) {
            $Ports += $SMTPPorts
        }

        # if no ports specified, test all ports
        if (!$Ports) {
            $Ports = 1..65535
        }

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            foreach ($Computer in $ComputerName) {
                foreach ($port in $Ports) {
                    try {
                        $result = Test-NetConnection -ComputerName $Computer -Port $port -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        $status = if ($result.TcpTestSucceeded) { "Open" } else { "Closed" }
                        $output = [PSCustomObject]@{
                            "ComputerName" = $Computer
                            "Port"         = $port
                            "Status"       = $status
                            "Timestamp"    = (Get-Date)
                        }
                        Write-Output $output
                    }
                    catch {
                        Write-Output "An error occurred while trying to reach $($Computer)"
                    }
                }
            }
        }
    }

    end {
    }
}
