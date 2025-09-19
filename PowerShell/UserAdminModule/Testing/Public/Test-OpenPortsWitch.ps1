<#
    .SYNOPSIS
        The Test-OpenPortsWitch function utilises the Test-NetConnection cmdlet to make it easier to test multiple ports on multiple computers. It has been created with a number of preset ports that can be tested by selecting the relevant switches.
    
    .DESCRIPTION
        The Test-OpenPortsWitch function utilises the Test-NetConnection cmdlet to make it easier to test multiple ports on multiple computers. It has been created with a number of preset ports that can be tested by selecting the relevant switches.
    
    .PARAMETER ComputerName
        This parameter accepts a string for the name of the computer you would like to test. This parameter accepts values from the pipeline.

    .PARAMETER Ports
        This parameter accepts an integer representing the TCP port/s number you would like to test. This parameter accepts values from the pipeline.

    .PARAMETER ActiveDirectory
        This parameter is a switch that is configured with a preset for Active Directory TCP ports

    .PARAMETER CommonPorts
        This parameter is a switch that is configured with a preset for common ports (80, 443, 8080)

    .PARAMETER DNSServer
        This parameter is a switch that is configured with a preset for DNS Server ports

    .PARAMETER Exchange
        This parameter is a switch that is configured with a preset for Exchange Server ports

    .PARAMETER FTP
        This parameter is a switch that is configured with a preset for FTP ports

    .PARAMETER HTTP
        This parameter is a switch that is configured with a preset for HTTP ports

    .PARAMETER HTTPS
        This parameter is a switch that is configured with a preset for HTTPS ports

    .PARAMETER PowerShell
        This parameter is a switch that is configured with a preset for PowerShell ports

    .PARAMETER QnapSites
        This parameter is a switch that is configured with a preset for QNAP Nas Websites/Open ports

    .PARAMETER RDP
        This parameter is a switch that is configured with a preset for RDP ports

    .PARAMETER RemoteAccess
        This parameter is a switch that is configured with a preset for remote access ports

    .PARAMETER SMB
        This parameter is a switch that is configured with a preset for SMB/CIFS ports

    .PARAMETER SMTP
        This parameter is a switch that is configured with a preset for SMTP ports

    .PARAMETER SSH
        This parameter is a switch that is configured with a preset for SSH ports

    .PARAMETER SQL
        This parameter is a switch that is configured with a preset for SQL Server ports

    .PARAMETER Top10
        This parameter is a switch that is configured with a preset for Top 10 standard ports

    .PARAMETER Top20
        This parameter is a switch that is configured with a preset for Top 20 standard ports

    .PARAMETER Top100
        This parameter is a switch that is configured with a preset for Top 100 standard ports

    .PARAMETER Top200
        This parameter is a switch that is configured with a preset for Top 200 standard ports

    .PARAMETER Websites
        This parameter is a switch that is configured with a preset for Websites/Open ports
    
    .EXAMPLE
    Test-OpenPortsWitch -ComputerName COMPUTER -RDP -PowerShell -Ports 445

    ComputerName Port Status Timestamp
    ------------ ---- ------ ---------
    COMPUTER     445 Open   20/03/2023 20:21:06
    COMPUTER    5985 Open   20/03/2023 20:21:06
    COMPUTER    3389 Open   20/03/2023 20:21:06

    This command tests the computer named 'COMPUTER', RDP and PowerShell ports using the preset switches and also tests the specified port 445.

    .EXAMPLE
    $Computers = Get-ADComputer -Filter { Name -like '*Server*' }
    foreach ($Computer in $Computers) {
        Test-OpenPortsWitch -ComputerName $Computer -Ports 80, 443, 445, 3389, 5985 | Format-Table -AutoSize
    }
        
    This command tests all computers in the AD search scope to see if port 80, 443, 445, 3389, and 5985 are open.

    .EXAMPLE
    Test-OpenPortsWitch -ComputerName 'COMPUTER' -Ports 21, 80, 443, 445, 3389, 5985 | Format-Table -AutoSize

    This will test COMPUTER to see if port 21, 80, 443, 445, 3389, and 5985 are open.

    .EXAMPLE
    Test-OpenPortsWitch -ComputerName 'COMPUTER' -CommonPorts -Top20

    This will test COMPUTER to see if common ports and the top 20 standard ports are open.

    .OUTPUTS
        System.String. Test-OpenPortsWitch returns an object of type System.String.
    
    .NOTES
        Author:     Luke Leigh
        Website:    https://scripts.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy
    
    .INPUTS
        You can pipe objects to these parameters.
        
        - ComputerName [string[]]
        - Ports [int[]]
    
    .LINK
        https://scripts.lukeleigh.com
#>

