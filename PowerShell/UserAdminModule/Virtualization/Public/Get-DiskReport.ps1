function Get-DiskReport {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Specify one or more computer names. Defaults to the local computer."
        )]
        [string[]]
        $ComputerName = $env:COMPUTERNAME,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Specify credentials for remote connections if needed."
        )]
        [System.Management.Automation.Credential()]
        [PSCredential]
        $Credential
    )

    process {
        foreach ($computer in $ComputerName) {
            # Script block to execute on each remote computer
            $scriptBlock = {
                Get-PSDrive -PSProvider FileSystem |
                    ForEach-Object {
                        [PSCustomObject]@{
                            ComputerName = $env:COMPUTERNAME
                            Name         = $_.Name
                            UsedGB       = [math]::Round($_.Used / 1GB, 2)
                            FreeGB       = [math]::Round($_.Free / 1GB, 2)
                            TotalGB      = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
                        }
                    }
            }

            try {
                # Invoke the script block on the remote computer (or locally if ComputerName=localhost)
                if ($Credential) {
                    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock -Credential $Credential
                }
                else {
                    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock
                }
            }
            catch {
                Write-Warning "Failed to retrieve disk info from '$computer': $_"
            }
        }
    }
}
