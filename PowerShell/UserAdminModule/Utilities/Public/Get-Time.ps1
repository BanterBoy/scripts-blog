function Get-Time {
    <#
      .SYNOPSIS
         Gets the time of a windows server
 
      .DESCRIPTION
         Uses WMI to get the time of a remote server
 
      .PARAMETER  ServerName
         The Server to get the date and time from
 
      .EXAMPLE
         PS C:\> Get-Time localhost
 
      .EXAMPLE
         PS C:\> Get-Time server01.domain.local -Credential (Get-Credential)
 
   #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ServerName,
 
        $Credential
 
    )
    try {
        If ($Credential) {
            $DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $servername -Credential $Credential
        }
        Else {
            $DT = Get-WmiObject -Class Win32_LocalTime -ComputerName $servername
        }
    }
    catch {
        throw
    }
 
    $Times = New-Object PSObject -Property @{
        ServerName = $DT.__Server
        DateTime   = (Get-Date -Day $DT.Day -Month $DT.Month -Year $DT.Year -Minute $DT.Minute -Hour $DT.Hour -Second $DT.Second)
    }
    $Times
 
}
