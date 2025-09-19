function Get-WTFismyIP {
    [CmdletBinding()]

    param (
        [Parameter(Mandatory = $false, HelpMessage = "Return the result as an object")]
        [switch] $AsObject,

        [Parameter(Mandatory = $false, HelpMessage = "Be polite")]
        [switch] $Polite,

        [Parameter(Mandatory = $false, HelpMessage = "Timeout in seconds")]
        [int] $TimeoutSeconds = 5
    )
    
    begin { }
    
    process {
        try {
            $WTFismyIP = Invoke-RestMethod -Method Get -Uri "https://wtfismyip.com/json" -TimeoutSec $TimeoutSeconds

            if ($AsObject.IsPresent) {
                return $WTFismyIP
            }

            $fucking = $polite.IsPresent ? "" : "Fucking"

            $properties = [ordered]@{
                "Your$($fucking)IPAddress"   = $WTFismyIP.YourFuckingIPAddress
                "Your$($fucking)Location"     = $WTFismyIP.YourFuckingLocation
                "Your$($fucking)HostName"    = $WTFismyIP.YourFuckingHostname
                "Your$($fucking)ISP"          = $WTFismyIP.YourFuckingISP
                "Your$($fucking)TorExit"     = $WTFismyIP.YourFuckingTorExit
                "Your$($fucking)CountryCode" = $WTFismyIP.YourFuckingCountryCode
            }
            
            $obj = New-Object -TypeName psobject -Property $properties

            Write-Output -InputObject $obj
        }
        catch {
            Write-Error -Message "$_"
        }
    }

    end { }
}