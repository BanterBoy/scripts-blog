#PowerShellNap.ps1

#nap time in minutes
Param([int]$Naptime = 1)

#define the wakeup time
If ($Naptime -le 0) { $Wake = (Get-Date).AddSeconds(1) }
Else { $Wake = (Get-Date).AddMinutes($Naptime) }

#loop until the time is >= the wake up time
do {
    Clear-Host
    Write-host "Ssshhhh...."

    #trim off the milliseconds
    Write-Host ($Wake - (Get-Date)).ToString().Substring(0, 8) -NoNewline

    Start-Sleep -Seconds 1

} Until ( (Get-Date) -ge $Wake)

#Speak wake up text
Add-Type -AssemblyName System.speech
$Speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$InstalledVoices = $Speak.GetInstalledVoices() | ForEach-Object { $_.VoiceInfo }
$InstalledVoices | ForEach-Object { If ($_.Name -eq "Microsoft Hazel Desktop") { $Speak.SelectVoice("Microsoft Hazel Desktop") } }
$Speak.Speak('Wake up and assimilate the day. We are the borg. Resistance is futile!')
$Speak.Speak('Wake up and assimilate the day. We are the borg. Resistance is futile!')
Start-Sleep -Seconds 1
$InstalledVoices | ForEach-Object { If ($_.Name -eq "Microsoft David Desktop") { $Speak.SelectVoice("Microsoft David Desktop") } }
$Speak.Speak("Okay, but how do I turn you off?")
Start-Sleep -Seconds 1
$InstalledVoices | ForEach-Object { If ($_.Name -eq "Microsoft Hazel Desktop") { $Speak.SelectVoice("Microsoft Hazel Desktop") } }
$Speak.Speak("Believe me, I'm pretty much turned off right now.")
Start-Sleep -Seconds 2
$InstalledVoices | ForEach-Object { If ($_.Name -eq "Microsoft David Desktop") { $Speak.SelectVoice("Microsoft David Desktop") } }
$Speak.Speak("Time to get back to work and replace someone with a very small shell script!")
