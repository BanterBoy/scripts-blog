---
layout: post
title: CreateADMXCentralStore.ps1
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_BanterBoy:_** Explain what the script does and why it is useful.

**_GitHub Copilot:_** This PowerShell script is designed to create a central store for ADMX files. The script starts by checking if the specified source server location exists. If it does not exist, the script will output an error message to the console.

After checking the source server location, the script proceeds to create the central store. It starts by creating a new folder with the name "PolicyDefinitions" in the specified destination location. Then, it copies all the ADMX files from the source server location to the newly created "PolicyDefinitions" folder.

Once the ADMX files have been copied, the script outputs a summary of the total number of ADMX files in the destination folder. It then proceeds to iterate through each language folder in the destination folder and outputs the total number of ADML files and ADML DLL files for each language.

Finally, the script outputs a message indicating that it has finished creating the central store.

To improve the readability of the code, the script could benefit from more descriptive variable names. Additionally, the script could be optimized for performance by using the pipeline to pass objects between commands instead of using variables.

**_BanterBoy:_** Can you provide examples for using the script

**_GitHub Copilot:_** Certainly! Here are a few examples of how you can use this PowerShell script:

Example 1: Create a central store on a local machine

```
.\CreateADMXCentralStore.ps1 -SourcePath "C:\Windows\PolicyDefinitions" -DestinationPath "C:\Windows\CentralStore"
```

This command will create a central store on the local machine by copying all the ADMX files from the "C:\Windows\PolicyDefinitions" folder to the newly created "C:\Windows\CentralStore\PolicyDefinitions" folder.

Example 2: Create a central store on a remote machine

```
Invoke-Command -ComputerName "Server01" -FilePath "C:\Scripts\CreateADMXCentralStore.ps1" -ArgumentList "C:\Windows\PolicyDefinitions", "\\Server02\CentralStore"
```

This command will create a central store on a remote machine named "Server02" by copying all the ADMX files from the "C:\Windows\PolicyDefinitions" folder on "Server01" to the newly created "\\Server02\CentralStore\PolicyDefinitions" folder.

Example 3: Create a central store with verbose output

```
.\CreateADMXCentralStore.ps1 -SourcePath "C:\Windows\PolicyDefinitions" -DestinationPath "C:\Windows\CentralStore" -Verbose
```

This command will create a central store on the local machine and provide verbose output to the console, including information about each ADMX file that is copied and the total number of ADML files and ADML DLL files for each language.

---

#### Information

This PowerShell script will create the ADMX Central Store for you by copying the ADMX files from several source locations, such as a master source on an Administrative share and/or several management servers, including IT Pro workstations.

The script has 3 variables which you will need to configure:-

- `$MasterReferenceLocation` – This is the location where you may store your ADMX master files, or 3rd party ADMX files. If you use a relative path, the script will prepend the script path to create an absolute path.
- `$languages` – This is an array of languages you use so that we copy across the relevant ADML files, such as “en-us” for example. Setting this to an \* (asterix) will copy the ADML files from ALL language folders.
- `$SourceServers` – This is an array of servers and workstations that you want to use to build the ADMX Central Store. They are typically the servers and workstations that contain the latest versions of ADMX files, as well as the customised and 3rd party ones you’re currently referencing in any GPOs.

---

#### OutPut

The screen shot below shows the output from the script running for the first time

<div>
<a href="/assets/images/functions/CreateADMXCentralStore-Script-Output.png" data-lightbox="CreateADMXCentralStore" data-title="CreateADMXCentralStore"><img src="/assets/images/tools/CreateADMXCentralStore-Script-Output.png" alt="CreateADMXCentralStore" width="828" height="800"/></a>
</div>

More information can be found on the owners website - [jhouseconsulting.com][5]{:target="\_blank"}

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

