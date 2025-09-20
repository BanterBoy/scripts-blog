Function Start-DownloadFileToTemp {
    param
    (
        [Parameter()]
        [String]$Url
    )

    $fileName = [system.io.path]::GetFileName($url)
    $tmpFilePath = [system.io.path]::Combine($env:TEMP, $fileName)

    $wc = new-object System.Net.WebClient
    $wc.DownloadFile($url, $tmpFilePath)
    $wc.Dispose()

    return $tmpFilePath
}
