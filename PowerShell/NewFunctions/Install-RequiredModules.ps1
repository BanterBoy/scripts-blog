function Install-RequiredModules {

    <#
    .SYNOPSIS
        Install-RequiredModules - Tests to see if scripts/function required modules are available.
    .DESCRIPTION
        Install-RequiredModules - Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .EXAMPLE
        PS C:\> Install-RequiredModules 
        Tests to see if scripts/function required modules are available. Where module is missing it, the function installs the missing module and then imports all required modules.
    .INPUTS
        None.
    .OUTPUTS
        [String] Outputs details of installation, importing and failure.
    .NOTES
        Author	: Luke Leigh
        Website	: https://blog.lukeleigh.com
        Twitter	: https://twitter.com/luke_leighs
        GitHub  : https://github.com/BanterBoy

    #>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('trm')]
    Param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('pm')]
        [string[]]$PublicModules,

        [Parameter(ParameterSetName = 'Internal',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('im')]
        [string[]]$InternalModules,

        [Parameter(ParameterSetName = 'Internal',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter a computer name or pipe input'
        )]
        [Alias('ign')]
        [string[]]$InternalGalleryName
    )
    
    begin {
    }

    process {
        if ($PublicModules) {
            # Installing Public Modules
            foreach ($Module in $PublicModules) {
                if ($PSCmdlet.ShouldProcess("$Module", "Importing/Installing modules...")) {
                    try {
                        if ((Get-Module -Name $Module -ListAvailable)) {
                            Write-Verbose "Importing module - $($Module)"
                            Import-Module -Name $Module
                        }
                        Else {
                            Write-Verbose "Installing module - $($Module)"
                            Install-Module -Name $Module -Repository 'PSGallery' -Force -ErrorAction Stop
                            Import-Module -Name $Module
                        }
                    }
                    catch {
                        Write-Error -Message $_.Exception.Message
                    }
                    finally {
                        ForEach-Object -InputObject $Module -Process {
                            Get-Module -Name $Module
                        }
                    }
                }
            }
        }

        if ($InternalModules) {
            # Installing Internal Modules
            foreach ($Module in $InternalModules) {
                if ($PSCmdlet.ShouldProcess("$Module", "Importing/Installing modules...")) {
                    try {
                        if ((Get-Module -Name $Module -ListAvailable)) {
                            Write-Verbose "Importing module - $($Module)"
                            Import-Module -Name $Module
                        }
                        Else {
                            Write-Verbose "Installing module - $($Module)"
                            Install-Module -Name $Module -Repository $InternalGalleryName -Force -ErrorAction Stop
                            Import-Module -Name $Module
                        }
                    }
                    catch {
                        Write-Error -Message $_.Exception.Message
                    }
                    finally {
                        ForEach-Object -InputObject $Module -Process {
                            Get-Module -Name $Module
                        }
                    }
                }
            }
        }
    }

    end {
    }

}
