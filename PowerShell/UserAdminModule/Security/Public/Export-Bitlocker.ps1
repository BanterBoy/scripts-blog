[CmdletBinding()]
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
            $TMPID = $TPMKey | Select-Object KeyProtector -ExpandProperty KeyProtector
                        
            $Keyproperties = @{ComputerName = $TPMKey.ComputerName
                MountPoint                  = $TPMKey.MountPoint
                CapacityGB                  = $TPMKey.CapacityGB
            }
            $TMPID = $TPMKey | Select-Object KeyProtector -ExpandProperty KeyProtector
            $IDproperties = @{KeyProtectorType = $TMPID.KeyProtectorType
                KeyProtectorId                 = $TMPID.KeyProtectorId
                RecoveryPassword               = $TMPID.RecoveryPassword
            }
        }
        catch {
            Write-Verbose "Couldn't connect to $Computer"
            $Keyproperties = @{ComputerName = $TPMKey.ComputerName
                MountPoint                  = $TPMKey.MountPoint
                CapacityGB                  = $TPMKey.CapacityGB
            }
            $IDproperties = @{KeyProtectorType = $TMPID.KeyProtectorType
                KeyProtectorId                 = $TMPID.KeyProtectorId
                RecoveryPassword               = $TMPID.RecoveryPassword
            }
        }
        finally {
            $Keyobj = New-Object -TypeName PSObject -Property $Keyproperties
            Write-Output $Keyobj
            $IDobj = New-Object -TypeName PSObject -Property $IDproperties
            Write-Output $IDobj

        }
    }
}
END {
    
}
