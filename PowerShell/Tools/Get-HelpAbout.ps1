Get-Help about* | 
 Select-Object -Property Name, Synopsis |
 Out-GridView -Title 'Select Topic' -OutputMode Multiple |
 ForEach-Object {
   Get-Help -Name $_.Name -ShowWindow
 }
 