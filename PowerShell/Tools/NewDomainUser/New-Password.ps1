<#
API Usage

It is possible to pass settings into the generator to set the initial values of the complexity settings.

This is done simply by adding values into the URL.

For instance, if you wish to have the initial passwords be numbers only that is just numbers between 6 and 9 and you want to make it 8 characters long and create 5 of these passwords you can use this URL for those results.

https://passwordwolf.com/api/?length=10&upper=off&lower=off&special=off&exclude=012345&repeat=5

The output from this request is returned simply in JSON data.

If a value is omitted the default is used. The returned password will also be displayed phonetically.

Variable	Possible Values	Default	Description
upper	off	on	Turns the upper case characters on or off.
lower	off	on	Turns the lower case characters on or off.
numbers	off	on	Turns numbers on or off.
special	off	on	Turns special characters on or off.
length	1-128	15	Set the password length.
exclude	[string]	?!<>li1I0OB8`	Indicates which characters to exclude.
repeat	1-128	9	Indicates how many passwords to generate.

#>

function New-Password {
    [CmdletBinding()]
        $Alphas = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=8&upper=on&lower=on&numbers=off&special=off&repeat=1"
        $Special = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=1&upper=off&lower=off&numbers=off&special=on&exclude={}][<>~¬&repeat=1"
        $Numbers = Invoke-RestMethod -Uri "https://passwordwolf.com/api/?length=3&upper=off&lower=off&numbers=on&special=off&repeat=1"
        $password = $Alphas.password + $Special.password + $Numbers.password
        $password
    }

# $upper
# $lower
# $numbers
# $special
# $length
# [string]$exclude		?!<>li1I0OB8`	Indicates which characters to exclude.
# repeat	1-128	9	Indicates how many passwords to generate.
