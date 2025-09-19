#Requires -PSEdition Core

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

            $fucking = $polite.IsPresent ? "" : " fucking"

            $properties = [ordered]@{
                "Your$($fucking) IP address"   = $WTFismyIP.YourFuckingIPAddress
                "Your$($fucking) location"     = $WTFismyIP.YourFuckingLocation
                "Your$($fucking) host name"    = $WTFismyIP.YourFuckingHostname
                "Your$($fucking) ISP"          = $WTFismyIP.YourFuckingISP
                "Your$($fucking) tor exit"     = $WTFismyIP.YourFuckingTorExit
                "Your$($fucking) country code" = $WTFismyIP.YourFuckingCountryCode
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