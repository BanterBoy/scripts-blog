$Names = Resolve-DnsName $env:USERDNSDOMAIN
foreach ($Name in $Names){
    ping $Name.IPAddress
    }

