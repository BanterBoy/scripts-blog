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
	[parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Export")]
	[parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Import")]
	[parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="Copy")]
		[string]$Server,
	[parameter(Position=1,Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="Export")]
		[string]$ExportTo,
	[parameter(Position=1,Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="Import")]
		[string]$ImportFrom,
	[parameter(Position=1,Mandatory=$true,ValueFromPipeline=$false,ParameterSetName="Copy")]
		[string]$CopyFrom,
	[parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Copy")]
	[parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Import")]
		[switch]$Overwrite=$false,
	[parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Copy")]
	[parameter(Mandatory=$false,ValueFromPipeline=$false,ParameterSetName="Import")]
		[switch]$Clear=$false
    )

Function iif {
	param([bool]$cond, $rtrue, $rfalse)
	If( $cond) {
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

If( $ExportTo) {
	Get-ReceiveConnector -Server $Server | Export-CliXML -Path $ExportTo
}
Else {
	If( $ImportFrom) {
		If( Test-Path $ImportFrom) {
			$Config= Import-CliXml $ImportFrom
		}
		else {
			throw "Import file not found";
		}
	}
	If( $CopyTo) {
		$Config= Get-ReceiveConnector -Server $Server
	}
	If( $Clear) {
		Get-ReceiveConnector -Server $Server | Remove-ReceiveConnector -Confirm:$false
	}
	ForEach( $Conn in $Config) {
		If( Get-ReceiveConnector -Identity "$Server\$($Conn.Name)" -ErrorAction SilentlyContinue) {
			If( $Overwrite) {
				$cmd= "Set-ReceiveConnector -Identity ""$Server\$($Conn.Name)"""
			}
			else {
				$cmd= ""
			}
		}
		else {
			$cmd= "New-ReceiveConnector -Name ""$($Conn.Name)"" -Server $Server -Custom"

		}
		If( $cmd -ne "") {

			$d= "$" # To turn True/False into $True/$False
			$srvfqdn= (Get-ExchangeServer $Server).Fqdn

			$Domain= iif ($Conn.DefaultDomain -ne $null) "'$($Conn.DefaultDomain)'" "$($d)null"
			$FQDN= iif ($Conn.AuthMechanism.ToString().contains("ExchangeServer")) "'$($srvfqdn)'" ( iif ($Conn.Fqdn -ne $null) "'$($Conn.Fqdn)'" "$($d)null") 
			$TlsDomainCapabilities= iif ( $Conn.TlsDomainCapabilities.count -ne 0) (( $Conn.TlsDomainCapabilities) -join ",") "$($d)null"
			$RemoteIPRanges= ($Conn.RemoteIPRanges) -join ","
			$Bindings= ($Conn.Bindings) -join ","

			$cmd+= " -Bindings $Bindings -RemoteIPRanges $RemoteIPRanges -AdvertiseClientSettings $d$($Conn.AdvertiseClientSettings) "+
				"-AuthMechanism $($Conn.AuthMechanism) -Banner '$($Conn.Banner)' -BinaryMimeEnabled $d$($Conn.BinaryMimeEnabled) "+
				"-ChunkingEnabled $d$($Conn.ChunkingEnabled) -Comment '$($Conn.Comment)' -ConnectionInactivityTimeout $($Conn.ConnectionInactivityTimeout) "+
				"-ConnectionTimeout $($Conn.ConnectionTimeout) "+
				"-DefaultDomain $Domain -DeliveryStatusNotificationEnabled $d$($Conn.DeliveryStatusNotificationEnabled) "+
				"-DomainSecureEnabled $d$($Conn.DomainSecureEnabled) -EightBitMimeEnabled $d$($Conn.EightBitMimeEnabled) "+
				"-EnableAuthGSSAPI $d$($Conn.EnableAuthGSSAPI) -Enabled $d$($Conn.Enabled) -EnhancedStatusCodesEnabled $d$($Conn.EnhancedStatusCodesEnabled) "+
				"-ExtendedProtectionPolicy $($Conn.ExtendedProtectionPolicy) -Fqdn $FQDN "+
				"-LongAddressesEnabled $d$($Conn.LongAddressesEnabled) -MaxAcknowledgementDelay $($Conn.MaxAcknowledgementDelay) "+
				"-MaxHeaderSize $($Conn.MaxHeaderSize.ToBytes()) -MaxHopCount $($Conn.MaxHopCount) -MaxInboundConnection $($Conn.MaxInboundConnection) "+
				"-MaxInboundConnectionPercentagePerSource $($Conn.MaxInboundConnectionPercentagePerSource) -MaxInboundConnectionPerSource $($Conn.MaxInboundConnectionPerSource) "+
				"-MaxLocalHopCount $($Conn.MaxLocalHopCount) -MaxLogonFailures $($Conn.MaxLogonFailures) -MaxMessageSize $($Conn.MaxMessageSize.ToBytes()) "+
				"-MaxProtocolErrors $($Conn.MaxProtocolErrors) -MaxRecipientsPerMessage $($Conn.MaxRecipientsPerMessage) -MessageRateLimit $($Conn.MessageRateLimit) "+
				"-MessageRateSource $($Conn.MessageRateSource) -OrarEnabled $d$($Conn.OrarEnabled) -PermissionGroups $($Conn.PermissionGroups) "+
				"-PipeliningEnabled $d$($Conn.PipeliningEnabled) -ProtocolLoggingLevel $($Conn.ProtocolLoggingLevel) -RequireEHLODomain $d$($Conn.RequireEHLODomain) "+
				"-RequireTLS $d$($Conn.RequireTLS) -SizeEnabled $($Conn.SizeEnabled) -SuppressXAnonymousTls $d$($Conn.SuppressXAnonymousTls) "+
				"-TarpitInterval $($Conn.TarpitInterval) -TlsDomainCapabilities $TlsDomainCapabilities"

			#echo $cmd
			Invoke-Expression -Command $cmd

		}
		else {
			Write-Output "Skipping existing connector $($Connector.Name)"
		}


	}
}