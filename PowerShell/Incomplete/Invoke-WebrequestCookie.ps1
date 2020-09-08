$downloadToPath = "c:\somewhere\on\disk\file.zip"
$remoteFileLocation = "http://somewhere/on/the/internet"

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

$cookie = New-Object System.Net.Cookie 

$cookie.Name = "cookieName"
$cookie.Value = "valueOfCookie"
$cookie.Domain = "domain.for.cookie.com"

$session.Cookies.Add($cookie);

Invoke-WebRequest $remoteFileLocation -WebSession $session -TimeoutSec 900 -OutFile $downloadToPath
