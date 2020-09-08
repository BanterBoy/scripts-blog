$groups = Get-ADGroup -Filter * | Select-Object Name
foreach ($group in $groups) {
    $users = Get-ADGroupMember -Identity "$group.name" | Select-Object Name
    foreach($user in $users){
        try {
            $properties = @{
                Group = "$group.name"
                User = "$user.name"
            }
        }
        catch {
            $properties = @{
                Group = "$group.name"
                User = "$user.name"
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj | ConvertTo-Json | Out-File C:\exported-data.json -Append
        }
    }
}
