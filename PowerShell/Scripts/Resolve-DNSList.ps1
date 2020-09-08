
$IPs = New-Object System.Collections.ArrayList

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$ips = Import-Csv "$scriptDir\resources\IPList.csv"

# $IPs.AddRange(
#     (
#         "172.16.5.0",
#         "172.16.5.1",
#         "172.16.5.2",
#         "172.16.5.3",
#         "172.16.5.4",
#         "172.16.5.5",
#         "172.16.5.6",
#         "172.16.5.7",
#         "172.16.5.8",
#         "172.16.5.9",
#         "172.16.5.10",
#         "172.16.5.11",
#         "172.16.5.12",
#         "172.16.5.13",
#         "172.16.5.14"

#     )
# )

foreach ($IP in $IPs) {
    try {
        Resolve-DnsName -Name $IP.ip -Type PTR -ErrorAction Stop
    }
    catch {
        Write-Warning -Message "$IP.ip - DNS name does not exist"
    }
}
