<#
.SYNOPSIS
Retrieves Outlook appointments within a specified date range.

.DESCRIPTION
The Get-OutlookAppointments function retrieves Outlook appointments within a specified date range. It uses the Outlook COM object to connect to the Outlook application and retrieve the appointments.

.PARAMETER NumDays
Specifies the number of days to retrieve appointments for. The default value is 7.

.PARAMETER Start
Specifies the start date for retrieving appointments. The default value is the current date and time.

.PARAMETER End
Specifies the end date for retrieving appointments. The default value is calculated by adding the NumDays parameter to the Start date.

.EXAMPLE
Get-OutlookAppointments -NumDays 14 -Start (Get-Date "2022-01-01") -End (Get-Date "2022-01-14")
Retrieves Outlook appointments for the next 14 days starting from January 1, 2022.

.NOTES
This function requires the Outlook COM object to be installed on the system.

.LINK
https://docs.microsoft.com/en-us/office/vba/api/overview/outlook

#>
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
