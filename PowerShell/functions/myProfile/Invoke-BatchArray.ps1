function Invoke-BatchArray {
    <#
    .SYNOPSIS
    Takes an array and breaks down into an array of arrays by a supplied batch size

    .EXAMPLE
    Invoke-BatchArray -Arr @(1,2,3,4,5,6,7,8,9) -BatchSize 5 | ForEach-Object { Write-Host $_ }
    #>
    param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Array to be batched.")]
		[object[]]$Arr,

		[Parameter(Mandatory = $false, HelpMessage = "Number of objects in each batch.")]
        [int]$BatchSize = 5
    )

    for ($i = 0; $i -lt $Arr.Count; $i += $BatchSize) {
        , ($Arr | Select-Object -Skip $i -First $BatchSize)
    }
}