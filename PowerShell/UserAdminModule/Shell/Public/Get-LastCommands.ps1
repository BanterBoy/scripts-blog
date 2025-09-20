function Get-LastCommands {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $Number
    )
    Get-History | Select-Object -Last $Number | Format-Table -Property CommandLine -AutoSize -Wrap
}
