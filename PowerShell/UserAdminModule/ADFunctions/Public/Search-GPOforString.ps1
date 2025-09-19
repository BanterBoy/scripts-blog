# Import-Module GroupPolicy -SkipEditionCheck

function Search-GPOsForString {
    <#
    .SYNOPSIS
        Searches all Group Policy Objects (GPOs) in the current user's domain for a specified string.

    .DESCRIPTION
        This function searches all GPOs in the current user's domain for a specified string. It uses the Get-GPOReport cmdlet to retrieve the XML report for each GPO, and then searches the report for the specified string using regular expressions. If a match is found, the function outputs a custom object with the name of the matching GPO and the search string.

    .PARAMETER SearchText
        The string to search for in the GPOs.

    .EXAMPLE
        Search-GPOsForString -SearchText "password"
        This example searches all GPOs in the current user's domain for the string "password".

    .NOTES
        Author: Luke Leigh
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the string to search for in the GPOs')]
        [string]$SearchText
    )

    # Get the domain name from the environment variable
    $DomainName = $env:USERDNSDOMAIN
    Write-Verbose "Domain Name: $DomainName"

    # Get all GPOs in the domain
    Write-Verbose "Retrieving all GPOs in the domain..."
    $allGposInDomain = Get-GPO -All -Domain $DomainName
    $totalGpos = $allGposInDomain.Count
    Write-Verbose "Total GPOs retrieved: $totalGpos"

    # Initialize the current GPO counter
    $currentGpo = 0

    # Loop through each GPO
    foreach ($gpo in $allGposInDomain) {
        # Increment the current GPO counter
        $currentGpo++

        # Check if the GPO ID is not null
        if ($null -ne $gpo.Id) {
            Write-Verbose "Processing GPO: $($gpo.DisplayName) (ID: $($gpo.Id))"

            # Get the GPO report in XML format
            try {
                $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml -ErrorAction Stop
                Write-Verbose "GPO report retrieved successfully."
            }
            catch {
                Write-Warning "Failed to retrieve report for GPO: $($gpo.DisplayName). Skipping this GPO."
                continue
            }

            # Check if the report matches the search text
            if ($report -match ([regex]::Escape("$SearchText"))) {
                Write-Verbose "Match found in GPO: $($gpo.DisplayName)"

                # Create a custom object with the GPO name and the match
                $result = [PSCustomObject]@{
                    'GPOName' = $gpo.DisplayName
                    'Match'   = $SearchText
                }

                # Output the result
                Write-Output $result
            }
        }

        # Update the progress bar
        Write-Progress -Activity "Searching GPOs" -Status "$currentGpo of $totalGpos GPOs searched" -PercentComplete (($currentGpo / $totalGpos) * 100)
    }
}
