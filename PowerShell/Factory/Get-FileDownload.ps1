$url = "https://gist.githubusercontent.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt"
$destination = "$env:userprofile\desktop"
(new-object System.Net.WebClient).DownloadFile($url, "$destination\tempfile.txt")

# $links = (new-object System.Net.WebClient).DownloadFile($url, "$destination\tempfile.txt")
# $links = Get-Content "$($env:userprofile)\desktop\tempfile.txt"


# ForEach ($item in $links) {
#     $basename = ($item -split "/")[-1]
#     (New-Object System.Net.WebClient).DownloadFile($item, "$destination\$basename")
# }
