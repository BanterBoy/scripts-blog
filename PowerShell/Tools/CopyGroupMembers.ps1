Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
Add-PSSnapin Quest.ActiveRoles.ADManagement
Clear-Host
write-output "This script helps to add user to all the Groups which other user is memberof.It is can be normally used when new user needs to have all the group membership of the existing users"
write-output " "
write-output " "
$SName = Read-Host "Please Enter the alias name of the source user "
$DName = Read-Host "Please Enter the alias name of the Destination user "

$K = Get-QADUser $SName | Select-Object memberof
foreach($user in $K.memberof) {
    Add-QADGroupMember -Identity $user -Member $DName
}
