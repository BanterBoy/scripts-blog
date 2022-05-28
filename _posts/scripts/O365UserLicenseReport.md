---
layout: post
title: O365UserLicenseReport.ps1
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
#Using this script administrator can identify all licensed users with their assigned licenses, services, and its status.
#Connect AzureAD from PowerShell
Connect-MsolService
#Set output file
$ExportCSV = ".\DetailedO365UserLicenseReport_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm` tt).ToString()).csv"
$ExportSimpleCSV = ".\SimpleO365UserLicenseReport_$((Get-Date -format yyyy-MMM-dd-ddd` hh-mm` tt).ToString()).csv"
#FriendlyName list for license plan and service
$FriendlyNameHash = Get-Content -Raw -Path .\LicenseFriendlyName.txt -ErrorAction Stop | ConvertFrom-StringData
$ServiceArray = Get-Content -Path .\ServiceFriendlyName.txt -ErrorAction Stop
#Hash table declaration
$Result = ""
$Results = @()
$output = ""
$outputs = @()
#Get licensed user
$LicensedUserCount = 0
Get-MsolUser -All | Where-Object { $_.islicensed -eq "true" } | Foreach-Object { #User loop
    $LicensedUserCount++
    $LicensePlanWithEnabledService = ""
    $FriendlyNameOfLicensePlanWithService = ""
    $upn = $_.userprincipalname
    Write-Progress -Activity "`n     Exported user count:$LicensedUserCount "`n"Currently Processing:$upn"
    #Get all asssigned SKU for current user
    $Skus = $_.licenses.accountSKUId
    $LicenseCount = $skus.count
    $count = 0
    #Loop through each SKUid
    foreach ($Sku in $Skus) {
        #License loop
        #Convert Skuid to friendly name
        $LicenseItem = $Sku -Split ":" | Select-Object -Last 1
        $EasyName = $FriendlyNameHash[$LicenseItem]
        if (!($EasyName))
        { $NamePrint = $LicenseItem }
        else
        { $NamePrint = $EasyName }
        #Get all services for current SKUId
        $Services = $_.licenses[$count].ServiceStatus
        if (($Count -gt 0) -and ($count -lt $LicenseCount)) {
            $LicensePlanWithEnabledService = $LicensePlanWithEnabledService + ","
            $FriendlyNameOfLicensePlanWithService = $FriendlyNameOfLicensePlanWithService + ","
        }
        $DisabledServiceCount = 0
        $serviceExceptDisabled = ""
        $FriendlyNameOfServiceExceptDisabled = ""
        foreach ($Service in $Services) {
            #Service loop
            $flag = 0
            $ServiceName = $Service.ServicePlan.ServiceName
            if ($service.ProvisioningStatus -eq "Disabled") {
                $DisabledServiceCount++
            }
            else {
                $serviceExceptDisabled = $serviceExceptDisabled + $ServiceName + ","
                $flag = 1
            }
            #Convert ServiceName to friendly name
            for ($i = 0; $i -lt $ServiceArray.length; $i += 2) {
                $ServiceFriendlyName = $ServiceName
                $Condition = $ServiceName -Match $ServiceArray[$i]
                if ($Condition -eq "True") {
                    $ServiceFriendlyName = $ServiceArray[$i + 1]
                    break
                }
            }
            if ($flag -eq 1)
            { $FriendlyNameOfServiceExceptDisabled = $FriendlyNameOfServiceExceptDisabled + $ServiceFriendlyName + "," }
            #Store Service and its status in Hash table
            $Result = @{'DisplayName' = $_.Displayname; 'UserPrinciPalName' = $upn; 'LicensePlan' = $Licenseitem; 'FriendlyNameofLicensePlan' = $nameprint; 'ServiceName' = $service.ServicePlan.ServiceName;
                'FriendlyNameofServiceName' = $serviceFriendlyName; 'ProvisioningStatus' = $service.ProvisioningStatus
            }
            $Results = New-Object PSObject -Property $Result
            $Results | select-object DisplayName, UserPrinciPalName, LicensePlan, FriendlyNameofLicensePlan, ServiceName, FriendlyNameofServiceName,
            ProvisioningStatus | Export-Csv -Path $ExportCSV -Notype -Append
        }
        if ($Disabledservicecount -eq 0) {
            $serviceExceptDisabled = "All services"
            $FriendlyNameOfServiceExceptDisabled = "All services"
        }
        $LicensePlanWithEnabledService = $LicensePlanWithEnabledService + $Licenseitem + "[" + $serviceExceptDisabled + "]"
        $FriendlyNameOfLicensePlanWithService = $FriendlyNameOfLicensePlanWithService + $NamePrint + "[" + $FriendlyNameOfServiceExceptDisabled + "]"
        #Increment SKUid count
        $count++
    }
    $Output = @{'Displayname' = $_.Displayname; 'UserPrincipalName' = $upn;
        'FriendlyNameOfLicensePlanWithService' = $FriendlyNameOfLicensePlanWithService
    }
    $Outputs = New-Object PSObject -Property $output
    $Outputs | Select-Object Displayname, userprincipalname, FriendlyNameOfLicensePlanWithService | Export-Csv -path $ExportSimpleCSV -NoTypeInformation -Append
}
#Open output file after execution
Write-Host Detailed report available in: $ExportCSV
Write-host Simple report available in: $ExportSimpleCSV
$Prompt = New-Object -ComObject wscript.shell
$UserInput = $Prompt.popup("Do you want to open output files?", `
        0, "Open Files", 4)
If ($UserInput -eq 6) {
    Invoke-Item "$ExportCSV"
    Invoke-Item "$ExportSimpleCSV"
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/information/O365UserLicenseReport.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=O365UserLicenseReport.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
