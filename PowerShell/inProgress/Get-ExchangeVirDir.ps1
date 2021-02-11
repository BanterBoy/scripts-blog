function Get-ExchangeVirDir {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium')]
    [Alias('gevd')]
    [OutputType([String])]
    Param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Enter the Name or FQDN of the Exchange Server.")]
        [Alias("cn")]
        [String[]]
        $ComputerName
    )

    begin {

    }

    process {
        foreach ($Computer in $ComputerName) {
            $OWA = Get-OwaVirtualDirectory -Server $Computer
            $ECP = Get-EcpVirtualDirectory -Server $Computer
            $ActiveSync = Get-ActiveSyncVirtualDirectory -Server $Computer
            $WebServices = Get-WebServicesVirtualDirectory -Server $Computer
            $OAB = Get-OabVirtualDirectory -Server $Computer
            $MAPI = Get-MapiVirtualDirectory -Server $Computer
            try {
                $properties = [ordered]@{
                    'Server'            = $item.Server
                    'OWAIntUrl'         = $OWA.InternalUrl
                    'OWAExtUrl'         = $OWA.ExternalUrl
                    'ECPIntUrl'         = $ECP.InternalUrl
                    'ECPExtUrl'         = $ECP.ExternalUrl
                    'ActiveSyncIntUrl'  = $ActiveSync.InternalUrl
                    'ActiveSyncExtUrl'  = $ActiveSync.ExternalUrl
                    'WebServicesIntUrl' = $WebServices.InternalUrl
                    'WebServicesExtUrl' = $WebServices.ExternalUrl
                    'OABIntUrl'         = $OAB.InternalUrl
                    'OABExtUrl'         = $OAB.ExternalUrl
                    'MAPIIntUrl'        = $MAPI.InternalUrl
                    'MAPIExtUrl'        = $MAPI.ExternalUrl
                }
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
            catch {
                Write-Warning "$_"
            }
        }
    }

    end {

    }
}

