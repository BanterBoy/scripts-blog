function Set-Title {
    [cmdletbinding()]
    param (
        [string]$Title
    )
    Import-Module $PSScriptRoot\taglib-sharp.dll
    $tag = [TagLib.File]::Create($_.fullname)
    $tag.Tag.Title = $(
        if ($title) {
            $title
        }
        else {
            $_.baseName
        })
    $tag.Save()
}
