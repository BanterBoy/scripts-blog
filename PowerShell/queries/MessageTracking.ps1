Get-MessageTrace -RecipientAddress "*@company.com" |
Where-Object { ( $_.Status -like "*Failed" ) } |
Format-List |
Out-File -FilePath '.\Scripts\output.txt' -Append

Get-MessageTrace -RecipientAddress "*@company.com" |
Where-Object { ( $_.Status -eq "Failed" ) } |
Get-MessageTraceDetail |
Where-Object { ( $_.Event -eq "Fail" ) } |
Format-List |
Out-File -FilePath '.\Scripts\output.txt' -Append

Get-MessageTrace -RecipientAddress "*@company.com" |
Format-Table -AutoSize |
Out-File -FilePath '.\Scripts\output.txt' -Append

#===============================#

Get-MessageTrace -StartDate "03/21/2018 00:00:00" -EndDate "03/21/2018 12:00:00" |
Where-Object { ( $_.Status -like "*Failed" ) } |
Format-List 

Get-MessageTrace -SenderAddress "notifications@company.com" -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" |
Get-MessageTraceDetail | Format-List -Property Organization, MessageId, MessageTraceId, Date, Event, Action, Detail, Data

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -SenderAddress "*@company.com" -RecipientAddress "notifications@company.com"

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -RecipientAddress "notifications@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -RecipientAddress "notifications@company.com" -SenderAddress "*@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize |
Measure-Object

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -SenderAddress "*@company.com" -RecipientAddress "notifications@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize

Get-MessageTrace -RecipientAddress "*@company.com" |
Where-Object { ( $_.Status -like "*Failed" ) } |
Format-List 


Get-MessageTrace -RecipientAddress "*@company.com" |
Where-Object { ( $_.Status -eq "Failed" ) } |
Get-MessageTraceDetail |
Where-Object { ( $_.Event -eq "Fail" ) } |
Format-List 

Get-MessageTrace -RecipientAddress "*@company.com" |
Format-Table -AutoSize

#===============================#

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -RecipientAddress "*@company.com" -SenderAddress "notifications@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -RecipientAddress "notifications@company.com" -SenderAddress "*@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -RecipientAddress "notifications@company.com" -SenderAddress "*@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize |
Measure-Object

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -SenderAddress "*@company.com" -RecipientAddress "notifications@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize

#========================#

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -SenderAddress "*@company.com" -RecipientAddress "notifications@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -SenderAddress "*@company.com" -RecipientAddress "notifications@company.com" | Measure-Object


Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -SenderAddress "notifications@company.com" -RecipientAddress "*@company.com" |
Format-Table -Property Received, SenderAddress, RecipientAddress, Status -AutoSize

Get-MessageTrace -StartDate "03/11/2018 00:00:00" -EndDate "03/21/2018 12:00:00" -SenderAddress "notifications@company.com" -RecipientAddress "*@company.com" | Measure-Object

Get-MessageTrace -SenderAddress "box.SCM.MDVendors@nationalgrid.com" -StartDate "03/07/2019 10:00:00" -EndDate "03/07/2019 12:00:00" | Get-MessageTraceDetail | Format-List -Property Organization, MessageId, MessageTraceId, Date, Event, Action, Detail, Data

