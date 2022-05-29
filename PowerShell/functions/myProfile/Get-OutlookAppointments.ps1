Function Get-OutlookAppointments {
   param ( 
      [Int] $NumDays = 7,
      [DateTime] $Start = [DateTime]::Now ,
      [DateTime] $End = [DateTime]::Now.AddDays($NumDays)
   )
 
   Process {
      $outlook = New-Object -ComObject Outlook.Application
 
      $session = $outlook.Session
      $session.Logon()
 
      $apptItems = $session.GetDefaultFolder(9).Items
      $apptItems.Sort("[Start]")
      $apptItems.IncludeRecurrences = $true
      $apptItems = $apptItems
 
      $restriction = "[End] >= '{0}' AND [Start] <= '{1}'" -f $Start.ToString("g"), $End.ToString("g")
 
      foreach ($appt in $apptItems.Restrict($restriction)) {
         If (([DateTime]$Appt.Start - [DateTime]$appt.End).Days -eq "-1") {
            "All Day Event : {0} Organized by {1}" -f $appt.Subject, $appt.Organizer
         }
         Else {
            "{0:dd/MM/yyyy @ hh:mmtt} - {1:hh:mmtt} : {2} Organized by {3}" -f [DateTime]$appt.Start, [DateTime]$appt.End, $appt.Subject, $appt.Organizer
         }
          
      }
 
      $outlook = $session = $null;
   }
}