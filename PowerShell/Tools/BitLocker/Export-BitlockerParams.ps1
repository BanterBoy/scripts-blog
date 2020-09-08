#Requires -RunAsAdministrator
#Requires -Modules @{ModuleName="BitLocker";ModuleVersion="1.0.0.0"}

[CmdletBinding(
DefaultParameterSetName="BitEncrypt",
SupportsShouldProcess=$True,
ConfirmImpact='High'
)]

param(
    [Parameter(Mandatory=$True,
                ValueFromPipeline=$True,
                ValueFromPipelineByPropertyName=$True,
                HelpMessage="Please enter the ComputerName or Pipe in from another command.")]
    [Alias('Hostname','cn')]
    [string[]]$ComputerName
)

BEGIN{}

PROCESS{
    foreach ($Computer in $ComputerName){
        try {
            $Volumes = Invoke-Command -ComputerName $computer { Get-Volume }
            $TPMKey = Invoke-Command -computername $computer  { (Get-BitLockerVolume).KeyProtector }
            foreach ($Volume in $Volumes){
            $properties = @{ComputerName = $Computer
                            KeyProtectorType = $TPMKey.KeyProtectorType
                            KeyProtectorId = $TPMKey.KeyProtectorId
                            RecoveryPassword = $TPMKey.RecoveryPassword
                            }
                }
        } catch {
            Write-Verbose "Couldn't connect to $Computer"
            foreach ($property in $properties){
            $properties = @{ComputerName = $Computer
                            KeyProtectorType = $TPMKey.KeyProtectorType
                            KeyProtectorId = $TPMKey.KeyProtectorId
                            RecoveryPassword = $TPMKey.RecoveryPassword
                            }
                  }
        } finally {
            $obj = New-Object -TypeName PSObject -Property $properties
            Write-Output $obj | Format-List -Property $obj.ComputerName,$obj.KeyProtectorId,$obj.RecoveryPassword
        }
    }
}
END {}
