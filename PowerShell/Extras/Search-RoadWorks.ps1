# http://api.hatrafficinfo.dft.gov.uk/Mtf.aspx?road=M5

function Search-RoadWorks {
	param(
		[string]$RoadName
	)
	[xml]$trafficincidents = invoke-webrequest http://hatrafficinfo.dft.gov.uk/feeds/rss/AllEvents.xml
	$trafficincidents.rss.channel.item | ConvertTo-Json
	Where-Object { $_.road -eq $RoadName } |
	Format-List title, county, road, description # | Out-File -FilePath "$HOME\desktop\RoadWorks.txt"
}
