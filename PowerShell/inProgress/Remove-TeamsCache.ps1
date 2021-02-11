function Remove-TeamsCache {
    [CmdletBinding(
        SupportsShouldProcess = $True,
        DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(
            Mandatory = $True,
            ParameterSetName = "Default",
            HelpMessage = "Enter the remote Computer name.")]
        [string[]]
        $ComputerName,

        [Parameter(
            Mandatory = $True,
            ParameterSetName = "Default",
            HelpMessage = "Enter the User's SamAccountName")]
        [string[]]
        $Name
    )

    begin {
    }
    
    process {
        $UserPath = "C:\Users\$Name\AppData\Roaming\Microsoft\Teams\*"
        foreach ($Computer in $ComputerName) {
            if ($PSCmdlet.ShouldProcess("$Name", "Removing Cache files")) {
                try {
                    Invoke-Command -ComputerName "$Computer" -ScriptBlock {
                        $Files = Get-ChildItem -Path "$UserPath" -Directory  -ErrorAction Stop |
                        Where-Object Name -in ('application cache', 'blob storage', 'databases', 'GPUcache', 'IndexedDB', 'Local Storage', 'tmp')
                        foreach ($File in $Files) {
                            Remove-Item -Path $File.FullName -Recurse -Force -Verbose -ErrorAction Stop
                        }
                    }
                }
                catch [Microsoft.PowerShell.Commands.WriteErrorException] {
                    Write-Error -Message "$_ - WriteErrorException"
                    continue
                }
                catch [Microsoft.PowerShell.Commands.GetChildItemCommand] {
                    Write-Error -Message "$_ - GetChildItemCommand"
                    continue
                }
                catch {
                    Write-Error -Message "$_ - EverythingElse"
                    continue
                }
            }
        }
    }
}
