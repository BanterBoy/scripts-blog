function Delete-UserPhoto {
    <#
    .SYNOPSIS
    Short function to 

    .DESCRIPTION
    Short function to 

    This function 

    .EXAMPLE
    Delete-UserPhoto

    .INPUTS
    Accepts ###### input.
    Accepts ###### as piped input.
    
    .OUTPUTS
    The output 
            
    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/
#>
            
    [CmdletBinding()]
            
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your API Key.")]
        [Alias('sa')]
        [string]$SamAccountName
    )

    BEGIN { }

    PROCESS {
        $UserPhoto = Get-UserPhoto -Filter { SamAccountName -eq "$SamAccountName" }
        $somethingElse = @{

        }

        foreach ( $item in $accessPolicies ) {
            $Settings = $item | Select-Object -Property *
            try {
                $accessPoliciesProperties = @{
                    number        = $Settings.number
                    name          = $Settings.name
                    accessType    = $Settings.accessType
                    guestVlan     = $Settings.guestVlan
                    radiusServers = $Settings.radiusServers
                }
                
                $obj = New-Object -TypeName PSObject -Property $accessPoliciesProperties
                Write-Output $obj
            }
            catch {
                Write-Host "Failed with error: $_.Message" -ForegroundColor Red
            }
        }
    }

    END { }

}