# Needed in a script when trying to use an HTTPS URL

$AllProtocols = [Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[Net.ServicePointManager]::SecurityProtocol = $AllProtocols
