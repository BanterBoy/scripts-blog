<#
.SYNOPSIS
Retrieves contact information for members of specified distribution groups.

.DESCRIPTION
The Get-ContactList function retrieves contact information for members of one or more distribution groups. It returns a list of properties for each member, including their group name, group description, group SamAccountName, group managed by, group primary SMTP address, member name, member SamAccountName, member display name, member title, member company, member manager, member identity, member primary SMTP address, member external email address, member Windows email address, and member recipient type details.

.PARAMETER GroupName
Specifies the name(s) of the distribution group(s) to export. This parameter is mandatory and can accept multiple values.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSObject. The function outputs a PSObject for each member of the specified distribution group(s), containing the properties described above.

.NOTES
- This function requires the Get-DistributionGroup and Get-DistributionGroupMember cmdlets.
- The function supports the Confirm and WhatIf parameters.
- For more information, visit the help URI: http://scripts.lukeleigh.com/

.EXAMPLE
Get-ContactList -GroupName "Group1", "Group2"
Retrieves contact information for members of "Group1" and "Group2" distribution groups.

.EXAMPLE
"Group1", "Group2" | Get-ContactList
Retrieves contact information for members of "Group1" and "Group2" distribution groups using pipeline input.

#>

function Get-ContactList {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        ConfirmImpact = 'Medium',
        SupportsShouldProcess = $true,
        HelpUri = 'http://scripts.lukeleigh.com/')]
    [OutputType([string], ParameterSetName = 'Default')]
    param
    (
        [Parameter(ParameterSetName = 'Default',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Enter the name/s of the Distribution Group/s to export.')]
        [string[]]$GroupName
    )

    begin {
    }

    process {
        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            $DistributionGroups = Get-DistributionGroup -Filter " Name -like '$GroupName' "  | Select-Object -Property Name, DisplayName, GroupType, PrimarySmtpAddress
            foreach ($DistributionGroup in $DistributionGroups) { 
                $Group = Get-DistributionGroup $($DistributionGroup.Name) | Select-Object -Property *
                $Members = Get-DistributionGroupMember -Identity $Group.Name
                foreach ($Member in $Members) {
                    try {
                        $properties = [ordered]@{
                            GroupName               = $Group.DisplayName
                            GroupDescription        = $Group.Description
                            GroupSamAccountName     = $Group.SamAccountName
                            GroupManagedBy          = $Group.ManagedBy
                            GroupPrimarySmtpAddress = $Group.PrimarySmtpAddress
                            MemberName              = $Member.Name
                            MemberSamAccountName    = $Member.SamAccountName
                            DisplayName             = $Member.DisplayName
                            Title                   = $Member.Title
                            Company                 = $Member.Company
                            Manager                 = $Member.Manager
                            Identity                = $Member.Identity
                            PrimarySmtpAddress      = $Member.PrimarySmtpAddress
                            ExternalEmailAddress    = $Member.ExternalEmailAddress
                            WindowsEmailAddress     = $Member.WindowsEmailAddress
                            RecipientTypeDetails    = $Member.RecipientTypeDetails
                        }
                    }
                    catch [System.Exception] {
                        Write-Error -Message $_
                    }
                    finally {
                        $obj = New-Object PSObject -Property $properties
                        Write-Output $obj
                    }
                }
            }
        }
    }

    end {
    }

}