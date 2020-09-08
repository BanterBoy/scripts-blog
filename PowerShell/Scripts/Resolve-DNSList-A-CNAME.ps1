$Records = New-Object System.Collections.ArrayList
$Records.AddRange(
    (
		"domain.com",
		"domain.net",
		"domain.org"
    )
)
foreach ($Record in $Records) {
    Try {
        Resolve-DnsName -Name $Record -Type A -Server 8.8.8.8 -ErrorAction Stop
    }
    Catch [System.Exception] {
        Write-Verbose "$Record not found!" -Verbose
    }
    Catch {
        Write-Verbose "Catch all" -Verbose
    }
}

$Records = New-Object System.Collections.ArrayList
$Records.AddRange(
    (
		"domain.com",
		"domain.net",
		"domain.org"
    )
)
foreach ($Record in $Records) {
    Try {
        Resolve-DnsName -Name $Record -Type CNAME -Server 8.8.8.8 -ErrorAction Stop | Format-Table
    }
    Catch [System.Exception] {
        Write-Verbose "$Record not found!" -Verbose
    }
    Catch {
        Write-Verbose "Catch all" -Verbose
    }
}

