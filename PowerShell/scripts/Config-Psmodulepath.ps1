<# Import OneDrive to PSModulePath
The following commands will:-
Test/Check current module path
#>
[Environment]::GetEnvironmentVariable("PSModulePath")

#Save the current value in the $p variable.
$currentPath = [Environment]::GetEnvironmentVariable("PSModulePath")

#Add the new path to the $p variable. Begin with a semi-colon separator.
$Path = $env:OneDrive
$ModuleDrive = Join-Path -Resolve -Path $Path -ChildPath .\PowerShellModules
$currentPath += ";$ModuleDrive"

#Add the paths in $p to the PSModulePath value.
[Environment]::SetEnvironmentVariable("PSModulePath", $currentPath)

#Test/Check current module path
[Environment]::GetEnvironmentVariable("PSModulePath")
