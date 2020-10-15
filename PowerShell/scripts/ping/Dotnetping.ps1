<#
.SYNOPSIS
Pings a host


.DESCRIPTION
This script takes a target IP address or hostname and pings it, providing the source IP address the stack uses to ping that host. If the DNS server 
returns multiple records, it will ping them all. Note that this script uses the [System.Net.Dns]::GetHostAddresses
function, this returns an array of IP addresses. If you want access to the complete DNS record objects, it is recommended 
that you use the Resolve-DnsName cmdlet. This script outputs 2 objects, the ping results and the ping statistics.  

.PARAMETER Destination
The target IP address or hostname to ping.

.PARAMETER Pings
The number of pings to attempt, default is 1.

.NOTES
Requires Windows 8 or later.

#>

param( 

    [Parameter(Position = 0, Mandatory = $True)][string]$Destination,
    [Parameter(Position = 1, Mandatory = $False)][int]$Pings = 1)

####################################
#Set the time between pings, in Milliseconds
$TimeBetweenPings = 50

function CreateResultObject() {
    $IndResult = New-Object PSObject -Property @{
        RemoteIPAddress = "";
        LocalIPAddress  = "";
        Size            = "0";
        TTL             = "0";
        RTT             = "0";
        Status          = "0";
    }
    Return $IndResult
}

function CreateStatsObject() {
    $StatsObject = New-Object PSObject -Property @{
        DestIPAddress = "";
        Sent          = "";
        Received      = "0";
        Lost          = "0";
        MinRtt        = "0";
        MaxRtt        = "0";
        AvgRtt        = "0";
    }
    Return $StatsObject
}

function CalculateStats() {

    ####################################
    #Initialize variables to track/calculate statistics
    $TempStatsObj = CreateStatsObject
    $Item = CreateResultObject
    $PingSuccess = 0
    $PingFailure = 0
    $PingMinRtt = 0
    $PingMaxRtt = 0
    $PingAverage = 0

    foreach ($Item in $TempObjectArray) {
        ####################################
        #Track the total successful pings
        if ($Item.Status -eq "Success") {
            $PingSuccess++

            if ($Item.RTT -eq "<1") {
                $TempItem = 1
            }
            else {
                $TempItem = $Item.RTT
            }
            
            $PingAverage = $PingAverage + $TempItem
            if ($TempItem -le $PingMinRtt) {
                $PingMinRtt = $TempItem
            }
            if ($TempItem -gt $PingMaxRtt) {
                $PingMaxRtt = $TempItem
            }
        }
        ####################################
        #Track the total unsuccessful pings
        else {
            $PingFailure++
        }
    }
    
    ####################################
    #Calculate the statistics
    $TempStatsObj.Received = $PingSuccess
    $TempStatsObj.Lost = $PingFailure
    if ($PingSuccess -gt 0) {
        $PingAverage = $PingAverage / $PingSuccess
        $TempStatsObj.AvgRtt = [System.Math]::Round($PingAverage, 2)
        if ($PingMinRtt -eq 0) {
            $TempStatsObj.MinRtt = "<1"
        }
        else {
            $TempStatsObj.MinRtt = $PingMinRtt
        }
        $TempStatsObj.MaxRtt = $PingMaxRtt
    }
    ####################################
    #Don't Calculate the statistics if there were no successful pings
    if ($PingSuccess -eq 0) {
        $TempStatsObj.MinRtt = $Null
        $TempStatsObj.MaxRtt = $Null
        $TempStatsObj.AvgRtt = $Null
    }

    Return $TempStatsObj
}

function UpdateStats() {
    $StatsObjectArray = $StatsObjectArray + $NewStats
}

function SendPing($Destination) {
    $TempResult = CreateResultObject;
    $TempResult.RemoteIPAddress = $Destination

    ####################################
    #Send the ping
    try {
        $Result = $IcmpRequest.send($Destination)
        ####################################
        #The amount of time to wait between pings
        Start-Sleep -Milliseconds $TimeBetweenPings
    }
    catch [System.Management.Automation.MethodException] {
        #If result is null record a general failure, this is handled below
    }

    ####################################
    #If a result was observed, record it
    if ($Result) {
        $TempResult.Size = $Result.Buffer.Length
        $TempResult.TTL = $Result.Options.TTL
        $TempResult.Status = $Result.Status

        if ($Result.Status -eq "Success") {
            $TempResult.RTT = $Result.RoundtripTime
            if ($Result.RoundtripTime -eq 0) {
                $TempResult.RTT = "<1"
            }
        }
        
        if ($Result.Status -ne "Success") {
            $TempResult.RTT = $Null
            $TempResult.Size = $Null
        }
        if ($Null -ne $Result.Address) {
            $TempResult.RemoteIPAddress = $Result.Address.ToString()
        }
    }
    
    ####################################
    #If a result was not observed, record it
    if (!$Result) {
        $TempResult.Status = "GeneralFailure"
        $TempResult.RTT = $Null
        $TempResult.Size = $Null
        $TempResult.TTL = $Null
    }

    ################################################
    #Query the IP stack to calculate the source address of the ping.

    if ($TempResult.Status -ne "GeneralFailure") {
        try {
            $UdpClient = new-object System.Net.Sockets.UdpClient($Destination, 6000)
            $LocalAddress = $UdpClient.Client.LocalEndPoint
            if ($UdpClient.Client.LocalEndPoint.AddressFamily -eq "InterNetwork") {
                $LocalAddress = $LocalAddress.ToString()
                $TempAddress = $LocalAddress.Split(":")
                $TempResult.LocalIPAddress = [string]$TempAddress[0]
            }

            if ($UdpClient.Client.LocalEndPoint.AddressFamily -eq "InterNetworkV6") {
                $LocalAddress = $LocalAddress.ToString()
                $TempAddress = $LocalAddress.Split("]")
                $LocalAddress = [string]$TempAddress[0]
                $TempAddress = $LocalAddress.Split("[")
                $TempResult.LocalIPAddress = [string]$TempAddress[1]
            }
        }
        catch {
            $LocalAddress = ""
        }
        finally {
            if ($UdpClient) {
                $UdpClient.Close()
            }
        }
    }

    Return $TempResult
}

