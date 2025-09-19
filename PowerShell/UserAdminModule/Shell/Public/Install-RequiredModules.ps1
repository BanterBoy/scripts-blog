<#
    .SYNOPSIS
    Installs and imports required PowerShell modules, including public, internal, and RSAT tools.

    .DESCRIPTION
    The `Install-RequiredModules` function ensures that all required PowerShell modules are installed and imported. 
    It supports installing public modules from the PowerShell Gallery, internal modules from a specified repository, 
    and the Microsoft RSAT (Remote Server Administration Tools) suite.

    - For public modules, it installs them from the PowerShell Gallery if they are not already available.
    - For internal modules, it installs them from a specified internal repository.
    - For RSAT tools, it installs the required Windows capabilities and imports the Active Directory module.

    .PARAMETER PublicModules
    Specifies the list of public modules to install and import. These modules are installed from the PowerShell Gallery.

    .PARAMETER InternalModules
    Specifies the list of internal modules to install and import. These modules are installed from the repository specified 
    by the `InternalGalleryName` parameter.

    .PARAMETER InternalGalleryName
    Specifies the name of the internal repository to use when installing internal modules. This parameter is required 
    when the `InternalModules` parameter is specified.

    .PARAMETER RSATTools
    A switch parameter that installs the Microsoft RSAT (Remote Server Administration Tools) suite and imports the 
    Active Directory module.

    .INPUTS
    None. This function does not accept pipeline input.

    .OUTPUTS
    [String]. Outputs details of the installation, importing, or failure of modules.

    .EXAMPLE
    Install-RequiredModules -PublicModules 'Module1'
    This command installs and imports the public module `Module1` from the PowerShell Gallery.

    .EXAMPLE
    Install-RequiredModules -InternalModules 'InternalModule1' -InternalGalleryName 'MyInternalRepo'
    This command installs and imports the internal module `InternalModule1` from the internal repository `MyInternalRepo`.

    .EXAMPLE
    Install-RequiredModules -RSATTools
    This command installs the RSAT tools and imports the Active Directory module.

    .NOTES
    Author       : Luke Leigh
    Website      : https://blog.lukeleigh.com
    Twitter      : https://twitter.com/luke_leighs
    GitHub       : https://github.com/BanterBoy

    This function uses the `Install-Module` cmdlet to install modules and the `Import-Module` cmdlet to import them. 
    For RSAT tools, it uses the `Get-WindowsCapability` and `Add-WindowsCapability` cmdlets to install the required Windows features.

    - PowerShell 5.1 or later
    - Administrative privileges for installing RSAT tools or modules

    .LINK
    https://learn.microsoft.com/en-us/powershell/module/powershellget/install-module
    https://learn.microsoft.com/en-us/windows-server/remote/remote-server-administration-tools
#>

function Install-RequiredModules {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string])]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specify public modules to install/import.'
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$PublicModules,

        [Parameter(ParameterSetName = 'Internal',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Specify internal modules to install/import.'
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$InternalModules,

        [Parameter(ParameterSetName = 'Internal',
            Mandatory = $false,
            HelpMessage = 'Specify the internal gallery name for internal modules.'
        )]
        [ValidateNotNullOrEmpty()]
        [string]$InternalGalleryName,

        [Parameter(ParameterSetName = 'RSAT',
            Mandatory = $false,
            HelpMessage = 'Use this switch to install the Microsoft RSAT suite of tools.'
        )]
        [switch]$RSATTools
    )

    begin {
        # Helper function to handle module installation and import
        function Install-And-ImportModule {
            param (
                [string]$ModuleName,
                [string]$Repository = 'PSGallery'
            )
            try {
                if (Get-Module -Name $ModuleName -ListAvailable) {
                    Write-Verbose "Importing module - $ModuleName"
                    Import-Module -Name $ModuleName -ErrorAction Stop
                }
                else {
                    Write-Verbose "Installing module - $ModuleName from repository - $Repository"
                    Install-Module -Name $ModuleName -Repository $Repository -Force -ErrorAction Stop
                    Import-Module -Name $ModuleName -ErrorAction Stop
                }
            }
            catch {
                Write-Error "Failed to install/import module '$ModuleName': $_"
            }
        }
    }

    process {
        # Process Public Modules
        if ($PublicModules) {
            foreach ($Module in $PublicModules) {
                if ($PSCmdlet.ShouldProcess("Public Module: $Module", "Install and Import")) {
                    Install-And-ImportModule -ModuleName $Module
                }
            }
        }
    
        # Process Internal Modules
        if ($InternalModules) {
            if (-not $InternalGalleryName) {
                Write-Error "InternalGalleryName is required when specifying InternalModules."
                return
            }
            foreach ($Module in $InternalModules) {
                if ($PSCmdlet.ShouldProcess("Internal Module: $Module", "Install and Import from $InternalGalleryName")) {
                    Install-And-ImportModule -ModuleName $Module -Repository $InternalGalleryName
                }
            }
        }
    
        # Process RSAT Tools
        if ($RSATTools) {
            if ($PSCmdlet.ShouldProcess("RSAT Tools", "Install and Import Active Directory module")) {
                try {
                    if (Get-Module -Name 'ActiveDirectory' -ListAvailable) {
                        Write-Verbose "Importing module - ActiveDirectory"
                        Import-Module -Name 'ActiveDirectory' -ErrorAction Stop
                    }
                    else {
                        Write-Verbose "Installing RSAT Tools"
                        Get-WindowsCapability -Name "Rsat*" -Online | Add-WindowsCapability -Online
                        Import-Module -Name 'ActiveDirectory' -ErrorAction Stop
                    }
                }
                catch {
                    Write-Error "Failed to install/import RSAT Tools: $_"
                }
            }
        }
    }

    end {
        Write-Verbose "Module installation/import process completed."
    }
}