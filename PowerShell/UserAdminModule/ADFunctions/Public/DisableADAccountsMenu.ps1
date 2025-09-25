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
    function Disable-KurtisMarsden {
        Disable-ADAccount -Identity kurtismarsden.admin
        Write-Output "Account kurtismarsden.admin has been disabled."
    }

    function Disable-JamieBeale {
        Disable-ADAccount -Identity jamiebeale.admin
        Write-Output "Account jamiebeale.admin has been disabled."
    }

    function Disable-LukeLeigh {
        Disable-ADAccount -Identity lukeleigh.admin
        Write-Output "Account lukeleigh.admin has been disabled."
    }

    # Create the menu items
    $menuItems = @(
        "Disable Kurtis Marsden Account",
        "Disable Jamie Beale Account",
        "Disable Luke Leigh Account",
        $(Get-MenuSeparator),
        "Exit"
    )

    # Display the menu
    $Menu = Show-Menu -MenuItems $menuItems -ReturnIndex -ItemFocusColor "Yellow"

    # Use the correct comparison operator and check the value of $Menu
    switch ($Menu) {
        0 { Disable-KurtisMarsden }
        1 { Disable-JamieBeale }
        2 { Disable-LukeLeigh }
        default { Write-Output "Nothing Selected" }
    }
}

# Call the function to display the menu
# DisableADAccountsMenu
