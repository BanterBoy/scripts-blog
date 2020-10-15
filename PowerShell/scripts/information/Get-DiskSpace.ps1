[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$computer = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the ComputerName ", "ComputerName ")

Get-WMIobject win32_LogicalDisk -computername $computer -filter "DriveType=3" | 
Select-Object SystemName,DeviceID,@{Name="DriveCapacity";Expression={"{0:N1}" -f($_.size/1gb)}},`
@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}},`
@{Name="% FreeSpace(GB)";Expression={"{0:N2}%" -f(($_.freespace/$_.size)*100)}}

