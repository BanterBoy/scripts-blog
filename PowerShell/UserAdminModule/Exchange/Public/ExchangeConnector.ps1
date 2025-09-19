<#
.SYNOPSIS
Connects to Exchange Online or Exchange On-premises using a script menu.

.DESCRIPTION
The ExchangeConnector function uses the PSMenu module to create a script menu for connecting to Exchange Online or Exchange On-premises. It prompts the user to select an option from the menu and performs the corresponding action based on the selection.

.PARAMETER None

.INPUTS
None

.OUTPUTS
None

.EXAMPLE
ExchangeConnector
Connects to Exchange Online or Exchange On-premises based on the user's selection.

.NOTES
Requires the PSMenu module to be installed. You can install it from the PowerShell Gallery using the following command:
Install-Module -Name PSMenu -Scope CurrentUser

#>

function ExchangeConnector {

    # Using the PSMenu module to create a script menu
    # Requires PSMenu module to be installed
    # https://www.powershellgallery.com/packages/PSMenu/1.0.0

    # Import the PSMenu module
    Import-Module PSMenu

    # Create a new menu
    $Menu = Show-Menu @("Connect Exchange Online", "Connect Exchange On-prem", $(Get-MenuSeparator), "Quit")

    # Use the correct comparison operator and check the value of $Menu
    if ($Menu -eq "Connect Exchange Online") { Connect-ExchangeOnline -UserPrincipalName (Read-Host "Enter your O365 Admin Email Address") }
    elseif ($Menu -eq "Connect Exchange On-prem") { Connect-ExchangeOnPrem -ComputerName ($(Get-ExchangeServerInSite)[0].fqdn) }
    else { Write-Output "Nothing Selected" }

}
