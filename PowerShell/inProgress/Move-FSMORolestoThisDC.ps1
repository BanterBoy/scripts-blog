
function Move-FSMORolestoThisDC {
    <#
    
        .SYNOPSIS
        A function to reassign all of the Active Directory FSMO Roles to a specific computer.
    
        .DESCRIPTION
        A function to reassign all of the Active Directory FSMO Roles to a specific computer.
    
        .PARAMETER ComputerName
        Enter the Name of the Computer that you want to reassign the FSMO roles to.

        .EXAMPLE
        Move-FSMORolestoThisDC
        
        Move Operation Master Role
        Do you want to move role 'PDCEmulator' to server 'DANTOOINE.domain.leigh-services.com' ?
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
        
        When run without any parameters, the command uses the $env:COMPUTERNAME environment variable and attempt to move the roles.

        .EXAMPLE
        Move-FSMORolestoThisDC -ComputerName DANTOOINE -Verbose

        Move Operation Master Role
        Do you want to move role 'PDCEmulator' to server 'DANTOOINE.domain.leigh-services.com' ?
        [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):

        When run with the ComputerName parameter, the command attempts to move the roles to the specified Domain Controller.
        
        .INPUTS
        You can pipe objects to this perameter.
    
        - ComputerName [string]
    
        .NOTES
        Author:     Luke Leigh
        Website:    https://scripts.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy
    
        .LINK
        https://github.com/BanterBoy/scripts-blog
        Move-ADDirectoryServerOperationMasterRole
    
    #>
    [cmdletbinding(DefaultParameterSetName = "Default")]
    Param(
        [Parameter(
            Mandatory = $false,
            Position = 1,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the Domain Controller ComputerName")]
        [string]
        $ComputerName = $env:COMPUTERNAME
    )
    Move-ADDirectoryServerOperationMasterRole -Identity $ComputerName -OperationMasterRole 0, 1, 2, 3, 4
}
