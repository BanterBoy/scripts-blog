function Get-WTFismyIP {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $WTFismyIP = Invoke-RestMethod -Method Get -Uri "https://wtfismyip.com/json"
    }
    
    process {

        try {
            $properties = @{
                "YourFuckingIPAddress"   = $WTFismyIP.YourFuckingIPAddress
                "YourFuckingLocation"    = $WTFismyIP.YourFuckingLocation
                "YourFuckingHostname"    = $WTFismyIP.YourFuckingHostname
                "YourFuckingISP"         = $WTFismyIP.YourFuckingISP
                "YourFuckingTorExit"     = $WTFismyIP.YourFuckingTorExit
                "YourFuckingCountryCode" = $WTFismyIP.YourFuckingCountryCode
            }
        }
        catch {
            Write-Error -Message "$_"
        }
        finally {
            $obj = New-Object -TypeName psobject -Property $properties
            Write-Output -InputObject $obj
        }
    }

    end {
        
    }
}
