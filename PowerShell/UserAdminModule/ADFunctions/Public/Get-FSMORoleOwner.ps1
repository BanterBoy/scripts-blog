function Get-FSMORoleOwner {

    <#
    .SYNOPSIS
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    .DESCRIPTION
    A set of functions to provide the ability to manage Active Directory FSMO Roles.

    Functions included;
    Get-FSMORoleOwner

    This CmdLet will export the FSMO roles from your domain. This information is then output in a Table,
    showing which Domain Controller on the network holds the different FSMO Roles.

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

    .INPUTS


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

    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpURI = 'https://github.com/BanterBoy/MSPTech/wiki')]
    param (
	
    )
    BEGIN {
        $ForestInfo = (Get-ADForest)
        $DomainInfo = (Get-ADDomain)
    }
    PROCESS {
        $Forest = $ForestInfo | Select-Object DomainNamingMaster, SchemaMaster
        $Domain = $DomainInfo | Select-Object InfrastructureMaster, PDCEmulator, RIDMaster
        try {
            $Properties = @{
                PDCEmulator          = $Domain.PDCEmulator
                RIDMaster            = $Domain.RIDMaster
                InfrastructureMaster = $Domain.InfrastructureMaster
                SchemaMaster         = $Forest.SchemaMaster
                DomainNamingMaster   = $Forest.DomainNamingMaster
            }
        }
        catch {
            $Properties = @{
                PDCEmulator          = $Domain.PDCEmulator
                RIDMaster            = $Domain.RIDMaster
                InfrastructureMaster = $Domain.InfrastructureMaster
                SchemaMaster         = $Forest.SchemaMaster
                DomainNamingMaster   = $Forest.DomainNamingMaster
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $Properties
            Write-Output $obj
        }
    }
    END {
	
    }

}