<#
.SYNOPSIS
Retrieves WHOIS information for a given domain name.

.DESCRIPTION
The Get-WhoIsInformation function retrieves WHOIS information for a given domain name using the WhoisXmlApi service. It requires an API key and a domain name as input parameters. The function makes a GET request to the WhoisXmlApi service for each domain name provided and returns the relevant WHOIS information.

.PARAMETER APIKey
The API key required to access the WhoisXmlApi service. This parameter is mandatory.

.PARAMETER DomainName
The domain name(s) for which to retrieve WHOIS information. This parameter is mandatory and accepts an array of strings.

.EXAMPLE
Get-WhoIsInformation -APIKey "your-api-key" -DomainName "example.com"

This example retrieves WHOIS information for the domain name "example.com" using the specified API key.

.NOTES
Author: Your Name
Date:   Current Date
#>
# Define a function to get WHOIS information for a list of domain names
function Get-WhoIsInformation {
    # Use CmdletBinding to enable advanced function features
    [CmdletBinding()]
    param (
        # Define mandatory parameters for the function: API key and domain names
        [Parameter(Mandatory = $true)]
        [String]
        $APIKey,
        [Parameter(Mandatory = $true)]
        [string[]]
        $DomainName
    )

    # Initialize an array to store the responses
    $responses = @()

    # Loop through each domain name
    $DomainName | ForEach-Object {
        # Construct the request URI for the WHOIS API
        $requestUri = "https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey=$APIKey&amp;domainName=$_&amp;outputFormat=JSON"
        # Invoke the REST method to get the WHOIS information and add it to the responses array
        $responses += Invoke-RestMethod -Method Get -Uri $requestUri
    }

    # Define a helper function to get a valid date from the WHOIS information
    function Get-ValidDate ($Value, $Date) {
        # Try to get the default date
        $defaultDate = $Value."$($Date)Date"
        # If the default date is not available, get the normalized date
        $normalizedDate = $Value.registryData."$($Date)DateNormalized"
        if (![string]::IsNullOrEmpty($defaultDate)) {
            return Get-Date $defaultDate
        }

        # Parse the normalized date into a DateTime object
        return [datetime]::ParseExact($normalizedDate, "yyyy-MM-dd HH:mm:ss UTC", $null)   
    }

    # Define the properties to select from the WHOIS information
    $properties = "domainName", "domainNameExt",
    @{N = "createdDate"; E = { Get-ValidDate $_ "created" } },
    @{N = "updatedDate"; E = { Get-ValidDate $_ "updated" } },
    @{N = "expiresDate"; E = { Get-ValidDate $_ "expires" } },
    "registrarName",
    "contactEmail",
    "estimatedDomainAge",
    @{N = "contact"; e = { ($_.registrant | Select-Object -Property * -ExcludeProperty rawText ).PSObject.Properties.Value -join ", " } }

    # Select the defined properties from the WHOIS records
    $whoIsInfo = $responses.WhoisRecord | Select-Object -Property $properties

    # Export the WHOIS information to a CSV file
    $whoIsInfo | Export-Csv -NoTypeInformation domain-whois.csv

    # Format the WHOIS information as a table and output it
    $whoIsInfo | Format-Table
}