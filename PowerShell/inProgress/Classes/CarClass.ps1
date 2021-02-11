class Vehicle {
    [int] $Mileage;
    [void] Drive([int] $NumberOfMiles) {
        Write-Host -Object ( '{0} Miles Driven' -f $NumberOfMiles ) -ForegroundColor Red;
        $this.Mileage += $NumberOfMiles;
    }
}

class Car : Vehicle {
    [string] $Colour;
    [string] $Name
    [int] $Length;
    [int] $Width;
    [int] $Height;
    [string] $Manufacturer;
    [string] $Model;
    [void] Drive([int] $NumberOfMiles) {
        Write-Host -Object ( '{0} Miles Driven' -f $NumberOfMiles ) -ForegroundColor Green;
        $this.Mileage += $NumberOfMiles;
        ([Vehicle]$this).Drive($NumberOfMiles);
    }

    Car () {

    }

    Car ([string] $Name) {
        $this.Name = $Name;
    }

    Car ([int] $Mileage) {
        $this.Mileage += $Mileage;
    }

    Car ([string] $Name, [int] $Mileage) {
        $this.Name = $Name;
        $this.Mileage += $Mileage;
    }

}

$Car = [Car]::new();

$Car

$Car.Drive(10);

$Car.Mileage;
