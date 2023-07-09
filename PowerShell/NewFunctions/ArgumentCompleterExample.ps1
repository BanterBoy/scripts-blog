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
