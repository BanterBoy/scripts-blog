# Download Json.NET
# Popular high-performance JSON framework for .NET
# https://www.newtonsoft.com/json
# https://www.jesusninoc.com/02/11/convert-xml-to-json-powershell/

# Adds a Microsoft .NET Framework type (a class) to a Windows PowerShell session
Add-Type -Path C:\Users\juan\Desktop\Automatizacion\Windows\packages\Newtonsoft.Json.9.0.1\lib\net45\Newtonsoft.Json.dll

[XML]$members = '<?xml version="1.0"?>
<members>
	<member id="1">
		<user>juanito</user>
		<group>ventas</group>
	</member>
	<member id="2">
		<user>luis</user>
		<group>ventas</group>
	</member>
</members>'

$json = [Newtonsoft.Json.JsonConvert]::SerializeXmlNode($members) | ConvertFrom-Json

$json.members.member | %{
    $_.user
    $_.group
}

