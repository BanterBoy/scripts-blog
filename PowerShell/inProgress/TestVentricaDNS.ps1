$VentricaDNS = Get-Content .\Ventrica\NewWork\ventrica-dns-entries.csv | ConvertFrom-Csv

foreach ($entry in $VentricaDNS) {
    if ($entry.recordname -eq '@') {
        $record = $entry.recordname + ".ventrica.co.uk"
        Resolve-DnsName -Name $record -Type $entry.type
    }
}
