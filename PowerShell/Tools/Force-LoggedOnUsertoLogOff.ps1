<#
    .NOTES
    ===========================================================================
     Created by:       Murray Wall
     Organization:
     Filename:         Force-LoggedOnUsertoLogOff.ps1
    ===========================================================================
    .DESCRIPTION
        Force the Logged on Console/RDP user to log Off
#>
$computer = $env:COMPUTERNAME #Get Computer Name
$ConsoleUsers = get-wmiobject win32_ComputerSystem | Select-Object Username #Get the console users
if ($consoleusers.username.length -le 2) {
    $queryResults = (qwinsta /server:$computer | ForEach-Object { (($_.trim() -replace "\s+", ",")) } | ConvertFrom-Csv) #Parse the RDP Username
    $ConsoleUser = ($queryresults | Where-Object { $_.sessionname -like "*#*" }).username
    $ConsoleUserID = ($queryresults | Where-Object { $_.sessionname -like "*#*" }).ID
}
Else {
    $queryResults = (qwinsta /server:$computer | ForEach-Object { (($_.trim() -replace "\s+", ",")) } | ConvertFrom-Csv) #Parse the console Usernames
    $ConsoleUser = ($queryresults | Where-Object { $_.sessionname -like "*Console*" }).username|Select-Object -first 1
    $ConsoleUserID = ($queryresults | Where-Object { $_.sessionname -like "*Console*" }).ID
}
if ($consoleUserID) {
    Foreach ($User in $ConsoleUserID) {
        Logoff $User #Force Logged on user to logout
        #Wait for user to log off
        start-sleep 10
    }
}
