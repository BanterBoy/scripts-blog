<#
Script Name   : Get-NestedGroupMember.ps1
Author        : By Adam Bertram - 03/15/2016
Compiled from : https://redmondmag.com/articles/2016/03/15/nested-active-directory-group-memberships.aspx
Notes         : Find all members in the group specified
                If any member in that group is another group call this function again
                otherwise, output the non-group object
#>

function Get-NestedGroupMember {
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory)] 
        [string]
        $Group 
    )
  
    $members = Get-ADGroupMember -Identity $Group 
  
    foreach ($member in $members) {
  
        if ($member.objectClass -eq 'group') {
            Get-NestedGroupMember -Group $member.Name
        }

        else {
            $member.Name
        }
    }
}
