enum CarColours {
    Red
    Yellow
    Blue
    Green
    Brown
    Black
    White
    Orange
    Purple
    Pink
}

class Vehicle {
    [int] $Mileage;
    [void] Drive([int] $NumberOfMiles) {
        Write-Host -Object ( '{0} Miles Driven' -f $NumberOfMiles ) -ForegroundColor Red;
        $this.Mileage += $NumberOfMiles;
    }
}

class Car : Vehicle {
    [string] $Manufacturer
    [string] $Name
    [string] $Model
    [CarColours] $Colour
    [int] $Height
    [int] $Width
    [int] $Length
    [void] Drive([int] $NumberOfMiles) {
        Write-Host -Object ( '{0} Miles Driven' -f $NumberOfMiles ) -ForegroundColor Yellow;
        $this.Mileage += $NumberOfMiles
    }

    Car ([string] $Name) {
        $this.Name = $Name
    }

    Car ([int] $Mileage) {
        $this.Mileage += $Mileage
    }

    Car ([string] $Name, [string] $Manufacturer, [int] $Mileage) {
        $this.Name = $Name
        $this.Manufacturer = $Manufacturer
        $this.Mileage += $Mileage
    }

    Car ([string] $Manufacturer, [string] $Name, [string] $Model, [string] $Colour ) {
        $this.Manufacturer = $Manufacturer
        $this.Name = $Name
        $this.Model = $Model
        $this.Colour = $Colour
    }

    Car ([string] $Manufacturer, [string] $Name, [string] $Model, [string] $Colour, [string] $Height, [string] $Width, [string] $Length ) {
        $this.Manufacturer = $Manufacturer
        $this.Name = $Name
        $this.Model = $Model
        $this.Colour = $Colour
        $this.Height = $Height
        $this.Width = $Width
        $this.Length = $Length
    }
}

$LukeStart = New-TimeSpan -Start 28/08/1975
$LukeCar = [Car]::New('Luke', 'Ford Fiesta' ,"$($LukeStart.Days)")

$AlisonStart = New-TimeSpan -Start 25/04/1968
$AlisonCar = [Car]::New('Alison', 'Ford Focus' ,"$($AlisonStart.Days)")

$LukeCar
$AlisonCar
