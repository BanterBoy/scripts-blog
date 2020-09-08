Import-Module C:\GitRepos\ModulePlayground\MovieAmend\taglib

$MoviesMP4 = Get-ChildItem -Path '\\deathstar\Movies\' -Filter '*.mp4' -Recurse

foreach($MP4 in $MoviesMP4){
	Get-item $MP4.FullName |
	set-title -title $MP4.BaseName
	Write-Verbose -Message "Title amended for $($MP4.BaseName)" -Verbose
	}
	