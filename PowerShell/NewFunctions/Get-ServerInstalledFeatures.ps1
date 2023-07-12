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
