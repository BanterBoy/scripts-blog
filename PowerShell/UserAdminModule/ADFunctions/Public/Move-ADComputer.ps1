<#
.SYNOPSIS
    Moves a computer object from one OU to another in Active Directory.

.DESCRIPTION
    This function moves a computer object from one Organizational Unit (OU) to another in Active Directory.
    It accepts pipeline input from Get-ADComputer and outputs the results as a PSObject.

.PARAMETER ComputerName
    The name of the computer object to be moved. This parameter accepts pipeline input.

.PARAMETER TargetOU
    The target Organizational Unit (OU) where the computer object will be moved.

.EXAMPLE
    Get-ADComputer -Filter * | Move-ADComputer -TargetOU "NewOU"

.NOTES
    Author: Your Name
    Date: 2025-02-19
    Version: 1.2

#>
#requires -PSEdition Desktop

function Move-ADComputer {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$ComputerName,

        [Parameter(Mandatory = $true)]
        [string]$TargetOU
    )

    process {
        if ($PSCmdlet.ShouldProcess("$ComputerName to $TargetOU")) {
            try {
                # Validate the target OU format
                if ($TargetOU -notmatch '^OU=.*') {
                    throw "Invalid TargetOU format. It should be in the format 'OU=Name,DC=domain,DC=com'."
                }

                # Get the computer object from AD
                $Computer = Get-ADComputer -Identity $ComputerName -ErrorAction Stop

                # Move the computer to the target OU
                Move-ADObject -Identity $Computer.DistinguishedName -TargetPath $TargetOU

                # Log the successful move
                Write-Verbose "Successfully moved $ComputerName to $TargetOU"

                # Create a PSObject to output the result
                $result = [PSCustomObject]@{
                    ComputerName = $ComputerName
                    TargetOU     = $TargetOU
                    Status       = "Success"
                    Message      = "Successfully moved $ComputerName to $TargetOU"
                }
            }
            catch {
                # Log the error
                Write-Error "Failed to move {$ComputerName}: $_"

                # Create a PSObject to output the error
                $result = [PSCustomObject]@{
                    ComputerName = $ComputerName
                    TargetOU     = $TargetOU
                    Status       = "Failed"
                    Message      = "Failed to move {$ComputerName}: $_"
                }
            }
            # Output the result
            $result
        }
    }
}
