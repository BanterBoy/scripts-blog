function Upload-AssetstoProGet {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param(
        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the base path you would like to search."
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("FilePath")]
        [string]$Path,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the base path you would like to search."
        )]
        [Alias("f")]
        [string]$folder,

        [Parameter(
            ParameterSetName = "Default",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the base path you would like to search."
        )]
        [Alias("subf")]
        [string]$subfolder
        
    )
    
    begin {
        $url = 'http://proget.domain.leigh-services.com/endpoints/iac/content/PowerShell/'
        if ($subfolder) {
            $structure = $folder + '/' + $subfolder + '/'
        }
        else {
            $structure = $folder + '/'
        }
        $endpoint = $url + $structure
        $files = Get-ChildItem -Path $Path -File -Filter *.ps1
    }
    
    process {
        try {
            foreach ($file in $files) {
                Upload-ProGetAsset -fileName $file.FullName -endpointUrl $endpoint -assetName $file.Name
            }
        }
        catch {
            Write-Warning "Catch all"
        }
    }
    
    end {
        
    }
}
