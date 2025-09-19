Function Get-MgAdmins {
  <#
  .SYNOPSIS
  Get all users with an Admin role.

  .DESCRIPTION
  This function retrieves all users who have an Admin role. It uses the Microsoft Graph API to get the directory roles and their members. It then filters the members to only include users and returns the user details such as display name, user principal name, email, and ID.

  .NOTES
  - This function requires the Microsoft Graph PowerShell module.
  - You need to have the necessary permissions to access the directory roles and their members.

  .EXAMPLE
  Get-MgAdmins
  Retrieves all users with an Admin role.

  .OUTPUTS
  System.Management.Automation.PSCustomObject
  The function returns a custom object with the following properties:
  - Role: The name of the directory role.
  - DisplayName: The display name of the user.
  - UserPrincipalName: The user principal name (UPN) of the user.
  - Mail: The email address of the user.
  - Id: The ID of the user.

  .LINK
  Microsoft Graph PowerShell module: https://docs.microsoft.com/powershell/module/graph/?view=graph-powershell-1.0

  #>
  process {
    $admins = Get-MgDirectoryRole | Select-Object DisplayName, Id | 
    ForEach-Object -Process { $role = $_.DisplayName; Get-MgDirectoryRoleMember -DirectoryRoleId $_.id | 
      Where-Object -FilterScript { $_.AdditionalProperties."@odata.type" -eq "#microsoft.graph.user" } | 
      ForEach-Object -Process { Get-MgUser -userid $_.id }
    } | 
    Select-Object -Property @{Name = "Role"; Expression = { $role } }, DisplayName, UserPrincipalName, Mail, Id | Sort-Object -Property Mail -Unique
  
    return $admins
  }
}