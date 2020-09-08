function Import-GivenNames
{
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
		BLOG:		http://www.poweradmin.se/blog
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
	if ((Test-Path -path $gNamesFile))
	{
		Remove-Item $gNamesFile
	}
	
	switch ($Country)
	{
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

function Import-SurNames
{
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
		BLOG:		http://www.poweradmin.se/blog
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
	if ((Test-Path -path $sNamesFile))
	{
		Remove-Item $sNamesFile
	}
	
	switch ($Country)
	{
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

function Get-GivenName
{
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
		BLOG:		http://www.poweradmin.se/blog
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
	
	if ($country -eq "ALL")
	{
		$mysNameFiles = Get-ChildItem -Path $CurrDir -Name "gNames*.txt"
		if (!($mysNameFiles -eq $null))
		{
			$mysNames = @()
			
			foreach ($myFile in $mysNameFiles)
			{
				$mysNames += Get-Content "$currDir\$myFile"
			}
			
			Get-Random $mysNames
		}
		else
		{
			Write-Warning "No imported given name files found!`nUse Import-GivenNames to get Given name files."
		}
	}
	else
	{
		$mysNameFile = Get-ChildItem -Path $CurrDir -Name "gNames$country.txt"
		if (!($mysNameFile -eq $null))
		{
			
			$mysNames = @()
			
			foreach ($myFile in $mysNameFile)
			{
				$mysNames += Get-Content "$currDir\$myFile"
			}
			
			Get-Random $mysNames
		}
		else
		{
			Write-Warning "No imported given name files for $Country found!`nUse Import-GivenNames -Country $Country to get Given name files."
		}
	}
	
}

function Get-SurName
{
<#
	.SYNOPSIS
		This function will get a random surname from a list of peoples surnames in USA, UK or Sweden

	.DESCRIPTION
		This function will get a random surname from a list of peoples surnames in USA, UK or Sweden.
        To get the list/lists of surnames use the Import-Surnames function Given.
         
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
		BLOG:		http://www.poweradmin.se/blog
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
	
	if ($country -eq "ALL")
	{
		$mysNameFiles = Get-ChildItem -Path $CurrDir -Name "snames*.txt"
		if (!($mysNameFiles -eq $null))
		{
			$mysNames = @()
			
			foreach ($myFile in $mysNameFiles)
			{
				$mysNames += Get-Content "$currDir\$myFile"
			}
			Get-Random $mysNames
		}
		else
		{
			Write-Warning "No imported surname files found!`nUse Import-SurNames to get surname files."	
		}
	}
	else
	{
		$mysNameFile = Get-ChildItem -Path $CurrDir -Name "snames$country.txt"
		if (!($mysNameFile -eq $null))
		{
			$mysNames = @()
			
			foreach ($myFile in $mysNameFile)
			{
				$mysNames += Get-Content "$currDir\$myFile"
			}	
			Get-Random $mysNames
		}
		else
		{
			Write-Warning "No imported surname files for $Country found!`nUse Import-SurNames -Country $Country to get surname files."
		}
	}
}

#Import-SurNames -country SWEDEN
#Import-SurNames -country USA
#Import-SurNames -country UK

#Import-GivenNames -country SWEDEN
#Import-GivenNames -country USA
#Import-GivenNames -country UK

#Write-Output "$(Get-GivenName -Country SWEDEN) $(Get-SurName -Country SWEDEN)"
#Write-Output "$(Get-GivenName -Country USA) $(Get-SurName -Country USA)"
#Write-Output "$(Get-GivenName -Country UK) $(Get-SurName -Country UK)"
#Write-Output "$(Get-GivenName -Country ALL) $(Get-SurName -Country ALL)"

#1..100 | foreach { Write-Output "$(Get-GivenName -Country ALL) $(Get-SurName -Country ALL)" }