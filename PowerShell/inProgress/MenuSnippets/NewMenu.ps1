using namespace System.Management.Automation.Host

function New-Menu {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Question
    )
    
    $red = [ChoiceDescription]::new('&Red', 'Favourite colour: Red')
    $blue = [ChoiceDescription]::new('&Blue', 'Favourite colour: Blue')
    $yellow = [ChoiceDescription]::new('&Yellow', 'Favourite colour: Yellow')

    $options = [ChoiceDescription[]]($red, $blue, $yellow)

    $result = $host.ui.PromptForChoice($Title, $Question, $options, 0)

    switch ($result) {
        0 { 'Your favourite colour is Red' }
        1 { 'Your favourite colour is Blue' }
        2 { 'Your favourite colour is Yellow' }
    }

}
