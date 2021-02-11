class Address {
    [string]$Addressee
    [string]$StreetName
    [string]$PostTown
    [string]$Locality
    [string]$PostCode

    Address ([string]$Addressee, $StreetName, $PostTown, $Locality, $PostCode) {
        $this.Addressee = $Addressee
        $this.StreetName = $StreetName
        $this.PostTown = $PostTown
        $this.Locality = $Locality
        $this.PostCode = $PostCode
    }
}

$address
$address = [Address]::new('Luke Leigh', '63 Archer Avenue', 'Southend-on-Sea', 'Essex', 'SS2 4QU')
$address

