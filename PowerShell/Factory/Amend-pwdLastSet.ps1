Set-ADUser "ADUserName" -Replace @{pwdLastSet='0'}
Get-ADUser "ADUserName" -Properties PasswordExpired | Select-Object PasswordExpired


$users = Get-ADUser -Filter {name -like '*' } -Properties *
foreach($user in $users){ Set-ADUser -Replace @{pdwLastSet='0' -whatif }
