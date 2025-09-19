function Get-VMGuestHardwareDetails {
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipeline            = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string[]]$VMName
    )

    Process {
        foreach ($name in $VMName) {
            try {
                # This can return multiple VMs if $name is a wildcard
                $vmList = Get-VM -Name $name -ErrorAction Stop

                foreach ($vm in $vmList) {
                    # Build an array of disk info
                    $hardDisks = $vm.ExtensionData.Config.Hardware.Device |
                        Where-Object { $_.DeviceInfo.Label -like 'Hard disk*' } |
                        ForEach-Object {
                            [PSCustomObject]@{
                                Name       = $_.DeviceInfo.Label
                                CapacityGB = [Math]::Round($_.CapacityInKB / 1MB, 2)
                            }
                        }

                    # Build an array of NIC info (excluding NetworkName if you prefer)
                    $nicDevices = $vm.ExtensionData.Config.Hardware.Device |
                        Where-Object { $_ -is [VMware.Vim.VirtualEthernetCard] } |
                        ForEach-Object {
                            [PSCustomObject]@{
                                Name       = $_.DeviceInfo.Label
                                MacAddress = $_.MacAddress
                            }
                        }

                    # Retrieve IP addresses from the Guest property (can be null)
                    $ipList = if ($vm.Guest -and $vm.Guest.IPAddress) {
                        $vm.Guest.IPAddress
                    } else {
                        @('N/A')
                    }

                    # Construct the final custom object
                    $vmInfo = [PSCustomObject]@{
                        VMName      = $vm.Name
                        PowerState  = $vm.PowerState
                        NumCPU      = $vm.NumCPU
                        MemoryGB    = $vm.MemoryGB
                        GuestOS     = $vm.Guest.OSFullName
                        ToolsStatus = $vm.ExtensionData.Guest.ToolsStatus
                        IPAddresses = $ipList
                        HardDisks   = $hardDisks
                        Networks    = $nicDevices
                    }

                    # Emit the object
                    Write-Output $vmInfo
                }
            }
            catch {
                Write-Warning "Failed to retrieve details for VM '$name': $($_.Exception.Message)"
            }
        }
    }
}
