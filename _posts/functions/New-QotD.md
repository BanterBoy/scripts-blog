---
layout: post
title: New-QotD.ps1
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
<#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .INPUTS

    .OUTPUTS

    .NOTES
    Author:     Luke Leigh
    Website:    https://blog.lukeleigh.com/
    LinkedIn:   https://www.linkedin.com/in/lukeleigh/
    GitHub:     https://github.com/BanterBoy/
    GitHubGist: https://gist.github.com/BanterBoy

    .LINK
#>
function New-QotD {
    [CmdletBinding()]
    $Uri = @{
        "QuoteOfTheDay" = "http://quotes.rest/qod"
    }
    $QuoteOfTheDay = Invoke-RestMethod -Method GET -Uri $Uri.QuoteOfTheDay -Headers @{
        'Content-Type' = 'application/json'
    }
    foreach ( $item in $QuoteOfTheDay ) {
        try {
        $QuoteOfTheDayProperties = $item | Select-Object -Property *
            $QuoteOfTheDayProperties = @{
                Quote      = $QuoteOfTheDayProperties.contents.quotes.quote
                Length     = $QuoteOfTheDayProperties.contents.quotes.length
                Author     = $QuoteOfTheDayProperties.contents.quotes.author
                Tags       = $QuoteOfTheDayProperties.contents.quotes.tags
                Category   = $QuoteOfTheDayProperties.contents.quotes.category
                Date       = $QuoteOfTheDayProperties.contents.quotes.date
                Permalink  = $QuoteOfTheDayProperties.contents.quotes.permalink
                Title      = $QuoteOfTheDayProperties.contents.quotes.title
                Background = $QuoteOfTheDayProperties.contents.quotes.background
                Id         = $QuoteOfTheDayProperties.contents.quotes.id
            }
        }
        catch {
            $QuoteOfTheDayProperties = @{
                Quote      = $QuoteOfTheDayProperties.contents.quotes.quote
                Length     = $QuoteOfTheDayProperties.contents.quotes.length
                Author     = $QuoteOfTheDayProperties.contents.quotes.author
                Tags       = $QuoteOfTheDayProperties.contents.quotes.tags
                Category   = $QuoteOfTheDayProperties.contents.quotes.category
                Date       = $QuoteOfTheDayProperties.contents.quotes.date
                Permalink  = $QuoteOfTheDayProperties.contents.quotes.permalink
                Title      = $QuoteOfTheDayProperties.contents.quotes.title
                Background = $QuoteOfTheDayProperties.contents.quotes.background
                Id         = $QuoteOfTheDayProperties.contents.quotes.id
            }
        }
        finally {
            $obj = New-Object -TypeName PSObject -Property $QuoteOfTheDayProperties
            Write-Output $obj
        }
    }
}
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/functions/New-QotD.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=New-QotD.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/functions.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Functions
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
