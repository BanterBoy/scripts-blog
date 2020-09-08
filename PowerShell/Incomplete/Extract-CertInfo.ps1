# Extract-CertInfo.ps1

# Location of the personal certificates
# Cert:\CurrentUser\My
 
# Location of the local machine certificates
# Cert:\LocalMachine\My
 
# Export Certificate information from both LocalMachine and CurrentUser Certificate stores
# Generates a file on the desktop with the Servers Name
Get-ChildItem -Path 'Cert:\LocalMachine\My' |
Format-List -Property FriendlyName,DnsNameList,Issuer,NotAfter,NotBefore,Thumbprint,Subject |
Out-File -FilePath $HOME\Desktop\Certificates-$env:COMPUTERNAME.txt

Add-Content -Value 'END - Cert:\LocalMachine\My' -Path $HOME\Desktop\Certificates-$env:COMPUTERNAME.txt

Get-ChildItem -Path 'Cert:\CurrentUser\My' |
Format-List -Property FriendlyName,DnsNameList,Issuer,NotAfter,NotBefore,Thumbprint,Subject |
Out-File -FilePath $HOME\Desktop\Certificates-$env:COMPUTERNAME.txt -Append

Add-Content -Value 'END - Cert:\CurrentUser\My' -Path $HOME\Desktop\Certificates-$env:COMPUTERNAME.txt

