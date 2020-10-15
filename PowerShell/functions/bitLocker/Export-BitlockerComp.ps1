#Requires -RunAsAdministrator
#Requires -Modules @{ModuleName="BitLocker";ModuleVersion="1.0.0.0"}

[CmdletBinding(
    DefaultParameterSetName = "BitEncrypt",
    SupportsShouldProcess = $True,
    ConfirmImpact = 'High'
)]

param(
    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        HelpMessage = "Please enter the ComputerName or Pipe in from another command.")]
    [Alias('Hostname', 'cn')]
    [string[]]$ComputerName
)

BEGIN {

}

PROCESS {
    foreach ($Computer in $ComputerName) {
        try {
            $TPMKey = Get-BitLockerVolume
            $TMPID = Get-BitLockerVolume | Select-Object KeyProtector -ExpandProperty KeyProtector
            $properties = @{ComputerName = $TPMKey.ComputerName
                MountPoint               = $TPMKey.MountPoint
                CapacityGB               = $TPMKey.CapacityGB
                KeyProtectorType         = $TMPID.KeyProtectorType
                KeyProtectorId           = $TMPID.KeyProtectorId
                RecoveryPassword         = $TMPID.RecoveryPassword
            }
        }
        catch {
            Write-Verbose "Couldn't connect to $Computer"
            $properties = @{ComputerName = $TPMKey.ComputerName
                MountPoint               = $TPMKey.MountPoint
                CapacityGB               = $TPMKey.CapacityGB
                KeyProtectorType         = $TMPID.KeyProtectorType
                KeyProtectorId           = $TMPID.KeyProtectorId
                RecoveryPassword         = $TMPID.RecoveryPassword
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj
        }
    }
}
END {
    
}
