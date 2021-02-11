#These commands work best in a PowerShell session running in Windows Terminal.

# http://www.unicode.org/emoji/charts/full-emoji-list.html

Function ConvertTo-Emoji {
    [cmdletbinding()]
    [alias("cte")]
    Param(
        [parameter(Position = 0, Mandatory, ValueFromPipeline, HelpMessage = "Specify a value like 0x1F499 or 128153")]
        [int]$Value
    )
    Process {
        if ($env:wt_Session -OR ($host.name -match "studio")) {
            [char]::convertfromutf32($Value)
        }
        else {
            Write-Warning 'This command is only supported when running in Windows Terminal at this time.'
        }
    }
}
Function Show-Emoji {
    [cmdletbinding()]
    Param(
        [parameter(Position = 0, Mandatory, HelpMessage = "Enter the starting Unicode value")]
        [int32]$Start,
        [Parameter(HelpMessage = "How many items do you want to display?")]
        [int]$Count = 20
    )
    Write-verbose "Starting at $Start and getting $count items"
    $counter = 1

    Do {
        for ($i = 1; $i -le 5; $i++) {
            write-verbose "Counter = $counter i = $i"
            $item = "{0} {1}  " -f (ConvertTo-Emoji ($start)), $start
            if ($counter -le $count) {
                write-host $item -NoNewline
                $counter++
                $start++
            }
        }
        write-host "`r"
    } until ($counter -ge $count)
}