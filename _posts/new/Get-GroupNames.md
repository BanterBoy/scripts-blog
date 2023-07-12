---
layout: post
title: Get-GroupNames.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell script that defines a function called `Get-GroupNames`. This function queries Active Directory and exports the details for the matching groups. The function takes one parameter called `GroupName`, which is the name of the group that you want to search for. This field supports wildcards.

The function is defined using the `CmdletBinding` attribute, which allows it to support common parameters like `-Verbose`, `-Debug`, and `-ErrorAction`. The `OutputType` attribute specifies that the function returns an object of type `[string]`. The `Alias` attribute provides an alternate name for the function, which is `ggm`.

The `begin`, `process`, and `end` blocks are used to define the different stages of the function. The `process` block is where the main logic of the function is defined. It checks if the `ShouldProcess` method returns true, which means that the function should extract members of the group. If it does, the function calls the `Get-ADGroup` cmdlet to retrieve the group details. The `-Filter` parameter is used to filter the groups based on the `GroupName` parameter.

Overall, this function is a useful tool for querying Active Directory and extracting group details. It is well-structured and easy to use, with clear documentation and helpful parameter validation.

Possible ways to improve the code with respect to readability and performance include:

- Removing unnecessary comments and whitespace to make the code more concise
- Using more descriptive variable names to improve readability
- Using the `-Properties` parameter of `Get-ADGroup` to limit the amount of data returned, which can improve performance for large Active Directory environments.

**_@BanterBoy:_** - Can you provide examples for using the script

**_@GitHub Copilot_** - Sure! Here are some examples of how you can use the `Get-GroupNames` function:

1. To get a list of all groups in Active Directory, run the following command:

   ```
   Get-GroupNames
   ```

   This will return a list of all groups in Active Directory.

2. To get a list of groups that contain the word "Admins" in their name, run the following command:

   ```
   Get-GroupNames -GroupName "*Admins*"
   ```

   This will return a list of all groups in Active Directory that contain the word "Admins" in their name.

3. To get a list of groups that start with the word "Sales", run the following command:

   ```
   Get-GroupNames -GroupName "Sales*"
   ```

   This will return a list of all groups in Active Directory that start with the word "Sales" in their name.

4. To get a list of groups that end with the word "Managers", run the following command:

   ```
   Get-GroupNames -GroupName "*Managers"
   ```

   This will return a list of all groups in Active Directory that end with the word "Managers" in their name.

I hope these examples help you get started with using the `Get-GroupNames` function! Let me know if you have any other questions.

---

#### Script

```powershell
function Get-GroupNames {

    <#
	.SYNOPSIS
		Get-GroupNames

	.DESCRIPTION
		Get-GroupNames - This function will query Active Directory and export the details for the matching Groups.

	.PARAMETER GroupName
		Enter the group name that you want to search for. This field supports wildcards..

	.EXAMPLE
		Get-GroupNames -GroupName "*Admins*"
		Outputs a list of Active Directory Groups matching the search string.

	.OUTPUTS
		[Object]

	.NOTES
		General notes

	.INPUTS
		[string]GroupName
	#>

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('ggm')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the group name that you want to search for. This field supports wildcards.')]
        [Alias('gn')]
        [String]$GroupName
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("$GroupName", "Extract members of group")) {
            Get-ADGroup -Filter ' Name -like $GroupName ' -Properties *
        }
    }

    end {
    }

}

```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Get-GroupNames.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-GroupNames.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
