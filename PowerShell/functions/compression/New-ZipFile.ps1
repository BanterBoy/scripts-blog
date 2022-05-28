function New-ZipFile {
    <#
		.SYNOPSIS

		.DESCRIPTION

		.EXAMPLE

		.INPUTS

		.OUTPUTS

		.NOTES
			Author:     Luke Leigh
			Website:    https://blog.lukeleigh.com/
			LinkedIn:   https://www.linkedin.com/in/lukeleigh/
			GitHub:     https://github.com/BanterBoy/
			GitHubGist: https://gist.github.com/BanterBoy

		.LINK
			https://github.com/BanterBoy/scripts-blog

	#>
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $false,
        HelpURI = 'https://github.com/BanterBoy/scripts-blog'
		)]
	[Alias('nz','New-Zip')]
    param(
        [Parameter(Mandatory = $true,
            HelpMessage = "Please enter your source filename e.g. example.txt",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('zs','source')]
        [string[]]$zipSource,
        [Parameter(Mandatory = $true,
            HelpMessage = "Please enter the ZipFile name e.g. example.zip)",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('zf','zip')]
        [string]$zipFile,
        [Parameter(Mandatory = $false,
            HelpMessage = "Please enter the ZipFile name e.g. example.zip)",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
		[Alias('dir')]
		[switch]$Directory=$false
		)
    begin {
    }
    process {
		if ($Directory) {
			foreach ($zip in $zipSource) {
				Compress-Archive -Path $zip -DestinationPath $zipFile
			}
		}
		else {
			foreach ($zip in $zipSource) {
			Compress-Archive -Path $zip -DestinationPath $zipFile
			}
		}
    }
	end {
	}
}
