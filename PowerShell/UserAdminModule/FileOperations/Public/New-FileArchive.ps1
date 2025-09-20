$SourceFiles = Get-ChildItem -Path "D:\TEST"
foreach ($Source in $SourceFiles){
	$ArchiveLocation = "D:\TEST\Archive"
	$SubtractDays = -1
	$FileBeforeHour = 20
	$FileBeforeMin = 00
	$FileBeforeSec = 00
	$ArchiveDate = $Source.LastWriteTime.ToString("yyyyMMdd")
	$FileBefore = Get-Date -Date (Get-Date).Adddays($SubtractDays) -Hour $FileBeforeHour -Minute $FileBeforeMin -Second -$FileBeforeSec
	$FinalLocation = $ArchiveLocation + '\' + $ArchiveDate
	if ( -not ( Test-Path $FinalLocation ) ) {
		New-Item $FinalLocation -Type Directory
	}
	$Source |
	Where-Object {$_.LastWriteTime -lt $FileBefore -and (!$_.PSIsContainer) } |
	Move-Item -Destination $FinalLocation
}
# (Get-Date).Adddays($SubtractDays).ToString("yyyyMMdd")
