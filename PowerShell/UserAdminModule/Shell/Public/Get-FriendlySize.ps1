<#
.SYNOPSIS
Converts a given number of bytes to a human-readable format.

.DESCRIPTION
The Get-FriendlySize function takes a number of bytes and converts it to a human-readable format, such as KB, MB, GB, etc. It returns an object with the following properties:
- DecimalSize: The size in bytes, rounded to two decimal places.
- FriendlySize: The size in a human-readable format, with the number rounded to the specified number of decimal places (default is 2).
- SizeType: The unit of measurement used for the FriendlySize property.

.PARAMETER Bytes
The number of bytes to convert. This parameter is mandatory.

.PARAMETER DecimalPlaces
The number of decimal places to round the FriendlySize property to. This parameter is optional and defaults to 2.

.EXAMPLE
PS C:\> Get-FriendlySize -Bytes 1234567890 -DecimalPlaces 1

FriendlySize : 1.1 GB
SizeType     : GB

Converts 1234567890 bytes to a human-readable format with 1 decimal place.
#>
function Get-FriendlySize {

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[int64]$Bytes,
		[Parameter(Mandatory = $false)]
		[int]$DecimalPlaces = 2
	)

	$sizes = "Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB"

	$i = 0
	while ($Bytes -ge 1kb -and $i -lt $sizes.Count) {
		$Bytes /= 1kb
		$i++
	}

	$sizeType = $sizes[$i]
	$friendlySize = "{0:N$($DecimalPlaces)} $sizeType" -f $Bytes

	[PSCustomObject]@{
		FriendlySize = $friendlySize
		SizeType     = $sizeType
	}
}
