$Users = ForEach ($U in (Get-ADUser -Filter {Enabled -eq "True"}))
{
	$UN = Get-ADUser $U -Properties MemberOf
	$Groups = ForEach ($Group in ($UN.MemberOf))
	{
		(Get-ADGroup $Group).Name
	}
	$Groups = $Groups | Sort-Object
	ForEach ($Group in $Groups)
	{
		New-Object PSObject -Property @{
		Name = $UN.Name
		Group = $Group
		}
	}
}
$Users | Export-Csv c:\temp\ACMList.csv
