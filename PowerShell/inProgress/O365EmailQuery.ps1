Install-Module ExchangeOnlineManagement -Scope CurrentUser
Connect-ExchangeOnline -UserPrincipalName luke@leigh-services.com -DelegatedOrganization leigh-services.com
Get-MessageTrace -RecipientAddress "luke@leigh-services.com" -StartDate "11/02/2020 0:00 AM" -EndDate "11/02/2020 11:59 PM"
Get-MessageTrace -RecipientAddress "luke@leigh-services.com" -StartDate "11/02/2020 0:00 AM" -EndDate "11/02/2020 11:59 PM" | Format-Table -Property SenderAddress, RecipientAddress, Subject, Received
