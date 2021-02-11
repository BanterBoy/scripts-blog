enum Fruit {
    Apple
    Orange
    Pear
    # Squirrel
}

class Person {
    [void] Eat ([Fruit] $Food) {
        Write-Host -Object ('Person ate {0}' -f $Food ) -ForegroundColor Green;
    }
}

$Person = [Person]::new();

$Person.Eat('Squirrel')
