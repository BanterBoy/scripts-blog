---
layout: post
title: Test-Computer.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Test-Computer/
categories:
  - UserAdminModule
  - Testing
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

Tests a computer and returns its current status including DNS, RDP, AD, and DHCP IP address information.

#### Detailed Description

The function performs a series of tests on the specified computer(s) to retrieve DNS, RDP, AD, and DHCP IP address information. The tests include:

- Test-Connection

- Get-ADComputer

- Resolve-DnsName

- Test-NetConnection

- Get-NetIPAddress

Each test's results are returned in a custom object. If the computer is not online, the function will return a custom object with the computer name and the status "Offline" and will not perform further tests.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Test-Computer -ComputerName "Computer01"
```

Tests and returns the status of "Computer01" including DNS, RDP, AD, and DHCP IP address information.

**Example 2**

```powershell
Test-Computer -ComputerName "Computer01.contoso.com"
```

Tests and returns the status of "Computer01.contoso.com" including DNS, RDP, AD, and DHCP IP address information.

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author: Luke Leigh Website: https://scripts.lukeleigh.com/ LinkedIn: https://www.linkedin.com/in/lukeleigh/ GitHub: https://github.com/BanterBoy/ GitHubGist: https://gist.github.com/BanterBoy

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
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
```
{% endraw %}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Testing/Public/Test-Computer.ps1')">
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

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

