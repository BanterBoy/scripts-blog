function PadOrTruncate([string]$s, [int]$length) {
	if ($s.length -le $length) {
		return $s.PadRight($length, " ")
	}

	$truncated = $s.Substring(0, ($length - 3))

	return "$truncated..."
}