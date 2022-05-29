function Start-TaskList {
    $PSDefaultParameterValues['Write-Progress:Activity'] = $phrase
    $phrases = Get-Content -Path C:\GitRepos\TextFiles\prankphrases.txt
    $i = 0
    foreach ($phrase in $phrases) {
        $i++
        Write-Progress -activity “Listing Commands” -status $phrase -PercentComplete (($i / $phrases.count) * 100)
        Start-Sleep -Seconds 5
    }
}
    



function Write-ProgressHelper {
    param (
        [int]$StepNumber,
        [string]$Message
    )
    $stepCounter = 0
    Write-Progress -Activity 'Title' -Status $Message -PercentComplete (($StepNumber / ($stepCounter).count ) * 100)
}

<#

Write-ProgressHelper -Message 'Doing something' -StepNumber ($stepCounter++)
Start-Sleep -Seconds 5

## Some process here

Write-ProgressHelper -Message 'Doing something2' -StepNumber ($stepCounter++)

Start-Sleep -Seconds 5

## Some process here

Write-ProgressHelper -Message 'Doing something3' -StepNumber ($stepCounter++)

Start-Sleep -Seconds 5



$tcount = 100
for($i=0;$i -le $tcount; $i++){

   $pcomplete = ($i / $tcount) * 100
   Write-Progress -Activity "Counting from 1 to 100" -Status "Counting $i times" -PercentComplete $pcomplete
   Start-Sleep 1
}

#>

