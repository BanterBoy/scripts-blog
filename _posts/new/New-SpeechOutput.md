---
layout: post
title: Blank-Page.ps1
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

**_@GitHub Copilot_** - The code above is a PowerShell function called `New-SpeechOutput`. This function is designed to output a string as speech using the `System.Speech.Synthesis.SpeechSynthesizer` class.

The function has a single parameter called `$Output`, which is of type `String`. This parameter is not mandatory, but can be passed in either through the pipeline or as a positional parameter. If no value is passed in for `$Output`, the function will not output anything.

The function uses the `[CmdletBinding()]` attribute to specify that it supports positional binding, and that it can be used with the `ShouldProcess` parameter. The `ShouldProcess` parameter is used to confirm that the user wants to output the string as speech.

The `begin` and `end` blocks are empty, but the `process` block contains the logic for outputting the string as speech. If the `ShouldProcess` parameter is used and the user confirms that they want to output the string as speech, the function creates a new instance of the `SpeechSynthesizer` class and uses the `Speak` method to output the string as speech.

To improve the readability of this code, it could be helpful to add comments to explain the purpose of each block of code. Additionally, the parameter names could be made more descriptive to make it easier for users to understand what values they should be passing in. Finally, the function could be modified to handle errors more gracefully, such as by catching exceptions and providing more informative error messages.

**_@BanterBoy:_** - Explain how to use the script and provide examples.

**_@GitHub Copilot_** - Sure! Here's an example of how to use the `New-SpeechOutput` function:

```powershell
New-SpeechOutput -Output "Hello, world!"
```

This will output the string "Hello, world!" as speech. You can also pipe a string to the function like this:

```powershell
"Hello, world!" | New-SpeechOutput
```

This will have the same effect as the previous example. If you don't pass in a value for the `-Output` parameter, the function won't output anything.

---

#### Script

```powershell
function New-SpeechOutput {

    [CmdletBinding(DefaultParameterSetName = 'Default',
        PositionalBinding = $true,
        SupportsShouldProcess = $true)]
    [OutputType([string], ParameterSetName = 'Default')]
    [Alias('nso')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 1,
            HelpMessage = 'Enter the text you would like to output as speech.')]
        [Alias('op')]
        [String]$Output
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("$Output", "Outputing string as speech")) {
            [System.Speech.Synthesis.SpeechSynthesizer]::new().Speak("$Output")
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

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/Blank-Page.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Blank-Page.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
