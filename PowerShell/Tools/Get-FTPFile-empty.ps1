
function Get-FTPFile ($Source,$Target,$UserName,$Password)
{

# Create a FTPWebRequest object to handle the connection to the ftp server
$ftprequest = [System.Net.FtpWebRequest]::create($Source)

# set the request's network credentials for an authenticated connection
$ftprequest.Credentials =
    New-Object System.Net.NetworkCredential($username,$password)

$ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
$ftprequest.UseBinary = $true
$ftprequest.KeepAlive = $false

# send the ftp request to the server
$ftpresponse = $ftprequest.GetResponse()

# get a download stream from the server response
$responsestream = $ftpresponse.GetResponseStream()

# create the target file on the local system and the download buffer
$targetfile = New-Object IO.FileStream ($Target,[IO.FileMode]::Create)
[byte[]]$readbuffer = New-Object byte[] 1024

# loop through the download stream and send the data to the target file
do{
    $readlength = $responsestream.Read($readbuffer,0,1024)
    $targetfile.Write($readbuffer,0,$readlength)
}
while ($readlength -ne 0)

$targetfile.close()
}

$sourceuri = "ftp://MyFtpServer/FolderPath\File.txt"
$targetpath = "C:\temp\MyFile.txt"
$user = "Username"
$pass = "Password"
Get-FTPFile $sourceuri $targetpath $user $pass
