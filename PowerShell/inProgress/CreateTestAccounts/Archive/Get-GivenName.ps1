function Get-GivenName {
    <#
	.SYNOPSIS
		This function will get a random Given name from a list of peoples Given names in USA, UK or Sweden

	.DESCRIPTION
		This function will get a random Given name from a list of peoples Given names in USA, UK or Sweden.
        To get the list/lists of Given names use the Import-GivenNames function Given.
         
	.PARAMETER Country
        Choose from wish country you want to get a surname or use ALL for all lists
    
	.EXAMPLE 
        Get-GivenName -Country SWEDEN
    
	.EXAMPLE 
        Get-GivenName -Country USA

    .EXAMPLE 
        Get-GivenName -Country UK
        
    .EXAMPLE
        Get-GivenName -Country ALL
	
	.NOTES
		NAME:      	Get-GivenName
		AUTHOR:    	Fredrik Wall, fredrik@poweradmin.se
		BLOG:		http://www.fredrikwall.se
		TWITTER:	walle75
		CREATED:	12/24/2009
		LASTEDIT:  	03/23/2016
		VERSION: 	3.1
#>	
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true,
            Position = 1)]
        $Country
    )
	
    # Path to the current directory.
    $CurrDir = (Get-Location -PSProvider FileSystem).ProviderPath
	
    if ($country -eq "ALL") {
        $mysNameFiles = Get-ChildItem -Path $CurrDir -Name "gNames*.txt"
        if (!($mysNameFiles -eq $null)) {
            $mysNames = @()
			
            foreach ($myFile in $mysNameFiles) {
                $mysNames += Get-Content "$currDir\$myFile"
            }
			
            Get-Random $mysNames
        }
        else {
            Write-Warning "No imported given name files found!`nUse Import-GivenNames to get Given name files."
        }
    }
    else {
        $mysNameFile = Get-ChildItem -Path $CurrDir -Name "gNames$country.txt"
        if (!($mysNameFile -eq $null)) {
			
            $mysNames = @()
			
            foreach ($myFile in $mysNameFile) {
                $mysNames += Get-Content "$currDir\$myFile"
            }
			
            Get-Random $mysNames
        }
        else {
            Write-Warning "No imported given name files for $Country found!`nUse Import-GivenNames -Country $Country to get Given name files."
        }
    }
	
}
