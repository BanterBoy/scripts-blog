function Get-O365CalendarPermissions {

    <#

    .SYNOPSIS
    Get-O365CalendarPermissions - A function to get the permissions for a calendar.
	
	.DESCRIPTION
    Get-O365CalendarPermissions - A function to get the permissions for a calendar. This function will only return the permissions for the calendar of the user named in UserPrincipalName. It will not return the permissions for any other calendars that the user may have access to.
	
	.PARAMETER UserName
    [string]UserPrincipalName - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.
	
	.EXAMPLE
    Get-O365CalendarPermissions -UserPrincipalName "user@example.com"

    Returns the permissions for the calendar of the user named in UserPrincipalName
	
	.INPUTS
    You can pipe objects to these perameters.
    
    - UserPrincipalName [string] - Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.
	
	.OUTPUTS
    [string] - Returns the permissions for the calendar of the user named in UserPrincipalName
	
	.NOTES
    Author:     Luke Leigh
    Website:    https://scripts.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy
	
	.LINK
    https://scripts.lukeleigh.com
    Get-MailboxFolderPermission
    Get-Mailbox
    New-Object
    Write-Output

    #>
	
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]

    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the UserPrincipalName for the calendar owner whose calendar you want to query. This parameter can be piped.')]
        [ValidateNotNullOrEmpty()]
        [string[]]$UserPrincipalName
    )

    begin {
    }

    process {

        if ($PSCmdlet.ShouldProcess("$UserPrincipalName", "Querying calendar permissions for")) {
            
            foreach ($User in $UserPrincipalName) {
            
                $Permissions = Get-MailboxFolderPermission "$($User):\Calendar"
                
                foreach ($Permission in $Permissions) {

                    if ($Permission.User.UserType -like 'Internal') {
                        $properties = @{
                            'CalendarOwner'     = $Permission.Identity -split ':' | Select-Object -First 1
                            'UserPrincipalName' = $User
                            'UserType'          = $Permission.User.UserType
                            'PermissionType'    = 'Calendar'
                            'User'              = $Permission.User.DisplayName
                            'AccessRights'      = $Permission.AccessRights
                        }
                        $Output = New-Object -TypeName psobject -Property $properties
                        Write-Output -InputObject $Output

                    }

                }

            }

        }

    }

    end {
        
    }

}
