---
layout: post
title: Copy-ReceiveConnector.ps1
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

**_@GitHub Copilot_** -

---

#### Script

```powershell
<#
    .SYNOPSIS
    Copies, saves or restores receive connector information on Exchange 2010 servers

   	Michel de Rooij
	michel@eightwone.com
	http://eightwone.com

	THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
	RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

	Version 1.0, August 23rd, 2012

    .DESCRIPTION

	This script can copy, export or import receive connector definitions
	from Exchange 2010 Hub Transport Servers.

	.PARAMETER Server
	Exchange server to act upon

	.PARAMETER CopyFrom
	Target Exchange server

	.PARAMETER ExportTo
	File to import settings to

	.PARAMETER ImportFrom
	File to import settings from

	.PARAMETER Overwrite
	Overwrite existing receive connectors

	.PARAMETER Clear
	Clear previously defined receive connectors

    .EXAMPLE
    Export receive connectors from Exchange server HUB1 to file
    .\Copy-ReceiveConnector.ps1 -Server HUB1 -ExportTo hub1.xml

    Import receive connectors from file to Exchange server HUB2
    .\Copy-ReceiveConnector.ps1 -Server HUB2 -ImportFrom hub1.xml

    Copy receive connectors from Exchange server HUB1 to HUB2
    .\Copy-ReceiveConnector.ps1 -Server HUB1 -CopyFrom HUB2 -Overwrite

    #>

#Requires -Version 2.0

param(
	[parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Export")]
	[parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Import")]
	[parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Copy")]
	[string]$Server,
	[parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = "Export")]
	[string]$ExportTo,
	[parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = "Import")]
	[string]$ImportFrom,
	[parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $false, ParameterSetName = "Copy")]
	[string]$CopyFrom,
	[parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "Copy")]
	[parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "Import")]
	[switch]$Overwrite = $false,
	[parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "Copy")]
	[parameter(Mandatory = $false, ValueFromPipeline = $false, ParameterSetName = "Import")]
	[switch]$Clear = $false
)

Function iif {
	param([bool]$cond, $rtrue, $rfalse)
	If ( $cond) {
		return $rtrue;
	}
	else {
		return $rfalse;
	}
}

##################################################
# main
##################################################

if (!(Get-Command Get-ExchangeServer -ErrorAction SilentlyContinue)) {
	throw "Exchange Management Shell required";
}

If ( $ExportTo) {
	Get-ReceiveConnector -Server $Server | Export-CliXML -Path $ExportTo
}
Else {
	If ( $ImportFrom) {
		If ( Test-Path $ImportFrom) {
			$Config = Import-CliXml $ImportFrom
		}
		else {
			throw "Import file not found";
		}
	}
	If ( $CopyTo) {
		$Config = Get-ReceiveConnector -Server $Server
	}
	If ( $Clear) {
		Get-ReceiveConnector -Server $Server | Remove-ReceiveConnector -Confirm:$false
	}
	ForEach ( $Conn in $Config) {
		If ( Get-ReceiveConnector -Identity "$Server\$($Conn.Name)" -ErrorAction SilentlyContinue) {
			If ( $Overwrite) {
				$cmd = "Set-ReceiveConnector -Identity ""$Server\$($Conn.Name)"""
			}
			else {
				$cmd = ""
			}
		}
		else {
			$cmd = "New-ReceiveConnector -Name ""$($Conn.Name)"" -Server $Server -Custom"

		}
		If ( $cmd -ne "") {

			$d = "$" # To turn True/False into $True/$False
			$srvfqdn = (Get-ExchangeServer $Server).Fqdn

			$Domain = iif ($null -ne $Conn.DefaultDomain) "'$($Conn.DefaultDomain)'" "$($d)null"
			$FQDN = iif ($Conn.AuthMechanism.ToString().contains("ExchangeServer")) "'$($srvfqdn)'" ( iif ($null -ne $Conn.Fqdn) "'$($Conn.Fqdn)'" "$($d)null")
			$TlsDomainCapabilities = iif ( $Conn.TlsDomainCapabilities.count -ne 0) (( $Conn.TlsDomainCapabilities) -join ",") "$($d)null"
			$RemoteIPRanges = ($Conn.RemoteIPRanges) -join ","
			$Bindings = ($Conn.Bindings) -join ","

			$cmd += " -Bindings $Bindings -RemoteIPRanges $RemoteIPRanges -AdvertiseClientSettings $d$($Conn.AdvertiseClientSettings) " +
			"-AuthMechanism $($Conn.AuthMechanism) -Banner '$($Conn.Banner)' -BinaryMimeEnabled $d$($Conn.BinaryMimeEnabled) " +
			"-ChunkingEnabled $d$($Conn.ChunkingEnabled) -Comment '$($Conn.Comment)' -ConnectionInactivityTimeout $($Conn.ConnectionInactivityTimeout) " +
			"-ConnectionTimeout $($Conn.ConnectionTimeout) " +
			"-DefaultDomain $Domain -DeliveryStatusNotificationEnabled $d$($Conn.DeliveryStatusNotificationEnabled) " +
			"-DomainSecureEnabled $d$($Conn.DomainSecureEnabled) -EightBitMimeEnabled $d$($Conn.EightBitMimeEnabled) " +
			"-EnableAuthGSSAPI $d$($Conn.EnableAuthGSSAPI) -Enabled $d$($Conn.Enabled) -EnhancedStatusCodesEnabled $d$($Conn.EnhancedStatusCodesEnabled) " +
			"-ExtendedProtectionPolicy $($Conn.ExtendedProtectionPolicy) -Fqdn $FQDN " +
			"-LongAddressesEnabled $d$($Conn.LongAddressesEnabled) -MaxAcknowledgementDelay $($Conn.MaxAcknowledgementDelay) " +
			"-MaxHeaderSize $($Conn.MaxHeaderSize.ToBytes()) -MaxHopCount $($Conn.MaxHopCount) -MaxInboundConnection $($Conn.MaxInboundConnection) " +
			"-MaxInboundConnectionPercentagePerSource $($Conn.MaxInboundConnectionPercentagePerSource) -MaxInboundConnectionPerSource $($Conn.MaxInboundConnectionPerSource) " +
			"-MaxLocalHopCount $($Conn.MaxLocalHopCount) -MaxLogonFailures $($Conn.MaxLogonFailures) -MaxMessageSize $($Conn.MaxMessageSize.ToBytes()) " +
			"-MaxProtocolErrors $($Conn.MaxProtocolErrors) -MaxRecipientsPerMessage $($Conn.MaxRecipientsPerMessage) -MessageRateLimit $($Conn.MessageRateLimit) " +
			"-MessageRateSource $($Conn.MessageRateSource) -OrarEnabled $d$($Conn.OrarEnabled) -PermissionGroups $($Conn.PermissionGroups) " +
			"-PipeliningEnabled $d$($Conn.PipeliningEnabled) -ProtocolLoggingLevel $($Conn.ProtocolLoggingLevel) -RequireEHLODomain $d$($Conn.RequireEHLODomain) " +
			"-RequireTLS $d$($Conn.RequireTLS) -SizeEnabled $($Conn.SizeEnabled) -SuppressXAnonymousTls $d$($Conn.SuppressXAnonymousTls) " +
			"-TarpitInterval $($Conn.TarpitInterval) -TlsDomainCapabilities $TlsDomainCapabilities"

			#echo $cmd
			Invoke-Expression -Command $cmd

		}
		else {
			Write-Output "Skipping existing connector $($Connector.Name)"
		}


	}
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/exchange/Copy-ReceiveConnector.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Copy-ReceiveConnector.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
