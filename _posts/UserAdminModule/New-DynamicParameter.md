---
layout: post
title: New-DynamicParameter.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/security/new-dynamicparameter/
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

No synopsis provided.

#### Detailed Description

No detailed description provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

No usage examples provided.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

No additional notes.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
<!-- BEGIN: FUNCTION CODE -->
```powershell
function New-DynamicParameter
{
	[CmdletBinding()]
	[OutputType('System.Management.Automation.RuntimeDefinedParameter')]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[type]$Type = [string],
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[array]$ValidateSetOptions,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$ValidateNotNullOrEmpty,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateCount(2, 2)]
		[int[]]$ValidateRange,
		
		[Parameter()]
		[Array] $ParameterAttributes
	)
	
	$AttribColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
	Foreach ( $ParameterAttribute in $ParameterAttributes ) {
		$ParamAttrib = New-Object System.Management.Automation.ParameterAttribute

		$ParamAttrib.Mandatory = $ParameterAttribute.Mandatory
		If ( $ParameterAttribute.Position ) { $ParamAttrib.Position = $ParameterAttribute.Position }
		If ( $ParameterAttribute.ParameterSetName ) { $ParamAttrib.ParameterSetName = $ParameterAttribute.ParameterSetName }
		$ParamAttrib.ValueFromPipeline = $ParameterAttribute.ValueFromPipeline
		$ParamAttrib.ValueFromPipelineByPropertyName = $ParameterAttribute.ValueFromPipelineByPropertyName

		$AttribColl.Add( $ParamAttrib )
	}
	if ($PSBoundParameters.ContainsKey('ValidateSetOptions'))
	{
		$AttribColl.Add((New-Object System.Management.Automation.ValidateSetAttribute($ValidateSetOptions)))
	}
	if ($PSBoundParameters.ContainsKey('ValidateRange'))
	{
		$AttribColl.Add((New-Object System.Management.Automation.ValidateRangeAttribute($ValidateRange)))
	}
	if ($ValidateNotNullOrEmpty.IsPresent)
	{
		$AttribColl.Add((New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute))
	}
	
	$RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, $Type, $AttribColl)
	$RuntimeParam
	
}
```

<!-- END: FUNCTION CODE -->
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/New-DynamicParameter.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-DynamicParameter.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

