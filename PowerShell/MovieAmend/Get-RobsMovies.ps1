<#

    .SYNOPSIS
    File Parsing tool, to read contents of Rob's Movie list.

    .DESCRIPTION
    File Parsing tool, to read contents of Rob's Movie list.

    Tool loads the movie list from the text file and parses the contents, turning each line into a Movie Name Object.
    A list is compiled and this is output to the screen.

    Outputs inlcude the MovieName

    .EXAMPLE
    $MovieList = Get-RobsMovies -FilePath 'C:\GitRepos\' -FileName 'movies.list.txt'
    $MyMovies = Get-ChildItem -Path \\deathstar\Movies\ -Directory | Select-Object Name
    Compare-Object -ReferenceObject $MovieList -DifferenceObject $MyMovies -Property Movie -OutVariable Missing
    $Missing.Movie | Out-File -FilePath C:\GitRepos\MissingMoviesList.txt

    Reads contents of Movies list and compares with list of films on my NAS. Finally, it also exports a list of files missing from the NAS.

    .INPUTS
    FilePath [string]
    FileName [string]


    .OUTPUTS
    Directory                                  Name                LastWriteTime
    ---------                                  ----                -------------
    C:\GitRepos\AdminToolkit\PowerShell\CmdLet Get-LatestFiles.ps1 02/02/2020 15:30:35

    .NOTES
    Author:     Luke Leigh
    Website:    https://admintoolkit.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
    https://github.com/BanterBoy/adminToolkit/wiki

    #>
    
function Get-RobsMovies {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the Movie Name or Pipe in from another command.")]
        [Alias('fn')]
        [string]$FilePath,
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Please enter the Movie Path or Pipe in from another command.")]
        [Alias('fp')]
        [string]$FileName
    )

    BEGIN {
        $File = $FilePath + '\' + $FileName
    }

    PROCESS {
        $Movies = Get-Content -Path $File
        foreach ($Movie in $Movies) {
            $Name = $Movie | Split-Path -Parent
            try {
                $properties = @{
                    Movie = $Name
                }
            }
            catch {
                $properties = @{
                    Movie = $Name
                }
            }
            finally {
                $obj = New-Object -TypeName PSObject -Property $properties
                Write-Output $obj
            }
        }
    }

    END {

    }

}
