$servers = "APP01","AS01","AZAPP01","AZAPP02","AZAPP03","BIWEB01","DRSRV01","FEDERATION01","FTP01","FTP02","MEADMANAG01","MEADMANGSS01","MEDS01","MESD01","SAGESQL","SQL04B","SQL07","SQLDEV01","SSIS01","TIMELOG","VENMABS01","VERINTDEV","VNSRVALT03","VNSRVSQL01","WFMDC01","WFMFCS01"
foreach ( $Server in $Servers ) {
Get-RemoteServiceAccount -ComputerName $server |
Where-Object { ( $_.StartName -notmatch 'LocalSystem|^NT Authority' ) -and ( $_.StartName -like '*Administrator' ) }
}


$servers = "APP01","AS01","AZAPP01","AZAPP02","AZAPP03","BIWEB01","DRSRV01","FEDERATION01","FTP01","FTP02","MEADMANAG01","MEADMANGSS01","MEDS01","MESD01","SAGESQL","SQL04B","SQL07","SQLDEV01","SSIS01","TIMELOG","VENMABS01","VERINTDEV","VNSRVALT03","VNSRVSQL01","WFMDC01","WFMFCS01"
foreach ( $Server in $Servers ) {
Get-RemoteServiceAccount -ComputerName $server |
Where-Object { ( $_.StartName -notmatch 'LocalSystem|^NT Authority' ) }
}


DisplayName                               StartName                     State
-----------                               ---------                     -----
Ventrica Integration Service              ventrica\svc-IntegrationServi Running
WallboardService                          ventrica\svc-IntegrationServi Running
Altitude Enterprise Recording Connector 8 ventrica\aer                  Stopped
Altitude License Manager - easy_lms       ventrica\adminsvc             Running
Altitude uCI Server - uCI8                ventrica\adminsvc             Running
Data Pipeline Service                     ventrica\svc-IntegrationServi Running
On-premises data gateway service          Administrator@ventrica.local  Stopped
STCIWorkerService                         ventrica\svc-IntegrationServi Running
Data Pipeline Service                     svc-IntegrationServices@ve... Running
STCI Altitude Monitor                     svc-IntegrationServices@ve... Running
STCI Zendesk Monitor                      svc-IntegrationServices@ve... Running
Data Pipeline Service                     svc-IntegrationServices@ve... Running
On-premises data gateway service          Administrator@ventrica.local  Running
CaptureService_c731e8e                                                  Stopped
Clipboard User Service_c731e8e                                          Stopped
Connected Devices Platform User Servic...                               Running
ConsentUX_c731e8e                                                       Stopped
DevicePicker_c731e8e                                                    Stopped
DevicesFlow_c731e8e                                                     Stopped
Contact Data_c731e8e                                                    Stopped
PrintWorkflow_c731e8e                                                   Stopped
User Data Storage_c731e8e                                               Stopped
User Data Access_c731e8e                                                Stopped
Windows Push Notifications User Servic...                               Running
Power BI Report Server                    ventrica\BISvc                Running
Get-WmiObject : The RPC server is unavailable.
At C:\PowerShell\functions\activeDirectory\Get-RemoteServiceAccount.ps1:23 char:9
+         Get-WmiObject -Class Win32_Service -ComputerName $ComputerNam ...
+         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [Get-WmiObject], COMException
    + FullyQualifiedErrorId : GetWMICOMException,Microsoft.PowerShell.Commands.GetWmiObjectCommand

