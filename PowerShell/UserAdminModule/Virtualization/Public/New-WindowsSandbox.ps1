<#
.SYNOPSIS
Creates a new Windows Sandbox with specified configurations.

.DESCRIPTION
The New-WindowsSandbox function creates a new Windows Sandbox with the specified configurations. It includes the powershell script 'Start-WindowsSandbox.ps1' and starts the sandbox with the specified memory, applications, read-write mappings, and custom PowerShell profile.

.PARAMETER ProfilePath
Specifies the full path to the profile, including the filename. If not provided, the default PowerShell profile path will be used.

.EXAMPLE
New-WindowsSandbox -ProfilePath "C:\Users\John\Documents\MyProfile.ps1"
Creates a new Windows Sandbox using the specified PowerShell profile.

.EXAMPLE
New-WindowsSandbox
Creates a new Windows Sandbox using the default PowerShell profile.

#>
function New-WindowsSandbox {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Please enter the full path to the profile, including the filename.'
        )]
        [string]
        $ProfilePath = $PROFILE
    )

    # include the powershell script
    . 'C:\GitRepos\Windows-Sandbox\Start-WindowsSandbox.ps1'
    Start-WindowsSandbox -Memory 8  -NotepadPlusPlus -ReadWriteMappings @('C:\Temp\', 'C:\GitRepos\') -CopyPsProfile -CustomPsProfilePath $ProfilePath
}