```powershell
<#
  This script will create your ADMX Central Store by using a master
  source and the local store on existing management servers.

  Script Name: CreateADMXCentralStore.ps1
  Release 1.3
  Modified by Jeremy@jhouseconsulting.com 23rd February 2014
  Written by Jeremy@jhouseconsulting.com 14th February 2014

  Notes:
  - I've found that some ADML files are more language generic.
    For Example: The OpsMgs (SCOM) HealthService.adml is located
      under the "EN" folder instead of the "en-us" folder.
  - I've found that some ADML files are accompanied by a dll.
    For Example: The OpsMgr (SCOM) HealthService.adml also has a
      HealthServiceADML.Dll.
    I've not been able to find any information on this, so have
    made sure this script copies across any existing dlls that
    accompany the ADML.

  ADMX Central Store references:
  - For further information refer to Managing Group Policy ADMX Files Step-by-Step Guide:
    http://msdn.microsoft.com/en-us/library/bb530196.aspx
  - How to create a Central Store for Group Policy Administrative Templates in Window Vista
    http://support.microsoft.com/kb/929841

  Compare-Object cmdlet limitations:
  - The output of the compare-object cmdlet may be incorrect if
    you're comparing collections of more than 11 elements. To
    address this issue we set the SyncWindow parameter to half the
    size of the smaller object.
    http://dmitrysotnikov.wordpress.com/2008/06/06/compare-object-gotcha/

  Copy-Item cmdlet limitations:
  - The Copy-Item cmdlet is quite limiting in its behavior. There
    is no "overwrite if newer", or "keep newest version" parameter.
    If the destination file exists, it will not be overwritten
    unless you use the -force paratemeter. So to work around this
    I've added a check to compare the lastwritetime property of
    the source and destination files to decide on which one is the
    newer file.

  Get-ChildItem cmdlet confusion:
  - The Include parameter is effective only when the command includes
    the "-recurse" parameter OR the path leads to the contents of a
    directory such as C:\Windows\*

#>

#-------------------------------------------------------------

# Set this to the location where your ADMX master files are kept.
# If you use a relative path, the script will prepend the script
# path to create an absolute path.
$MasterReferenceLocation = "ADMXCentralStore\Used"

# Set array to the language so that we copy across the relevant
# ADML files. Note that but setting this to an * (asterix), it
# will copy the ADML files from all language folders.
$languages = @("EN", "en-us")

# Set this to the servers that you want to use to build the ADMX
# Central Store. They are typically the servers that contain the
# latest versions of ADMX files, as well as the customised and
# 3rd party ones you're currently using in any GPOs.
$SourceServers = @("dc01", "ctx01", "adm01")

#-------------------------------------------------------------

# Get the current domain name
$FQDN = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().name

if (!($MasterReferenceLocation.Contains(':\')) -AND !($MasterReferenceLocation.Contains('\\'))) {
    $ScriptPath = (Split-Path -Path ((Get-Variable -Name MyInvocation).Value).MyCommand.Path)
    if (!($MasterReferenceLocation.StartsWith('\'))) {
        $MasterReferenceLocation = $ScriptPath + "\" + $MasterReferenceLocation
    }
    else {
        $MasterReferenceLocation = $ScriptPath + $MasterReferenceLocation
    }
}

# We can either prepend of append the $MasterReferenceLocation to the $SourceServers
# array. If we append it, we should then reverse the array so that it's processed first.
$SourceServers = , $MasterReferenceLocation + $SourceServers
#$SourceServers += $MasterReferenceLocation
#[array]::Reverse($SourceServers)

Write-Host -ForegroundColor green "`nCreating or adding to the ADMX Central Store..."

[string]$t = "\\$FQDN\SYSVOL\$FQDN\Policies\PolicyDefinitions"
if (-not(Test-Path -Path "$t")) {
    Write-Host -ForegroundColor green "`n`tCreating the '$t' folder..."
    New-Item -Path "$t" -ItemType Directory | out-Null
}
else {
    Write-Host -ForegroundColor yellow "`n`tThe '$t' folder already exists."
}

$target = Get-ChildItem $t | Where-Object { $_.psIsContainer -eq $false }

