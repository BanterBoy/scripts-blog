function New-SecureSession {
    param (
        [Parameter(ValueFromPipeline = $True,
            HelpMessage = "Enter preferred Server Name, FQDN or IP")]
        [string[]]$ComputerName,
        [string[]]$Username,
        [SecureString[]]$Password
    )
    $Credentials = ($Username, $Password)
    Enter-PSSession -ComputerName $Server -Credential $Credentials -Authentication Negotiate
}

function Remove-SecureSession {
    Get-PSSession | Remove-PSSession
}
