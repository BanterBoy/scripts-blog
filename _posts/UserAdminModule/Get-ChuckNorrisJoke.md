---
layout: post
title: Get-ChuckNorrisJoke.ps1
date: 2025-09-19
last_modified_at: "2025-09-20 00:00:00"
permalink: /useradminmodule/utilities/get-chucknorrisjoke/
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

<!-- BEGIN: FUNCTION CODE -->
```powershell
#requires -PSEdition Desktop
function Get-ChuckNorrisJoke {
    <#
        .SYNOPSIS
        Retrieves a random Chuck Norris joke from the public Chuck Norris API.

        .DESCRIPTION
        The Get-ChuckNorrisJoke function queries the Chuck Norris API (https://api.chucknorris.io) and returns the
        details of a random joke. Use the ListCategories switch to retrieve the available joke categories or
        the Category parameter to request a joke from a specific category.

        .PARAMETER Category
        Optional category filter applied to the API request. Use -ListCategories to view available categories.

        .PARAMETER ListCategories
        Returns the available joke categories without requesting a joke.

        .EXAMPLE
        Get-ChuckNorrisJoke

        Retrieves a random joke and returns a custom object containing the joke text and metadata.

        .EXAMPLE
        Get-ChuckNorrisJoke -Category dev

        Retrieves a random joke from the "dev" category.

        .EXAMPLE
        Get-ChuckNorrisJoke -ListCategories

        Returns the available categories published by the API.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Random')]
    param(
        [Parameter(ParameterSetName = 'Random')]
        [ValidateNotNullOrEmpty()]
        [string]$Category,

        [Parameter(ParameterSetName = 'Categories')]
        [switch]$ListCategories
    )

    $baseUri = 'https://api.chucknorris.io/jokes'

    if ($PSCmdlet.ParameterSetName -eq 'Categories') {
        return Invoke-RestMethod -Uri "$baseUri/categories" -Method Get -ErrorAction Stop | Sort-Object
    }

    $uri = "$baseUri/random"
    if ($Category) {
        $uri = "$uri?category=$Category"
    }

    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
    }
    catch {
        throw "Failed to retrieve joke from API: $($_.Exception.Message)"
    }

    [PSCustomObject]@{
        Id         = $response.id
        Joke       = $response.value
        Url        = $response.url
        Categories = $response.categories
        CreatedAt  = if ($response.created_at) { Get-Date $response.created_at } else { $null }
        UpdatedAt  = if ($response.updated_at) { Get-Date $response.updated_at } else { $null }
    }
}
```

<!-- END: FUNCTION CODE -->

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/UserAdminModule/Utilities/Public/Get-ChuckNorrisJoke.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=Get-ChuckNorrisJoke.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#top"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/UserAdminModule.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to UserAdminModule
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
