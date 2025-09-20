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
