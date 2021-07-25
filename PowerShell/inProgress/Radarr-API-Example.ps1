$MovieList = @("Babe","Paddington")
$API = "76889421dfa047b4b8e7372e21816fce"
$GETURI = "https://radarr.domain.com/api/movie?apikey=$API"
$MoviesJSON = Invoke-WebRequest -uri $GETURI -Method GET
$Movies = $MoviesJSON | ConvertFrom-Json

ForEach($Movie in $Movies)
    {
        If($MovieList -contains $Movie.Title)
            {
                Write-Output "Working on $($Movie.Title)"
                Write-Output "Monitored: $($Movie.monitored)"
                $Movie.monitored = $false
                Write-Output "Monitored: $($Movie.monitored)"
                $MovieJSON = $Movie | ConvertTo-Json -Depth 32
                $SetURI = "https://radarr.domain.com/api/movie/$($Movie.id)?apikey=$API"
                $Return = Invoke-WebRequest -Uri $SETURI -Method Put -Body $MovieJSON
            }
        
    }