do {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
        '1' {
            'You chose option #1'
        } '2' {
            'You chose option #2'
        } '3' {
            'You chose option #3'
        }
    }
    pause
}
until ($selection -eq 'q')
 