<#
.SYNOPSIS
    Tests the time settings on remote computers.

.DESCRIPTION
    The Test-RemoteTimeSettings function is used to test the time settings on multiple remote computers. It checks the time configuration, time source, time status, and performs a stripchart to monitor time synchronization.

.PARAMETER ComputerNames
    Specifies an array of computer names on which the time settings need to be tested.

.PARAMETER Duration
    Specifies the duration (in seconds) for which the stripchart will be monitored. The default value is 60 seconds.

.PARAMETER Interval
    Specifies the interval (in seconds) between each stripchart sample. The default value is 5 seconds.

.EXAMPLE
    $computers = @("RemotePC1", "RemotePC2", "RemotePC3")
    $testResults = Test-RemoteTimeSettings -ComputerNames $computers -Duration 120 -Interval 10

    # Display results
    $testResults | Format-Table -Property ComputerName, Success, ErrorMessage

.EXAMPLE
    $computers = @("RemotePC1", "RemotePC2", "RemotePC3")
    $testResults = Test-RemoteTimeSettings -ComputerNames $computers -Duration 120 -Interval 10

    # Display detailed results
    $testResults | Format-List
#>

function Test-RemoteTimeSettings {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$ComputerNames,
        
        [Parameter(Mandatory = $false)]
        [int]$Duration = 60,

        [Parameter(Mandatory = $false)]
        [int]$Interval = 5
    )

    function Get-TimeSettings {
        param (
            [string]$ComputerName,
            [int]$Duration,
            [int]$Interval
        )
        
        $result = [PSCustomObject]@{
            ComputerName  = $ComputerName
            TimeConfig    = $null
            TimeSource    = $null
            TimeStatus    = $null
            Stripchart    = @()
            Success       = $true
            ErrorMessage  = $null
        }

        try {
            # Checking time configuration
            $result.TimeConfig = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                w32tm /query /configuration
            }

            # Checking time source
            $result.TimeSource = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                w32tm /query /source
            }

            # Checking time status
            $result.TimeStatus = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                w32tm /query /status
            }

            # Using stripchart to monitor time synchronization
            $stripchartResults = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                param ($Duration, $Interval)
                $end = (Get-Date).AddSeconds($Duration)
                $results = @()

                while ((Get-Date) -lt $end) {
                    $result = w32tm /stripchart /computer:localhost /dataonly /samples:1
                    $results += $result
                    Start-Sleep -Seconds $Interval
                }
                return $results
            } -ArgumentList $Duration, $Interval

            $result.Stripchart = $stripchartResults

        } catch {
            $result.Success = $false
            $result.ErrorMessage = $_.Exception.Message
        }

        return $result
    }

    $results = @()
    $totalComputers = $ComputerNames.Count
    $currentIndex = 0

    foreach ($computer in $ComputerNames) {
        $currentIndex++
        Write-Progress -Activity "Testing time settings on remote computers" -Status "Processing $computer" -PercentComplete (($currentIndex / $totalComputers) * 100)
        $results += Get-TimeSettings -ComputerName $computer -Duration $Duration -Interval $Interval
    }

    Write-Progress -Activity "Testing time settings on remote computers" -Status "Completed" -PercentComplete 100 -Completed

    return $results
}
