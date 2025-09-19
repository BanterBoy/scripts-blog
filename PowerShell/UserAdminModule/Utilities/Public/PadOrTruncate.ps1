<#
.SYNOPSIS
    Pad or truncate a string to a specified length.

.DESCRIPTION
    This function takes a string and a length as input parameters. 
    - If the length of the string is less than or equal to the specified length, it pads the string with spaces (or a specified character) on the right side to make it equal to the specified length. 
    - If the length of the string is greater than the specified length, it truncates the string and appends "..." (or a specified truncation indicator) at the end.

.PARAMETER s
    The input string to be padded or truncated.

.PARAMETER length
    The desired length of the string.

.PARAMETER PaddingChar
    The character to use for padding the string. Defaults to a space.

.PARAMETER TruncationIndicator
    The string to use to indicate truncation. Defaults to "...".

.OUTPUTS
    System.String

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 15
    # Output: "Hello, world!  "

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 10
    # Output: "Hello, wo..."

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 20 -PaddingChar "-"
    # Output: "Hello, world!-------"

.EXAMPLE
    PadOrTruncate -s "Hello, world!" -length 10 -TruncationIndicator ">>>"
    # Output: "Hello, w>>>"

#>

function PadOrTruncate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$s,

		[Parameter(Mandatory = $true)]
		[ValidateRange(1, [int]::MaxValue)]
		[int]$length,

		[Parameter(Mandatory = $false)]
		[ValidateLength(1, 1)]
		[char]$PaddingChar = ' ',

		[Parameter(Mandatory = $false)]
		[string]$TruncationIndicator = '...'
	)

	begin {
		# Calculate the max length of the string before truncation indicator
		$maxLengthBeforeTruncation = $length - $TruncationIndicator.Length
	}

	process {
		if ($s.Length -le $length) {
			# Pad the string if it is shorter than or equal to the specified length
			$result = $s.PadRight($length, $PaddingChar)
		}
		else {
			# Truncate the string and append the truncation indicator if it is longer than the specified length
			$truncated = $s.Substring(0, $maxLengthBeforeTruncation)
			$result = "$truncated$TruncationIndicator"
		}

		# Output the result
		return $result
	}
}
