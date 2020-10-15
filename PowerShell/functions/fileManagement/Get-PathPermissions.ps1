function Get-PathPermissions {
 
    param (
        [Parameter(
            Mandatory = $true)]
        [System.String]
        ${Path}
    )
 
    begin {
        $root = Get-Item $Path
        ($root | Get-Acl).Access | Add-Member -MemberType NoteProperty -Name "Path" -Value $($root.fullname).ToString() -PassThru
    }
    process {
        $containers = Get-ChildItem -path $Path -recurse | Where-Object { $_.psIscontainer -eq $true }
        if ($null -eq $containers) { break }
        foreach ($container in $containers) {
            (Get-ACL $container.fullname).Access | Where-Object { $_.IsInherited -eq $false } | Add-Member -MemberType NoteProperty -Name "Path" -Value $($container.fullname).ToString() -PassThru
        }
    }
}
