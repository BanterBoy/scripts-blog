---
layout: post
title: Get-ComputerIP.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
function Get-ComputerIP {
    <#
        .SYNOPSIS
            Get-ComputerIP will extract the current IP from the computer entered.

        .DESCRIPTION
            A detailed description of the Get-ComputerIP function.

        .PARAMETER ComputerName
            Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.

        .PARAMETER Days
            A description of the Days parameter.

        .PARAMETER Since
            A description of the Since parameter.

        .EXAMPLE
            Get-ComputerIP

        .EXAMPLE
            Get-ComputerIP -ComputerName "HOTH"

        .EXAMPLE
            Get-ADComputer -Filter { Name -like '*' } -Properties * | ForEach-Object -Process { Get-ComputerIP -Computer $_.Name } | Format-Table -AutoSize

        .EXAMPLE
            'HOTH','KAMINO','DANTOOINE' | ForEach-Object -Process { Get-ComputerIP -Computer $_.Name } | Format-Table -AutoSize

        .OUTPUTS
            string

        .NOTES
            Additional information about the function.
    #>
    [cmdletbinding(
        SupportsShouldProcess = $True,
        DefaultParameterSetName = 'computer',
        ConfirmImpact = 'low'
    )]
    param(
        # Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.
        [Parameter(ParameterSetName = 'computer',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name/IP/FQDN for the computer you would like to retrieve the information from or pipe in a list of computers.')]
        [ValidateNotNullOrEmpty()]
        [Alias('cn')]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter your credentials or pipe input'
        )]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )
    BEGIN {
    }
    PROCESS {
        ForEach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$Computer", "Query Computer IPAddress...")) {
                If ($Credential) {
                    try {
                        $IP = ((Test-Connection -ErrorAction Stop -Count 1 -ComputerName $Computer -Credential $Credential -IPv4).Address).IPAddresstoString
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Active"
                            IPAddress = $IP
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                    }
                    catch [System.Net.NetworkInformation.PingException] {
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Down"
                            IPAddress = "Testing failed"
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                        Write-Verbose -Message "Check network connection, firewall, and/or DNS settings. Perhaps you should just check all of the things."
                    }
                }
                Else {
                    try {
                        $IP = ((Test-Connection -ErrorAction Stop -Count 1 -ComputerName $Computer -IPv4).Address).IPAddresstoString
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Active"
                            IPAddress = $IP
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                    }
                    catch [System.Net.NetworkInformation.PingException] {
                        $properties = @{
                            'Name'    = $Computer
                            'Status'  = "Down"
                            IPAddress = "Testing failed"
                        }
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                        Write-Verbose -Message "Check network connection, firewall, and/or DNS settings. Perhaps you should just check all of the things."
                    }
                }
            }
        }
    }
    END {
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/myProfile/Get-ComputerIP.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ComputerIP.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
