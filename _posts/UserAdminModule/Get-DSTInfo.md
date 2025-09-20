---
layout: post
title: Get-DSTInfo.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Get-DSTInfo/
categories:
  - UserAdminModule
  - Shell
---

- [Description](#description)
  - [Purpose](#purpose)
  - [Detailed Description](#detailed-description)
  - [Usage](#usage)
  - [Notes](#notes)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

#### Purpose

This function will check when a computer is scheduled for Daylight/Standard time changes.

#### Detailed Description

This function will check when a computer is scheduled for Daylight/Standard time changes. It uses the WMI Win32_TimeZone and Win32_LocalTime class to query the required information. It will return the actual time change dates or the current year.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Get-DSTInfo -ComputerName Server1
```

Computer          : SERVER1 CurrentTime       : 2/12/2012 7:17:53 PM DaylightName      : Eastern Daylight Time DaylightDay       : Second DaylightDayOfWeek : Sunday DaylightMonth     : March DaylightChgDate   : 3/11/2012 2:00:00 AM StandardName      : Eastern Standard Time StandardDay       : First StandardDayOfWeek : Sunday StandardMonth     : November StandardChgDate   : 11/4/2012 2:00:00 AM This example will query the DST and Standard Time information from Server1 and display it in the console.

**Example 2**

```powershell
Get-DSTInfo -ComputerName Server1 -Standard
```

Computer          : SERVER1 CurrentTime       : 2/12/2012 7:19:46 PM StandardName      : Eastern Standard Time StandardDay       : First StandardDayOfWeek : Sunday StandardMonth     : November StandardChgDate   : 11/4/2012 2:00:00 AM This example will query the Standard Time information from Server1 and display it in the console.

**Example 3**

```powershell
$Servers = "Server1", "Server2", "Server3"
```

$Servers | Get-DSTInfo | Export-Csv -Path C:\DSTInformation.csv This example creates a $Server array varible that contains three servers.  It is then piped to the Get-DSTInfo function which will collect the DST Information from the three servers.  It is then piped to the Export-Csv cmdlet to output the data in a csv file for later review.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:  Brian Wilhite Email:   bwilhite1@carolina.rr.com Date:    11/04/2011 Updated: 10/11/2012 Notes:   Updated the code where problems occurred with the "Last" DaylightDay or "Last" StandardDay to calculate the change date correctly.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
Function Get-DSTInfo {
    <#
.SYNOPSIS
	This function will check when a computer is scheduled for Daylight/Standard time changes.
.DESCRIPTION
	This function will check when a computer is scheduled for Daylight/Standard time changes.  
	It uses the WMI Win32_TimeZone and Win32_LocalTime class to query the required information.
	It will return the actual time change dates or the current year.
.PARAMETER ComputerName
	A single Computer or an array of computer names.  The default is localhost ($env:COMPUTERNAME).
.PARAMETER Daylight
	The Daylight parameter will only return the scheduled DST Information.
.PARAMETER Standard
	The Standard parameter will only return the scheduled Standard Time Information.
.EXAMPLE
	Get-DSTInfo -ComputerName Server1

	Computer          : SERVER1
	CurrentTime       : 2/12/2012 7:17:53 PM
	DaylightName      : Eastern Daylight Time
	DaylightDay       : Second
	DaylightDayOfWeek : Sunday
	DaylightMonth     : March
	DaylightChgDate   : 3/11/2012 2:00:00 AM
	StandardName      : Eastern Standard Time
	StandardDay       : First
	StandardDayOfWeek : Sunday
	StandardMonth     : November
	StandardChgDate   : 11/4/2012 2:00:00 AM

	This example will query the DST and Standard Time information from Server1 and 
	display it in the console.
.EXAMPLE
	Get-DSTInfo -ComputerName Server1 -Standard

	Computer          : SERVER1
	CurrentTime       : 2/12/2012 7:19:46 PM
	StandardName      : Eastern Standard Time
	StandardDay       : First
	StandardDayOfWeek : Sunday
	StandardMonth     : November
	StandardChgDate   : 11/4/2012 2:00:00 AM

	This example will query the Standard Time information from Server1 and display it in 
	the console.
.EXAMPLE
	$Servers = "Server1", "Server2", "Server3"
	$Servers | Get-DSTInfo | Export-Csv -Path C:\DSTInformation.csv

	This example creates a $Server array varible that contains three servers.  It is then
	piped to the Get-DSTInfo function which will collect the DST Information from the three
	servers.  It is then piped to the Export-Csv cmdlet to output the data in a csv file
	for later review.
.LINK
	Win32_TimeZone Link:
	http://msdn.microsoft.com/en-us/library/windows/desktop/aa394498(v=vs.85).aspx
	Win32_LocalTime Link:
	http://msdn.microsoft.com/en-us/library/windows/desktop/aa394171(v=vs.85).aspx
.NOTES
    Author:  Brian Wilhite
    Email:   bwilhite1@carolina.rr.com
    Date:    11/04/2011
    Updated: 10/11/2012
    Notes:   Updated the code where problems occurred with the "Last" DaylightDay or "Last"
             StandardDay to calculate the change date correctly.
#>

    [CmdletBinding(DefaultParametersetName = "DL")]
    param(
        [parameter(Position = 0, ValueFromPipeLine = $true)]
        [alias("CN", "Computer")]
        [String[]]$ComputerName = "$env:COMPUTERNAME",
 
        [Parameter(ParameterSetName = "DL")] 
        [Switch]$Daylight,
 
        [Parameter(ParameterSetName = "STND")]
        [Switch]$Standard
    )
    Begin {
        #Adjusting ErrorActionPreference to stop on all errors
        $TempErrAct = $ErrorActionPreference
        $ErrorActionPreference = "Stop"
        #Getting The Current Year
        $CurrentYear = (Get-Date).Year
    }#End Begin Script Block

    Process {
        Foreach ($Computer in $ComputerName) {
            #Making ComputerName UPPER CASE and removing trailing empty spaces.
            $Computer = $Computer.ToUpper().Trim()
            Try {
                #Creating a DateTime Object from Win32_LocalTime from the supplied ComputerName
                $Win32LT = Get-WmiObject -Class Win32_LocalTime -ComputerName $Computer
                $Month = $Win32LT.Month
                $Day = $Win32LT.Day
                $Year = $Win32LT.Year
                $Hour = $Win32LT.Hour
                $Minute = $Win32LT.Minute
                $Second = $Win32LT.Second
                #Converting the Win32_LocalTime information in to a DateTime object.
                [Datetime]$LocalTime = "$Month/$Day/$Year $Hour`:$Minute`:$Second"
     
                #Gathering TimeZone Information From Win32_TimeZone
                $TimeZone = Get-WmiObject -Class Win32_TimeZone -ComputerName $Computer
                $DayTime = $TimeZone.DaylightName
                $STNDTime = $TimeZone.StandardName
                $DSTHour = $TimeZone.DaylightHour
                $STNDHour = $TimeZone.StandardHour
     
                #Using the Switch Statements to convert numeric values into more meaningful information.
                #This information can be found in the links provided in the Function's Help
                Switch ($TimeZone.DaylightDay) {
                    1 { $DSTDay = "First" }
                    2 { $DSTDay = "Second" }
                    3 { $DSTDay = "Third" }
                    4 { $DSTDay = "Fourth" }
                    5 { $DSTDay = "Last" }
                }#End Switch ($TimeZone.DaylightDay)      
                Switch ($TimeZone.DaylightDayOfWeek) {
                    0 { $DSTDoW = "Sunday" }
                    1 { $DSTDoW = "Monday" }
                    2 { $DSTDoW = "Tuesday" }
                    3 { $DSTDoW = "Wednesday" }
                    4 { $DSTDoW = "Thursday" }
                    5 { $DSTDoW = "Friday" }
                    6 { $DSTDoW = "Saturday" }
                }#End Switch ($TimeZone.DaylightDayOfWeek)      
                Switch ($TimeZone.DaylightMonth) {
                    1 { $DSTMonth = "January" }
                    2 { $DSTMonth = "February" }
                    3 { $DSTMonth = "March" }
                    4 { $DSTMonth = "April" }
                    5 { $DSTMonth = "May" }
                    6 { $DSTMonth = "June" }
                    7 { $DSTMonth = "July" }
                    8 { $DSTMonth = "August" }
                    9 { $DSTMonth = "September" }
                    10 { $DSTMonth = "October" }
                    11 { $DSTMonth = "November" }
                    12 { $DSTMonth = "December" }
                }#End Switch ($TimeZone.DaylightMonth)      
                Switch ($TimeZone.StandardDay) {
                    1 { $STNDDay = "First" }
                    2 { $STNDDay = "Second" }
                    3 { $STNDDay = "Third" }
                    4 { $STNDDay = "Fourth" }
                    5 { $STNDDay = "Last" }
                }#End Switch ($TimeZone.StandardDay)      
                Switch ($TimeZone.StandardDayOfWeek) {
                    0 { $STNDWeek = "Sunday" }
                    1 { $STNDWeek = "Monday" }
                    2 { $STNDWeek = "Tuesday" }
                    3 { $STNDWeek = "Wednesday" }
                    4 { $STNDWeek = "Thursday" }
                    5 { $STNDWeek = "Friday" }
                    6 { $STNDWeek = "Saturday" }
                }#End Switch ($TimeZone.StandardDayOfWeek)      
                Switch ($TimeZone.StandardMonth) {
                    1 { $STNDMonth = "January" }
                    2 { $STNDMonth = "February" }
                    3 { $STNDMonth = "March" }
                    4 { $STNDMonth = "April" }
                    5 { $STNDMonth = "May" }
                    6 { $STNDMonth = "June" }
                    7 { $STNDMonth = "July" }
                    8 { $STNDMonth = "August" }
                    9 { $STNDMonth = "September" }
                    10 { $STNDMonth = "October" }
                    11 { $STNDMonth = "November" }
                    12 { $STNDMonth = "December" }
                }#End Switch ($TimeZone.StandardMonth)
     
                #Calculating the actual DST/Standard time change date - Through loops.
                [DateTime]$DDate = "$DSTMonth 01, $CurrentYear $DSTHour`:00:00"
                [DateTime]$SDate = "$STNDMonth 01, $CurrentYear $STNDHour`:00:00"

                #DST Date Loop
                $i = 0
                While ($i -lt $TimeZone.DaylightDay) {
                    If ($DDate.DayOfWeek -eq $TimeZone.DaylightDayOfWeek) {
                        $i++
                        If ($i -eq $TimeZone.DaylightDay) {
                            $DFinalDate = $DDate
                        }#End If ($i -eq $TimeZone.DaylightDay)
                        Else {
                            $DDate = $DDate.AddDays(1)
                        }#End Else
                    }#End If ($DDate.DayOfWeek -eq $TimeZone.DaylightDayOfWeek)
                    Else {
                        $DDate = $DDate.AddDays(1)
                    }#End Else
                }#End While ($i -lt $TimeZone.DaylightDay)
     
                #Addressing the DayOfWeek Issue "Last" vs. "Forth" when there are only four of one day in a month
                If ($DFinalDate.Month -ne $TimeZone.DaylightMonth) {
                    $DFinalDate = $DFinalDate.AddDays(-7)
                }

                #Standard Date Loop
                $i = 0
                While ($i -lt $TimeZone.StandardDay) {
                    If ($SDate.DayOfWeek -eq $TimeZone.StandardDayOfWeek) {
                        $i++
                        If ($i -eq $TimeZone.StandardDay) {
                            $SFinalDate = $SDate
                        }#End If ($i -eq $TimeZone.StandardDay)
                        Else {
                            $SDate = $SDate.AddDays(1)
                        }#End Else
                    }#End If ($SDate.DayOfWeek -eq $TimeZone.StandardDayOfWeek)
                    Else {
                        $SDate = $SDate.AddDays(1)
                    }#End Else
                }#End While ($i -lt $TimeZone.StandardDay)
     
                #Addressing the DayOfWeek Issue "Last" vs. "Forth" when there are only four of one day in a month
                If ($SFinalDate.Month -ne $TimeZone.StandardMonth) {
                    $SFinalDate = $SFinalDate.AddDays(-7)
                }

                #Creating Daylight/Standard Object
                If ((-not $Standard) -and (-not $Daylight)) {
                    $DL_STND = New-Object PSObject -Property @{
                        Computer          = $Computer
                        CurrentTime       = $LocalTime
                        DaylightName      = $DayTime
                        DaylightDay       = $DSTDay
                        DaylightDayOfWeek = $DSTDoW
                        DaylightMonth     = $DSTMonth
                        DaylightChgDate   = $DFinalDate
                        StandardName      = $STNDTime
                        StandardDay       = $STNDDay
                        StandardDayOfWeek = $STNDWeek
                        StandardMonth     = $STNDMonth
                        StandardChgDate   = $SFinalDate
                    }#End $DL New-Object
                    $DL_STND = $DL_STND | Select-Object -Property Computer, CurrentTime, DaylightName, DaylightDay, DaylightDayOfWeek, DaylightMonth, DaylightChgDate, StandardName, StandardDay, StandardDayOfWeek, StandardMonth, StandardChgDate
                    $DL_STND
                }#End If ((-not $Standard) -and (-not $Daylight))
                #Creating Parameters so that there is a choice as to which information is returend
                If ($Daylight) {
                    #Creating Daylight Saving Time Object
                    $DL = New-Object PSObject -Property @{
                        Computer          = $Computer
                        CurrentTime       = $LocalTime
                        DaylightName      = $DayTime
                        DaylightDay       = $DSTDay
                        DaylightDayOfWeek = $DSTDoW
                        DaylightMonth     = $DSTMonth
                        DaylightChgDate   = $DFinalDate
                    }#End $DL New-Object
                    $DL = $DL | Select-Object -Property Computer, CurrentTime, DaylightName, DaylightDay, DaylightDayOfWeek, DaylightMonth, DaylightChgDate
                    $DL
                }#End of If ($Daylight)
                If ($Standard) {
                    #Creating Standard Time Object
                    $STND = New-Object PSObject -Property @{
                        Computer          = $Computer
                        CurrentTime       = $LocalTime
                        StandardName      = $STNDTime
                        StandardDay       = $STNDDay
                        StandardDayOfWeek = $STNDWeek
                        StandardMonth     = $STNDMonth
                        StandardChgDate   = $SFinalDate
                    }#End $DL New-Object PSObject
                    $STND = $STND | Select-Object -Property Computer, CurrentTime, StandardName, StandardDay, StandardDayOfWeek, StandardMonth, StandardChgDate
                    $STND
                }#End If ($Standard)
            }#End Try
    
            Catch {
                Write-Warning "$Computer threw an exception"
                $Error[0].Exception.Message
            }#End Catch
        }#End Foreach ($Computer in $ComputerName)
    }#End Process Script Block
 
    End {
        #Resetting ErrorActionPref
        $ErrorActionPreference = $TempErrAct
    }
}#End function Get-DSTInfo
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Shell/Public/Get-DSTInfo.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-DSTInfo.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

