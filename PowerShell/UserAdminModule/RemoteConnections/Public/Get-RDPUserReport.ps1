# Function: Get-RDPUserReport
Function Get-RDPUserReport {
    <#
    .SYNOPSIS
    Retrieves RDP session details from specified computers.

    .DESCRIPTION
    Queries the specified servers for RDP session details and outputs them as objects for further manipulation.

    .PARAMETER ComputerName
    Name or IP address of the computer(s) to query.

    .EXAMPLE
    Get-RDPUserReport -ComputerName "DANTOOINE"

    .EXAMPLE
    Get-RDPUserReport -ComputerName "DANTOOINE" | Sort-Object IdleTime | Format-Table -AutoSize
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName
    )

    # Initialize array to store session details
    $Sessions = @()

    # Query each specified computer
    foreach ($Computer in $ComputerName) {
        try {
            $ConnectionResult = Test-NetConnection -ComputerName $Computer -CommonTCPPort RDP -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($ConnectionResult.TcpTestSucceeded) {
                Write-Verbose "Connected to $Computer"
                $DirtyOutput = (quser /server:$Computer) -replace '\s{2,}', ',' | ConvertFrom-Csv
                foreach ($session in $DirtyOutput) {
                    if (($session.sessionname -notlike "console") -and ($session.sessionname -notlike "rdp-tcp*")) {
                        $sessionData = [pscustomobject]@{
                            Username    = $session.USERNAME
                            SessionName = ""
                            ID          = $session.SESSIONNAME
                            State       = $session.ID
                            IdleTime    = $session.STATE
                            LogonTime   = $session."IDLE TIME"
                            ServerName  = $Computer
                        }
                    } else {
                        $sessionData = [pscustomobject]@{
                            Username    = $session.USERNAME
                            SessionName = $session.SESSIONNAME
                            ID          = $session.ID
                            State       = $session.STATE
                            IdleTime    = $session."IDLE TIME"
                            LogonTime   = $session."LOGON TIME"
                            ServerName  = $Computer
                        }
                    }
                    $Sessions += $sessionData
                }
            } else {
                Write-Verbose "Failed to connect to $Computer"
                $Sessions += [pscustomobject]@{
                    Username    = 'N/A'
                    SessionName = 'N/A'
                    ID          = 'N/A'
                    State       = 'Unavailable'
                    IdleTime    = 'N/A'
                    LogonTime   = 'N/A'
                    ServerName  = $Computer
                }
            }
        } catch {
            Write-Warning "Failed to query $($Computer): $_"
        }
    }

    # Return session details
    return $Sessions
}

