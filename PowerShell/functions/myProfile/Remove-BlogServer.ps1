function Remove-BlogServer {
	$title = 'Clean Blog Environment'
	$question = 'Are you sure you want to proceed?'
	$choices = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
	if ($decision -eq 0) {
		$directoryPath = Select-FolderLocation
		if (![string]::IsNullOrEmpty($directoryPath)) {
			Write-Host "You selected the directory: $directoryPath"
		}
		else {
			"You did not select a directory."
		}
		Write-Host 'Cleaning Environment - Removing Images'
		$images = docker images jekyll/jekyll:latest -q
		foreach ($image in $images) {
			docker image rm $image -f
			docker image rm $(docker ps -a -f status=exited -q)
		}
		$vendor = $directoryPath + "\vendor"
		$site = $directoryPath + "\_site"
		$gemfile = $directoryPath + "\gemfile.lock"
		$jekyllmetadata = $directoryPath + "\.jekyll-metadata"

		$vendorPath = Test-Path -Path $vendor
		$sitePath = Test-Path -Path $site
		$gemfilePath = Test-Path -Path $gemfile
		$jekyllmetadataPath = Test-Path -Path $jekyllmetadata


		if ($vendorPath = $true) {
			Write-Warning -Message 'Cleaning Environment - Removing Vendor Bundle'
			try {
				Remove-Item -Path $vendor -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message 'Vendor Bundle removed.' -Verbose
			}
			catch {
				Write-Verbose -Message 'Vendor Bundle does not exist.' -Verbose
			}
		}

		if ($sitePath = $true) {
			Write-Warning -Message 'Cleaning Environment - Removing _site Folder'
			try {
				Remove-Item -Path $site -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message '_site folder removed.' -Verbose
			}
			catch {
				Write-Verbose -Message '_site folder does not exist.' -Verbose
			}
		}

		if ($gemfilePath = $true) {
			Write-Warning -Message 'Cleaning Environment - Removing Gemfile.lock File'
			try {
				Remove-Item -Path $gemfile -Force -ErrorAction Stop
				Write-Verbose -Message 'gemfile.lock removed.' -Verbose
			}
			catch {
				Write-Verbose -Message 'gemfile.lock does not exist.' -Verbose
			}
		}

		if ($jekyllmetadataPath = $true) {
			Write-Warning -Message 'Cleaning Environment - Removing .jekyll-metadata File'
			try {
				Remove-Item -Path $jekyllmetadata -Force -ErrorAction Stop
				Write-Verbose -Message '.jekyll-metadata removed.' -Verbose
			}
			catch {
				Write-Verbose -Message '.jekyll-metadata does not exist.' -Verbose
			}
		}
	}
	else {
		Write-Warning -Message 'Images left intact.'
	}
}
