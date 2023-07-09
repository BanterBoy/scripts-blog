Function New-RemoteFileMonitor {
    [CmdletBinding()]
    param (
        [string[]]$RemoteServers,
        [string]$RemoteFile,
        [string]$LogPath,
        [string]$ClientId,
        [string]$TenantId,
        [SecureString]$ClientSecret,
        [string]$From,
        [string]$To,
        [string]$Subject,
        [string]$Filter,
        [int]$SizeThreshold,
        [string]$JobName
    )
    foreach ($RemoteServer in $RemoteServers) {
        $cred = Get-Credential
        $session = New-PSSession -ComputerName $RemoteServer -Credential $cred
        $jobDefinition = {
            $filewatcher = New-Object System.IO.FileSystemWatcher
            $filewatcher.Path = $RemoteFile
            $filewatcher.Filter = "*$Filter"
            $filewatcher.IncludeSubdirectories = $true
            $filewatcher.EnableRaisingEvents = $true
            $writeaction = {
                $path = $Event.SourceEventArgs.FullPath
                $changeType = $Event.SourceEventArgs.ChangeType
                $file = Get-Item $path
                if ($file.Length -lt $SizeThreshold) {
                    $logline = "$(Get-Date), $changeType, $path"
                    Add-Content $LogPath -value $logline
                    $token = (Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" -Method POST -Body @{client_id = $ClientId; scope = "https://graph.microsoft.com/.default"; client_secret = $ClientSecret; grant_type = "client_credentials" }).access_token
                    $body = @{
                        "subject" = $Subject
                        "body" = @{
                            "contentType" = "text"
                            "content"     = "$changeType happened on the file $path on server $RemoteServer with filter $Filter and size $($file.Length) bytes"
                        }
                        "toRecipients" = @[
                        @{
                            "emailAddress" = @{
                                "address" = $To
                            }
                        }
                        ]
                    } | ConvertTo-Json
                    Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users/$From/sendMail" -Headers @{Authorization = "Bearer $token" } -Method POST -Body $body
                }
            }
           
