$env:Path
. .\GitRepos\RDG\WorkingFolder\EnvPaths.ps1
Get-ScriptFunctionNames C:\GitRepos\RDG\WorkingFolder\EnvPaths.ps1
Get-EnvPath
Get-EnvPath -Container User
Get-EnvPath -Container Machine
Add-EnvPath -Container Machine -Path "C:\Program Files\SysinternalsSuite" -Verbose
Get-EnvPath -Container Machine
Clear-Host

Get-ProfileFunctions
Get-Command -CommandType Function
Get-Command -CommandType Function -ListImported
Clear-Host

Get-Command -CommandType Function -ListImported | Where-Object -Property Name -Like "Get-Mail*"


logonsessions /?
logonsessions -p
logonsessions -p | Format-List
logonsessions -p | Format-Table
Clear-Host
logonsessions -p
logonsessions -p -c | ConvertFrom-Csv
logonsessions -p -c
$Sessions = logonsessions -p -c
$Sessions | ConvertFrom-Csv
$Sessions | ConvertFrom-Csv | Get-Member
$Sessions = logonsessions -p -c
$Sessions
$Sessions | Select-Object -Skip 5 | Convertrom-csv
Get-Content $Sessions | Select-Object -Skip 5 | Convertrom-csv
Get-Content $Sessions
$Sessions | Select-Object -Skip 5 | ConvertFrom-Csv
$Sessions | Select-Object -Skip 5 | ConvertFrom-Csv | Format-Table -AutoSize


Get-Service -Name IISExpressSVC | Stop-Service -Force


notepad 'C:\Program Files (x86)\Lansweeper\IISexpress\IISExpressSvc.exe.config'


