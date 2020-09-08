$ADUserParams = @{
    'Server'      = 'remote.domain.com'
    'Searchbase'  = 'OU=users,DC=remote,DC=domain,DC=com'
    'Searchscope' = 'Subtree'
    'Filter'      = '*'
    'Properties'  = '*'
}

#This is where to change if different properties are required.

$SelectParams = @{
    'Property' = 'SAMAccountname','CN', 'title', 'DisplayName', 'Description', 'EmailAddress', 'mobilephone', @{name = 'businesscategory'; expression = {$_.businesscategory -join '; '}}, 'office', 'officephone', 'state', 'streetaddress', 'city', 'employeeID', 'Employeenumber', 'enabled', 'lockedout', 'lastlogondate', 'badpwdcount', 'passwordlastset', 'created'
}

Get-ADUser @ADUserParams | Select-Object @SelectParams  | Export-Csv "$HOME\desktop\users.csv"
