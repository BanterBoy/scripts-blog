function Get-O365LastLogonTime {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Identity
    )
    $Result = @() 
    $mailboxes = Get-Mailbox -ResultSize Unlimited | Where-Object { $_ -like $Identity }
    $totalmbx = $mailboxes.Count
    $i = 1 
    $mailboxes | ForEach-Object {
        $i++
        $mbx = $_
        $mbs = Get-MailboxStatistics -Identity $mbx.UserPrincipalName | Select-Object LastLogonTime
        if ($null -eq $mbs.LastLogonTime) {
            $lt = "Never Logged In"
        }
        else {
            $lt = $mbs.LastLogonTime 
        }
 
        Write-Progress -activity "Processing $mbx" -status "$i out of $totalmbx completed"
 
        $Result += New-Object PSObject -property @{ 
            Name              = $mbx.DisplayName
            UserPrincipalName = $mbx.UserPrincipalName
            LastLogonTime     = $lt 
        }
    }
    $Result
}
