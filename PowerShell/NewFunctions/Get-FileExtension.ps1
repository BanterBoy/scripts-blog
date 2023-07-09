function Get-Extension {

    class FileExtension {
        [string]$Extension
        [string]$Category

        FileExtension([string]$extension, [string]$category) {
            $this.Extension = $extension
            $this.Category = $category
        }
    }

    function Get-FileExtensions([string]$JsonData) {
        $data = ConvertFrom-Json $JsonData
        $fileExtensions = New-Object System.Collections.Generic.List[FileExtension]

        foreach ($category in $data.PSObject.Properties.Name) {
            foreach ($extension in $data.$category) {
                $fileExtension = [FileExtension]::new($extension, $category)
                $fileExtensions.Add($fileExtension)
            }
        }

        return $fileExtensions
    }

    $Extensions = Get-FileExtensions -JsonData (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/dyne/file-extension-list/master/pub/categories.json" -Method Get -UseBasicParsing | ConvertTo-Json)
    foreach ($Extension in $Extensions) {
        try {
            $properties = @{
                Extension = "*.$($Extension.Extension)"
                Category  = $Extension.Category
            }
            $Output = New-Object -TypeName psobject -Property $properties
        }
        catch {
            Write-Output -InputObject "This is some kind of bullshit"
        }
        finally {
            Write-Output -InputObject $Output
        }
    }

}

<#
$jsonData = Get-Content -Raw -Path C:\GitRepos\scripts-blog\PowerShell\NewFunctions\categories.json
$fileExtensions = Get-FileExtensions $jsonData

# Example usage: find the category for the 'zip' extension
$zipCategory = $fileExtensions | Where-Object { $_.Extension -eq 'zip' } | Select-Object -ExpandProperty Category
Write-Output "The category for the 'zip' extension is: $zipCategory"
#>