function Test-OpenPortsWitch {
    
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
            HelpMessage = 'preset for Active Directory TCP ports')]
        [switch]$ActiveDirectory,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for common ports (80, 443, 8080)')]
        [switch]$CommonPorts,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for DNS Server ports')]
        [switch]$DNSServer,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Exchange Server ports')]
        [switch]$Exchange,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for FTP ports')]
        [switch]$FTP,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for HTTP ports')]
        [switch]$HTTP,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for HTTPS ports')]
        [switch]$HTTPS,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for PowerShell ports')]
        [switch]$PowerShell,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for QNAP Nas Websites/Open ports')]
        [switch]$QnapSites,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for RDP ports')]
        [switch]$RDP,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for remote access ports')]
        [switch]$RemoteAccess,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for SMB/CIFS ports')]
        [switch]$SMB,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for SMTP ports')]
        [switch]$SMTP,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for SSH ports')]
        [switch]$SSH,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for SQL Server ports')]
        [switch]$SQL,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Top 10 standard ports')]
        [switch]$Top10,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Top 20 standard ports')]
        [switch]$Top20,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Top 100 standard ports')]
        [switch]$Top100,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Top 200 standard ports')]
        [switch]$Top200,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            HelpMessage = 'preset for Websites/Open ports')]
        [switch]$Websites

    )
    
    begin {
        # Declare preset port arrays for various services

        # Active Directory TCP ports
        $activeDirectoryPortsArray = @(25, 42, 53, 88, 135, 137, 139, 389, 445, 464, 636, 3268, 3269, 5722, 9389)
        
        # Common ports
        $commonPortsArray = @(80, 443, 8080)
        
        # DNS Server ports
        $dnsServerPortsArray = @(53)
        
        # Exchange Server ports
        $exchangePortsArray = @(25, 110, 143, 443, 587, 993, 995, 2525)
        
        # FTP ports
        $ftpPortsArray = @(20, 21)
        
        # HTTP ports
        $httpPortsArray = @(80, 8080, 8081)
        
        # HTTPS ports
        $httpsPortsArray = @(443, 8443)
        
        # PowerShell ports
        $powerShellPortsArray = @(5985)
        
        # QNAP Nas Websites/Open ports
        $qnapPortsArray = @(80, 443, 445, 7878, 8989, 9117, 49092)
        
        # RDP ports
        $rdpPortsArray = @(3389)
        
        # Remote access ports
        $remoteAccessPortsArray = @(21, 80, 443, 445, 3389, 5985)
        
        # SMB/CIFS ports
        $smbPortsArray = @(137, 138, 139, 445)
        
        # SMTP ports
        $smtpPortsArray = @(25, 465, 587, 2525)
        
        # SSH ports
        $sshPortsArray = @(22)
        
        # SQL Server ports
        $sqlPortsArray = @(1433, 1434)
        
        # Top 10 standard ports
        $top10PortsArray = @(21, 22, 23, 25, 53, 80, 110, 143, 443, 993)
        
        # Top 20 standard ports
        $top20PortsArray = @(21, 22, 23, 25, 53, 80, 110, 111, 135, 139, 143, 443, 445, 993, 995, 1723, 3306, 3389, 5900, 8080)
        
        # Top 100 standard ports
        $top100PortsArray = @(
            7, 20, 21, 22, 23, 25, 37, 42, 43, 49, 53, 67, 68, 69, 70, 79, 80, 88, 102, 110, 111, 113, 119, 123, 135, 137, 138, 139,
            143, 161, 162, 177, 179, 194, 201, 264, 318, 381, 383, 389, 411, 412, 427, 443, 445, 464, 465, 497, 500, 512, 513, 514,
            515, 543, 544, 548, 554, 587, 631, 636, 646, 691, 860, 873, 902, 989, 990, 993, 995, 1080, 1194, 1214, 1241, 1352, 1433,
            1434, 1521, 1723, 1725, 1741, 1755, 1812, 1813, 1863, 1985, 2000, 2003, 2049, 2100, 2222, 2323, 2483, 2484, 2745, 3124,
            3127, 3128, 3222, 3260, 3306, 3389, 3689, 3690, 3724, 3784, 4000, 4343, 4444, 4500, 4662, 4899, 5000, 5001, 5050, 5060,
            5190, 5222, 5223, 5432, 5500, 5631, 5632, 5800, 5900, 6000, 6346, 6660, 6661, 6662, 6663, 6664, 6665, 6666, 6667, 6668,
            6669, 6679, 6697, 7000, 7001, 8000, 8008, 8009, 8080, 8081, 8443, 8888, 9100, 9999, 10000, 32768, 49152, 49153, 49154,
            49155, 49156, 49157
        )
        
        # Top 200 standard ports
        $top200PortsArray = @(
            1, 3, 7, 9, 13, 17, 19, 21, 22, 23, 25, 24, 26, 37, 53, 79, 80, 81, 82, 88, 100, 106, 110, 111, 113, 119, 135, 139, 143, 144, 179, 199, 254, 255, 280, 311, 389, 427, 443, 444, 445, 464, 465, 497, 513, 514, 515, 543, 544, 548, 554, 587, 593, 625, 631, 636, 646, 787, 808, 873, 902, 990, 993, 995, 1000, 1022, 1024, 1025, 1026, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1035, 1036, 1037, 1038, 1039, 1040, 1041, 1044, 1048, 1049, 1050, 1053, 1054, 1056, 1058, 1059, 1064, 1065, 1066, 1069, 1071, 1074, 1080, 1110, 1234, 1433, 1494, 1521, 1720, 1723, 1755, 1761, 1801, 1900, 1935, 1998, 2000, 2001, 2002, 2003, 2005, 2049, 2103, 2105, 2107, 2121, 2161, 2301, 2383, 2401, 2601, 2717, 2869, 2967, 3000, 3001, 3128, 3268, 3306, 3389, 3689, 3690, 3703, 3986, 4000, 4001, 4045, 4899, 5000, 5001, 5003, 5009, 5050, 5051, 5060, 5101, 5120, 5190, 5357, 5432, 5555, 5631, 5666, 5800, 5900, 5901, 6000, 6002, 6004, 6112, 6646, 6666, 7000, 7070, 7937, 7938, 8000, 8002, 8008, 8009, 8010, 8031, 8080, 8081, 8443, 8888, 9000, 9001, 9090, 9100, 9102, 9999, 10000, 10001, 10010, 32768, 32771, 49152, 49153, 49154, 49155, 49156, 49157, 50000
        )
        
        # Websites Open ports
        $websitesPortsArray = @(80, 443)
        
    }
    
    process {
        # Add ports from selected switches to the Ports array

        # Check if -ActiveDirectory switch is used
        if ($ActiveDirectory) {
            $Ports += $activeDirectoryPortsArray
        }
        
        # Check if -CommonPorts switch is used
        if ($CommonPorts) {
            $Ports += $commonPortsArray
        }
        
        # Check if -DNSServer switch is used
        if ($DNSServer) {
            $Ports += $dnsServerPortsArray
        }
        
        # Check if -Exchange switch is used
        if ($Exchange) {
            $Ports += $exchangePortsArray
        }
        
        # Check if -FTP switch is used
        if ($FTP) {
            $Ports += $ftpPortsArray
        }
        
        # Check if -HTTP switch is used
        if ($HTTP) {
            $Ports += $httpPortsArray
        }
        
        # Check if -HTTPS switch is used
        if ($HTTPS) {
            $Ports += $httpsPortsArray
        }
        
        # Check if -PowerShell switch is used
        if ($PowerShell) {
            $Ports += $powerShellPortsArray
        }
        
        # Check if -QnapSites switch is used
        if ($QnapSites) {
            $Ports += $qnapPortsArray
        }
        
        # Check if -RDP switch is used
        if ($RDP) {
            $Ports += $rdpPortsArray
        }
        
        # Check if -RemoteAccess switch is used
        if ($RemoteAccess) {
            $Ports += $remoteAccessPortsArray
        }
        
        # Check if -SMB switch is used
        if ($SMB) {
            $Ports += $smbPortsArray
        }
        
        # Check if -SMTP switch is used
        if ($SMTP) {
            $Ports += $smtpPortsArray
        }
        
        # Check if -SSH switch is used
        if ($SSH) {
            $Ports += $sshPortsArray
        }
        
        # Check if -SQL switch is used
        if ($SQL) {
            $Ports += $sqlPortsArray
        }
        
        # Check if -Top10 switch is used
        if ($Top10) {
            $Ports += $top10PortsArray
        }
        
        # Check if -Top20 switch is used
        if ($Top20) {
            $Ports += $top20PortsArray
        }
        
        # Check if -Top100 switch is used
        if ($Top100) {
            $Ports += $top100PortsArray
        }
        
        # Check if -Top200 switch is used
        if ($Top200) {
            $Ports += $top200PortsArray
        }
        
        # Check if -Websites switch is used
        if ($Websites) {
            $Ports += $websitesPortsArray
        }

        # If no ports are specified, test all ports from 1 to 65535
        if (!$Ports) {
            $Ports = 1..65535
        }

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            foreach ($Computer in $ComputerName) {
                foreach ($port in $Ports) {
                    try {
                        # Test each port on each computer using Test-NetConnection
                        $result = Test-NetConnection -ComputerName $Computer -Port $port -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        $status = if ($result.TcpTestSucceeded) { "Open" } else { "Closed" }
                        # Create a custom object with the test result
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
