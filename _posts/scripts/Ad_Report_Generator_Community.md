---
layout: post
title: Ad_Report_Generator_Community.ps1
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
<#
				"Satnaam WaheGuru Ji"

	Author  : Aman Dhally
	Email	: amandhally@gmail.com
	Date	: 21-august-2012
	Time	: 13:20
	Script	: Active Directory Reports
	Purpose	: Active Directory Reporting to Excel
	website : www.amandhally.net
	twitter : https://twitter.com/#!/AmanDhally

				/^(o.o)^\  V.1

#>

# Import Active Directory Module
Import-Module -Name ActiveDirectory

# variables
$date = (Get-Date).tostring()
$week = (Get-Date).AddDays(-7)

# Active Directory Task Starts

Write-Host "Getting users created within a week."
$ADuserInWeek = Get-ADUser -Filter * -Properties * | Where-Object { $_.whenCreated -ge $week } | Select-Object Name, whenCreated
Write-Host "Getting users those password are Never expirpes"
$passNeverExpire = Get-ADUser -Filter * -Properties PasswordNeverExpires | Where-Object { $_.PasswordNeverExpires -eq $true } | Select-Object Name | Sort-Object
Write-Host "getting Computer Accounts"
$inAcComp = Get-ADComputer -Filter "Enabled -eq '$false'" | Select-Object Name
Write-Host "getting inactive User accounts"
$inacUser = Get-ADUser -Filter "Enabled -eq '$false'" | Select-Object Name


# Create a Excel Workspace
$excel = New-Object -ComObject Excel.Application

# make excel visible
$excel.visible = $true

# add a new blank worksheet
$workbook = $excel.Workbooks.add()

# Adding Sheets
$s1 = $workbook.sheets | Where-Object { $_.name -eq 'Sheet1' }
$s1.Delete()



# Sheet 2
# Find All Users those are created with in a Week
$s2 = $workbook.sheets | Where-Object { $_.name -eq 'Sheet2' }
$s2.name = "User Created in week"

#  Add information ot sheet 2
$cells = $s2.Cells
$s2.range("C1:C1").font.bold = "true"
$s2.range("C1:C1").font.size = 18
$s2.range("C1:C1").cells = "List of Active Directory User Account those are created with-in one Week."
$s2.range("A3:A3").cells = "Name"
$s2.range("A3:A3").font.bold = "true"
$s2.range("B3:B3").cells = "When Created"
$s2.range("B3:B3").font.bold = "true"

$row = 3
$col1 = 1
$col2 = 2
Foreach ($user in $ADuserInWeek ) {
	$row++
	$col1 = 1
	$col2 = 2
	$cells.item($Row, $col1) = $user.Name
	$col1++
	$cells.item($Row, $col2) = $user.whenCreated
	$col2++

}
$s2.range("A3:b3").EntireColumn.autofit() | out-Null

#Sheet 3 Users with Password Never Expire Set
$s3 = $workbook.sheets | Where-Object { $_.name -eq 'Sheet3' }
$s3.name = "Pass Never Expire"

#  Add information ot sheet 2
$cells = $s3.Cells
$s3.range("C1:C1").font.bold = "true"
$s3.range("C1:C1").font.size = 18
$s3.range("C1:C1").cells = "List of Active Directory Users those Password are set to never expire.."
$s3.range("A3:A3").cells = "Name"
$s3.range("A3:A3").font.bold = "true"

$row1 = 3
$col3 = 1
Foreach ( $Passw in $passNeverExpire) {
	$row1++
	$col3 = 1
	$cells.item($Row1, $col3) = $Passw.Name
	$col3++
}
$s3.range("A3:A3").EntireColumn.autofit() | out-Null

### Adding Sheet 4
$s4 = $workbook.Sheets.add()
$s4.name = "Inactive Computers"
$cells = $s4.Cells
$s4.range("C1:C1").font.bold = "true"
$s4.range("C1:C1").font.size = 18
$s4.range("C1:C1").cells = "List of Inactive Computer Acccounts"
$s4.range("A3:A3").cells = "Name"
$s4.range("A3:A3").font.bold = "true"

$row4 = 3
$col4 = 1
Foreach ( $Com in $inAcComp) {
	$row4++
	$col4 = 1
	$cells.item($Row4, $col4) = $Com.Name
	$col4++
}
$s4.range("A3:A3").EntireColumn.autofit() | out-Null

## Sheet 5
$s5 = $workbook.Sheets.add()
$s5.name = "inactive User"
$cells = $s5.Cells
$s5.range("C1:C1").font.bold = "true"
$s5.range("C1:C1").font.size = 18
$s5.range("C1:C1").cells = "List of Inactive User Acccounts"
$s5.range("A3:A3").cells = "Name"
$s5.range("A3:A3").font.bold = "true"
$row5 = 3
$col5 = 1
Foreach ( $Us in $inacUser) {
	$row5++
	$col5 = 1
	$cells.item($Row5, $col5) = $Us.Name
	$col5++
}
$s5.range("A3:A3").EntireColumn.autofit() | out-Null


# get sheet and update sheet name
$s6 = $workbook.Sheets.add()
$s6.name = "Report Information"

# Put user information on Sheet - 1
$s6.range("D7:D7").cells = "Title:"
$s6.range("D7:D7").font.bold = "true"
$s6.range("E7:E7").cells = "Active Directory Report"
$s6.range("D8:D8").font.bold = "true"
$s6.range("D8:D8").cells = "Generated By:"
$s6.range("E8:E8").cells = "$env:username"
$s6.range("D9:D9").font.bold = "true"
$s6.range("D9:D9").cells = "Generated Date:"
$s6.range("E9:E9").cells = $date
$s6.range("D7:D9").EntireColumn.autofit() | out-Null
#Saving File
"`n"
write-Host "Saving file in $env:userprofile\desktop"
$workbook.SaveAs("$env:userprofile\desktop\ActiveDirectoryReport.xlsx")

## End of the script...

############################################# a m a n   D |
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/Ad_Report_Generator_Community.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Ad_Report_Generator_Community.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
