class CountdownDate {
    [string]$CountdownDay
    [int]$DaysUntilCountdown

    CountdownDate([string]$CountdownDay, [int]$DaysUntilCountdown) {
        $this.CountdownDay = $CountdownDay
        $this.DaysUntilCountdown = $DaysUntilCountdown
    }

    [PSObject]GetCountdown() {
        if ($this.CountdownDay) {
            try {
                $CountdownDate = [datetime]::ParseExact($this.CountdownDay, "dd/MM/yyyy", $null)
            }
            catch {
                $CountdownDate = [datetime]$this.CountdownDay
            }
        }
        elseif ($this.DaysUntilCountdown) {
            $CountdownDate = (Get-Date).AddDays($this.DaysUntilCountdown)
        }
        else {
            throw "Please specify either CountdownDay or DaysUntilCountdown"
        }

        $Today = Get-Date
        $DaysLeft = New-TimeSpan -Start $Today -End $CountdownDate

        $output = New-Object PSObject
        $output | Add-Member -MemberType NoteProperty -Name "CurrentDate" -Value $Today.ToString("dd/MM/yyyy")
        $output | Add-Member -MemberType NoteProperty -Name "CountdownDate" -Value $CountdownDate.ToString("dd/MM/yyyy")
        $output | Add-Member -MemberType NoteProperty -Name "CountdownDay" -Value $CountdownDate.ToString("dddd dd MMMM")
        $output | Add-Member -MemberType NoteProperty -Name "DaysLeft" -Value "$($DaysLeft.Days) Days"

        return $output
    }
}

function New-CountdownDate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$CountdownDay,
        [Parameter(Mandatory = $false)]
        [int]$DaysUntilCountdown
    )

    try {
        $countdown = [CountdownDate]::new($CountdownDay, $DaysUntilCountdown)
        return $countdown.GetCountdown()
    }
    catch {
        Write-Error $_.Exception.Message
    }
}
