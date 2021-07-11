function Import-GivenNames {
    <#
	.SYNOPSIS
		This function will create a list of peoples given names in USA, UK or Sweden

	.DESCRIPTION
		This function will create a list of peoples given names in USA, UK or Sweden.
        The file will be created in the same folder as the script and will be named gNames[Country].txt.
		You need to have internet access when you run this function.
	
	.PARAMETER Country
        Choose from wish country you want to create a list of peoples given names
    
	.EXAMPLE 
        Import-GivenNames -Country SWEDEN
    
	.EXAMPLE 
        Import-GivenNames -Country USA

    .EXAMPLE 
        Import-GivenNames -Country UK
	
	.EXAMPLE
		Import-GivenNames -Country SWEDEN | Out-Null
	
	.NOTES
		NAME:      	Import-GivenNames
		AUTHOR:    	Fredrik Wall, fredrik@poweradmin.se
		BLOG:		http://www.fredrikwall.se
		TWITTER:	walle75
		CREATED:	12/24/2009
		LASTEDIT:  	03/23/2016
        VERSION:    3.1
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
    $gNamesFile = "$currdir\gNames" + $country + ".txt"
	
    Write-Output "Will create the list of Given names for $country"
	
    # Deleting old files
    if ((Test-Path -path $gNamesFile)) {
        Remove-Item $gNamesFile
    }
	
    switch ($Country) {
        "USA" {
            # The USA files is downloaded from 
            # http://names.mongabay.com/male_names_alpha.htm
            # http://names.mongabay.com/female_names_alpha.htm
            # It's a list of more then 1000 most common given names in the US
			
            # Male names
            $HTML = Invoke-WebRequest "http://names.mongabay.com/male_names_alpha.htm"
            $myMaleNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 1
                )
            }
			
            # Female names
            $HTML = Invoke-WebRequest "http://names.mongabay.com/female_names_alpha.htm"
            $myFemaleNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 1
                )
            }
			
            # Add Male and Female names together
            $myNames = $myMaleNames + $myFemaleNames
			
            # Make them in lower case and sort them
            # Lower  case is needed for the title case thing
            $myNames = $myNames.ToLower() | Sort-Object -Unique
			
            # Count all names
            $nrOfName = $myNames.Count
			
            # Fix so all names start with a capital letter
            $TextInfo = (Get-Culture).TextInfo
            $myNames = $TextInfo.ToTitleCase($myNames)
			
            # Fix the names so we can save them one by one in a text file
            $myNames.Split(" ") | Out-File $gNamesFile -Append
        }
		
        "SWEDEN" {
            # The SWEDEN file is downloaded from 
            # http://www.scb.se
            # It's a list of the 100 most common Given names for males and females in Sweden
			
            # Male names
            $HTML = Invoke-WebRequest "http://www.scb.se/sv_/Hitta-statistik/Statistik-efter-amne/Befolkning/Amnesovergripande-statistik/Namnstatistik/30898/30905/Samtliga-folkbokforda--Fornamn-och-tilltalsnamn-topplistor/286717/"
            $myMaleNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 3 | Select-Object -Last 1
                )
            }
			
            # Female names
            $HTML = Invoke-WebRequest "http://www.scb.se/sv_/Hitta-statistik/Statistik-efter-amne/Befolkning/Amnesovergripande-statistik/Namnstatistik/30898/30905/Samtliga-folkbokforda--Fornamn-och-tilltalsnamn-topplistor/31042/"
            $myFemaleNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 3 | Select-Object -Last 1
                )
            }
			
            # Add Male and Female names together
            $myNames = $myMaleNames + $myFemaleNames
			
            # Sort the names and only takes the unique ones
            $myNames = $myNames | Sort-Object -Unique
			
            # Count all names
            $nrOfName = $myNames.Count
			
            # Save the names to a text file
            $myNames | Out-File $gNamesFile -Append
        }
		
        "UK" {
            # The UK file is downloaded from 
            # http://www.behindthename.com
            # It's a list of the 991 most common Given names in the UK and Wales from 2014
			
            # Male and female names
            $HTML = Invoke-WebRequest "http://www.behindthename.com/top/lists/england-wales/2014"
            $myNames = $HTML.parsedhtml.getelementsbytagname("TR") |
			
            ForEach-Object {
                ($_.children |
                    Where-Object { $_.tagName -eq "td" } |
                    Select-Object -ExpandProperty innerText -First 2 | Select-Object -Last 1
                )
            }
			
            # Sort the names and only takes the unique ones
            $myNames = $myNames | Sort-Object -Unique
			
            # Fixing the Given line, that is an empty one and some lines in the end
            $myNames = $myNames | Select-Object -Skip 1 | Select-Object -First 991
			
            # Triming all names from blank spaces
            $myNames = $myNames.Trim()
			
            # Count all names
            $nrOfName = $myNames.Count
			
            # Save the names to a text file
            $myNames | Out-File $gNamesFile -Append
        }
    }
	
    Write-Output "$nrOfName Given names from $country imported!"
}
