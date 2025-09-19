function Remove-JekyllBlogServer {
	<#
    .SYNOPSIS
        Cleans up the Jekyll blog environment by removing Docker images and specific directories and files.

    .DESCRIPTION
        This function prompts the user to confirm the cleanup of the Jekyll blog environment. If confirmed, it removes Docker images related to Jekyll and specific directories and files associated with the Jekyll environment.

    .EXAMPLE
        Remove-JekyllBlogServer
        Prompts the user for confirmation and then performs the cleanup of the Jekyll blog environment if confirmed.

    .NOTES
        Author: Luke Leigh
        Date: [Today's Date]
    #>

	[CmdletBinding()]
	param ()

	# Prompt the user for confirmation
	$title = 'Clean Blog Environment'
	$question = 'Are you sure you want to proceed?'
	$choices = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)

	if ($decision -eq 0) {
		# Prompt user to select a directory
		$directoryPath = Select-FolderLocation

		if (![string]::IsNullOrEmpty($directoryPath)) {
			Write-Output "You selected the directory: $directoryPath"
		}
		else {
			Write-Output "You did not select a directory."
			return
		}

		Write-Output 'Cleaning Environment - Removing Docker Images'
		$images = docker images jekyll/jekyll:latest -q

		foreach ($image in $images) {
			Write-Verbose -Message "Removing Docker image $image" -Verbose
			docker image rm $image -f
		}

		# Remove exited containers related to Jekyll
		$jekyllContainers = docker ps -a --filter ancestor=jekyll/jekyll:latest -q
		foreach ($container in $jekyllContainers) {
			Write-Verbose -Message "Removing Docker container $container" -Verbose
			docker rm $container -f
		}

		# Define paths to remove
		$pathsToRemove = @{
			"Vendor Bundle"    = "$directoryPath\vendor"
			"_site Folder"     = "$directoryPath\_site"
			"Gemfile.lock"     = "$directoryPath\gemfile.lock"
			".jekyll-metadata" = "$directoryPath\.jekyll-metadata"
			".jekyll-cache"    = "$directoryPath\.jekyll-cache"
		}

		foreach ($path in $pathsToRemove.GetEnumerator()) {
			if (Test-Path -Path $path.Value) {
				Write-Warning -Message "Cleaning Environment - Removing $($path.Key)"
				try {
					Remove-Item -Path $path.Value -Recurse -Force -ErrorAction Stop
					Write-Verbose -Message "$($path.Key) removed." -Verbose
				}
				catch {
					Write-Verbose -Message "Failed to remove $($path.Key): $_" -Verbose
				}
			}
			else {
				Write-Verbose -Message "$($path.Key) does not exist." -Verbose
			}
		}
	}
	else {
		Write-Warning -Message 'Images left intact.'
	}
}
