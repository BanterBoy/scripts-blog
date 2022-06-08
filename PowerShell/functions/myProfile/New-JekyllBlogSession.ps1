function New-JekyllBlogSession {
	$PSRootFolder = Select-FolderLocation
	New-PSDrive -Name BlogDrive -PSProvider "FileSystem" -Root $PSRootFolder
	code ($PSRootFolder) -n
}