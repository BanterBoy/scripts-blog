function Connect-InternalPRTG {

    <#
        .SYNOPSIS
        Connects to the PRTG Monitoring Server.
        .DESCRIPTION
        Establishes a secure connection to the PRTG Monitoring Servers API, using the functions from the PrtgAPI module.
        .PARAMETER url
        Enter the url for the PRTG Monitoring Server API. This paramter is not mandatory and will default the CSO default PRTG server.
        .NOTES
        Name: Connect-InternalPRTG.ps1
        Author: Luke Leigh
        DateCreated: 02Sep2021

        .LINK 
        http://
        .EXAMPLE
        Connect-InternalPRTG
    #>

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter the url for the PRTG Monitoring Server."
        )]
        [string]
        $url = "https://csonetmon01.uk.cruk.net"
    )

    if (!(Get-PrtgClient)) {
        Connect-PrtgServer -Server $url -Credential (Get-Credential)
    }
}
