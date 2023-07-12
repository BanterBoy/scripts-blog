---
layout: post
title: Test-OpenPorts.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** - This PowerShell script is designed to test open ports on one or more computers. The script takes in a list of computer names and a list of ports to test. If no ports are specified, the script will test all ports from 1 to 65535.

The script has several switches that can be used to specify additional ports to test. The `-top200` switch will add the top 200 most commonly used ports to the list of ports to test. The `-ActiveDirectory` switch will add the ports commonly used by Active Directory to the list of ports to test. The `-PowerShell` switch will add the ports commonly used by PowerShell to the list of ports to test. Finally, the `-RDP` switch will add the ports commonly used by Remote Desktop Protocol to the list of ports to test.

The script then loops through each computer and each port, attempting to connect to the port using the `Test-NetConnection` cmdlet. If the connection is successful, the script outputs a custom object with the computer name, port number, status (open or closed), and timestamp. If the connection is unsuccessful, the script outputs an error message.

To improve the readability of the code, the author could consider adding comments to explain each section of the script. Additionally, the author could consider breaking up the script into smaller functions to make it easier to read and maintain. To improve the performance of the script, the author could consider using multithreading to test multiple ports on multiple computers simultaneously.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here are some examples showing the different switches:

1. To test the top 200 most commonly used ports on a list of computers:

```powershell
Test-OpenPorts -ComputerName "Computer1", "Computer2", "Computer3" -top200
```

2. To test the ports commonly used by Active Directory on a list of computers:

```powershell
Test-OpenPorts -ComputerName "Computer1", "Computer2", "Computer3" -ActiveDirectory
```

3. To test the ports commonly used by PowerShell on a list of computers:

```powershell
Test-OpenPorts -ComputerName "Computer1", "Computer2", "Computer3" -PowerShell
```

4. To test the ports commonly used by Remote Desktop Protocol on a list of computers:

```powershell
Test-OpenPorts -ComputerName "Computer1", "Computer2", "Computer3" -RDP
```

5. To test a specific list of ports on a list of computers:

```powershell
Test-OpenPorts -ComputerName "Computer1", "Computer2", "Computer3" -Ports 80, 443, 3389
```

6. To test a specific list of ports and the ports commonly used by Active Directory on a list of computers:

```powershell
Test-OpenPorts -ComputerName "Computer1", "Computer2", "Computer3" -Ports 80, 443, 3389 -ActiveDirectory
```

<span style="font-size:9px;">\* Note that you can combine multiple switches to test multiple sets of ports on a list of computers.</span>

---

#### Script

```powershell
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
    [Alias('top')]
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
        [switch]$RDP

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

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Test-OpenPorts.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-OpenPorts.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
