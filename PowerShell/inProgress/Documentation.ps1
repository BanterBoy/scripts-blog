<#
    http://sydiproject.com/

    cscript.exe 'D:\LazyWinAdmin\scripts\Sydi-Server.vbs' -wabefghipPqrsSu -racdklp -ew -f10 -d -o'D:\ServerDocumentation\ServerName.docx' -t'ServerName' -u'UserAccount' -p'PassWord'
#>

$Servers = Get-ADComputer -Filter { Name -like '*' } -SearchBase 'OU=Servers,DC=ventrica,DC=local' | Where-Object { $_ -notlike '*Service Computer Accounts*' } | Select-Object -Last 1

foreach ($item in $Servers) {

    cscript.exe 'D:\LazyWinAdmin\scripts\Sydi-Server.vbs' -wabefghipPqrsSu -racdklp -ew -f10 -d -o'D:\ServerDocumentation\ServerName.docx' -t'ServerName' -u'UserAccount' -p'PassWord'

}
