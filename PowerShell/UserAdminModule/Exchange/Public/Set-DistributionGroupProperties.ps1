function Set-DistributionGroupProperties {
    <#
    .SYNOPSIS
        Sets properties for distribution groups in Exchange.

    .DESCRIPTION
        This function sets various properties for distribution groups in Exchange. It takes a PSObject representing a distribution group and modifies its properties based on the provided values. It can handle setting names, aliases, primary SMTP addresses, and additional email addresses including x500 addresses.

    .PARAMETER DistributionGroup
        The distribution group object containing the properties to be set. This object should have the properties: PrimarySmtpAddress, Name, NEWName, Alias, DisplayName, NEWPrimarySmtpAddress, FULLADDRESS, and LegacyExchangeDN.

    .EXAMPLE
        Import-Csv -Path 'path_to_your_csv_file.csv' | Set-DistributionGroupProperties

        This example reads a CSV file and pipes the results to the Set-DistributionGroupProperties function. The CSV file should contain columns that match the properties expected by the function.

    .NOTES
        Author: Luke Leigh
        Last Edit: 2024-06-30

    .LINK
        https://github.com/BanterBoy

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [PSObject]$DistributionGroup
    )

    begin {
        Write-Verbose "Starting Set-DistributionGroupProperties function"
    }

    process {
        try {
            $PrimarySmtpAddress = $DistributionGroup.PrimarySmtpAddress
            Write-Verbose "Working on Group: $($DistributionGroup.Name)"

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Set properties")) {
                Write-Verbose "Setting properties for Group: $($DistributionGroup.Name)"
                Set-DistributionGroup -Identity $DistributionGroup.NEWName -Name $DistributionGroup.Name -Alias $DistributionGroup.Alias -DisplayName $DistributionGroup.DisplayName -PrimarySmtpAddress $PrimarySmtpAddress -HiddenFromAddressListsEnabled $false
                Write-Verbose "Properties set for Group: $($DistributionGroup.Name)"
            }

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Remove new primary SMTP address")) {
                Write-Verbose "Removing new primary SMTP address for Group: $($DistributionGroup.Name)"
                Set-DistributionGroup -Identity $DistributionGroup.PrimarySmtpAddress -EmailAddresses @{remove = $DistributionGroup.NEWPrimarySmtpAddress }
                Write-Verbose "New primary SMTP address removed for Group: $($DistributionGroup.Name)"
            }

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Add full address")) {
                Write-Verbose "Adding full address for Group: $($DistributionGroup.Name)"
                Set-DistributionGroup -Identity $DistributionGroup.PrimarySmtpAddress -EmailAddresses @{Add = $DistributionGroup.FULLADDRESS }
                Write-Verbose "Full address added for Group: $($DistributionGroup.Name)"
            }

            if ($PSCmdlet.ShouldProcess("Distribution Group: $($DistributionGroup.Name)", "Add x500 address")) {
                Write-Verbose "Adding x500 address for Group: $($DistributionGroup.Name)"
                $LegacyExchangeDN = "x500:" + $DistributionGroup.LegacyExchangeDN
                Set-DistributionGroup -Identity $DistributionGroup.PrimarySmtpAddress -EmailAddresses @{Add = $LegacyExchangeDN }
                Write-Verbose "x500 address added for Group: $($DistributionGroup.Name)"
            }
        }
        catch {
            Write-Error "An error occurred while processing Group: $($DistributionGroup.Name). Error: $_"
        }
    }

    end {
        Write-Verbose "Ending Set-DistributionGroupProperties function"
    }
}

# Example usage:
# Import-Csv -Path 'path_to_your_csv_file.csv' | Set-DistributionGroupProperties -Verbose
