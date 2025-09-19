Function Get-VMInformation {
    <#
    .SYNOPSIS
    Get information from a VM object. Properties include Name, PowerState, vCenterServer, Datacenter, Cluster, VMHost, Datastore, Folder, GuestOS, NetworkName, IPAddress, MacAddress, VMTools

    .DESCRIPTION
    This function retrieves information from a VM object. It returns a custom object with properties such as Name, PowerState, vCenterServer, Datacenter, Cluster, VMHost, Datastore, Folder, GuestOS, NetworkName, IPAddress, MacAddress, and VMTools.

    .PARAMETER Name
    Specifies the name of the VM. This parameter is used when the function is called with the -Name parameter.

    .PARAMETER InputObject
    Specifies the VM object. This parameter is used when the function is called with pipeline input.

    .EXAMPLE
    Get-VMInformation -Name "VM1"
    Retrieves information for the VM with the name "VM1".

    .EXAMPLE
    Get-VM | Get-VMInformation
    Retrieves information for all VMs in the pipeline.

    .NOTES   
    Name: Get-VMInformation
    Author: theSysadminChannel
    Version: 1.0
    DateCreated: 2019-Apr-29

    .LINK
    https://thesysadminchannel.com/get-vminformation-using-powershell-and-powercli
    Link to the blog post explaining the usage of the function.

    #>
    [CmdletBinding()]
     
    param(
        [Parameter(
            Position = 0,
            ParameterSetName = "NonPipeline"
        )]
        [string[]]  $Name,

        [Parameter(
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = "Pipeline"
        )]
        [PSObject[]]  $InputObject
     
    )

    BEGIN {
        if (-not $Global:DefaultVIServer) {
            Write-Error "Unable to continue.  Please connect to a vCenter Server." -ErrorAction Stop
        }
     
        #Verifying the object is a VM
        if ($PSBoundParameters.ContainsKey("Name")) {
            $InputObject = Get-VM $Name
        }
     
        $i = 1
        $Count = $InputObject.Count
    }
     
    PROCESS {
        if (($null -eq $InputObject.VMHost) -and ($null -eq $InputObject.MemoryGB)) {
            Write-Error "Invalid data type. A virtual machine object was not found" -ErrorAction Stop
        }
     
        foreach ($Object in $InputObject) {
            try {
                $vCenter = $Object.Uid -replace ".+@"; $vCenter = $vCenter -replace ":.+"
                [PSCustomObject]@{
                    Name        = $Object.Name
                    PowerState  = $Object.PowerState
                    vCenter     = $vCenter
                    Datacenter  = $Object.VMHost | Get-Datacenter | Select-Object -ExpandProperty Name
                    Cluster     = $Object.VMhost | Get-Cluster | Select-Object -ExpandProperty Name
                    VMHost      = $Object.VMhost
                    Datastore   = ($Object | Get-Datastore | Select-Object -ExpandProperty Name) -join ', '
                    FolderName  = $Object.Folder
                    GuestOS     = $Object.ExtensionData.Config.GuestFullName
                    NetworkName = ($Object | Get-NetworkAdapter | Select-Object -ExpandProperty NetworkName) -join ', '
                    IPAddress   = ($Object.ExtensionData.Summary.Guest.IPAddress) -join ', '
                    MacAddress  = ($Object | Get-NetworkAdapter | Select-Object -ExpandProperty MacAddress) -join ', '
                    VMTools     = $Object.ExtensionData.Guest.ToolsVersionStatus2
                }
     
            }
            catch {
                Write-Error $_.Exception.Message
     
            }
            finally {
                if ($PSBoundParameters.ContainsKey("Name")) {
                    $PercentComplete = ($i / $Count).ToString("P")
                    Write-Progress -Activity "Processing VM: $($Object.Name)" -Status "$i/$count : $PercentComplete Complete" -PercentComplete $PercentComplete.Replace("%", "")
                    $i++
                }
                else {
                    Write-Progress -Activity "Processing VM: $($Object.Name)" -Status "Completed: $i"
                    $i++
                }
            }
        }
    }
     
    END {}
}
