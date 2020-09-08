<#
Stop a service that is stuck when stopping
#>

Clear-Host

param
(
    $Name = $( Read-Host -Prompt 'Enter your name' ),
    $Id = $(Read-Host -Prompt 'Enter your ID')
)


"You are $Name and your ID is $Id"


$ProcessName = "Q1WindowsAgent.exe"

$ServerList = "$env:COMPUTERNAME"
$ServerArray = $ServerList.split(',');

foreach ($ComputerName in $ServerArray) {

    $Process = Get-WmiObject -Class Win32_Process -ComputerName $ComputerName -Filter "name='$Name'"

    IF ($Process -ne $null) {

        $returnval = $process.terminate()
        $processid = $process.handle

        if ($returnval.returnvalue -eq 0) {
            write-host "The process $Name `($processid`) terminated successfully on Server $ComputerName"
        }

        else {
            write-host "The process $Name `($processid`) termination has some problems on Server $ComputerName"
        }
    }

    Else {
        Write-Host "Process Not Running On Server $ComputerName"

    }
}
