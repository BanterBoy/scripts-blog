---
layout: post
title: Get-FileAndFolderPermissions.ps1
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

**_@GitHub Copilot_** - This PowerShell script is designed to retrieve the permissions for files and folders. The script takes two parameters, `$FileFolder` and `$SourcePath`. The `$FileFolder` parameter specifies whether the `$SourcePath` is a file or a folder. If `$FileFolder` is set to "File", the script retrieves the permissions for the specified file. If `$FileFolder` is set to "Folder", the script retrieves the permissions for the specified folder and, if the `$Recurse` parameter is set to `$true`, retrieves the permissions for all subfolders as well.

The script begins by checking whether `$FileFolder` is set to "File" or "Folder". If `$FileFolder` is set to "File", the script checks whether the specified file exists. If the file exists, the script retrieves the permissions for the file using the `Get-Acl` cmdlet. The script then loops through each access rule in the file's access control list (ACL) and creates a custom object that includes the file's path, the identity reference for the user or group that the access rule applies to, and the file system rights granted by the access rule.

If `$FileFolder` is set to "Folder", the script checks whether the specified folder exists. If the folder exists, the script retrieves the permissions for the folder using the `Get-Acl` cmdlet. The script then loops through each access rule in the folder's ACL and creates a custom object that includes the folder's path, the identity reference for the user or group that the access rule applies to, and the file system rights granted by the access rule. If `$Recurse` is set to `$true`, the script retrieves the permissions for all subfolders of the specified folder by using the `Get-ChildItem` cmdlet to retrieve a list of all subfolders, and then looping through each subfolder and retrieving its permissions in the same way as the parent folder.

Finally, the script includes a `try`/`catch` block to handle any errors that may occur during execution. If an error occurs, the script writes the error message to the console using the `Write-Error` cmdlet.

To improve the readability of the code, the script could benefit from additional comments to explain the purpose of each section of code. Additionally, the script could be optimized for performance by using the `-Filter` parameter of the `Get-ChildItem` cmdlet to retrieve only the subfolders that match a specific pattern, rather than retrieving all subfolders and then filtering them in the script.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Certainly! Here are a few examples of how to use the script:

To retrieve the permissions for a file:

```
Get-FileAndFolderPermissions -FileFolder "File" -SourcePath "C:\Temp\example.txt"
```

To retrieve the permissions for a folder:

```
Get-FileAndFolderPermissions -FileFolder "Folder" -SourcePath "C:\Temp" -Recurse $false
```

To retrieve the permissions for a folder and all subfolders:

```
Get-FileAndFolderPermissions -FileFolder "Folder" -SourcePath "C:\Temp" -Recurse $true
```

In each of these examples, replace the `SourcePath` parameter with the path to the file or folder for which you want to retrieve permissions. The `Recurse` parameter is optional and determines whether the script should retrieve permissions for all subfolders of the specified folder. Set `Recurse` to `$true` to retrieve permissions for all subfolders, or `$false` to retrieve permissions only for the specified folder.

---

#### Script

```powershell
function Get-FileAndFolderPermissions {

	<#
	.SYNOPSIS
	Retrieves the permissions for files or folders at a specified path.

	.DESCRIPTION
	The Get-FileAndFolderPermissions function retrieves the permissions for files or folders at a specified path. It can retrieve permissions for a single file or folder, or for all files or folders in a directory and its subdirectories.

	.PARAMETER SourcePath
	The path to the file or folder for which to retrieve permissions.

	.PARAMETER FileFolder
	Specifies whether to retrieve permissions for a file or a folder. Valid values are "File" and "Folder".

	.PARAMETER Extension
	Specifies a file extension to filter by when retrieving permissions for files.

	.PARAMETER Recurse
	Indicates whether to retrieve permissions for files or folders in subdirectories.

	.EXAMPLE
	Get-FileAndFolderPermissions -SourcePath "C:\Temp\MyFile.txt" -FileFolder "File"

	Retrieves the permissions for the file "MyFile.txt" located in the "C:\Temp" directory.

	.EXAMPLE
	Get-FileAndFolderPermissions -SourcePath "C:\Temp" -FileFolder "Folder" -Recurse

	Retrieves the permissions for all folders in the "C:\Temp" directory and its subdirectories.

	.NOTES
	Author: GitHub Copilot
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]$SourcePath,
		[Parameter(Mandatory = $true)]
		[ValidateSet("File", "Folder")]
		[string]$FileFolder,
		[string]$Extension,
		[switch]$Recurse
	)

	try {
		if ($FileFolder -eq "File") {
			if (-not (Test-Path $SourcePath)) {
				throw "File does not exist: $SourcePath"
			}
			if ($Extension) {
				$files = Get-ChildItem $SourcePath -Filter "*$Extension" -File -Recurse:$Recurse
			}
			else {
				$files = Get-ChildItem $SourcePath -File -Recurse:$Recurse
			}
			foreach ($file in $files) {
				$acl = Get-Acl $file.FullName
				foreach ($access in $acl.Access) {
					[PSCustomObject]@{
						Path              = $file.FullName
						IdentityReference = $access.IdentityReference
						FileSystemRights  = $access.FileSystemRights
					}
				}
			}
		}
		elseif ($FileFolder -eq "Folder") {
			if (-not (Test-Path $SourcePath)) {
				throw "Folder does not exist: $SourcePath"
			}
			$acl = Get-Acl $SourcePath
			foreach ($access in $acl.Access) {
				[PSCustomObject]@{
					Path              = $SourcePath
					IdentityReference = $access.IdentityReference
					FileSystemRights  = $access.FileSystemRights
				}
			}
			if ($Recurse) {
				$folders = Get-ChildItem $SourcePath -Directory -Recurse
				foreach ($folder in $folders) {
					$acl = Get-Acl $folder.FullName
					foreach ($access in $acl.Access) {
						[PSCustomObject]@{
							Path              = $folder.FullName
							IdentityReference = $access.IdentityReference
							FileSystemRights  = $access.FileSystemRights
						}
					}
				}
			}
		}
	}
 catch {
		Write-Error $_.Exception.Message
	}
}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/NewFunctions/Get-FileAndFolderPermissions.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-FileAndFolderPermissions.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
