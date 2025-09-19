<#
.SYNOPSIS
    Retrieves calendar access permissions for a specified user from Active Directory and exports the results to a CSV file.

.DESCRIPTION
    The Get-UsersCalendarAccess function retrieves calendar access permissions for a specified user from Active Directory. It uses the Get-ADUser cmdlet to get a list of users from a specified search base. Then, it uses the Get-O365CalendarPermissions cmdlet to get the calendar permissions for each user. The function filters the results to only include the permissions for the specified user and exports them to a CSV file.

.PARAMETER UserName
    Specifies the username for which to retrieve calendar access permissions.

.PARAMETER OutputPath
    Specifies the path where the CSV file containing the calendar access permissions will be saved.

.PARAMETER SearchBase
    Specifies the search base for the Get-ADUser cmdlet. This parameter is optional. If not specified, the function will use the default search base.

.EXAMPLE
    Get-UsersCalendarAccess -UserName "Charmaine Kerr" -OutputPath "C:\Temp\CharmaineCalendarPerms.csv" -SearchBase "OU=Azure Sync Users,OU=Active,OU=RDG Users,DC=rdg,DC=co,DC=uk"
    Retrieves the calendar access permissions for the user "Charmaine Kerr" from the specified search base and exports the results to the specified CSV file.

#>

function Get-UsersCalendarAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$UserName,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath, 

        [Parameter(Mandatory = $false)]
        [string]$SearchBase
    )

    try {
        $AZSyncUsers = Get-ADUser -filter " Name -like '*' " -SearchBase $SearchBase -ErrorAction Stop | Where-Object -FilterScript { $_.Enabled -eq $true }
    }
    catch {
        Write-Error "Failed to get AD users: $_"
        return
    }

    $CalendarPermissions = $AZSyncUsers | ForEach-Object -Process {
        try {
            Get-O365CalendarPermissions -UserPrincipalName $_.UserPrincipalName -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to get calendar permissions for $($_.UserPrincipalName): $_"
        }
    } | Where-Object -FilterScript { $_.User -eq $UserName }

    if ($CalendarPermissions) {
        $CalendarPermissions | Export-Csv -Path $OutputPath -Encoding utf8 -ErrorAction SilentlyContinue
        if (-not $?) {
            Write-Error "Failed to export calendar permissions to CSV at $OutputPath"
        }
    }
    else {
        Write-Warning "No calendar permissions found for $UserName"
    }

    return $CalendarPermissions
}
