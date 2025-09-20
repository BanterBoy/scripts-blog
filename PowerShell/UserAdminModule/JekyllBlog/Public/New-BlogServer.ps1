function global:New-BlogServer {

    [CmdletBinding(DefaultParameterSetName = 'default')]

    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter path or Browse to select dockerfile")]
        [ValidateSet('Select', 'Blog')]
        [string]$BlogPath,
        [string]$Path

    )

    switch ($BlogPath) {
        
        Select {
            try {
                $PSRootFolder = Select-FolderLocation
                New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
                Set-Location -Path BlogDrive:
                docker-compose.exe up
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_"
            }
        }

        Blog {
            try {
                New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root "$Path"
                Set-Location -Path BlogDrive:
                docker-compose.exe up
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_"
            }
        }
        Default {
            try {
                $PSRootFolder = Select-FolderLocation
                New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
                Set-Location -Path BlogDrive:
                docker-compose.exe up
            }
            catch [System.Management.Automation.ItemNotFoundException] {
                Write-Warning -Message "$_"
            }
        }
    }
}
