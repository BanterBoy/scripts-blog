function Test-IsAdmin {
  <#
  .Synopsis
  Tests if the user is an administrator
  .Description
  Returns true if a user is an administrator, false if the user is not an administrator
  .Example
  Test-IsAdmin
  #>
  
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = New-Object Security.Principal.WindowsPrincipal $identity
  $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Set-TitleisAdmin {
  <#
  .SYNOPSIS
  Sets the console window title to display the current user's username, privileges, and current path.
  
  .DESCRIPTION
  This function sets the console window title to display the current user's username, followed by their privileges (either "Admin Privileges" or "User Privileges"), and the current path.
  
  .PARAMETER None
  This function does not accept any parameters.
  
  .EXAMPLE
  Set-TitleisAdmin
  #>
  $Username = whoami.exe /upn
  $CurrentPath = $PWD.Path

  if (Test-IsAdmin) {
    $host.UI.RawUI.WindowTitle = "$($Username) - Admin Privileges - Path: $($CurrentPath)"
  }	
  else {
    $host.UI.RawUI.WindowTitle = "$($Username) - User Privileges - Path: $($CurrentPath)"
  }	
}

function Set-PromptisAdmin {
  <#
  .SYNOPSIS
  Sets the PowerShell prompt to display whether the current session is running as an administrator or not.
  
  .DESCRIPTION
  This function sets the PowerShell prompt to display "(Admin)" if the current session is running as an administrator, or "(User)" if it is not.
  
  .PARAMETER None
  This function has no parameters.
  
  .EXAMPLE
  Set-PromptisAdmin
  This example sets the PowerShell prompt to display whether the current session is running as an administrator or not.
  
  .NOTES
  This function requires the Test-IsAdmin and Set-TitleisAdmin functions to be defined.
  #>
  if (Test-IsAdmin) {
    function global:prompt {
      Set-TitleisAdmin
      "(Admin) $PWD> "
    }
  }	
  else {
    function global:prompt {
      Set-TitleisAdmin
      "(User) $PWD> "
    }
  }	
}

function Show-IsAdminOrNot {
  <#
  .SYNOPSIS
      Determines if the current user has administrative privileges.

  .DESCRIPTION
      This function checks if the current user has administrative privileges by calling the `Test-IsAdmin` function. 
      It outputs a warning message indicating whether the user has admin privileges or user privileges.

  .PARAMETER None
      This function does not take any parameters.

  .OUTPUTS
      None. Outputs a warning message indicating the privilege level.

  .EXAMPLE
      PS C:\> Show-IsAdminOrNot
      WARNING: Admin Privileges!

      This example checks the current user's privilege level and outputs "Admin Privileges!" if the user has administrative rights.

  .NOTES
      Author: Your Name
      Date: 30/06/2024
      The function `Test-IsAdmin` must be defined for this function to work correctly.

  .LINK
      https://github.com/YourGitHubProfile
  #>

  # Check if the user is an admin
  $IsAdmin = Test-IsAdmin

  # Output a warning message based on the user's privilege level
  if ($IsAdmin -eq $false) {
    Write-Warning -Message "User Privileges"
  }
  else {
    Write-Warning -Message "Admin Privileges!"
  }
}

# Helper function to determine if the current user is an administrator
function Test-IsAdmin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
