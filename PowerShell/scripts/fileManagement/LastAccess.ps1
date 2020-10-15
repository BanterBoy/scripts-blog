$StartDate = (Get-Date).AddDays(-730)
$Location = "D:\Shares\Images"
Get-ChildItem -Path $Location -Recurse |
Where-Object { $_.LastAccessTime -le $StartDate } |
Select-Object Directory,Name,LastAccessTime |
Out-File "D:\lastaccess.txt"
