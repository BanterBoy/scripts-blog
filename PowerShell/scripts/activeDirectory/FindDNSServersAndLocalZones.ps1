<#
  This script will find all Windows servers with the DNS Server service installed,
  report on it's state and any local zones files (non-Active Directory integrated).

  Note that for servers we filter out Cluster Name Objects (CNOs) and
  Virtual Computer Objects (VCOs) by checking the objects serviceprincipalname
  property for a value of MSClusterVirtualServer. The CNO is the cluster
  name, whereas a VCO is the client access point for the clustered role.
  These are not actual computers, so we exlude them to assist with
  accuracy.

  Script Name: FindDNSServersAndLocalZones.ps1
  Release 1.0
  Written by Jeremy@jhouseconsulting.com 10/01/2014

#>

#-------------------------------------------------------------
# Get the script path
$ScriptPath = { Split-Path $MyInvocation.ScriptName }
$OnlineFile = $(&$ScriptPath) + "\DNSServers-online.csv"
$OfflineFile = $(&$ScriptPath) + "\DNSServers-offline.csv"

#-------------------------------------------------------------

Import-Module ActiveDirectory 

# Get Domain Controllers
#$Computers = Get-ADDomainController -Filter * | Sort-Object Name

# Get All Servers filtering out Cluster Name Objects (CNOs) and Virtual computer Objects (VCOs) 
$Computers = Get-ADComputer -Filter * -Properties Name, Operatingsystem, servicePrincipalName | Where-Object { ($_.Operatingsystem -like '*server*') -AND !($_.serviceprincipalname -like '*MSClusterVirtualServer*') } | Sort-Object -Property Name

#-------------------------------------------------------------

$onlinearray = @()
$offlinearray = @()

$Count = 0
$Count = $Computers.Count

Write-Host -ForegroundColor Green "There are $Count servers to process.`n"

foreach ($Computer in $Computers) {
    $ComputerError = "$false"
    $ComputerName = $Computer.Name
    if (Test-Connection -Cn $Computer.Name -BufferSize 16 -Count 1 -ea 0 -quiet) {
        Write-Host -ForegroundColor Green "Checking for DNS Server service on $ComputerName"
        $ServiceName = "DNS"
        try {
            $serviceObj = Get-Service -ComputerName $ComputerName | Where-Object { $_.ServiceName -eq $serviceName } | Select-Object Name, Status
            if ($null -ne $serviceObj) {
                if ($serviceObj.Status -eq "Running") {
                    Write-Host -ForegroundColor green "- Service found in a $($serviceObj.Status) state."
                }
                else {
                    Write-Host -ForegroundColor red "- Service found in a $($serviceObj.Status) state."
                }
                # Path to DNS
                $path = "\\$ComputerName\admin$\System32\dns"
                # Testing the $path
                if ((Test-Path -Path $path) -and ($null -ne (Get-Item -Path $path).Length)) {

                    if ((Get-ChildItem "$path\*.dns" -Exclude "CACHE.DNS" | Measure-Object).Count -gt 0) {
                        # Get all zone file (*.dns) and exclude the CACHE.DNS file.
                        Write-Host -ForegroundColor yellow "- Local zones files found."
                        $ZoneFiles = Get-ChildItem "$path\*.dns" -Exclude "CACHE.DNS"
                        $LocalZones = ""
                        foreach ($ZoneFile in $ZoneFiles) {
                            if ($LocalZones -eq "" ) {
                                $LocalZones = $ZoneFile.Name
                            }
                            else {
                                $LocalZones = $LocalZones + ";" + $ZoneFile.Name
                            }
                        }
                    }
                    else {
                        Write-Host -ForegroundColor yellow "- No local zones files found."
                        $LocalZones = "none found."
                    }
                }
                else {
                    $ComputerError = "$true"
                    $ErrorDescription = "Not reachable via the $path path."
                    Write-Host -ForegroundColor Red "- $ErrorDescription"
                }
                $output = New-Object PSObject
                $output | Add-Member NoteProperty -Name "ComputerName" $ComputerName
                $output | Add-Member NoteProperty -Name "Service" $serviceObj.Name
                $output | Add-Member NoteProperty -Name "Status" $serviceObj.Status
                $output | Add-Member NoteProperty -Name "LocalZoneFiles" $LocalZones
                $onlinearray += $output
            }
            else {
                Write-Host -ForegroundColor yellow "- $ServiceName service not installed"
            }
        }
        catch {
            $ComputerError = "$true"
            $ErrorDescription = "Error connecting using the Get-Service cmdlet."
            Write-Host -ForegroundColor Red "- $ErrorDescription"
        }
    }
    else {
        $ComputerError = "$true"
        $ErrorDescription = "Unable to ping server"
        Write-Host -ForegroundColor Red "$ComputerName is offline"
    }
    if ($ComputerError -eq $true) {
        $outputbad = New-Object PSObject
        $outputbad | Add-Member NoteProperty ComputerName $ComputerName
        $outputbad | Add-Member NoteProperty ErrorDescription $ErrorDescription
        $offlinearray += $outputbad
    }
}
$onlinearray | Export-Csv -notype "$OnlineFile"
$offlinearray | Export-Csv -notype "$OfflineFile"

# Remove the quotes
(Get-Content "$OnlineFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$OnlineFile" -Force -Encoding ascii
(Get-Content "$OfflineFile") | ForEach-Object { $_ -replace '"', "" } | Out-File "$OfflineFile" -Force -Encoding ascii
