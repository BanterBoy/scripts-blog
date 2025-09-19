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
