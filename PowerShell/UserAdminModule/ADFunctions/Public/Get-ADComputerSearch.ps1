#requires -PSEdition Desktop
function Get-ADComputerSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Filter = '*',

        [Parameter(Mandatory = $false)]
        [string]$OperatingSystem,

        [Parameter(Mandatory = $false)]
        [string]$SearchBase, # Optional SearchBase

        [Parameter(Mandatory = $false)]
        [switch]$IncludeDisabled, # Include disabled computers

        [Parameter(Mandatory = $false)]
        [switch]$IncludeAdditionalProperties, # Retrieve all AD properties

        [Parameter(Mandatory = $false)]
        [ValidateSet("Name", "OperatingSystem", "LastLogonDate", "PasswordLastSet")]
        [string]$SortBy = "Name" # Sorting option
    )

    PROCESS {
        try {
            # Define properties to retrieve
            $properties = @(
                "Name", "Description", "SamAccountName", "OperatingSystem", "OperatingSystemVersion", "PasswordLastSet",
                "LastLogonDate", "ManagedBy", "DNSHostName", "IPv4Address", 
                "IPv6Address", "ServicePrincipalName", "Enabled"
            )

            if ($IncludeAdditionalProperties) {
                $properties += "*"
            }

            # Construct proper AD query filter
            $filterCondition = "(Name -like '$Filter')"

            if (-not $IncludeDisabled) {
                $filterCondition += " -and (Enabled -eq '$true')"
            }

            # Add Operating System filtering if specified
            if ($OperatingSystem) {
                $filterCondition += " -and (OperatingSystem -like '*$OperatingSystem*')"
            }

            Write-Verbose "Using AD filter: $filterCondition"

            # Perform AD query with or without SearchBase
            if ($SearchBase) {
                $computers = Get-ADComputer -Filter $filterCondition -SearchBase $SearchBase -Properties $properties
            }
            else {
                $computers = Get-ADComputer -Filter $filterCondition -Properties $properties
            }

            if (!$computers) {
                Throw "No computers found matching the criteria."
            }

            # Process results
            $output = foreach ($computerInfo in $computers) {
                [PSCustomObject]@{
                    Name                   = $computerInfo.Name
                    Description            = $computerInfo.Description
                    DNSHostName            = $computerInfo.DNSHostName
                    SamAccountName         = $computerInfo.SamAccountName
                    IPv4Address            = $computerInfo.IPv4Address
                    IPv6Address            = $computerInfo.IPv6Address
                    OperatingSystem        = $computerInfo.OperatingSystem
                    OperatingSystemVersion = $computerInfo.OperatingSystemVersion
                    PasswordLastSet        = $computerInfo.PasswordLastSet
                    LastLogonDate          = $computerInfo.LastLogonDate
                    ManagedBy              = $computerInfo.ManagedBy
                    ServicePrincipalName   = $computerInfo.ServicePrincipalName -join ", " # Join SPNs into a single string
                    Enabled                = $computerInfo.Enabled
                }
            }

            # Sort results
            if ($SortBy) {
                $output = $output | Sort-Object -Property $SortBy
            }

            # Output final results
            return $output

        }
        catch {
            Write-Error "Error retrieving computer information: $_"
        }
    }
}
