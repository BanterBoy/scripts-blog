---
layout: post
title: Connect-OPExchange.ps1
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

**_@GitHub Copilot_** - This code is a PowerShell script that connects to an on-premise Exchange server. The script takes in three parameters: `$creds`, `$UserName`, and `$ComputerName`. `$creds` is a PSCredential object that contains the username and password of the user that will be used to connect to the Exchange server. `$UserName` is a string that contains the username of the user that will be used to connect to the Exchange server. If `$UserName` is not specified, the script will try to use the default account for the PowerShell session, using the `env:USERNAME` environment variable. `$ComputerName` is a string that contains the name of the Exchange server that the script will connect to.

The script has three sections: `begin`, `process`, and `end`. The `begin` and `end` sections are empty, so they don't do anything. The `process` section is where the script does its work. The `process` section first checks if the PowerShell command should be processed by calling the `ShouldProcess` method of the `PSCmdlet` object. If the command should be processed, the script checks if the RDP port is open on the Exchange server by calling the `Test-OpenPorts` function. If the RDP port is open, the script imports the `ConnectExchangeOnPrem` module and calls the `Connect-ExchangeOnPrem` function to connect to the Exchange server. If the RDP port is not open, the script writes a warning message to the console.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Certainly! This PowerShell script is designed to connect to an on-premise Exchange server. Here are some examples of how to use it:

Example 1: Connect to a specific Exchange server using default credentials

```
Connect-OPExchange -ComputerName "EXCH01.contoso.com"
```

This command connects to the Exchange server named "EXCH01.contoso.com" using the default credentials for the current PowerShell session.

Example 2: Connect to a specific Exchange server using specified credentials

```
$creds = Get-Credential
Connect-OPExchange -ComputerName "EXCH01.contoso.com" -UserName "admin"
```

This command connects to the Exchange server named "EXCH01.contoso.com" using the specified credentials. The `-UserName` parameter specifies the username to use for the connection, and the `-Credential` parameter specifies the PSCredential object containing the password for the specified username.

Example 3: Connect to a random Exchange server in the current site using default credentials

```
Connect-OPExchange
```

This command connects to a random Exchange server in the current site using the default credentials for the current PowerShell session. Since the `-ComputerName` parameter is not specified, the script will randomly select an Exchange server from the current site.

I hope these examples help you get started with using this script!

---

#### Script

```powershell
Function Connect-OPExchange {

    <#

    .SYNOPSIS
    Connect-OPExchange - A function to connect to Exchange Server on premise.

	.DESCRIPTION
    Connect-OPExchange - A function to connect to Exchange Server on premise. This function will connect to a random server in the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site.

	.PARAMETER UserName
    [string]UserName - Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.

    .PARAMETER ComputerName
    [string]ComputerName - Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.

	.EXAMPLE
    Connect-OPExchange -UserName "username.admin" -ComputerName "exch01.domain.local"

    Connects using the account named in UserName and connects to the server named in ComputerName

	.EXAMPLE
    Connect-OPExchange -ComputerName "exch01.domain.local"

    Connects using the environment variable $Env:USERNAME and connects to the server named in ComputerName

	.EXAMPLE
    ex365 -UserName "lukeleigh" -ComputerName "exch01.domain.local"

    Using the command alias, this command connects using the account named in UserName and connects to the server named in ComputerName

	.OUTPUTS
    No output returned.

	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

	.INPUTS
    You can pipe objects to these perameters.

    - UserName [string] - Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.
    - ComputerName [string] - Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.

	.LINK
    https://scripts.lukeleigh.com
    Import-Module
    Connect-ExchangeOnline

#>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('ex365')]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a login/SamAccountName with permissions to access on-premise Exchange e.g. "username.admin". If left blank it will try to use the default account for the powershell session, using the env:USERNAME environment variable.')]
        [ValidateNotNullOrEmpty()]
        [Alias('user')]
        [string]$UserName = $env:USERNAME,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.')]
        [ArgumentCompleter( {
                $Exchange = Get-ExchangeServerInSite
                $Servers = Get-Random -InputObject $Exchange -Shuffle:$true
                foreach ($Server in $Servers) {
                    $Server.FQDN
                }
            }) ]
        [Alias('server')]
        [string]$ComputerName

    )

    begin {

    }

    process {

        if ($PSCmdlet.ShouldProcess($ComputerName, "Creating Session for Exchange access")) {

            if ( (Test-OpenPorts -ComputerName $ComputerName -RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).Status -eq 'Open' ) {
                Import-Module -Name ConnectExchangeOnPrem
                Connect-ExchangeOnPrem -ComputerName $ComputerName -Credential $creds -Authentication Kerberos
                Write-Verbose "Exchange Session connected to : $ComputerName."
            }
            else {
                Write-Warning "Unable to connect to $ComputerName."
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

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Connect-OPExchange.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Connect-OPExchange.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
