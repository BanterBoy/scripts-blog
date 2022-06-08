function Remove-JekyllBlogServer {
	$title = 'Clean Blog Environment'
	$question = 'Are you sure you want to proceed?'
	$choices = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
	if ($decision -eq 0) {
		$directoryPath = Select-FolderLocation
		if (![string]::IsNullOrEmpty($directoryPath)) {
			Write-Output "You selected the directory: $directoryPath"
		}
		else {
			"You did not select a directory."
		}
		Write-Output 'Cleaning Environment - Removing Images'
		$images = docker images jekyll/jekyll:latest -q
		foreach ($image in $images) {
			docker image rm $image -f
			docker rm $(docker ps -qf 'status=exited')
			docker rmi $(docker images -qf 'dangling=true')
			docker volume rm $(docker volume ls -qf 'dangling=true')
		}

		$vendor = ($directoryPath + "\vendor")
		$site = ($directoryPath + "\_site")
		$gemfile = ($directoryPath + "\gemfile.lock")
		$jekyllmetadata = ($directoryPath + "\.jekyll-metadata")
		$jekyllcache = ($directoryPath + "\.jekyll-cache")

		$vendorPath = Test-Path -Path $vendor
		$sitePath = Test-Path -Path $site
		$gemfilePath = Test-Path -Path $gemfile
		$jekyllmetadataPath = Test-Path -Path $jekyllmetadata
		$jekyllcachePath = Test-Path -Path $jekyllcache

		if ( $vendorPath ) {
			Write-Warning -Message 'Cleaning Environment - Removing Vendor Bundle'
			try {
				Remove-Item -Path $vendor -Recurse -Force -Recurse -ErrorAction Stop
				Write-Verbose -Message 'Vendor Bundle removed.' -Verbose
			}
			catch {
				Write-Verbose -Message 'Vendor Bundle does not exist.' -Verbose
			}
		}
		if ( $sitePath ) {
			Write-Warning -Message 'Cleaning Environment - Removing _site Folder'
			try {
				Remove-Item -Path $site -Recurse -Force -Recurse -ErrorAction Stop
				Write-Verbose -Message '_site folder removed.' -Verbose
			}
			catch {
				Write-Verbose -Message '_site folder does not exist.' -Verbose
			}
		}
		if ( $gemfilePath  ) {
			Write-Warning -Message 'Cleaning Environment - Removing Gemfile.lock File'
			try {
				Remove-Item -Path $gemfile -Force -Recurse -ErrorAction Stop
				Write-Verbose -Message 'gemfile.lock removed.' -Verbose
			}
			catch {
				Write-Verbose -Message 'gemfile.lock does not exist.' -Verbose
			}
		}
		if ( $jekyllmetadataPath ) {
			Write-Warning -Message 'Cleaning Environment - Removing .jekyll-metadata File'
			try {
				Remove-Item -Path $jekyllmetadata -Force -Recurse -ErrorAction Stop
				Write-Verbose -Message '.jekyll-metadata removed.' -Verbose
			}
			catch {
				Write-Verbose -Message '.jekyll-metadata does not exist.' -Verbose
			}
		}
		if ( $jekyllcachePath ) {
			Write-Warning -Message 'Cleaning Environment - Removing .jekyll-cache File'
			try {
				Remove-Item -Path $jekyllcache -Force -Recurse -ErrorAction Stop
				Write-Verbose -Message '.jekyll-cache removed.' -Verbose
			}
			catch {
				Write-Verbose -Message '.jekyll-cache does not exist.' -Verbose
			}
		}
	}
	else {
		Write-Warning -Message 'Images left intact.'
	}
}
