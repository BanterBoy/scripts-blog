<#
 .Synopsis
  Transfers a file to a ProGet asset directory.

 .Description
  Transfers a file to a ProGet asset directory. This function performs automatic chunking
  if the file is larger than a specified threshold.

 .Parameter FileName
  Name of the file to upload from the local file system.

 .Parameter EndpointUrl
  Full URL of the ProGet asset directory's API endpoint. This is typically something like http://proget/endpoints/<directoryname>

 .Parameter AssetName
  Full path of the asset to create in ProGet's asset directory.

 .Parameter ChunkSize
  Uploads larger than this value will be uploaded using multiple requests. The default is 5 MB.

 .Example
  Upload-ProGetAsset -FileName C:\Files\Image.jpg -AssetName images/image.jpg -EndpointUrl http://proget/endpoints/MyAssetDir
#>
function Upload-ProGetAsset {
    param(
        [Parameter(Mandatory = $true)]
        [string] $fileName,
        [Parameter(Mandatory = $true)]
        [string] $endpointUrl,
        [Parameter(Mandatory = $true)]
        [string] $assetName,
        [int] $chunkSize = 5 * 1024 * 1024
    )

    function CopyMaxBytes {
        param(
            [System.IO.Stream] $source,
            [System.IO.Stream] $target,
            [int] $maxBytes,
            [long] $startOffset,
            [long] $totalSize
        )
        $buffer = [Array]::CreateInstance([System.Byte], 32767)
        $totalBytesRead = 0
        while ($true) {
            $bytesRead = $source.Read($buffer, 0, [Math]::Min($maxBytes - $totalBytesRead, $buffer.Length))

            if ($bytesRead -eq 0) {
                break
            }
            $target.Write($buffer, 0, $bytesRead)
            $totalBytesRead += $bytesRead
            if ($totalBytesRead -ge $maxBytes) {
                break
            }

            $overallProgress = $startOffset + $totalBytesRead
            Write-Progress -Activity "Uploading $fileName..." -Status "$overallProgress/$totalSize" -PercentComplete ($overallProgress / $totalSize * 100)
        }
    }

    if (-not $endpointUrl.EndsWith('/')) {
        $endpointUrl += '/';
    }

    $targetUrl = $endpointUrl + [Uri]::EscapeUriString($assetName.Replace('\', '/'))

    $fileInfo = (Get-ChildItem -Path $fileName)
    if ($fileInfo.Length -le $chunkSize) {
        Invoke-WebRequest -Method Post -Uri $targetUrl -InFile $fileName
    }
    else {
        $sourceStream = New-Object -TypeName System.IO.FileStream -ArgumentList ($fileName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)
        try {
            $fileLength = $sourceStream.Length
            $remainder = [long]0
            $totalParts = [Math]::DivRem([long]$fileLength, [long]$chunkSize, [ref]$remainder)
            if ($remainder -ne 0) {
                $totalParts++
            }

            $uuid = (New-Guid).ToString("N")

            for ($index = 0; $index -lt $totalParts; $index++) {
                $offset = $index * $chunkSize
                $currentChunkSize = $chunkSize
                if ($index -eq ($totalParts - 1)) {
                    $currentChunkSize = $fileLength - $offset
                }

                $req = [System.Net.WebRequest]::CreateHttp("${targetUrl}?multipart=upload&id=$uuid&index=$index&offset=$offset&totalSize=$fileLength&partSize=$currentChunkSize&totalParts=$totalParts")
                $req.Method = 'POST'
                $req.ContentLength = $currentChunkSize
                $req.AllowWriteStreamBuffering = $false
                $reqStream = $req.GetRequestStream()
                try {
                    CopyMaxBytes -source $sourceStream -target $reqStream -maxBytes $currentChunkSize -startOffset $offset -totalSize $fileLength
                }
                finally {
                    if ($reqStream -ne $null) {
                        $reqStream.Dispose()
                    }
                }

                $response = $req.GetResponse()
                try {
                }
                finally {
                    if ($response -ne $null) {
                        $response.Dispose()
                    }
                }
            }

            Write-Progress -Activity "Uploading $fileName..." -Status "Completing upload..." -PercentComplete -1

            $req = [System.Net.WebRequest]::CreateHttp("${targetUrl}?multipart=complete&id=$uuid")
            $req.Method = 'POST'
            $req.ContentLength = 0
            $response = $req.GetResponse()
            try {
            }
            finally {
                if ($response -ne $null) {
                    $response.Dispose()
                }
            }
        }
        finally {
            if ($sourceStream -ne $null) {
                $sourceStream.Dispose()
            }
        }
    }
}
