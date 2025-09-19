function PersonalModules {
    [CmdletBinding(DefaultParameterSetName = "AllModules")]
    param (
        [Parameter(ParameterSetName = "AllModules", Mandatory = $false)]
        [Parameter(ParameterSetName = "CategoryFilter", Mandatory = $false)]
        [ValidateSet("All", "ADFunctions", "Azure", "EnvironmentManagement", "Exchange", "FileOperations", "Logging", "MediaManagement", "Network", "PKIdecommission", "RemoteConnections", "Replication", "Security", "Shell", "Teams", "Testing", "Utilities", "Database", "Weather")]
        [string]$Category = "All",

        [Parameter(ParameterSetName = "ExcludeADTools", Mandatory = $true)]
        [switch]$ADTools
    )

    $PersonalModules = @(
        "ADFunctions",
        "Azure",
        "EnvironmentManagement",
        "Exchange",
        "FileOperations",
        "Logging",
        "MediaManagement",
        "Network",
        "PKIdecommission",
        "RemoteConnections",
        "Replication",
        "Security",
        "Shell",
        "Teams",
        "Testing",
        "Utilities",
        "Database",
        "Weather"
    )

    switch ($PSCmdlet.ParameterSetName) {
        "AllModules" {
            # Return all modules
            if ($Category -ne "All") {
                # Filter the modules based on the selected category
                $PersonalModules = $PersonalModules | Where-Object { $_ -eq $Category }
            }
        }
        "ExcludeADTools" {
            # Exclude ADFunctions if -ADTools is specified
            $PersonalModules = $PersonalModules | Where-Object { $_ -ne "ADFunctions" }
        }
        "CategoryFilter" {
            # Filter the modules based on the selected category
            $PersonalModules = $PersonalModules | Where-Object { $_ -eq $Category }
        }
    }

    return $PersonalModules
}