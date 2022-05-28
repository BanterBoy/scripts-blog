---
layout: post
title: GetUserLoggedOnto.ps1
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
<#
http://powershell.com/cs/members/jagnagra/default.aspx
Queries a computer to check for interactive sessions
.EXAMPLE
.\GetUserLoggedOnto.ps1 -UserName <userid>
#>

[CmdletBinding()]
Param(
	[Parameter(ValueFromPipeline = $true,
		ValueFromPipelineByPropertyName = $true)]
	[string[]]$ComputerName = (Get-ADComputer -filter {
			Enabled -eq $True } | Sort-Object name | Select-Object -expand Name),
	[Parameter(ValueFromPipeline = $true,
		ValueFromPipelineByPropertyName = $true)]
	[string]$username = 'username',
	[Parameter()]
	[string]
	$OutputDir = "\\fileserver\sharename"
)
begin {
	$OutputFile = Join-Path $OutputDir "filename.csv"
	Write-Verbose "Script will write the output to $OutputFile folder"
	$ErrorActionPreference = 'Stop'
}
process {
	foreach ($Computer in $ComputerName) {
		If (!(Test-Connection -ComputerName $Computer -Count 1 -Quiet)) {
			# Device is off
		}
		else {
			try {
				quser /server:$Computer 2>&1 | Select-Object -Skip 1 | ForEach-Object {
					$CurrentLine = $_.Trim() -Replace '\s+', ' ' -Split '\s'
					$HashProps = @{
						UserName     = $CurrentLine[0]
						ComputerName = $Computer
					}

					# If session is disconnected different fields will be selected

					if ($currentline[0] -eq $username -and $CurrentLine[2] -eq 'Disc') {
						$HashProps.Id = $CurrentLine[1]
						$HashProps.State = $CurrentLine[2]
						$HashProps.IdleTime = $CurrentLine[3]
						$HashProps.LogonTime = $CurrentLine[4..6] -join ' '
						$HashProps.LogonTime = $CurrentLine[4..($CurrentLine.GetUpperBound(0))] -join ' '
						New-Object -TypeName PSCustomObject -Property $HashProps |
						Select-Object -Property UserName, ComputerName, State, ID, IdleTime, LogonTime
						Add-Content -Path $OutPutFile -Value "$Computer, $CurrentLine[1], State"
					}
					else {
						$HashProps.SessionName = $CurrentLine[1]
						$HashProps.Id = $CurrentLine[2]
						$HashProps.State = $CurrentLine[3]
						$HashProps.IdleTime = $CurrentLine[4]
						$HashProps.LogonTime = $CurrentLine[5..($CurrentLine.GetUpperBound(0))] -join ' '
						New-Object -TypeName PSCustomObject -Property $HashProps |
						Select-Object -Property UserName, ComputerName, State, ID, IdleTime, LogonTime
						Add-Content -Path $OutPutFile -Value "$Computer, $CurrentLine[1], State"
					}
				}
			}
			catch {

			}
			finally {

			}
		}
	}
}
end {

}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/activeDirectory/GetUserLoggedOnto.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=GetUserLoggedOnto.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
