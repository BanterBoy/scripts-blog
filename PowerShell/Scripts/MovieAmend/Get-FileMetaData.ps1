Add-Type -Path C:\GitRepos\ModulePlayground\MovieAmend\taglib-sharp.dll

$file = [TagLib.Mpeg4.File]::new('\\deathstar\Movies\Anna (2019)\Anna (2019).mp4')

$MetaDataObject = New-Object Taglib.Mpeg4.File
$shell = New-Object -COMObject Shell.Application

