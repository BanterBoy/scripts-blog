<#
.SYNOPSIS
Retrieves information about all domain controllers in the current domain.

.DESCRIPTION
The Get-AllDomainControllers function retrieves information about all domain controllers in the current domain. It uses the Get-ADDomainController cmdlet to query the domain controllers and returns a custom object with the hostname, site, and operating system of each domain controller.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-AllDomainControllers

This example retrieves information about all domain controllers in the current domain and displays the hostname, site, and operating system of each domain controller.

.OUTPUTS
System.Management.Automation.PSCustomObject
The function returns a custom object with the following properties:
- Hostname: The hostname of the domain controller.
- Site: The site where the domain controller is located.
- OperatingSystem: The operating system running on the domain controller.

.NOTES
Author: Your Name
Date: Current Date
Version: 1.0
#>

Function Get-AllDomainControllers {
    Get-ADDomainController -Filter * -Server (Get-ADDomain).DNSRoot | Select-Object Hostname,Site,OperatingSystem
}
