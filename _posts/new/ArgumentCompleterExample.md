---
layout: post
title: ArgumentCompleterExample.ps1
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

**_@GitHub Copilot_** - This PowerShell code defines a parameter called `$ComputerName` that is used to specify the Exchange Server to connect to. The parameter is marked as mandatory and accepts input from the pipeline or by property name. It also has an alias called `server`.

The `ArgumentCompleter` attribute is used to provide tab completion for the `$ComputerName` parameter. The attribute takes a script block that generates a list of possible values for the parameter. In this case, the script block first calls the `Get-ExchangeServerInSite` function to get a list of Exchange servers in the current site. It then randomly selects one or more servers from the list and returns their fully qualified domain names (FQDNs) as the possible values for the parameter.

This code is useful for simplifying the process of connecting to an Exchange Server by allowing the user to tab complete the server name instead of having to type it out manually. The use of the `ArgumentCompleter` attribute makes it easy to provide a list of valid server names to the user, which can help prevent errors and improve the user experience.

To improve the readability of the code, it could be helpful to add comments explaining what each section of the script block does. Additionally, the use of aliases can sometimes make code harder to read, so it may be beneficial to avoid using them in favor of more descriptive parameter names. Finally, if performance is a concern, it may be worth exploring ways to optimize the `Get-ExchangeServerInSite` function to reduce the time it takes to generate the list of servers.

**_@BanterBoy:_** -How can I use the `ArgumentCompleter` attribute in my PowerShell script?

**_@GitHub Copilot_** - You can use the `ArgumentCompleter` attribute in your PowerShell script to provide tab completion for a parameter. The attribute takes a script block that generates a list of possible values for the parameter.

Here's an example of how you can use the `ArgumentCompleter` attribute:

```powershell
[ArgumentCompleter( {
    # Generate a list of possible values for the parameter
    $possibleValues = @('Value1', 'Value2', 'Value3')
    foreach ($value in $possibleValues) {
        # Output each value to be used for tab completion
        $value
    }
})]
[string]$MyParameter
```

In this example, the `ArgumentCompleter` attribute is used to provide tab completion for the `$MyParameter` parameter. The script block generates a list of possible values for the parameter and outputs each value to be used for tab completion.

You can customize the script block to generate a list of possible values based on your specific requirements. For example, you could use the `Get-ChildItem` cmdlet to generate a list of files in a directory, or the `Get-Process` cmdlet to generate a list of running processes.

Once you've added the `ArgumentCompleter` attribute to your parameter, users can use tab completion to select a value for the parameter instead of having to type it out manually. This can help prevent errors and improve the user experience.

---

#### Script

```powershell
[Parameter(ParameterSetName = 'Default',
	Mandatory = $true,
	ValueFromPipeline = $true,
	ValueFromPipelineByPropertyName = $true,
	HelpMessage = 'Select the Exchange Server to connect to. This is a random server from the site you are in. If you want to connect to a specific server, you can tab complete the server name and cycle through the list of servers in your site. This is a mandatory parameter.')]
[ArgumentCompleter( {
		$Exchange = Get-ExchangeServerInSite
		$Servers = Get-Random -InputObject $Exchange -Shuffle:$true
		foreach ($Server in $Servers) {
			$Server.FQDN
		}
	}) ]
[Alias('server')]
[string]$ComputerName
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('PowerShell/NewFunctions/ArgumentCompleterExample.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ArgumentCompleterExample.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

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
