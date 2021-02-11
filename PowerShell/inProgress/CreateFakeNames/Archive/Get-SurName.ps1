function Get-SurName {
    <#
	.SYNOPSIS
		This function will get a random surname from a list of peoples surnames in USA, UK or Sweden

	.DESCRIPTION
		This function will get a random surname from a list of peoples surnames in USA, UK or Sweden.
        To get the list/lists of surnames use the Import-Surnames function first.
         
	.PARAMETER Country
        Choose from wish country you want to get a surname or use ALL for all lists
    
	.EXAMPLE 
        Get-SurName -Country SWEDEN
    
	.EXAMPLE 
        Get-SurName -Country USA

    .EXAMPLE 
        Get-SurName -Country UK
        
    .EXAMPLE
        Get-Surname -Country ALL
	
	.NOTES
		NAME:      	Get-SurName
		AUTHOR:    	Fredrik Wall, fredrik@poweradmin.se
		BLOG:		http://www.fredrikwall.se
		TWITTER:	walle75
		CREATED:	12/24/2009
		LASTEDIT:  	03/20/2016
		VERSION: 	3.0
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
        $mysNameFiles = Get-ChildItem -Path $CurrDir -Name "snames*.txt"
        if (!($mysNameFiles -eq $null)) {
            $mysNames = @()
			
            foreach ($myFile in $mysNameFiles) {
                $mysNames += Get-Content "$currDir\$myFile"
            }
            Get-Random $mysNames
        }
        else {
            Write-Warning "No imported surname files found!`nUse Import-SurNames to get surname files."	
        }
    }
    else {
        $mysNameFile = Get-ChildItem -Path $CurrDir -Name "snames$country.txt"
        if (!($mysNameFile -eq $null)) {
            $mysNames = @()
			
            foreach ($myFile in $mysNameFile) {
                $mysNames += Get-Content "$currDir\$myFile"
            }	
            Get-Random $mysNames
        }
        else {
            Write-Warning "No imported surname files for $Country found!`nUse Import-SurNames -Country $Country to get surname files."
        }
    }
}
