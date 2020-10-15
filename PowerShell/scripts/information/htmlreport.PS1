$head = @'
<style>
 BODY{font-family:Verdana; background-color:lightblue;}
 TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
 TH{font-size:1em; border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:#FFCCCC}
 TD{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:white}
</style>
'@
$header = "<H1>Reporting Running Software</H1>"
$title = "Example HTML Output"

Get-Process | Sort-Object Company | Where-Object { $_.Product -ne $null  } | Select-Object Company, Product, FileVersion | ConvertTo-HTML -head $head -body $header -title $title | Out-File $env:temp\report.htm
& "$env:temp\report.htm"
