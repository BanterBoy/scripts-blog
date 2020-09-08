# Print Server: Printer Usage Report
# This script generates and sends printer usage reports when run from the print server
# Version 2.0 - James Pearman, November 2018


#Email Parameters
$EmailTo = "emailto@domain.com"
$EmailFrom = "PrintRpt@domain.com"
$EmailSubject = "Printer Report " +$Computer
$Body = "Please see attached print usage report from " +$Computer
$SMTPServer  = "smtp.domain.com"
$Attachment = "C:\Support\PrintReport $Computer.csv"

#Report Parameters
$aPrinterList = @()
$Computer = $env:computername
$TodaysDate = Get-Date -DisplayHint Date

#Enter the date you wish to run the report from
$FirstDate = Read-Host -Prompt 'Enter the first date to report from as DD/MM/YYYY:
'
#Enter the date you want to run the report too
$LastDate = Read-Host -Prompt 'Enter the final date to report from as DD/MM/YYYY:
'
$Results = Get-WinEvent -FilterHashTable @{LogName="Microsoft-Windows-PrintService/Operational"; StartTime=$FirstDate; EndTime=$LastDate; ID=307} -ComputerName $Computer


ForEach($Result in $Results){
  $ProperyData = [xml]$Result.ToXml()
  $IP =  $ProperyData.Event.UserData.DocumentPrinted.Param6
     
   If ($IP.Contains("192.168.4")) {
    
		$hItemDetails = New-Object -TypeName psobject -Property @{
			DocName = $ProperyData.Event.UserData.DocumentPrinted.Param2
			UserName = $ProperyData.Event.UserData.DocumentPrinted.Param3
			MachineName = $ProperyData.Event.UserData.DocumentPrinted.Param4
			PrinterName = $ProperyData.Event.UserData.DocumentPrinted.Param5
			PageCount = $ProperyData.Event.UserData.DocumentPrinted.Param8
			TimeCreated = $Result.TimeCreated
    }

    $aPrinterList += $hItemDetails
  }
}


#Save a copy of the report as a .csv file the path specified below
$aPrinterList | Export-Csv -Path "C:\Support\PrintReport $Computer.csv" -NoTypeInformation

#Email a copy of the report using the email paramenters above
Send-MailMessage -To $EmailTo -From $EmailFrom -Subject $EmailSubject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $Attachment
