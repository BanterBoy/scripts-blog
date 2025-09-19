function Get-ADCertificates {
    [CmdletBinding()]
    Param(
        # Optional PSCredential for remote access. If not specified, uses the current user context.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSCredential]$Credential,
        
        # ComputerName(s) to query. Defaults to the local computer.
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        
        # Optional filter: certificates issued on or after this date.
        [Parameter()]
        [AllowNull()]
        [DateTime]$ValidAfter = $null,
        
        # Optional filter: certificates that expire on or before this date.
        [Parameter()]
        [AllowNull()]
        [DateTime]$ValidBefore = $null
    )

    # Define the certificate store locations to scan.
    $storePaths = @("Cert:\LocalMachine\My", "Cert:\CurrentUser\My")

    # Prepare a script block that will run on a target machine.
    $scriptBlock = {
        param(
            [string[]]$storePaths,
            [AllowNull()]
            [DateTime]$ValidAfter,
            [AllowNull()]
            [DateTime]$ValidBefore
        )

        $results = @()
        foreach ($store in $storePaths) {
            try {
                Get-ChildItem -Path $store -ErrorAction Stop | ForEach-Object {
                    $cert = $_

                    # Apply date filters if provided. Use 'continue' to skip current iteration.
                    if ($ValidAfter -and $cert.NotBefore -lt $ValidAfter) {
                        continue
                    }
                    if ($ValidBefore -and $cert.NotAfter -gt $ValidBefore) {
                        continue
                    }

                    # Create a custom PSObject with expanded certificate details.
                    $results += [PSCustomObject]@{
                        ComputerName       = $env:COMPUTERNAME
                        StoreLocation      = $store
                        Subject            = $cert.Subject
                        Issuer             = $cert.Issuer
                        NotBefore          = $cert.NotBefore
                        NotAfter           = $cert.NotAfter
                        Thumbprint         = $cert.Thumbprint
                        FriendlyName       = $cert.FriendlyName
                        SerialNumber       = $cert.SerialNumber
                        Version            = $cert.Version
                        HasPrivateKey      = $cert.HasPrivateKey
                        SignatureAlgorithm = $cert.SignatureAlgorithm.FriendlyName
                    }
                }
            }
            catch {
                Write-Warning "Could not access store $store on $env:COMPUTERNAME: $_"
            }
        }
        return $results
    }

    $allResults = @()
    foreach ($computer in $ComputerName) {
        if ($computer -eq $env:COMPUTERNAME) {
            # Local query.
            $results = & $scriptBlock -storePaths $storePaths -ValidAfter $ValidAfter -ValidBefore $ValidBefore
            $allResults += $results
        }
        else {
            # Remote query using Invoke-Command.
            try {
                $sessionParams = @{
                    ComputerName = $computer
                    ScriptBlock  = $scriptBlock
                    ArgumentList = @($storePaths, $ValidAfter, $ValidBefore)
                }
                if ($Credential) {
                    $sessionParams.Credential = $Credential
                }
                $results = Invoke-Command @sessionParams -ErrorAction Stop
                $allResults += $results
            }
            catch {
                # Use $($computer) to clearly expand the variable if desired.
                Write-Warning "Error connecting to $($computer): $_"
            }
        }
    }

    # Output all the collected certificate details.
    return $allResults
}

<# 
    Example usage:

    # Retrieve all certificate details on the local computer:
    Get-ADCertificates

    # Retrieve certificate details from remote computers using credentials:
    $cred = Get-Credential
    Get-ADCertificates -Credential $cred -ComputerName "Server01", "Server02"

    # Retrieve certificate details with validity dates filtered:
    Get-ADCertificates -ValidAfter (Get-Date "2023-01-01") -ValidBefore (Get-Date "2025-12-31")

    # Filter the output for certificates issued by a particular CA:
    Get-ADCertificates | Where-Object { $_.Issuer -like "*YourCAName*" }
#>
