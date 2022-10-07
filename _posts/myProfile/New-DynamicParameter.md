---
layout: post
title: New-DynamicParameter.ps1
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
function Set-Example {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateScript({ Test-Path -Path $_ })]
		[string]$Path,
		[Parameter(Mandatory)]
		[string]$Identity
	)
	DynamicParam {
		$ParamOptions = @(
		@{
			Name = 'Right'
			ParameterAttributes = @(
			@{
				Mandatory = $true
				# ParameterSetName = 'a'
				# Position = 0
				# ValueFromPipeline = $true
				# ValueFromPipelinyByPropertyName = $true
			}
			)
			ValidateSetOptions = ([System.Security.AccessControl.FileSystemRights]).DeclaredMembers | Where-Object { $_.IsStatic } | Select-Object -ExpandProperty name
		},
		@{
			Name = 'InheritanceFlags'
			ParameterAttributes = @(
			@{
				Mandatory = $true
			}
			)
			ValidateSetOptions = ([System.Security.AccessControl.InheritanceFlags]).DeclaredMembers | Where-Object { $_.IsStatic } | Select-Object -ExpandProperty name
		},
		@{
			Name = 'PropagationFlags'
			ParameterAttributes = @(
			@{
				Mandatory = $true
			}
			)
			ValidateSetOptions = ([System.Security.AccessControl.PropagationFlags]).DeclaredMembers | Where-Object { $_.IsStatic } | Select-Object -ExpandProperty name
		},
		@{
			Name = 'Type'
			ParameterAttributes = @(
			@{
				Mandatory = $true
			}
			)
			ValidateSetOptions = ([System.Security.AccessControl.AccessControlType]).DeclaredMembers | Where-Object { $_.IsStatic } | Select-Object -ExpandProperty name
		}
		)
		$RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
		foreach ($Param in $ParamOptions) {
			$RuntimeParam = New-DynamicParameter @Param
			$RuntimeParamDic.Add($Param.Name, $RuntimeParam)
		}

		return $RuntimeParamDic
	}

	begin {
		$PsBoundParameters.GetEnumerator() | ForEach-Object { New-Variable -Name $_.Key -Value $_.Value -ea 'SilentlyContinue' }
	}

	process {
		try {
			$Acl = Get-Acl $Path
			#$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule('Everyone', 'FullControl', 'ContainerInherit,ObjectInherit', 'NoPropagateInherit', 'Allow')
			$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($Identity, $Right, $InheritanceFlags, $PropagationFlags, $Type)
			$Acl.SetAccessRule($Ar)
			Set-Acl $Path $Acl
		} catch {
			Write-Error $_.Exception.Message
		}
	}
}

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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('https://scripts.lukeleigh.com/powershell/functions/myProfile/New-DynamicParameter.ps1')">
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

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/myProfile.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to myProfile
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
