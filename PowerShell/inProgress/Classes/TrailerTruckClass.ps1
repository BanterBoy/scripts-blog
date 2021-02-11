enum TrailerType {
    Box
    Logging
    Custom
    FlatBed
}

class Truck {
    [TrailerType] $TypeOfTrailer
}

$NewTruck = [Truck]::new();

$NewTruck
