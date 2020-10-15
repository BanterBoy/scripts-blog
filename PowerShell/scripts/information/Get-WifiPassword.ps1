Function Get-WifiPassword {
    netsh wlan show profiles |
        Select-Object -Skip 7 |
        Where-Object -FilterScript { ( $_ -like '*:*' ) } |
        ForEach-Object -Process {
        $NetworkName = $_.Split(':')[-1].trim()
        $PasswordDetection = $( netsh wlan show profile name="$NetworkName" key=clear ) |
            Where-Object -FilterScript { ( $_ -like "*key content*" )
        }
        New-Object -TypeName PSObject -Property @{
            NetworkName = "$NetworkName"
            Password    = if ($PasswordDetection) {$PasswordDetection.Split(':')[-1].Trim()}else {'Unavailable'}
        } -ErrorAction SilentlyContinue
    }
}
