function Get-DockerStatsSnapshot {
	$running = docker images -q
	if ($null -eq $running) {
		Write-Warning -Message "No Docker Containers are running"
	}
	else {
		docker container stats --no-stream
	}
}