Active Directory Federation Services      VENTRICA\federationsvc$       Running
Device Registration Service               VENTRICA\federationsvc$       Stopped
Windows Internal Database                 NT SERVICE\MSSQL$MICROSOFT... Running
FileZilla Server FTP server               VENTRICA\AdminSvc             Stopped
freeFTPdService                           ventrica\sftpsvc$             Stopped
freeFTPdService                           ftp02svc@ventrica.local       Running
ManageEngine ADSelfService Plus           VENTRICA\MengSvrSvc$          Running
ManageEngine DataSecurity Plus            svc-DataSecurityPlus@ventr... Running
ManageEngine ServiceDesk Plus             ventrica\MengSvrSvc$          Running
SQL Server Analysis Services (SAGEHR)     Ventrica\adminSVC             Running
SQL Server Agent (SAGEHR)                 Ventrica\AdminSVC             Running
SQL Full-text Filter Daemon Launcher (... NT Service\MSSQLFDLauncher    Running
SQL Server (MSSQLSERVER)                  ventrica\SVCSQL               Running
SQL Server Agent (MSSQLSERVER)            ventrica\SVCSQL               Running
SQL Server CEIP service (MSSQLSERVER)     NT Service\SQLTELEMETRY       Running
SQL Server Integration Services 14.0      svcsql07@ventrica.local       Running
SQL Full-text Filter Daemon Launcher (... NT Service\MSSQLFDLauncher    Stopped
SQL Server Launchpad (MSSQLSERVER)        svcsql07@ventrica.local       Stopped
SQL Server (MSSQLSERVER)                  VENTRICA\svcsql07             Running
SQL Server Analysis Services (MSSQLSER... svcsql07@ventrica.local       Stopped
Microsoft SQL Server IaaS Query Service   NT Service\SqlIaaSExtensio... Running
SQL Server Agent (MSSQLSERVER)            svcsql07@ventrica.local       Running
SQL Server CEIP service (MSSQLSERVER)     svcsql07@ventrica.local       Running
SQL Server Analysis Services CEIP (MSS... svcsql07@ventrica.local       Running
SQL Server Integration Services CEIP s... svcsql07@ventrica.local       Running
SQL Server (MSSQLSERVER)                  NT Service\MSSQLSERVER        Running
SQL Server Agent (MSSQLSERVER)            NT Service\SQLSERVERAGENT     Running
SQL Server CEIP service (MSSQLSERVER)     NT Service\SQLTELEMETRY       Stopped
SQL Server Integration Services 13.0      VENTRICA\adminsvc             Stopped
SQL Server Integration Services 14.0      adminsvc@ventrica.local       Stopped
On-premises data gateway service          NT SERVICE\PBIEgwService      Running
SQL Server Integration Services CEIP s... NT Service\SSISTELEMETRY130   Stopped
SQL Server Integration Services CEIP s... NT Service\SSISTELEMETRY140   Stopped
Ventrica Integration Service              ventrica\svc-IntegrationServi Running
SQL Server Agent (MSSQLSERVER)            adminsvc@ventrica.local       Stopped
SQL Server (MSDPMINSTANCE)                SQL-MicrosoftDPMAcct@ventr... Running
SQL Server Agent (MSDPMINSTANCE)          SQL-MicrosoftDPMAcct@ventr... Running
SQL Server CEIP service (MSDPMINSTANCE)   NT Service\SQLTELEMETRY$MS... Running
I360 CF Tomcat                            ventrica\wfmmsa_dev           Stopped
I360 Post Processing CMM                  ventrica\wfmmsa_dev           Stopped
I360 Post Processing Inspector            ventrica\wfmmsa_dev           Stopped
Integration Server                        ventrica\wfmmsa_dev           Running
Mas Service                               ventrica\wfmmsa_dev           Stopped
Miner Tomcat                              ventrica\wfmmsa_dev           Stopped
SQL Server Integration Services 14.0      wfmmsa_dev@ventrica.co.uk     Running
SQL Full-text Filter Daemon Launcher (... NT Service\MSSQLFDLauncher    Stopped
SQL Server (MSSQLSERVER)                  wfmmsa_dev@ventrica.co.uk     Running
PlatformBackendServices                   ventrica\wfmmsa_dev           Stopped
Recorder Api Service                      ventrica\wfmmsa_dev           Stopped
SQL Server Agent (MSSQLSERVER)            wfmmsa_dev@ventrica.co.uk     Running
SQL Server Reporting Services             ventrica\wfmmsa_dev           Running
SQL Server CEIP service (MSSQLSERVER)     NT Service\SQLTELEMETRY       Stopped
SQL Server Integration Services CEIP s... NT Service\SSISTELEMETRY140   Stopped
I360 Transcription Repository Service ... ventrica\wfmmsa_dev           Stopped
WFO Branch Forecasting                    ventrica\wfmmsa_dev           Stopped
WFO_ProductionDomain_ProductionServer     ventrica\wfmmsa_dev           Running
Altitude Communication Server 3.0         VENTRICA\Altitude2            Running
Altitude Communication Server Web Mana... VENTRICA\Altitude2            Running
Altitude Automated Agents Subsystem 8     VENTRICA\altitude2            Running
Altitude Recorder Storage Server 8        altitude2@ventrica.local      Running
Altitude Recorder Recording Client 8      VENTRICA\altitude2            Running
Altitude Recorder Control Server 8        VENTRICA\altitude2            Running
Altitude Recorder Service Controller 8    VENTRICA\altitude2            Running
Altitude Recorder Codec 8                 VENTRICA\altitude2            Running
Altitude Recorder File Transfer Client 8  VENTRICA\altitude2            Running
SQL Full-text Filter Daemon Launcher (... NT Service\MSSQLFDLauncher    Running
SQL Server (MSSQLSERVER)                  ventrica\SQLSvcServer$        Running
SQL Server Agent (MSSQLSERVER)            ventrica\SQLSvrAgent$         Running
SQL Server CEIP service (MSSQLSERVER)     NT Service\SQLTELEMETRY       Running
I360 CF Tomcat                            ventrica\wfmmsa               Stopped
I360 Post Processing CMM                  ventrica\wfmmsa               Stopped
I360 Post Processing Inspector            ventrica\wfmmsa               Stopped
Integration Server                        ventrica\wfmmsa               Running
Mas Service                               ventrica\wfmmsa               Stopped
Miner Tomcat                              ventrica\wfmmsa               Stopped
PlatformBackendServices                   ventrica\wfmmsa               Stopped
Recorder Api Service                      ventrica\wfmmsa               Stopped
SQL Server Reporting Services             ventrica\wfmmsa               Running
I360 Transcription Repository Service ... ventrica\wfmmsa               Stopped
WFO Branch Forecasting                    ventrica\wfmmsa               Stopped
WFO_ProductionDomain_ProductionServer     ventrica\wfmmsa               Running
Integration Server                        ventrica\wfmmsa               Running