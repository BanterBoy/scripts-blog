param 
(
    [Parameter(Mandatory)]$City
)

$weather = Invoke-WebRequest -Uri "http://wttr.in/$City"
$text = $weather.ParsedHtml.body.outerText
$text

# Example : Get-Weather.ps1 -City 'Southend-on-Sea'
