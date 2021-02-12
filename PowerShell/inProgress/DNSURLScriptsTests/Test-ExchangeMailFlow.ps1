function Test-ExchangeMailFlow {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false)]
        [string]
        $Server
    )
    
    try {
        Write-Verbose "Creating PSSession for $server"
        try {
            $url = (Get-PowerShellVirtualDirectory -Server $server | Where-Object { $_.Name -eq "Powershell (Default Web Site)" }).InternalURL.AbsoluteUri
            $session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $url -ErrorAction STOP
        }
        catch {
            Write-Verbose "Something went wrong"
            Write-Warning $_.Exception.Message
            EXIT
        }
        
        try {
            Write-Verbose "Running mail flow test on $Server"
            $result = Invoke-Command -Session $session { Test-Mailflow } -ErrorAction STOP
            $testresult = $result.TestMailflowResult
     
        }
        catch {
            Write-Verbose "An error occurred"
            Write-Warning $_.Exception.Message
            EXIT
        }
        Write-Output "Mail flow test: $testresult"
        Write-Verbose "Removing PSSession"
        Remove-PSSession $session.Id
    }
    catch {
        Write-Verbose "An error occurred"
        Write-Warning $_.Exception.Message
    
    }
}
