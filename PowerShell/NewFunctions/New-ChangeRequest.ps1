<#
    Script to create a Change Request document using PowerShell Module PSWriteWord
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$FileName,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$FilePath,
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]$AreasImpacted,
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [string]$DateRaised = [datetime]::Now.ToString("dd-MM-yyyy"),
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [string]$StartDate = [datetime]::Now.ToString("dd-MM-yyyy HH:mm"),
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [string]$ChangeReason,
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [string]$ChangeDetails,
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [string]$RollBackPlan = "N/A",
    [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
    [string]$RiskMitigation = "N/A"
)

# Import Script Dependencies
Import-Module PSWriteWord
Import-Module ActiveDirectory

# Variables
$FullPath = $FilePath + "\" + $FileName + ".docx"
$UserName = (Get-ADUser -Identity $env:USERNAME).Name

# Define Word Document
$WordDocument = New-WordDocument $FullPath
Set-WordMargins -WordDocument $WordDocument -MarginLeft "40" -MarginRight "40" -MarginTop "40" -MarginBottom "40"

# Add content to Word Document
Add-WordText -WordDocument $WordDocument -Text "RDG CHANGE REQUEST FORM" -FontSize 12 -Bold:$true
Add-WordText -WordDocument $WordDocument -Text "NO CHANGE IS PERMITTED WITHOUT APPROVAL OF THIS REQUEST" -FontSize 12 -Bold:$true -Italic:$true
Add-WordText -WordDocument $WordDocument -Text "Kurtis Marsden - IT Manager" -FontSize 12 -Bold:$true -Italic:$true -SpacingAfter 20

Add-WordText -WordDocument $WordDocument -Text "Change Owner:" -FontSize 10 -Bold:$true
Add-WordText -WordDocument $WordDocument -Text "$UserName" -FontSize 10 -SpacingAfter 12
Add-WordText -WordDocument $WordDocument -Text "Date Raised:" -FontSize 10 -Bold:$true
Add-WordText -WordDocument $WordDocument -Text "$DateRaised" -FontSize 10 -SpacingAfter 12
Add-WordText -WordDocument $WordDocument -Text "Systems/Areas Impacted:" -FontSize 10 -Bold:$true
Add-WordText -WordDocument $WordDocument -Text "$AreasImpacted" -FontSize 10 -SpacingAfter 12
Add-WordText -WordDocument $WordDocument -Text "Date and Time of Production Changes:" -FontSize 10 -Bold:$true
Add-WordText -WordDocument $WordDocument -Text "$StartDate" -FontSize 10 -SpacingAfter 16

Add-WordText -WordDocument $WordDocument -Text "Reason for Change" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "$ChangeReason" -FontSize 10 -SpacingAfter 16

Add-WordText -WordDocument $WordDocument -Text "Details of changes by System/Area - Configuration, Development etc" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "$ChangeDetails" -FontSize 10 -SpacingAfter 16

Add-WordText -WordDocument $WordDocument -Text "Changes to be applied in production by:" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 12
Add-WordText -WordDocument $WordDocument -Text "$UserName" -FontSize 10 -SpacingAfter 16

Add-WordText -WordDocument $WordDocument -Text "Details of Support in place post implementation into Production" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "Infrastructure Team" -FontSize 10 -SpacingAfter 16

Add-WordText -WordDocument $WordDocument -Text "Back-Out Option" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "$RollBackPlan" -FontSize 10 -SpacingAfter 16

Add-WordText -WordDocument $WordDocument -Text "Risks and Mitigation" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "$RiskMitigation" -FontSize 10 -SpacingAfter 16

Add-WordText -WordDocument $WordDocument -Text "Any other relevant detail:" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 50

Add-WordText -WordDocument $WordDocument -Text "To be completed by Kurtis Marsden - IT Manager" -FontSize 11 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "Request No:" -FontSize 10 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "Approved/Rejected by:" -FontSize 10 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 6
Add-WordText -WordDocument $WordDocument -Text "Reason for Rejection:" -FontSize 10 -Bold:$true -UnderlineStyle singleLine -SpacingAfter 50

Add-WordText -WordDocument $WordDocument -Text "Date:" -FontSize 10 -Bold:$true -UnderlineStyle singleLine

# Save Microsoft Word Document
Save-WordDocument $WordDocument

# Open new file in Microsoft Word Application
# Invoke-Item $FilePath

<# Test
. .\GitRepos\Carpetright\Tools\New-ChangeRequest.ps1 -FileName "Something I am going to do to something" -AreasImpacted "Active Directory/DNS/So many Areas" -ChangeReason "Cos its all just a bit shit really. Nothing works properly and it all needs fixing." -ChangeDetails "Fixing all the things with awesomeness and probably some PowerShell goodness thrown in for good measure" -RollBackPlan "Why would I need one of these...so I can roll it back into the state?" -RiskMitigation "Mitigating the risk by fixing all of the things." -DateRaised ([datetime]::Now).ToString('dd/MM/yyyy') -StartDate (Get-Date).AddHours('12')
#>

<# Example
& C:\GitRepos\Carpetright\Tools\New-ChangeRequest.ps1 -FileName "Implement Active Directory Activation" -AreasImpacted "Active Directory/Windows 10 Store Computers" -ChangeReason "Implementing Active Directory Activation will allow us to decommission two servers and reduce the number of servers required to be migrated to AVS." -ChangeDetails "To configure Active Directory-based activation I will complete the following steps:`
`
Use an account with Domain Administrator and Enterprise Administrator credentials to sign into a domain controller.`
Launch Server Manager.`
Add the Volume Activation Services role.`
Launch the Volume Activation Tools.`
Select the Active Directory-Based Activation.`
Enter your KMS host key and display name.`
Activate the KMS host." -RollBackPlan "N/A" -RiskMitigation "N/A" -DateRaised ([datetime]::Now).ToString('dd/MM/yyyy') -StartDate (Get-Date).ToString("dd-MM-yyyy 12:00")
#>