foreach ($SourceServer in $SourceServers ) {
    if ($SourceServer.Contains('\')) {
        [string]$s = $SourceServer
    }
    else {
        if ($SourceServer -ne ($env:computername)) {
            [string]$s = "\\" + $SourceServer + "\admin$\PolicyDefinitions"
        }
        else {
            [string]$s = "$($env:systemroot)\PolicyDefinitions"
        }
    }

    Write-Host -ForegroundColor green "`n`tProcessing source files from $SourceServer..."

    if (Test-Path -Path $s) {
        $source = Get-ChildItem $s | Where-Object { $_.psIsContainer -eq $false }
        if (($languages -eq "*") -OR ($languages -contains "*")) {
            $languages = @()
            $folders = Get-ChildItem $s | Where-Object { $_.psIsContainer -eq $true }
            foreach ($folder in $folders) {
                $languages += $folder.name
                if (-not(Test-Path -Path "$t\$($folder.name)")) {
                    Write-Host -ForegroundColor green "`t- Creating the '$t\$($folder.name)' folder..."
                    New-Item -Path "$t\$($folder.name)" -ItemType Directory | out-Null
                }
                else {
                    Write-Host -ForegroundColor yellow "`t- The '$t\$($folder.name)' folder already exists."
                }
            }
        }
        else {
            foreach ($language in $languages) {
                if (-not(Test-Path -Path "$t\$language")) {
                    Write-Host -ForegroundColor green "`t- Creating the '$t\$language' folder..."
                    New-Item -Path "$t\$language" -ItemType Directory | out-Null
                }
                else {
                    #Write-Host -ForegroundColor yellow "`t- The '$t\$language' folder already exists."
                }
            }
        }

        # Set the SyncWindow to half the size of the smaller object
        $TargetCount = ($target | Measure-object).Count
        $SourceCount = ($source | Measure-object).Count
        if ($TargetCount -le $SourceCount) {
            $SyncWindow = $TargetCount / 2
        }
        else {
            $SyncWindow = $SourceCount / 2
        }
        if ($SyncWindow -gt 5) {
            # Use the modulus operator to divide it by 2 to determine if it's an
            # odd or even number. An even number will not have a remainer of 0,
            # whilst an odd number has a remainder of 0.5, so we use the [int]
            # DataType to round it down to a A 32-bit signed whole number.
            if (($SyncWindow % 2) -ne 0) {
                $SyncWindow = [int]$SyncWindow
            }
        }
        else {
            $SyncWindow = 5
        }

        if ($TargetCount -eq 0) {
            # If there are no files in the target folder, the Compare-Object cmdlet
            # will fail with the following error:
            # Cannot bind argument to parameter 'DifferenceObject' because it is null.
            # To work around this issue we create a starter file, re-create the
            # target object and then delete the starter file. Now we have a difference
            # object that is not null.
            New-Item $t\StarterFile.txt -type file | Out-Null
            $target = Get-ChildItem $t | Where-Object { $_.psIsContainer -eq $false }
            Remove-Item $t\StarterFile.txt | Out-Null
        }

        $results = @(Compare-Object -ReferenceObject $source -DifferenceObject $target -SyncWindow $SyncWindow | Where-Object { $_.SideIndicator -eq '<=' } )
        if (($results | Measure-object).Count -ne 0) {
            Write-Host -ForegroundColor green "`t- Processing results from $SourceServer..."
            foreach ($result in $results) {
                if (!($result.InputObject.PSIsContainer)) {
                    #$SourceADMXFile = "$($result.InputObject.FullName)"
                    $SourceADMXFile = "$($result.InputObject.DirectoryName)\$($result.InputObject.BaseName).admx"
                    $ADMLFilePresent = $False
                    foreach ($language in $languages) {
                        $SourceADMLFile = "$($result.InputObject.DirectoryName)\$language\$($result.InputObject.BaseName).adml"
                        $SourceADMLLibraryFile = "$($result.InputObject.DirectoryName)\$language\$($result.InputObject.BaseName)ADML.dll"
                        if (Test-Path -Path $SourceADMLFile) {
                            $ADMLFilePresent = $True
                            $DestinationADMLFile = "$t\$language\$($result.InputObject.BaseName).adml"
                            $DestinationADMLLibraryFile = "$t\$language\$($result.InputObject.BaseName)ADML.dll"
                            if (Test-Path -Path $DestinationADMLFile) {
                                $SourceADMLFileTime = [datetime](Get-ItemProperty -Path $SourceADMLFile -Name LastWriteTime).lastwritetime
                                $DestinationADMLFileTime = [datetime](Get-ItemProperty -Path $DestinationADMLFile -Name LastWriteTime).lastwritetime
                                if ($SourceADMLFileTime -gt $DestinationADMLFileTime ) {
                                    Write-Host -ForegroundColor green "`t- Overwriting from source: $SourceADMLFile"
                                    Copy-Item "$SourceADMLFile" -destination "$t\$language" -force
                                }
                                else {
                                    Write-Host -ForegroundColor yellow "`t`t- Destination file is newer: $SourceADMLFile"
                                }
                            }
                            else {
                                Write-Host -ForegroundColor green "`t`t- Copying from source: $SourceADMLFile"
                                Copy-Item "$SourceADMLFile" -destination "$t\$language"
                            }
                            # Copy a matching ADML library file if present.
                            if ($ADMLFilePresent -AND (Test-Path -Path $SourceADMLLibraryFile)) {
                                if (Test-Path -Path $DestinationADMLLibraryFile) {
                                    $SourceADMLLibraryFileTime = [datetime](Get-ItemProperty -Path $SourceADMLLibraryFile -Name LastWriteTime).lastwritetime
                                    $DestinationADMLLibraryFileTime = [datetime](Get-ItemProperty -Path $DestinationADMLLibraryFile -Name LastWriteTime).lastwritetime
                                    if ($SourceADMLLibraryFileTime -gt $DestinationADMLLibraryFileTime ) {
                                        Write-Host -ForegroundColor green "`t- Overwriting from source: $SourceADMLLibraryFile"
                                        Copy-Item "$SourceADMLLibraryFile" -destination "$t\$language" -force
                                    }
                                    else {
                                        Write-Host -ForegroundColor yellow "`t`t- Destination file is newer: $SourceADMLLibraryFile"
                                    }
                                }
                                else {
                                    Write-Host -ForegroundColor green "`t`t- Copying from source: $SourceADMLLibraryFile"
                                    Copy-Item "$SourceADMLLibraryFile" -destination "$t\$language"
                                }
                            }
                        }
                    }
                    # Only copy the ADMX if an ADML is present.
                    if ($ADMLFilePresent) {
                        $DestinationADMXFile = "$t\$($result.InputObject.BaseName).admx"
                        if (Test-Path -Path $DestinationADMXFile) {
                            $SourceADMXFileTime = [datetime](Get-ItemProperty -Path $SourceADMXFile -Name LastWriteTime).lastwritetime
                            $DestinationADMXFileTime = [datetime](Get-ItemProperty -Path $DestinationADMXFile -Name LastWriteTime).lastwritetime
                            if ($SourceADMXFileTime -gt $DestinationADMXFileTime ) {
                                Write-Host -ForegroundColor green "`t`t- Overwriting from source: $SourceADMXFile"
                                Copy-Item "$SourceADMXFile" -destination "$t" -force
                            }
                            else {
                                Write-Host -ForegroundColor yellow "`t`t- Destination file is newer: $SourceADMXFile"
                            }
                        }
                        else {
                            Write-Host -ForegroundColor green "`t`t- Copying from source: $SourceADMXFile"
                            Copy-Item "$SourceADMXFile" -destination "$t"
                        }
                    }
                    else {
                        Write-Host -ForegroundColor yellow "`t- No matching ADML file was found for: $SourceADMXFile"
                    }
                }
            }
        }
        else {
            Write-Host -ForegroundColor yellow "`t- No files to be added from $SourceServer."
        }
    }
    else {
        Write-Host -ForegroundColor red "`t- The $SourceServer location does not exist."
    }
}

Write-Host -ForegroundColor green "`nSummary:"
$TotalADMX = (Get-ChildItem $t | Where-Object { $_.psIsContainer -eq $false } | Measure-object).Count
Write-Host -ForegroundColor green "- Total ADMX files in '$t': $TotalADMX"
$folders = Get-ChildItem $t | Where-Object { $_.psIsContainer -eq $true }
foreach ($folder in $folders) {
    $language = $folder.name
    $TotalADML = (Get-ChildItem "$t\$language\*" -include *.adml | Measure-object).Count
    if ($TotalADML -ne 0) {
        Write-Host -ForegroundColor green "- Total ADML files in '$t\$language': $TotalADML"
        $TotalADMLDLL = (Get-ChildItem "$t\$language\*" -include *adml.dll | Measure-object).Count
        if ($TotalADMLDLL -ne 0) {
            Write-Host -ForegroundColor green "- Total ADML dll files in '$t\$language': $TotalADMLDLL"
        }
    }
}

Write-Host -ForegroundColor green "`nFinished."
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

<small><i>CreateADMXCentralStore.ps1</i></small>

<button class="btn" type="submit" onclick="window.open('/PowerShell/tools/CreateADMXCentralStore.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=CreateADMXCentralStore.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/tools.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Tools
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
