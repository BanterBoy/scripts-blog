function Set-APIKey {
    [CmdletBinding()]
    Param
    (
        # VirusToral API Key.
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [string]
        $APIKey,

        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1)]
        [securestring]$MasterPassword

    )

    Begin
    {}
    Process {
        write-verbose -Message "Setting the env variable `$Global:APIKey with the key."
        $Global:APIKey = $APIKey

        $SecureKeyString = ConvertTo-SecureString -String $APIKey -AsPlainText -Force
        
        # Generate a random secure Salt
        $SaltBytes = New-Object byte[] 32
        $RNG = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
        $RNG.GetBytes($SaltBytes)

        $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $MasterPassword

        # Derive Key, IV and Salt from Key
        $Rfc2898Deriver = New-Object System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $Credentials.GetNetworkCredential().Password, $SaltBytes
        $KeyBytes = $Rfc2898Deriver.GetBytes(32)

        $EncryptedString = $SecureKeyString | ConvertFrom-SecureString -key $KeyBytes

        $FolderName = 'APIKey'
        $ConfigName = 'api.key'
        $saltname = 'salt.rnd'
        
        if (!(Test-Path -Path "$($env:AppData)\$FolderName")) {
            Write-Verbose -Message 'Seems this is the first time the config has been set.'
            Write-Verbose -Message "Creating folder $("$($env:AppData)\$FolderName")"
            New-Item -ItemType directory -Path "$($env:AppData)\$FolderName" | Out-Null
        }
        
        Write-Verbose -Message "Saving the information to configuration file $("$($env:AppData)\$FolderName\$ConfigName")"
        "$($EncryptedString)"  | Set-Content  "$($env:AppData)\$FolderName\$ConfigName" -Force
        Set-Content -Value $SaltBytes -Encoding Byte -Path "$($env:AppData)\$FolderName\$saltname" -Force
    }
    End
    {}
}