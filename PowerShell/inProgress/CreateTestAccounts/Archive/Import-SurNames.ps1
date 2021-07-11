function Import-SurNames {
    <#
	.SYNOPSIS
		This function will create a list of peoples surnames in USA, UK or Sweden

	.DESCRIPTION
		This function will create a list of peoples surnames in USA, UK or Sweden.
        The file will be created in the same folder as the script and will be named sNames[Country].txt.
		You need to have internet access when you run this function.
	
	.PARAMETER Country
        Choose from wish country you want to create a list of peoples surnames 
    
	.EXAMPLE 
        Import-SurNames -Country SWEDEN
    
	.EXAMPLE 
        Import-SurNames -Country USA

    .EXAMPLE 
        Import-SurNames -Country UK
	
	.EXAMPLE 
        Import-SurNames -Country SWEDEN | Out-Null
	
	.NOTES
		NAME:      	Import-SurNames
		AUTHOR:    	Fredrik Wall, fredrik@poweradmin.se
		BLOG:		http://www.fredrikwall.se
		TWITTER:	walle75
		CREATED:	12/24/2009
		LASTEDIT:  	03/20/2016
		VERSION:	3.0
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
	
    # Path to all local files
    $sNamesFile = "$currdir\snames" + $country + ".txt"
	
    Write-Output "Will create the list of surnames for $country"
	
    # Deleting old files
    if ((Test-Path -path $sNamesFile)) {
        Remove-Item $sNamesFile
    }
	
    switch ($Country) {
        "USA" {
            # The USA file is downloaded from 
            # http://names.mongabay.com/most_common_surnames.htm
            # It's a list of the 1000 most common surnames in the US
			
            $HTML = Invoke-WebRequest "http://names.mongabay.com/most_common_surnames.htm"
            $myNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 1
                )
            }
			
            # Make them in lower case and sort them
            # Lower case is needed for the title case thing
            $myNames = $myNames.ToLower() | Sort-Object
			
            # Count all names
            $nrOfName = $myNames.Count
			
            # Fix so all names start with a capital letter			
            $TextInfo = (Get-Culture).TextInfo
            $myNames = $TextInfo.ToTitleCase($myNames)
			
            # Fix the names so we can save them one by one in a text file
            $myNames.Split(" ") | Out-File $sNamesFile -Append
        }
		
        "SWEDEN" {
            # The SWEDEN file is downloaded from 
            # http://www.scb.se
            # It's a list of the 100 most common surnames in Sweden
			
            $HTML = Invoke-WebRequest "http://www.scb.se/sv_/hitta-statistik/statistik-efter-amne/befolkning/amnesovergripande-statistik/namnstatistik/30898/30905/samtliga-folkbokforda--efternamn-topplistor/31063/"
            $myNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 3 | Select-Object -Last 1
                )
            }
			
            # Sort the names and only takes the unique ones
            $myNames = $myNames | Sort-Object -Unique
			
            # Count all names
            $nrOfName = $myNames.Count
			
            # Save the names to a text file
            $myNames | Out-File $sNamesFile -Append
        }
		
        "UK" {
            # The UK file is downloaded from 
            # http://www.names-surnames.com
            # It's a list of the 200 most common surnames in the UK
			
            $HTML = Invoke-WebRequest "http://www.names-surnames.com/most-common-surnames-uk/588-most-common-surnames-uk-1-200"
            $myNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 3 | Select-Object -Last 1
                )
            }
			
            # Sort the names and only takes the unique ones
            $myNames = $myNames | Sort-Object -Unique
			
            # Count all names
            $nrOfName = $myNames.Count
			
            # Save the names to a text file
            $myNames | Out-File $sNamesFile -Append
        }
    }
	
    Write-Output "$nrOfName surnames from $country imported!"
}
