function Get-FolderPermissions {
    <#
        .SYNOPSIS
        A function to search for files
    
        .DESCRIPTION
        A function to search for files.
    
        .PARAMETER Path
        Species the search path. The search will perform a recursive search on the specified folder path.
    
        .PARAMETER SearchTerm
        Specifies the search string. This will define the text that the search will use to locate your files. Wildcard chars are not allowed.
    
        .PARAMETER Extension
        Specifies the extension. ".ps1" is the default. You can tab complete through the suggested list or you can enter your own file extension e.g. ".jpg"
    
        .PARAMETER SearchType
        Specifies the type of search perfomed. Options are Start, End or Wild. This will search either the beginning, end or somewhere inbetween. If no option is selected, it will default to performing a wildcard search.
    
        .EXAMPLE
    
        .INPUTS
        You can pipe objects to these perameters.
    
        - Path [string]
        - SearchTerm [string]
        - Extension [string]
        - SearchType [string]
    
    
        .OUTPUTS
        System.String. Search-Scripts returns a string with the extension or file name.
    
        Name                        DirectoryName                                       FullName
        ----                        -------------                                       --------
        Get-PublicDnsRecord.ps1     C:\GitRepos\scripts-blog\PowerShell\functions\dns   C:\GitRepos\scripts-blog\PowerShell\functions\dns\Get-PublicDnsRecord.ps1
    
        .NOTES
        Author:     Luke Leigh
        Website:    https://scripts.lukeleigh.com/
        LinkedIn:   https://www.linkedin.com/in/lukeleigh/
        GitHub:     https://github.com/BanterBoy/
        GitHubGist: https://gist.github.com/BanterBoy
    
        .LINK
        https://github.com/BanterBoy/scripts-blog
        Get-Childitem
        Select-Object
    
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    [Alias('GFPR')]
    [OutputType([String])]
    Param (
        # Description of parameter
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "Enter the directory string that you want to search.")]
        [Alias("sp")]
        [String]
        $SourcePath,

        # Description of parameter
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromRemainingArguments = $false, 
            ParameterSetName = 'Default',
            HelpMessage = "When enabled, this will recurse through all the subfolders.")]
        [ValidateSet('true', 'false')]
        [string]
        $Recurse
    )
    
    begin {

    }

    process {

        switch ($Recurse) {
            true { 
                if ($pscmdlet.ShouldProcess("Target", "Operation")) {
                    $Folders = Get-ChildItem $SourcePath -Recurse | Where-Object { $_.psiscontainer -eq $true }
                    foreach ($Folder in $Folders) {
                        $ACLs = Get-Acl $Folder.fullname | ForEach-Object { $_.Access }
                        try {
                            foreach ($ACL in $ACLs) {
                                $OutInfo = @{
                                    Fullname          = $Folder.Fullname
                                    IdentityReference = $ACL.IdentityReference
                                    AccessControlType = $ACL.AccessControlType
                                    IsInherited       = $ACL.IsInherited
                                    InheritanceFlags  = $ACL.InheritanceFlags
                                    PropagationFlags  = $ACL.PropagationFlags
                                }
                                $obj = New-Object -TypeName PSObject -Property $OutInfo
                                Write-Output $obj
                            }
                        }
                        catch {
                            Write-Warning "$_"
                        }
                    }
                }
        
            }
            false { 
                if ($pscmdlet.ShouldProcess("Target", "Operation")) {
                    $Folders = Get-ChildItem $SourcePath | Where-Object { $_.psiscontainer -eq $true }
                    foreach ($Folder in $Folders) {
                        $ACLs = Get-Acl $Folder.fullname | ForEach-Object { $_.Access }
                        try {
                            foreach ($ACL in $ACLs) {
                                $OutInfo = @{
                                    Fullname          = $Folder.Fullname
                                    IdentityReference = $ACL.IdentityReference
                                    AccessControlType = $ACL.AccessControlType
                                    IsInherited       = $ACL.IsInherited
                                    InheritanceFlags  = $ACL.InheritanceFlags
                                    PropagationFlags  = $ACL.PropagationFlags
                                }
                                $obj = New-Object -TypeName PSObject -Property $OutInfo
                                Write-Output $obj
                            }
                        }
                        catch {
                            Write-Warning "$_"
                        }
                    }
                }
        
            }
            Default {
                if ($pscmdlet.ShouldProcess("Target", "Operation")) {
                    $Folders = Get-ChildItem $SourcePath | Where-Object { $_.psiscontainer -eq $true }
                    foreach ($Folder in $Folders) {
                        $ACLs = Get-Acl $Folder.FullName | ForEach-Object { $_.Access }
                        try {
                            foreach ($ACL in $ACLs) {
                                $OutInfo = @{
                                    Fullname          = $Folder.Fullname
                                    IdentityReference = $ACL.IdentityReference
                                    AccessControlType = $ACL.AccessControlType
                                    IsInherited       = $ACL.IsInherited
                                    InheritanceFlags  = $ACL.InheritanceFlags
                                    PropagationFlags  = $ACL.PropagationFlags
                                }
                                $obj = New-Object -TypeName PSObject -Property $OutInfo
                                Write-Output $obj
                            }
                        }
                        catch {
                            Write-Warning "$_"
                        }
                    }
                }
        
            }
        }
    }
    
    end {
    }
}

# Get-FolderPermissions -SourcePath C:\
# Get-FolderPermissions -SourcePath C:\ -Recurse true
