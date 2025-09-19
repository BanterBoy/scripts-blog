function Move-FSMORolestoPDCEmulator {
    <#
    .SYNOPSIS
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    .DESCRIPTION
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    Functions included;
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

    .OUTPUTS

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
	
    )

    BEGIN {
        $ForestInfo = Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster
        $DomainInfo = Get-ADDomain | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster
        $PrimaryDC = Get-ADDomainController -Discover -DomainName $Env:USERDNSDOMAIN -Service 'PrimaryDC'
    }
    PROCESS {
        if ($DomainInfo.RIDMaster -notmatch $PrimaryDC) {
            Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 1
        }
        if ($DomainInfo.InfrastructureMaster -notmatch $PrimaryDC) {
            Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 2
        }
        if ($ForestInfo.SchemaMaster -notmatch $PrimaryDC) {
            Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 3
        }
        if ($ForestInfo.DomainNamingMaster -notmatch $PrimaryDC) {
            Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 4
        }
    }
    END {
	
    }

}