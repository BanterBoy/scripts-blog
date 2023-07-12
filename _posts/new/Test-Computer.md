---
layout: post
title: Test-Computer.ps1
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

**_@GitHub Copilot_** - The code is a PowerShell function called Test-Computer. This function is designed to test a computer and return the current status of the computer. The function performs a number of tests to retrieve the DNS, RDP, AD, and DHCP IP address information. The tests performed are as follows: Test-Connection, Get-ADComputer, Resolve-DnsName, Test-OpenPorts, and Get-NetIPAddress. Each test is performed and the results are returned in a custom object.

The first test performed is a Test-Connection to the computer. If the computer is not online, the function will return a custom object with the computer name and the status of "Inactive" and will not perform any further tests. The ComputerName parameter is used to specify the name of the computer you would like to test. This can be entered as a string or an array of strings. The format of the string can be either the computer name or the FQDN.

The function has two examples provided. The first example shows how to test and return the current status of the computer using the computer name. The second example shows how to test and return the current status of the computer using the FQDN. The function returns an object of type System.String.

The code is well-documented with comments that explain the purpose of the function, the parameters, and the tests performed. The code is also well-structured with proper indentation and spacing. The function uses try-catch blocks to handle errors and returns custom objects with ordered properties.

To improve the code's readability, the author could consider using more descriptive variable names and breaking up the code into smaller functions. To improve the code's performance, the author could consider using parallel processing to run the tests on multiple computers simultaneously.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here's an example of how to use the Test-Computer function with an array of computer names:

```powershell
$computers = @("computer1", "computer2", "computer3")
Test-Computer -ComputerName $computers
```

In this example, we create an array of computer names called `$computers` that contains the names of three computers. We then pass this array to the `Test-Computer` function using the `-ComputerName` parameter. The function will perform the tests on each computer in the array and return the results in a custom object.

Here's another example of how to use the `Test-Computer` function with a single computer name:

```powershell
Test-Computer -ComputerName "computer1"
```

In this example, we pass a single computer name to the `Test-Computer` function using the `-ComputerName` parameter. The function will perform the tests on the specified computer and return the results in a custom object.

You can also use the `Test-Computer` function to test the current computer by omitting the `-ComputerName` parameter:

```powershell
Test-Computer
```

In this example, the `Test-Computer` function will perform the tests on the current computer and return the results in a custom object.

---

#### Script

```powershell
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

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Test-Computer.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Test-Computer.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
