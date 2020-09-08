# This script creates graphical Report by using logparser and WMI
# for a set of remote server and localhost

# usage :
# With a list of remote computers
# cmdline
#   get-content MyServerList.txt | chart-driveSpace.V2.ps1

# MyServerList.txt is a list of remote servers

# localhost
# cmdline
# run script like that : & .\chart-driveSpace.V2.ps1


#############
#pre-requist#
#############
# logparser version 2.2
# Micrososft office or Microsoft Office Web Components

begin {
	# function found on http://www.blkmtn.org/sepeck
	function Get-DriveSpace([string]$SystemName ) {
		$driveinfo = get-wmiobject win32_logicaldisk -filter "drivetype=3 or drivetype=4" -computer $SystemName
		$driveinfo | Select-Object deviceid, `
		@{Name="FreeSpace";Expression={($_.freespace/1GB).tostring("0.00")}}, `
		@{Name="DriveSize";Expression={($_.size/1GB).tostring("0.00")}}, `
		@{Name="Percentfree";Expression={((($_.freespace/1GB)/($_.size/1GB))*100).tostring("0.00")}}
	}

}

Process {
$logparser = "c:\Program Files\Log Parser 2.2\LogParser.exe"
$serverName =  $_

if ($serverName -eq $Null) {
	$serverName= $env:COMPUTERNAME
}

Get-DriveSpace $serverName | Export-Csv $env:temp"\temp.csv" -NoTypeInformation
& $logparser "select deviceid, TO_REAL (REPLACE_CHR (percentfree, ',', '.')) as purcentage into chart_$serverName.gif from $env:temp\temp.csv order by deviceID desc" "-o:chart" "-charttype:BarStacked" "-charttitle:Purcentage : FreeSpace by disk              Server:$serverName" "-values:ON" "-categories:ON" "-maxCategoryLabels:100"
Invoke-Item .\"chart_"$serverName".gif"
}
