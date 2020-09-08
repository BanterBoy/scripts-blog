Function Get-ComputerInfo {
	param(
		[Parameter(Mandatory=$true)]
		[string[]]$ComputerName
	)


	BEGIN { }

	PROCESS {
		foreach ($Computer in $ComputerName) {
			try {
				New-CimSession -ComputerName $Computer -Name $Computer -ErrorAction Stop
				$CompInfo = Get-CimInstance -CimSession $Computer -Namespace CIM_ComputerSystem
				$properties = @{
					AdminPasswordStatus         = $CompInfo.AdminPasswordStatus
					AutomaticManagedPagefile    = $CompInfo.AutomaticManagedPagefile
					AutomaticResetBootOption    = $CompInfo.AutomaticResetBootOption
					AutomaticResetCapability    = $CompInfo.AutomaticResetCapability
					BootOptionOnLimit           = $CompInfo.BootOptionOnLimit
					BootOptionOnWatchDog        = $CompInfo.BootOptionOnWatchDog
					BootROMSupported            = $CompInfo.BootROMSupported
					BootStatus                  = $CompInfo.BootStatus
					BootupState                 = $CompInfo.BootupState
					Caption                     = $CompInfo.Caption
					ChassisBootupState          = $CompInfo.ChassisBootupState
					ChassisSKUNumber            = $CompInfo.ChassisSKUNumber
					CreationClassName           = $CompInfo.CreationClassName
					CurrentTimeZone             = $CompInfo.CurrentTimeZone
					DaylightInEffect            = $CompInfo.DaylightInEffect
					Description                 = $CompInfo.Description
					DNSHostName                 = $CompInfo.DNSHostName
					Domain                      = $CompInfo.Domain
					DomainRole                  = $CompInfo.DomainRole
					EnableDaylightSavingsTime   = $CompInfo.EnableDaylightSavingsTime
					FrontPanelResetStatus       = $CompInfo.FrontPanelResetStatus
					HypervisorPresent           = $CompInfo.HypervisorPresent
					InfraredSupported           = $CompInfo.InfraredSupported
					InitialLoadInfo             = $CompInfo.InitialLoadInfo
					InstallDate                 = $CompInfo.InstallDate
					KeyboardPasswordStatus      = $CompInfo.KeyboardPasswordStatus
					LastLoadInfo                = $CompInfo.LastLoadInfo
					Manufacturer                = $CompInfo.Manufacturer
					Model                       = $CompInfo.Model
					Name                        = $CompInfo.Name
					NameFormat                  = $CompInfo.NameFormat
					NetworkServerModeEnabled    = $CompInfo.NetworkServerModeEnabled
					NumberOfLogicalProcessors   = $CompInfo.NumberOfLogicalProcessors
					NumberOfProcessors          = $CompInfo.NumberOfProcessors
					OEMLogoBitmap               = $CompInfo.OEMLogoBitmap
					OEMStringArray              = $CompInfo.OEMStringArray
					PartOfDomain                = $CompInfo.PartOfDomain
					PauseAfterReset             = $CompInfo.PauseAfterReset
					PCSystemType                = $CompInfo.PCSystemType
					PCSystemTypeEx              = $CompInfo.PCSystemTypeEx
					PowerManagementCapabilities = $CompInfo.PowerManagementCapabilities
					PowerManagementSupported    = $CompInfo.PowerManagementSupported
					PowerOnPasswordStatus       = $CompInfo.PowerOnPasswordStatus
					PowerState                  = $CompInfo.PowerState
					PowerSupplyState            = $CompInfo.PowerSupplyState
					PrimaryOwnerContact         = $CompInfo.PrimaryOwnerContact
					PrimaryOwnerName            = $CompInfo.PrimaryOwnerName
					ResetCapability             = $CompInfo.ResetCapability
					ResetCount                  = $CompInfo.ResetCount
					ResetLimit                  = $CompInfo.ResetLimit
					Roles                       = $CompInfo.Roles
					Status                      = $CompInfo.Status
					SupportContactDescription   = $CompInfo.SupportContactDescription
					SystemFamily                = $CompInfo.SystemFamily
					SystemSKUNumber             = $CompInfo.SystemSKUNumber
					SystemStartupDelay          = $CompInfo.SystemStartupDelay
					SystemStartupOptions        = $CompInfo.SystemStartupOptions
					SystemStartupSetting        = $CompInfo.SystemStartupSetting
					SystemType                  = $CompInfo.SystemType
					ThermalState                = $CompInfo.ThermalState
					TotalPhysicalMemory         = $CompInfo.TotalPhysicalMemory
					UserName                    = $CompInfo.UserName
					WakeUpType                  = $CompInfo.WakeUpType
					Workgroup                   = $CompInfo.Workgroup
				}
			}
			catch {
				Write-Verbose "Couldn't connect to $Computer"
				$properties = @{
					AdminPasswordStatus         = $CompInfo.AdminPasswordStatus
					AutomaticManagedPagefile    = $CompInfo.AutomaticManagedPagefile
					AutomaticResetBootOption    = $CompInfo.AutomaticResetBootOption
					AutomaticResetCapability    = $CompInfo.AutomaticResetCapability
					BootOptionOnLimit           = $CompInfo.BootOptionOnLimit
					BootOptionOnWatchDog        = $CompInfo.BootOptionOnWatchDog
					BootROMSupported            = $CompInfo.BootROMSupported
					BootStatus                  = $CompInfo.BootStatus
					BootupState                 = $CompInfo.BootupState
					Caption                     = $CompInfo.Caption
					ChassisBootupState          = $CompInfo.ChassisBootupState
					ChassisSKUNumber            = $CompInfo.ChassisSKUNumber
					CreationClassName           = $CompInfo.CreationClassName
					CurrentTimeZone             = $CompInfo.CurrentTimeZone
					DaylightInEffect            = $CompInfo.DaylightInEffect
					Description                 = $CompInfo.Description
					DNSHostName                 = $CompInfo.DNSHostName
					Domain                      = $CompInfo.Domain
					DomainRole                  = $CompInfo.DomainRole
					EnableDaylightSavingsTime   = $CompInfo.EnableDaylightSavingsTime
					FrontPanelResetStatus       = $CompInfo.FrontPanelResetStatus
					HypervisorPresent           = $CompInfo.HypervisorPresent
					InfraredSupported           = $CompInfo.InfraredSupported
					InitialLoadInfo             = $CompInfo.InitialLoadInfo
					InstallDate                 = $CompInfo.InstallDate
					KeyboardPasswordStatus      = $CompInfo.KeyboardPasswordStatus
					LastLoadInfo                = $CompInfo.LastLoadInfo
					Manufacturer                = $CompInfo.Manufacturer
					Model                       = $CompInfo.Model
					Name                        = $CompInfo.Name
					NameFormat                  = $CompInfo.NameFormat
					NetworkServerModeEnabled    = $CompInfo.NetworkServerModeEnabled
					NumberOfLogicalProcessors   = $CompInfo.NumberOfLogicalProcessors
					NumberOfProcessors          = $CompInfo.NumberOfProcessors
					OEMLogoBitmap               = $CompInfo.OEMLogoBitmap
					OEMStringArray              = $CompInfo.OEMStringArray
					PartOfDomain                = $CompInfo.PartOfDomain
					PauseAfterReset             = $CompInfo.PauseAfterReset
					PCSystemType                = $CompInfo.PCSystemType
					PCSystemTypeEx              = $CompInfo.PCSystemTypeEx
					PowerManagementCapabilities = $CompInfo.PowerManagementCapabilities
					PowerManagementSupported    = $CompInfo.PowerManagementSupported
					PowerOnPasswordStatus       = $CompInfo.PowerOnPasswordStatus
					PowerState                  = $CompInfo.PowerState
					PowerSupplyState            = $CompInfo.PowerSupplyState
					PrimaryOwnerContact         = $CompInfo.PrimaryOwnerContact
					PrimaryOwnerName            = $CompInfo.PrimaryOwnerName
					ResetCapability             = $CompInfo.ResetCapability
					ResetCount                  = $CompInfo.ResetCount
					ResetLimit                  = $CompInfo.ResetLimit
					Roles                       = $CompInfo.Roles
					Status                      = $CompInfo.Status
					SupportContactDescription   = $CompInfo.SupportContactDescription
					SystemFamily                = $CompInfo.SystemFamily
					SystemSKUNumber             = $CompInfo.SystemSKUNumber
					SystemStartupDelay          = $CompInfo.SystemStartupDelay
					SystemStartupOptions        = $CompInfo.SystemStartupOptions
					SystemStartupSetting        = $CompInfo.SystemStartupSetting
					SystemType                  = $CompInfo.SystemType
					ThermalState                = $CompInfo.ThermalState
					TotalPhysicalMemory         = $CompInfo.TotalPhysicalMemory
					UserName                    = $CompInfo.UserName
					WakeUpType                  = $CompInfo.WakeUpType
					Workgroup                   = $CompInfo.Workgroup
				}
			}
			finally {
				$obj = New-Object -TypeName PSObject -Property $properties
				Write-Output $obj
			}
		}
	}

	END { }

}
