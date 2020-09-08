[CmdletBinding()]
Param (
    [int32]$Count = 5,
    
    [Parameter(ValueFromPipeline=$true)]
    [String[]]$Computer = "mftestwin7",
    
    [string]$LogPath = "c:\pinglog\pinglog.csv"
)

$Ping = @()
#Test if path exists, if not, create it
If (-not (Test-Path (Split-Path $LogPath) -PathType Container))
{   Write-Verbose "Folder doesn't exist $(Split-Path $LogPath), creating..."
    New-Item (Split-Path $LogPath) -ItemType Directory | Out-Null
}

#Test if log file exists, if not seed it with a header row
If (-not (Test-Path $LogPath))
{   Write-Verbose "Log file doesn't exist: $($LogPath), creating..."
    Add-Content -Value '"TimeStamp","Source","Destination","IPV4Address","Status","ResponseTime"' -Path $LogPath
}

#Log collection loop
Write-Verbose "Beginning Ping monitoring of $Comptuer for $Count tries:"
While ($Count -gt 0)
{   $Ping = Get-WmiObject Win32_PingStatus -Filter "Address = '$Computer'" | Select @{Label="TimeStamp";Expression={Get-Date}},@{Label="Source";Expression={ $_.__Server }},@{Label="Destination";Expression={ $_.Address }},IPv4Address,@{Label="Status";Expression={ If ($_.StatusCode -ne 0) {"Failed"} Else {""}}},ResponseTime
    $Result = $Ping | Select TimeStamp,Source,Destination,IPv4Address,Status,ResponseTime | ConvertTo-Csv -NoTypeInformation
    $Result[1] | Add-Content -Path $LogPath
    Write-verbose ($Ping | Select TimeStamp,Source,Destination,IPv4Address,Status,ResponseTime | Format-Table -AutoSize | Out-String)
    $Count --
    Start-Sleep -Seconds 1
}