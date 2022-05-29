function Remove-BlogServer {
	$title = 'Clean Blog Environment'
	$question = 'Are you sure you want to proceed?'
	$choices = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
	if ($decision -eq 0) {
		$PSRootFolder = Select-FolderLocation
		Set-Location -Path $PSRootFolder
		Write-Host 'Cleaning Environment - Removing Images'
		$images = docker images jekyll/jekyll -q
		foreach ($image in $images) {
			docker rmi $image -f
			docker rm $(docker ps -a -f status=exited -q)
		}
		$vendor = Test-Path $PSRootFolder\vendor
		$site = Test-Path $PSRootFolder\_site
		$gemfile = Test-Path -Path $PSRootFolder\gemfile.lock
		$jekyllmetadata = Test-Path -Path $PSRootFolder\.jekyll-metadata
		Write-Warning -Message 'Cleaning Environment - Removing Vendor Bundle'
		if ($vendor = $true) {
			try {
				Remove-Item -Path $vendor -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message 'Vendor Bundle removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message 'Vendor Bundle does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing _site Folder'
		if ($site = $true) {
			try {
				Remove-Item -Path $site -Recurse -Force -ErrorAction Stop
				Write-Verbose -Message '_site folder removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message '_site folder does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing Gemfile.lock File'
		if ($gemfile = $true) {
			try {
				Remove-Item -Path $gemfile -Force -ErrorAction Stop
				Write-Verbose -Message 'gemfile.lock removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message 'gemfile.lock does not exist.' -Verbose
			}
		}
		Write-Warning -Message 'Cleaning Environment - Removing .jekyll-metadata File'
		if ($jekyllmetadata = $true) {
			try {
				Remove-Item -Path $jekyllmetadata -Force -ErrorAction Stop
				Write-Verbose -Message '.jekyll-metadata removed.' -Verbose
			}
			catch [System.Management.Automation.ItemNotFoundException] {
				Write-Verbose -Message '.jekyll-metadata does not exist.' -Verbose

			}
			Set-Location -Path $PSRootFolder
		}
	}
	else {
		Write-Warning -Message 'Images left intact.'
	}
}
