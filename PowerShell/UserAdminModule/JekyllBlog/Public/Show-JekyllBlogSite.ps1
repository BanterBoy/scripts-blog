function Show-JekyllBlogSite {
	<#
    .SYNOPSIS
        Opens the local Jekyll blog site in the default web browser.

    .DESCRIPTION
        This function constructs the local URL for the Jekyll blog site using the computer's DNS name and network profile. 
        It then opens this URL in the default web browser.

    .PARAMETER None
        This function does not take any parameters.

    .OUTPUTS
        None. Opens the URL in the default web browser.

    .EXAMPLE
        PS C:\> Show-JekyllBlogSite
        This example opens the local Jekyll blog site in the default web browser.

    .NOTES
        Author: Your Name
        Date: 30/06/2024

    .LINK
        https://github.com/YourGitHubProfile
    #>

	[CmdletBinding()]
	param()

	begin {
		Write-Verbose "Initializing Show-JekyllBlogSite function"
	}

	process {
		try {
			Write-Verbose "Retrieving computer name and network profile"
			$ComputerDNSName = $env:COMPUTERNAME + '.' + (Get-NetIPConfiguration | Select-Object -ExpandProperty NetProfile).Name
			$URL = "http://" + $ComputerDNSName + ":4000"
			Write-Verbose "Constructed URL: $URL"
            
			Write-Verbose "Opening the URL in the default web browser"
			Start-Process $URL
		}
		catch {
			Write-Error "An error occurred while trying to open the Jekyll blog site: $_"
		}
	}

	end {
		Write-Verbose "Completed Show-JekyllBlogSite function"
	}
}

# Example usage:
# Show-JekyllBlogSite -Verbose
