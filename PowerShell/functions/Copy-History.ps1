#--------------------
# History Function
Function Copy-History {
    Get-History |
    Out-GridView -Title "Command History - press CTRL to select multiple - Selected commands copied to clipboard" -OutputMode Multiple |
    ForEach-Object -Begin { [Text.StringBuilder]$sb = "" } -Process { $null = $sb.AppendLine($_.CommandLine) } -End { $sb.ToString() |
        clip }
}
