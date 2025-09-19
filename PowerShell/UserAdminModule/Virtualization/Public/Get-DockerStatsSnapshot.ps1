<#
.SYNOPSIS
Retrieves the Docker container statistics snapshot.

.DESCRIPTION
The Get-DockerStatsSnapshot function retrieves the current statistics snapshot of Docker containers. It checks if any Docker containers are running and displays the statistics if there are any. If no containers are running, a warning message is displayed.

.NOTES
Author: Your Name
Date: Date created

.EXAMPLE
Get-DockerStatsSnapshot
# Retrieves the Docker container statistics snapshot.

#> 
function Get-DockerStatsSnapshot {
	$running = docker images -q
	if ($null -eq $running) {
		Write-Warning -Message "No Docker Containers are running"
	}
	else {
		docker container stats --no-stream
	}
}