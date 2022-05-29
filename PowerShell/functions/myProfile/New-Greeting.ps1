function New-Greeting {
	$Today = $(Get-Date)
	Write-Host "Day of Week -"$Today.DayOfWeek " - Today's Date -"$Today.ToShortDateString() "- Current Time -"$Today.ToShortTimeString()
	Switch ($Today.dayofweek) {
		Monday { Write-Host "Don't want to work today" }
		Friday { Write-Host "Almost the weekend" }
		Saturday { Write-Host "Everyone loves a Saturday ;-)" }
		Sunday { Write-Host "A good day to rest, or so I hear." }
		Default { Write-Host "Business as usual." }
	}
}