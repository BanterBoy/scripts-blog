function Start-TaskList {
    $PSDefaultParameterValues['Write-Progress:Activity'] = $phrase
    $phrases = Get-Content -Path C:\GitRepos\TextFiles\prankphrases.txt
    $i = 0
    foreach ($phrase in $phrases) {
        $i++
        Write-Progress -activity “Listing Commands” -status $phrase -PercentComplete (($i / $phrases.count) * 100)
        Start-Sleep -Seconds 5
    }
}
