function Get-NTPStatusFromHost {  
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
        [string[]]
        $ComputerName
    )
    Process {
        Write-Output "NTP Source for $ComputerName"
        w32tm /query /computer:$ComputerName /source           
    }
}

$ADQuery = Get-ADComputer -Filter { Name -like '*' } -Properties *
$ServerList = $ADQuery |
Sort-Object -Property Name |
Select-Object Name, OperatingSystem, DistinguishedName |
Where-Object { ( $_.OperatingSystem -like 'Windows Server*' ) -and ( $_.DistinguishedName -like '*Server*' ) }

foreach ( $Server in $ServerList ) {
    $TestServer = Test-ComputerAvailability -Servers $Server.Name
    if ($TestServer.Pingable -eq $true) {
        Get-NTPStatusFromHost -ComputerName $Server.Name
    }
    else {
        Write-Warning -Message "$($Server.Name) is Unavailable"
    }
}
