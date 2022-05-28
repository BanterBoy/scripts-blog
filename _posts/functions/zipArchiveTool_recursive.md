---
layout: post
title: zipArchiveTool_recursive.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
#James Bennett
#Environment variable to CD for top level source directory log file location
set-location C:\scripts\something\

#logfile location
$genericlogfile = 'c:\log.txt'

#Filelocked function
function filelocked ($filepath){
get-date | out-file -append $GenericLogFile
$filepath + ' is locked and has not been archived or deleted' | out-file -append $GenericLogFile
}

#DeleteZipped Function
function deletezipped ($filepath){
write-host $filepath -foregroundcolor "red"
if($filepath.attributes -ne "Directory") {remove-item $filepath -force}
}

#Function to zip files
function create-7zip([String] $aDirectory, [String] $aZipfile, $filemouth, $fileyear){
    $ZipFileName = "u_ex_" + "$filemonth" + "$fileyear" + ".zip"
    [string]$pathToZipExe = "C:\Program Files (x86)\7-Zip\7z.exe";
    [Array]$arguments = "a", "-tzip", "$ZipFileName", "$filepath", "-r", "2>$1";
    & $pathToZipExe $arguments;
}
################################################################################
#Source Directory - manually create
$oldtoplevel = "c:\scripts"
#Archive directory - manually create
$newtoplevel = "c:\archive"

#Source folder for logs - find all logs
$getFiles1 = get-childitem -recurse $oldtoplevel -exclude *.zip | Where-Object {$_.PSIsContainer -eq $false}

foreach ($file in $getfiles1){
	#get file full path
	$filepath = $file.fullname
    write-host $filepath -foregroundcolor "green"

	#get the directory name (only) of the file ($file)
	$dirpath = $file.directoryname
    write-host $dirpath -foregroundcolor "blue"

	#Get the file properties to pass to zip function
	$filemonth = $file.lastwritetime.month
	$fileyear = $file.lastwritetime.year

	#Destination path for zipped logs
	$aDirectory = $dirpath

	#Check your destiation path
	#write-host ($dirpath -replace [regex]::escape($oldtoplevel), $newtoplevel)

	#manipulate the path using replace for $adirectory to get created
	$aDirectory = ($dirpath -replace [regex]::escape($oldtoplevel), $newtoplevel)
	write-host $adirectory -foregroundcolor "yello"
    write-host $adirectory -foregroundcolor "red"
	#Check if folder doesn't exist
	if(!(test-path -path $adirectory)) {new-item $aDirectory -itemtype directory}

	#this is the destination of the zip
	set-location $adirectory

	#Call function
	create-7zip $aDirectory $filemonth $filepath $fileyear
	$filearray += $filepath

	#If the file is locked dont delete it
		if ($lastexitcode -ne 0) { filelocked $filepath } else {DeleteZipped $filepath}


}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

You can of course copy any part of the script from the text above, or you can simply press the download button and download the entire script. Choice is yours....its just nice to have choices 😎

<button class="btn" type="submit" onclick="window.open('/PowerShell/compression/zipArchiveTool_recursive.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=zipArchiveTool_recursive.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify

```

```
