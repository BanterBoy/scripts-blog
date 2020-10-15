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
    https://github.com/BanterBoy/ScriptFixing

#>
    [CmdletBinding(DefaultParameterSetName = 'Default',
        SupportsShouldProcess = $true,
        HelpURI = 'https://github.com/BanterBoy/ScriptFixing')]
    param(
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter your source filename e.g. example.txt",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [Alias('sf')]
        [string[]]$sourceFile,
        [Parameter(Mandatory = $True,
            HelpMessage = "Please enter the ZipFile name e.g. example.zip)",
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $True)]
        [Alias('f')]
        [string[]]$zipFile
    )

    begin {
        function Resolve-FullPath ([string]$Path) {    
            if ( -not ([System.IO.Path]::IsPathRooted($Path)) ) {
                # $Path = Join-Path (Get-Location) $Path
                $Path = "$PWD\$Path"
            }
            [IO.Path]::GetFullPath($Path)
        }
    }

    process {
        $sourceFile = Resolve-FullPath $sourceFile
        $zipFile = Resolve-FullPath $zipFile

        if (-not (Test-Path $zipFile)) {
            Set-Content $zipFile ('PK' + [char]5 + [char]6 + ([string][char]0 * 18))
            (Get-Item $zipFile).IsReadOnly = $false  
        }

        $shell = New-Object -ComObject shell.application
        $zipPackage = $shell.NameSpace($zipFile)

        $zipPackage.CopyHere($sourceFile)
    }
}
