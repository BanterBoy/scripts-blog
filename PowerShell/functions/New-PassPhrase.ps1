$rand = new-object System.Random
$words = import-csv ".\words.csv"
$word1 = ($words[$rand.Next(0, $words.Count)]).Word
$word2 = ($words[$rand.Next(0, $words.Count)]).Word
$word3 = ($words[$rand.Next(0, $words.Count)]).Word
$Passphrase = $word1 + $word2 + $word3

while ($Passphrase.length -lt 12) {
    $word4 = ($words[$rand.Next(0, $words.Count)]).Word

    $Passphrase = $Passphrase + $word4

}
return $Passphrase
