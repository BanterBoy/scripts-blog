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
