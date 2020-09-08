#Source of files to be archived
$DailySourceFiles = "P:\Testing\FileMove"

#Datefolder output location
$DailyArchiveLocation = "P:\Testing\FileMove\Archive"
$SubtractDays = -1
$FileBeforeHour = 20
$FileBeforeMin = 00
$FileBeforeSec = 00


$YesterdaysDate = (Get-Date).Adddays($SubtractDays).ToString("yyyyMMdd")
$FileBefore = Get-Date -Date (Get-Date).Adddays($SubtractDays) -Hour $FileBeforeHour -Minute $FileBeforeMin -Second -$FileBeforeSec

$DailyFinalLocation = $DailyArchiveLocation + '\' + $YesterdaysDate
 

if ( -not ( Test-Path $DailyFinalLocation ) ) {
    New-Item $DailyFinalLocation -Type Directory
    }


Get-ChildItem -Path $DailySourceFiles |
Where-Object {$_.LastWriteTime -lt $FileBefore -and (!$_.PSIsContainer) } |
Move-Item -Destination $DailyFinalLocation
