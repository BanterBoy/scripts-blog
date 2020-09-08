function Set-MovieTitle {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the Movie Path or Pipe in from another command.")]
        [Alias('mp')]
        [string]$MoviePath,
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the file extension or Pipe in from another command.")]
        [Alias('ft')]
        [string]$Filetype
    )

    BEGIN {
        Import-Module $PSScriptRoot\taglib-sharp.dll

        function Set-Title {
            [cmdletbinding()]
            param (
                [Parameter(Mandatory = $True,
                ValueFromPipeline = $True,
                ValueFromPipelineByPropertyName = $True,
                HelpMessage = "Please enter the Title or Pipe in from another command.")]
                [string]$Title
            )
            $Files = Get-ChildItem -Path $MoviePath -Filter $Filetype -Recurse
            foreach($File in $Files) {
            $Tag = [TagLib.File]::Create($File.FullName)
            $Tag.Tag.Title = $(
                if ($Title) {
                    $Title
                }
                else {
                    $_.BaseName
                })
            $Tag.Save()
            }
        }
                
    }

    PROCESS {
        $Files = Get-ChildItem -Path $MoviePath -Filter $Filetype -Recurse
        foreach ($File in $Files) {
            [string]$Title = ($File.BaseName)
            Get-Item $File.FullName |
            Set-Title $Title
            Write-Verbose -Message "Title amended for $($File.BaseName)" -Verbose
        }
    }

    END {

    }
}
