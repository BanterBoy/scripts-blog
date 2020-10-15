function Get-ExchangeServer {
    param
    (
        [switch]$mailbox,
        [switch]$CAS,
        [switch]$UM,
        [switch]$hub,
        [switch]$edge,
        [switch]$getAll
    )

    $roleMask += 2 * [boolean]$mailbox
    $roleMask += 4 * [boolean]$CAS
    $roleMask += 16 * [boolean]$UM
    $roleMask += 32 * [boolean]$hub
    $roleMask += 64 * [boolean]$edge

    $configNamingContext = (("CN=Configuration," + (Get-ADDomain).distinguishedname))
    $exchangeServers = (Get-ADObject -SearchBase $configNamingContext -Filter {objectclass -eq "msExchExchangeServer"} -properties msexchcurrentserverroles)
    $exchangeServers = $exchangeServers | Where-Object {($_.msexchcurrentserverroles -band $roleMask) -eq $roleMask}

    [array]$exchangeServers = $exchangeServers | Select-Object -ExpandProperty name
    if (!$getAll) {
        $exchangeServers = $exchangeServers[0]
    }
    Write-Output ($exchangeServers)
}
