function Get-PortInfo
{
   param
   (
       [Parameter(Mandatory)]
       [Int]
       $Port,

       [Parameter(Mandatory)]
       [Int]
       $TimeoutMilliseconds,

       [String]
       $ComputerName = $env:COMPUTERNAME
   )

   # try and establish a connection to port async
   $tcpobject = New-Object System.Net.Sockets.TcpClient
   $connect = $tcpobject.BeginConnect($computername, $port,$null,$null)

   # wait for the connection no longer than $timeoutMilliseconds
   $wait = $connect.AsyncWaitHandle.WaitOne( $timeoutMilliseconds,$false)

   # return rich information
   $result = @{
       ComputerName = $ComputerName
   }

   if(!$wait) {
       # timeout
       $tcpobject.Close()
       $result.Online = $false
       $result.Error = 'Timeout'
   } else {
       try {
           # try and complete the connection
           $null = $tcpobject.EndConnect($connect )
           $result.Online = $true
       }
       catch {
           $result.Online = $false
       }
       $tcpobject.Close()
   }
   $tcpobject.Dispose()

   [PSCustomObject]$result
}
