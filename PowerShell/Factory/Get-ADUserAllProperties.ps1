$Users = Get-AdUser -Filter 'Name -like "luke leigh*"' -Properties *
foreach ($User in $Users) {
    Select-Object -Property Name,MemberOf
}
