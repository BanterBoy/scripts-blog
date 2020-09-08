$dict = @{}
$SearchPath = Read-Host 'Enter Folder path to be searched'
$Extension = Read-Host 'Enter File Extension (e.g. *.doc)'

Get-ChildItem -Path $SearchPath -Filter $Extension -Recurse |
    ForEach-Object {
    $hash = ($_ | Get-FileHash -Algorithm MD5).Hash
    if ($dict.ContainsKey($hash)) {
        [PSCustomObject]@{
            Original  = $dict[$hash]
            Duplicate = $_.FullName
        }
    }
    else {
        $dict[$hash] = $_.FullName
    }
} |
    Out-GridView