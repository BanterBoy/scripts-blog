---
layout: post
title: Invoke-PasswordifyPhrase.ps1
date: 2025-09-19
permalink: /_posts/UserAdminModule/Invoke-PasswordifyPhrase/
categories:
  - UserAdminModule
  - Security
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

Replaces characters in a supplied phrase to obscure the characters and adds the result to the clipboard.

#### Detailed Description

Replaces characters in a supplied phrase to obscure the characters and adds the result to the clipboard.

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Usage

**Example 1**

```powershell
Invoke-PasswordifyPhrase "SecureMyPassphraseAndMakeItAwesome"
```

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Notes

Author:     Rob Green

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Script

{% raw %}
```powershell
function Invoke-PasswordifyPhrase {
    <#
	.SYNOPSIS
		Replaces characters in a supplied phrase to obscure the characters and adds the result to the clipboard.
	
	.DESCRIPTION
		Replaces characters in a supplied phrase to obscure the characters and adds the result to the clipboard.
	
	.PARAMETER Phrase
		Phrase to passwordify.
	
	.PARAMETER AllowNumericToAlphaConversion
		If supplied then any numeric characters defined in the conversion table can be converted to alpha characters.
	
	.PARAMETER DisallowAlphaCaseChange
		If supplied then alpha characters casing can not be changed.
	
	.PARAMETER DisallowConversionToSpecialCharacters
		If supplied then any characters defined in the conversion table can not be converted to special characters if available.
	
	.PARAMETER SpecialCharactersAllowed
		If supplied then only special characters within this array will be used as replacements.
	
	.PARAMETER NoClipboard
		If supplied the output will not be written to the clipboard
	
	.EXAMPLE
		Invoke-PasswordifyPhrase "SecureMyPassphraseAndMakeItAwesome"
	
	.OUTPUTS
		System.String. Phrase, passwordified :)
	
	.NOTES
		Author:     Rob Green
	
	.INPUTS
		You can pipe objects to these perameters.
		
		- Phrase [string]
    #>
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Phrase to passwordify.")]
		[string]$Phrase,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then any numeric characters defined in the conversion table can be converted to alpha characters.")]
		[switch]$AllowNumericToAlphaConversion,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then alpha characters casing can not be changed.")]
		[switch]$DisallowAlphaCaseChange,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then any characters defined in the conversion table can not be converted to special characters if available.")]
		[switch]$DisallowConversionToSpecialCharacters,

		[Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If supplied then only special characters within this array will be used as replacements.")]
		[string[]]$SpecialCharactersAllowed = $null,

		[Parameter(Mandatory = $false, HelpMessage="If supplied the output will not be written to the clipboard")]
		[switch]$NoClipboard
	)

    function RandChar {
        param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Phrase to passwordify.")]
            [string]$Char
        )

        $allowed = @()
    
        if ($hashTable.ContainsKey($Char)) {
            foreach ($c in $hashTable[$Char]) {
                if (($DisallowConversionToSpecialCharacters.IsPresent) -and (-not ($c -match "[a-zA-Z0-9]"))) {
                    continue
                }

                if (($null -ne $SpecialCharactersAllowed) -and (-not ($c -match "[a-zA-Z0-9]") -and (-not ($SpecialCharactersAllowed -contains $c)))) {
                    continue
                }

                if (($DisallowAlphaCaseChange.IsPresent) -and ((($c -match "[a-z]") -and ($Char -match "[A-Z]")) -or (($c -match "[A-Z]") -and ($Char -match "[a-z]")))) {
                    continue
                }

                $allowed += $c
            }

            if ($null -ne $allowed -and $allowed.length -gt 0) {
                return get-random $allowed
            }
        }
    
        return $Char
    }

    $hashTable = New-Object System.Collections.HashTable
    $hashTable.b = @("b", "B", "8")
    $hashTable.B = @("b", "B", "8")
    $hashTable.e = @("e", "E", "3")
    $hashTable.E = @("e", "E", "3")
    $hashTable.i = @("i", "I", "1", "|", "!")
    $hashTable.I = @("i", "I", "1", "|", "!")
    $hashTable.l = @("l", "L", "1", "|", "!")
    $hashTable.L = @("l", "L", "1", "|", "!")
    $hashTable.o = @("o", "O", "0")
    $hashTable.O = @("o", "O", "0")
    $hashTable.s = @("s", "S", "5", "$")
    $hashTable.S = @("s", "S", "5", "$")
    $hashTable.t = @("t", "T", "7")
    $hashTable.T = @("t", "T", "7")

    if ($AllowNumericToAlphaConversion.IsPresent) {
        $hashTable.0 = @("o", "O", "0")
        $hashTable.1 = @("L", "l", "i", "I", "|", "!")
        $hashTable.3 = @("e", "E", "3")
        $hashTable.5 = @("s", "S", "5", "$")
        $hashTable.7 = @("t", "T", "7")
        $hashTable.8 = @("b", "B", "8")
    }

    if (-not $DisallowAlphaCaseChange.IsPresent) {
        $lowerAlpha = "abcdefghijklmnopqrstuvwxyz"
        $upperAlpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        for ($i = 0; $i -lt $lowerAlpha.length; $i++) { 
            if (-not $hashTable.ContainsKey($lowerAlpha[$i])) {
                $hashTable.Add($lowerAlpha[$i], @($lowerAlpha[$i], $upperAlpha[$i]))
            }
        }

        for ($i = 0; $i -lt $upperAlpha.length; $i++) { 
            if (-not $hashTable.ContainsKey($upperAlpha[$i])) {
                $hashTable.Add($upperAlpha[$i], @($upperAlpha[$i], $lowerAlpha[$i]))
            }
        }
    }

	$passwordified = ''

    $char = for ($i = 0; $i -lt $phrase.length; $i++) { 
        $passwordified = "$passwordified$(RandChar -Char $phrase[$i])"
    }

    Write-Host $passwordified

    if (-Not $NoClipboard.IsPresent) {
        $passwordified | Set-Clipboard

        Write-Host("passwordified phrase copied to clipboard")
    }
}

# uncomment to test
# Invoke-PasswordifyPhrase "SecureMyPassphraseAndMakeItAwesome" -DisallowConversionToSpecialCharacters
```
{% endraw %}

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simply click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Security/Public/Invoke-PasswordifyPhrase.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Invoke-PasswordifyPhrase.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

