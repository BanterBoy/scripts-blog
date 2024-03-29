---
layout: post
title: zipArchiveTool_recursive.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code. For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

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

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/compression/zipArchiveTool_recursive.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

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
