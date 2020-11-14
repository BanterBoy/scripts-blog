function Get-FriendlySize {
    param($Bytes)
    $sizes = 'Bytes,KB,MB,GB,TB,PB,EB,ZB' -split ','
    for ($i = 0; ($Bytes -ge 1kb) -and
        ($i -lt $sizes.Count); $i++) { $Bytes /= 1kb }
    $N = 2; if ($i -eq 0) { $N = 0 }
    "{0:N$($N)} {1}" -f $Bytes, $sizes[$i]
}

$DaysPast = 9
$Start = (Get-Date).AddDays(-$DaysPast)
$Path = 'DataPath'
Get-ChildItem -Path $Path -Recurse |
Where-Object { $_.LastWriteTime -ge "$Start" } |
Select-Object Fullname, LastWriteTime, @{N = 'FriendlySize'; E = { Get-FriendlySize -Bytes $_.Length } } |
ConvertTo-Csv |
Out-file -FilePath 'OutputPath\Output.csv'

$error.CategoryInfo.TargetName | Out-File 'OutputPath\SharedDrivePathTooLongException.txt'
