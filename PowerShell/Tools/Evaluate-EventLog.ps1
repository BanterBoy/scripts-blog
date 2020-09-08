<#----------
Evaluating Event Log Information

Get-EventLog provides access to the content written to the classic Windows event logs.
The most valuable information can be found in a secret property called ReplacementStrings.
Here is an approach to make this information visible so you can examine it and build reports.

In the example, the event ID 44 written by the Windows Update Client is retrieved, and the code outputs the replacement strings.
They tell you exactly which updates were downloaded, and when:
----------#>

Get-EventLog -LogName System -InstanceId 44 -Source Microsoft-Windows-WindowsUpdateClient |

ForEach-Object { 
  
  $hash = [Ordered]@{}
  $counter = 0
  foreach($value in $_.ReplacementStrings)
  {
    $counter++
    $hash.$counter = $value
  }
  $hash.EventID = $_.EventID
  $hash.Time = $_.TimeWritten
  [PSCustomObject]$hash
	}

<#----------
Always make sure you query for one distinct event ID: the information found in ReplacementStrings is unique per event ID, and you don't want to mix information from different event ID types.
----------#>
