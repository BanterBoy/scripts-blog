<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .INPUTS

    .OUTPUTS

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/PowerRepo/wiki

#>

[CmdletBinding(DefaultParameterSetName = 'default')]

param(
    [Parameter(Mandatory = $True,
        HelpMessage = "####",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('####')]
    [string[]]$####,

    [Parameter(Mandatory = $True,
        HelpMessage = "####",
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $True)]
    [Alias('####')]
    [string[]]$####

)

BEGIN {
    # [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    # $SiteURL = "http://apilayer.net/api/check"
    # $AccessKey = ("?access_key=" + "$ApiKey")
    # $Address = ("&email=" + "$EmailAddress")
    # $smtp = "&smtp=1"
    # $format = "&format=1"
    # # $catchall = "&catch_all=1" (Disabled, requires Pro Account)
    # $ValidationResults = Invoke-RestMethod -Method Get -Uri ($SiteURL + $AccessKey + $Address + $smtp + $format + $catchall)
}

PROCESS {

    foreach ($item in $####s) {
        $#### = $item | Select-Object -Property *

        try {
            $properties = @{

            }
        }
        catch {
            $properties = @{

            }
        }
        Finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }

}

END {}
