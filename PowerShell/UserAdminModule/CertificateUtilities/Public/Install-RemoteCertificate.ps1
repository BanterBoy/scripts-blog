function Install-RemoteCertificate {

    <#
    .SYNOPSIS
        Installs a certificate on a remote computer.
    .DESCRIPTION
        This function installs a certificate on a remote computer using a PSSession.
    .PARAMETER ComputerName
        Specifies the name of the remote computer on which to install the certificate.
    .PARAMETER Credential
        Specifies the credentials to use to authenticate the user on the remote computer.
    .PARAMETER PassString
        Specifies the password for the certificate file.
    .PARAMETER CertFilePath
        Specifies the path to the certificate file on the remote computer.
    .EXAMPLE
        Install-RemoteCertificate -ComputerName "RemoteComputer" -Credential $cred -PassString "password" -CertFilePath "C:\certificates\cert.pfx"
        Installs the certificate located at "C:\certificates\cert.pfx" on the remote computer "RemoteComputer" using the specified credentials and password.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default', supportsShouldProcess = $true, HelpUri = 'https://github.com/BanterBoy')]
    [OutputType([string])]
    param
    (
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cn')]
        [string]$ComputerName,
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter computer name or pipe input')]
        [Alias('cred')]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter computer name or pipe input')]
        [ValidateNotNullOrEmpty()]
        [string]$PassString,
        [Parameter(ParameterSetName = 'Default', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter the certificate Local file path, where it is located on the remote Server')]
        [ValidateNotNullOrEmpty()]
        [string]$CertFilePath
    )
    PROCESS {
        if ($PSCmdlet.ShouldProcess("$ComputerName", "Install Certificate")) {
            try {
                Write-Verbose "Creating PSSession to $ComputerName"
                $PSSession = New-PSSession -ComputerName $ComputerName -Credential $Credential -Name "Certificate Install Session" -EnableNetworkAccess -ConfigurationName Microsoft.PowerShell -Authentication Kerberos
                Write-Verbose "Checking if certificate file exists at $CertFilePath"
                $fileExists = Invoke-Command -Session $PSSession -ScriptBlock { param($CertFilePath) Test-Path -Path $CertFilePath } -ArgumentList $CertFilePath
                if (-not $fileExists) {
                    Write-Error "Certificate file does not exist at path: $CertFilePath"
                    return
                }
                Write-Verbose "Invoking command to install certificate"
                Invoke-Command -Session  $PSSession -ScriptBlock { param($PassString, $CertFilePath)
                    try {
                        Write-Verbose 'Converting PassString to SecureString'
                        $crtPwd = ConvertTo-SecureString -String $PassString -AsPlainText -Force
                        Write-Verbose 'Importing Pfx Certificate'
                        Import-PfxCertificate -FilePath $CertFilePath -CertStoreLocation Cert:\LocalMachine\My -Password $crtpwd -ErrorAction Stop
                        Write-Output 'Certificate Installed'
                    }
                    catch {
                        Write-Error "Failed to install certificate: $_"
                    }
                } -ArgumentList $PassString, $CertFilePath
            }
            catch {
                Write-Error "Failed to create PSSession or invoke command: $_"
            }
            finally {
                Write-Verbose "Removing PSSession"
                if ($PSSession) {
                    Remove-PSSession -Session $PSSession
                }
            }
        }
    }
    END {
    }
}
