$O365user = New-FakeADUserDetails -Nationality GB -PassLength 14 -Quantity 10 -Email "leigh-services.com"
$O365user | New-FakeADUser
$O365user | Format-Table -Property * -AutoSize -Wrap

$OnPremUser = New-FakeADUserDetails -Nationality GB -PassLength 14 -Quantity 10
$OnPremUser | New-FakeADUser
$OnPremUser | Format-Table -Property * -AutoSize -Wrap


Source RemoteAccess ID 20250, 20275

RemoteAccess 20249, 20250, 20271, 20272, 20274, 20275

Microsoft-Windows-RasRoutingProtocols/Config,System


Get-WinEvent -LogName System -ComputerName REMOTE01 | Where-Object { ( $_.Id -like '20249' ) -or ( $_.Id -like '20250' ) -or ( $_.Id -like '20271' ) -or ( $_.Id -like '20272' ) -or ( $_.Id -like '20274' ) -or ( $_.Id -like '20275' ) }


$StartTime = (Get-Date).AddDays(-30)
$EndTime = Get-Date
$Events = Get-WinEvent -ComputerName REMOTE01 -FilterHashTable @{LogName='System';ID='20249','20250','20271','20272','20274','20275';StartTime=$StartTime;EndTime=$EndTime}

$Events |
Where-Object {  ( $_.Message -like '*VENTRICA\*' ) -and ( $_.Message -like '*connected*' ) -or ( $_.Message -like '*disconnected*' ) } |
Select-Object -Property Message |
Format-Table -Wrap
