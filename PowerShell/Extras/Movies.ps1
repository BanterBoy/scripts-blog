. .\PowerShellScripts\MovieAmend\Get-MovieInfo.ps1
Get-MovieInfo -MoviePath \\DEATHSTAR\MOVIES
$MovieData = Get-MovieInfo -MoviePath \\DEATHSTAR\MOVIES
$MovieData.Count

$TraktMovies = Get-Content -Path 'C:\Users\bante\OneDrive\Desktop\DesktopFiles\banterboy-collection-movies.csv' | ConvertFrom-Csv -Delimiter ','
foreach($Movie in $TraktMovies) {
    $Movie |
    Select-Object -Property title,imdb_id |
    Out-File -FilePath C:\GitRepos\Movies.txt -Append
}

