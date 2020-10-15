$Connector = Get-ReceiveConnector -Identity 'MAIL02\Default Frontend MAIL02'
$Connector.RemoteIPRanges += "10.0.0.1","10.0.0.2","10.0.0.3"
Set-ReceiveConnector -Name $Connector.Name -RemoteIPRanges $Connector.RemoteIPRanges
