<#
.SYNOPSIS
    Retrieves the installed features on a remote server.

.DESCRIPTION
    The Get-ServerInstalledFeatures function retrieves the installed features on a remote server by using the Get-WindowsFeature cmdlet. 
    It takes the computer name as input and returns a custom object with various properties of the installed features.

.PARAMETER ComputerName
    Specifies the name of the remote computer from which to retrieve the installed features. 
    This parameter supports pipeline input.

.EXAMPLE
    Get-ServerInstalledFeatures -ComputerName "Server01"
    Retrieves the installed features on the remote server "Server01".

.EXAMPLE
    "Server01" | Get-ServerInstalledFeatures
    Retrieves the installed features on the remote server "Server01" using pipeline input.

.INPUTS
    System.String

.OUTPUTS
    System.Management.Automation.PSObject

.NOTES
    Author: Your Name
    Date:   Current Date

.LINK
    Get-WindowsFeature
#>

function Get-ServerInstalledFeatures {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Please enter the computer name or pipe in from another command.")]
        [string[]]$ComputerName
    )
    BEGIN {
    }
    PROCESS {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            try {
                foreach ($Computer in $ComputerName) {
                    $instances = Invoke-Command -ComputerName $Computer -ScriptBlock {
                        Get-WindowsFeature
                    }
                }
            }
            catch {
                Write-Error  -Message $_
            }
            foreach ( $item in $instances ) {
                try {
                    $properties = @{
                        PSComputerName            = $item.PSComputerName
                        AdditionalInfo            = $item.AdditionalInfo
                        BestPracticesModelId      = $item.BestPracticesModelId
                        DependsOn                 = $item.DependsOn
                        Depth                     = $item.Depth
                        Description               = $item.Description
                        DisplayName               = $item.DisplayName
                        EventQuery                = $item.EventQuery
                        FeatureType               = $item.FeatureType
                        Installed                 = $item.Installed
                        InstallState              = $item.InstallState
                        Name                      = $item.Name
                        Notification              = $item.Notification
                        Path                      = $item.Path
                        PostConfigurationNeeded   = $item.PostConfigurationNeeded
                        ServerComponentDescriptor = $item.ServerComponentDescriptor
                        SubFeatures               = $item.SubFeatures
                        SystemService             = $item.SystemService
                    }
                }
                catch {
                    Write-Error  -Message $_
                }
                finally {
                    $obj = New-Object -TypeName PSObject -Property $properties
                    Write-Output $obj
                }
            }
        }
    }
    END {
    }
}
