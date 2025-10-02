#requires -Modules PSMenu
#requires -PSEdition Desktop

<#
.SYNOPSIS
    Displays a menu to disable Active Directory user accounts.

.DESCRIPTION
    The DisableADAccountsMenu function displays a menu with options to disable specific Active Directory user accounts. 
    It uses the PSMenu module to create the menu and calls the appropriate functions to disable the selected user account.

.PARAMETER None

.INPUTS
    None

.OUTPUTS
    None

.EXAMPLE
    DisableADAccountsMenu
    Displays the menu to disable Active Directory user accounts.

.NOTES
    This function requires the PSMenu module to be imported.

.LINK
    PSMenu module: https://github.com/gangstanthony/PSMenu

#>

function DisableADAccountsMenu {

    # Import the PSMenu module
    Import-Module PSMenu

    # Define the actions
    function Disable-JohnSmith {
        Disable-ADAccount -Identity JohnSmith.admin
        Write-Output "Account JohnSmith.admin has been disabled."
    }

    function Disable-JackDaniels {
        Disable-ADAccount -Identity JackDaniels.admin
        Write-Output "Account JackDaniels.admin has been disabled."
    }

    function Disable-GeoffGeoffries {
        Disable-ADAccount -Identity GeoffGeoffries.admin
        Write-Output "Account GeoffGeoffries.admin has been disabled."
    }

    # Create the menu items
    $menuItems = @(
        "Disable John Smith Account",
        "Disable Jack Daniels Account",
        "Disable Geoff Geoffries Account",
        $(Get-MenuSeparator),
        "Exit"
    )

    # Display the menu
    $Menu = Show-Menu -MenuItems $menuItems -ReturnIndex -ItemFocusColor "Yellow"

    # Use the correct comparison operator and check the value of $Menu
    switch ($Menu) {
        0 { Disable-JohnSmith }
        1 { Disable-JackDaniels }
        2 { Disable-GeoffGeoffries }
        default { Write-Output "Nothing Selected" }
    }
}

# Call the function to display the menu
# DisableADAccountsMenu
