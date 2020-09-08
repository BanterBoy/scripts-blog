This script has been written to provide a quick and basic report of events of the last 48 hours in the Exchange administrator audit log.

This has been written for Exchange 2010 SP3 with PowerShell 2.0 and can be run on the server and as a scheduled task.

To run this as a scheduled task set the following under Action:
      Action: Start a program
      Program/script: %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe
      Add arguments (optional): -version 2.0 -NonInteractive -WindowStyle Hidden -command ". 'C:\Program Files\Microsoft\Exchange   Server\V14\bin\RemoteExchange.ps1'; Connect-ExchangeServer -auto; C:\Support\ActiveScripts\Exch_AdminAuditReport.ps1
      