####################################
#Initialize an array of ping results
$TempObjectArray = @()
$ResultObjectArray = @()
$StatsObjectArray = @()

####################################
#Initialize ICMP request and address variables
$IcmpRequest = New-Object System.Net.NetworkInformation.Ping
$Address = [System.Net.IPaddress]"0.0.0.0"

####################################
#Ensure valid IP address input
$InputIsAlreadyIPAddress = [System.Net.IPaddress]::TryParse($Destination, [ref]$Address)

####################################  
#If Address is input, then ping that address

function PingTargetAddresses {

    ####################################    
    #If something other than an address is input, check DNS names. 
    #Prepare to ping them all if it is valid

    if (!$InputIsAlreadyIPAddress) {
        ####################################    
        #Initialize array to handle DNS results
        $DestIPAddresses = @()

        ####################################    
        #Query DNS
        try {
            Write-Progress "Querying DNS"
            $DestIPAddresses = [System.Net.Dns]::GetHostAddresses($Destination)
            #Note that the Resolve-DnsName cmdlet could be used instead:
            #$DestIPAddresses = (Resolve-DnsName $Destination -ErrorAction "SilentlyContinue").IPAddress
        }
        catch [System.Net.Sockets.SocketException] {
            #If no destination IP addresses are returned, this is handled below. 
        }

        ####################################    
        #If DNS query fails
        if (!$DestIPAddresses) {
            Write-Host "DotNetPing could not find host $Destination. Please check the name and try again."
            Exit(1)
        }
    }

    else {
        $DestIPAddresses = @($Destination)
    }

    ####################################    
    #Calculate the number of pings to send and track them
    $NumAddresses = $DestIPAddresses.Length - 1
    $TotalPings = ($DestIPAddresses.Length) * $Pings
    $PingTracker = 0

    while ($NumAddresses -ne -1) {
        for ($i = 0; $i -lt $Pings; $i++) {
            ####################################    
            #Send each ping, record the result and show progress
            $TempAddress = $DestIPAddresses[$NumAddresses]
            $NewResult = SendPing($TempAddress)
            $NewResult # Output for pipeline to print
            $TempObjectArray = $TempObjectArray + @($NewResult)

            $PercentComplete = [decimal](($PingTracker / $TotalPings) * 100)
            $PercentComplete = [System.Math]::Round($PercentComplete, 2)
            Write-Progress -activity "Pinging $Destination `[$TempAddress`]" -status "Percent complete: $PercentComplete%" -percentComplete $PercentComplete
            $PingTracker++
        }

        ####################################    
        #Organize the results and track the statistics  
        $TempStatsObj = CalculateStats([array[]]$TempObjectArray)
        $TempStatsObj.DestIPAddress = $DestIPAddresses[$NumAddresses]
        $TempStatsObj.Sent = $Pings
        $TempStatsObj.Received = ($Pings - $TempStatsObj.Lost)
            
        #Note reference StatsObjectArray at script-level scope
        $script:StatsObjectArray = $script:StatsObjectArray + $TempStatsObj
        $ResultObjectArray = $ResultObjectArray + $TempObjectArray
        $TempObjectArray = @()
        $NumAddresses--
    }
}

####################################    
#Print results in a table
PingTargetAddresses | Format-Table @{Expression = { $_.LocalIPAddress }; Label = "Local IP Address"; width = 41 },
@{Expression = { $_.RemoteIPAddress }; Label = "Remote IP Address"; width = 41 },
@{Expression = { $_.Size }; Label = "Size(Bytes)"; width = 12 },
@{Expression = { $_.RTT }; Label = "Time(ms)"; width = 9; alignment = "right" },
@{Expression = { $_.TTL }; Label = "TTL"; width = 6 },
@{Expression = { $_.Status }; Label = "Status"; width = 18 }

####################################   
#Add the statistics
Write-Host "Ping Statistics:"
$StatsObjectArray | Format-Table @{Expression = { $_.DestIPAddress }; Label = "Remote IP Address"; width = 42 }, 
@{Expression = { $_.Sent }; Label = "Sent"; width = 6 },
@{Expression = { $_.Received }; Label = "Received"; width = 9 },
@{Expression = { $_.Lost }; Label = "Lost"; width = 6 },
@{Expression = { $_.MinRtt }; Label = "MinRtt"; width = 7; alignment = "right" },
@{Expression = { $_.MaxRtt }; Label = "MaxRtt"; width = 7 },
@{Expression = { $_.AvgRtt }; Label = "AvgRtt"; width = 7 }

####################################   
#Clean-up
$ResultObjectArray = @()
$StatsObjectArray = @()
