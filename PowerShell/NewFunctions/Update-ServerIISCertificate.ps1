<#
    https://lachlanbarclay.net/2022/01/updating-iis-certificates-with-powershell

    Let's say you were in a situation where you had to update a certificate that was installed on a lot of servers. Do you want to do it all manually? Heck no. Let's hack together some powershell to make it work. This code is very loosely based on this one except the typos have been fixed and there's no magic IP addresses :)

    Importing the certificate locally
    Let's get it working locally first. Within a powershell window, let's try a few commands. First off, let's load in our new certificate that we want to install. Assuming that we have a certificate in pfx format that is ready to be imported, let's install it into our certificate store:
#>
function Update-ServerIISCertificate {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/',
        PositionalBinding = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('ts')]
    [OutputType([String])]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cn')]
        [string[]]$ComputerName,

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the Name of the computer you would like to connect to.')]
        [Alias('cfp')]
        [string[]]$certname = "c:\my-certificate.pfx",

        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $true,
            Position = 0,
            HelpMessage = 'Enter the password for the certificate.')]
        [Alias('cp')]
        [string[]]$certpwd
    )

    foreach ($Computer in $ComputerName) {
        <# $Computer is the current item #>
        $session = New-PsSession -ComputerName $Computer
        $importCertificatesCommand = ({
                $newCert = Import-PfxCertificate -FilePath "c:\$($using:certname)" -CertStoreLocation "Cert:\LocalMachine\My" -password $using:pfxpass
                Import-Module Webadministration
                $sites = Get-ChildItem -Path IIS:\Sites
                foreach ($site in $sites) {
                    foreach ($binding in $site.Bindings.Collection) {
                        if ($binding.protocol -eq 'https') {
                            $search = "Cert:\LocalMachine\My\$($binding.certificateHash)"
                            $certs = Get-ChildItem -path $search -Recurse
                            $hostname = hostname
                        
                            if (($certs.count -gt 0) -and 
                            ($certs[0].Subject.StartsWith("CN=MyOldCertificate"))) {
                                Write-Output "Updating $hostname, site: `"$($site.name)`", binding: `"$($binding.bindingInformation)`", current cert: `"$($certs[0].Subject)`", Expiry Date: `"$($certs[0].NotAfter)`""
        
                                $binding.AddSslCertificate($newCert.Thumbprint, "my")
                            }
                        }
                    }
                }
            })
        Invoke-Command -session $session -scriptblock $importCertificatesCommand
    }
    Invoke-command -Session $session { remove-item -path "c:\$($using:certname)" }
}

<#
    Updating IIS to use the new certificate
    Now how about we update one particular binding to use this new certificate:
#>

# load in the admin scripts for doing stuff with IIS:
Import-Module Webadministration

#  fetch the default web site:
$site = Get-ChildItem -Path "IIS:\Sites" | Where-Object -FilterScript { ( $_.Name -eq "Default Web Site" ) }

<#
    You might want to check that your $site variable has the right web site before you proceed. Just run echo $site and it should be pretty obvious.
    Now let's fetch the first SSL binding that is mapped to port 443:
#>

$binding = $site.Bindings.Collection | Where-Object -FilterScript { ( $_.protocol -eq 'https' -and $_.bindingInformation -eq '*:443:') }

# and let's do the magic:
$binding.AddSslCertificate($newCert.Thumbprint, "my")

<#
    BTW, this AddSslCertificate command doesn't seem to be documented anywhere, and in my opinion it's confusingly named - if there's already an SSL certificate assigned to the binding then it will update it to use the new one. But hey, it works:

    Installing certs on multiple servers
    Let's copy the cert to a few servers:
#>

$servers = @('server1', 'server2', 'server3')
$servers | ForEach-Object { Copy-Item -Path $certname -Destination "\\$_\c`$" }

<#
    This will copy the cert into the c:\ drive on the desired servers. Note the extra confusing use of the tilde character which you have to use in powershell to escape a dollar sign in a string!
    Now let's connect to all of these servers and import the certificate:
#>

# Establish a connection to all of those servers:
$session = New-PsSession -ComputerName $servers

$importCertificatesCommand = (
    {
        Import-Module Webadministration
        $newCert = Import-PfxCertificate -FilePath "c:\$($using:certname)" -CertStoreLocation "Cert:\LocalMachine\My" -Password $using:pfxpass
    }
)
Invoke-Command -Session $session -ScriptBlock $importCertificatesCommand

<#
    There's a bunch of magic here. New-PsSession creates a new connection to a remote server, for the supplied list of server names. Invoke-Command executes the desired command against all of the servers that we've opened a connection to, and then we are adding the $using prefix to any variables that we wish to access outside of this command.
    Once that's done, we can delete the certificate off the servers:
#>

Invoke-Command -Session $session { Remove-Item -Path "c:\$($using:certname)" }

#  Things are starting to look good! We have the cert imported, shall we update IIS to use this new certificate across all our servers, if they are using an older certificate that we know is about to expire? Let's update our command:

$importCertificatesCommand = (
    {
        $newCert = Import-PfxCertificate -FilePath "c:\$($using:certname)" -CertStoreLocation "Cert:\LocalMachine\My" -password $using:pfxpass
        Import-Module Webadministration
        $sites = Get-ChildItem -Path IIS:\Sites
        foreach ($site in $sites) {
            foreach ($binding in $site.Bindings.Collection) {
                if ($binding.protocol -eq 'https') {
                    $search = "Cert:\LocalMachine\My\$($binding.certificateHash)"
                    $certs = Get-ChildItem -Path $search -Recurse
                    $hostname = hostname
                    if (($certs.count -gt 0) -and 
                    ($certs[0].Subject.StartsWith("CN=MyOldCertificate"))) {
                        Write-Output "Updating $hostname, site: `"$($site.name)`", binding: `"$($binding.bindingInformation)`", current cert: `"$($certs[0].Subject)`", Expiry Date: `"$($certs[0].NotAfter)`""
                        $binding.AddSslCertificate($newCert.Thumbprint, "my")
                    }
                }
            }
        }
    }
)

