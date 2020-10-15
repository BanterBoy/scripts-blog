<#
    .SYNOPSIS
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    .DESCRIPTION
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    Functions included;
    Get-FSMORoleOwner
    Set-FSMORolePDCEmulator
    Set-FSMORoleRIDMaster
    Set-FSMORoleInfrastructureMaster
    Set-FSMORoleSchemaMaster
    Set-FSMORoleDomainNamingMaster
    Move-FSMORolestoPDCEmulator

    Wrapper for the Move-ADDirectoryServerOperationMasterRole command. 
    Operation Master Roles
    PDCEmulator or 0
    RIDMaster or 1
    InfrastructureMaster or 2
    SchemaMaster or 3
    DomainNamingMaster or 4


    .EXAMPLE
    PS C:\> Get-FSMORoleOwner

    PDCEmulator          : LSERV-DC01.example.com
    DomainNamingMaster   : LSERV-DC01.example.com
    InfrastructureMaster : LSERV-DC01.example.com
    RIDMaster            : LSERV-DC01.example.com
    SchemaMaster         : LSERV-DC01.example.com

    .EXAMPLE
    PS C:\> Get-FSMORoleOwner | Select-Object RIDMaster

    RIDMaster
    ---------
    LSERV-DC01.example.com

    .EXAMPLE
    PS C:\> Set-FSMORolePDCEmulator -PDCEmulator LSERV-DC02

    Move Operation Master Role
    Do you want to move role 'PDCEmulator' to server 'lserv-dc02.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
    
    .EXAMPLE
    PS C:\> Set-FSMORoleRIDMaster -RIDMaster LSERV-DC02

    Move Operation Master Role
    Do you want to move role 'RIDMaster' to server 'lserv-dc02.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
    
    .EXAMPLE
    PS C:\> Set-FSMORoleInfrastructureMaster -InfrastructureMaster LSERV-DC02

    Move Operation Master Role
    Do you want to move role 'InfrastructureMaster' to server 'lserv-dc02.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
    
    .EXAMPLE
    PS C:\> Set-FSMORoleSchemaMaster -SchemaMaster LSERV-DC02

    Move Operation Master Role
    Do you want to move role 'SchemaMaster' to server 'lserv-dc02.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
    
    .EXAMPLE
    PS C:\> Set-FSMORoleDomainNamingMaster -DomainNamingMaster LSERV-DC02

    Move Operation Master Role
    Do you want to move role 'DomainNamingMaster' to server 'lserv-dc02.example.com' ?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y
    
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
    Get-FSMORoleOwner

    PDCEmulator          : LSERV-DC01.example.com
    DomainNamingMaster   : LSERV-DC01.example.com
    InfrastructureMaster : LSERV-DC01.example.com
    RIDMaster            : LSERV-DC01.example.com
    SchemaMaster         : LSERV-DC01.example.com


    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/MSPTech

#>

#Requires -Module ActiveDirectory
#Requires -RunAsAdministrator

function Get-FSMORoleOwner {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki',
        SupportsShouldProcess = $true)]

    $ForestInfo = Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster
    $DomainInfo = Get-ADDomain | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster

    try {
        $Properties = @{
            PDCEmulator          = $DomainInfo.PDCEmulator
            RIDMaster            = $DomainInfo.RIDMaster
            InfrastructureMaster = $DomainInfo.InfrastructureMaster
            SchemaMaster         = $ForestInfo.SchemaMaster
            DomainNamingMaster   = $ForestInfo.DomainNamingMaster
        }
    }
    catch {
        $Properties = @{
            PDCEmulator          = $DomainInfo.PDCEmulator
            RIDMaster            = $DomainInfo.RIDMaster
            InfrastructureMaster = $DomainInfo.InfrastructureMaster
            SchemaMaster         = $ForestInfo.SchemaMaster
            DomainNamingMaster   = $ForestInfo.DomainNamingMaster
        }
    }
    finally {
        $obj = New-Object -TypeName PSObject -Property $Properties
        Write-Output $obj
    }
}

function Set-FSMORolePDCEmulator {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the PDCEmulator FSMO Role")]
        [Alias('PDC')]
        [String]$PDCEmulator
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $PDCEmulator -OperationMasterRole 0
}

function Set-FSMORoleRIDMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the RIDMaster FSMO Role")]
        [Alias('RID')]
        [String]$RIDMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $RIDMaster -OperationMasterRole 1
}

function Set-FSMORoleInfrastructureMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the InfrastructureMaster FSMO Role")]
        [Alias('Infra')]
        [String]$InfrastructureMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $InfrastructureMaster -OperationMasterRole 2
}

function Set-FSMORoleSchemaMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the SchemaMaster FSMO Role")]
        [Alias('Schema')]
        [String]$SchemaMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $SchemaMaster -OperationMasterRole 3
}

function Set-FSMORoleDomainNamingMaster {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter Domain Controller ServerName where you want to move the DomainNamingMaster FSMO Role")]
        [Alias('Domain')]
        [String]$DomainNamingMaster
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $DomainNamingMaster -OperationMasterRole 4
}

function Move-FSMORolestoPDCEmulator {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    $ForestInfo = Get-ADForest | Select-Object DomainNamingMaster, SchemaMaster
    $DomainInfo = Get-ADDomain | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster
    $PrimaryDC = Get-ADDomainController -Discover -Domain $Env:USERDNSDOMAIN -Service 'PrimaryDC'
    if ( $DomainInfo.RIDMaster -notmatch $PrimaryDC ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 1
    }
    if ( $DomainInfo.InfrastructureMaster -notmatch $PrimaryDC  ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 2
    }
    if ( $ForestInfo.SchemaMaster -notmatch $PrimaryDC ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 3
    }
    if ( $ForestInfo.DomainNamingMaster -notmatch $PrimaryDC ) {
        Move-ADDirectoryServerOperationMasterRole -Identity $PrimaryDC -OperationMasterRole 4
    }
}
