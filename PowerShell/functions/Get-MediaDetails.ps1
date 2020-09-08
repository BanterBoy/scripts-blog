# $TagLib = "S:\tag\Libraries\taglib-sharp.dll"
# [System.Reflection.Assembly]::LoadFile($TagLib)

Filter Get-MediaDetails {
    param($mediaItem)
    if ($mediaItem -eq $null) {$mediaItem = $_}

    0..($mediaItem.attributeCount - 1) |

    foreach -begin {
        $MediaObj = New-Object -TypeName System.Object
    } -process {
        $attributeName = $mediaItem.GetattributeName($_)
        if ($mediaItem.GetitemInfo($attributeName
            )) {
            Add-Member -inputObject $mediaObj -MemberType NoteProperty -Name $AttributeName -Value $mediaItem.GetitemInfo($attributeName)
        }
        -end {$MediaObj}
    }
}

