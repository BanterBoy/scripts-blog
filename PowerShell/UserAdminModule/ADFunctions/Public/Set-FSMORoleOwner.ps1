function Set-FSMORoleOwner {

    <#
    .SYNOPSIS
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    .DESCRIPTION
    A function to centralise all Roles on the Active Directory PDC Emulator.

    Move-FSMORolestoPDCEmulator

    Wrapper for the Move-ADDirectoryServerOperationMasterRole command. 
    Operation Master Roles
    PDCEmulator or 0
    RIDMaster or 1
    InfrastructureMaster or 2
    SchemaMaster or 3
    DomainNamingMaster or 4

    .EXAMPLE
    PS C:\> Move-FSMORolestoPDCEmulator

    Move Operation Master Role
    Do you want to move role 'InfrastructureMaster' to server 'LSERV-DC01.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

    .INPUTS
    Each SET function accepts piped input. All SET functions are strings.
    $PDCEmulator
    $RIDMaster
    $InfrastructureMaster
    $SchemaMaster
    $DomainNamingMaster

    .OUTPUTS
    Move Operation Master Role
    Do you want to move role 'InfrastructureMaster' to server 'LSERV-DC01.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/MSPTech

#>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param (
        [parameter(Mandatory = $true, HelpMessage = "Select the Operation Master Role that you want to move.")]
        [ValidateSet("PDCEmulator", "RIDMaster", "InfrastructureMaster", "SchemaMaster", "DomainNamingMaster")]
        [string]$OperationMasterRole
    )

    BEGIN {
        $ForestInfo = (Get-ADForest) | Select-Object DomainNamingMaster, SchemaMaster
        $DomainInfo = (Get-ADDomain) | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster
    }
    PROCESS {
        Move-ADDirectoryServerOperationMasterRole -Identity $PDCEmulator -OperationMasterRole 0 -whatif
        Move-ADDirectoryServerOperationMasterRole -Identity $RIDMaster -OperationMasterRole 1 -whatif
        Move-ADDirectoryServerOperationMasterRole -Identity $InfrastructureMaster -OperationMasterRole 2 -whatif
        Move-ADDirectoryServerOperationMasterRole -Identity $SchemaMaster -OperationMasterRole 3 -whatif
        Move-ADDirectoryServerOperationMasterRole -Identity $DomainNamingMaster -OperationMasterRole 4 -whatif
    }
    END {
	
    }

}
