# ############################################################################# 
# NAME: FUNCTION-Get-LocalGroupMembership.ps1 
#  
# AUTHOR:  Francois-Xavier Cat 
# DATE:    2013/06/03
# EMAIL:   fxcat@lazywinadmin.com
# WEBSITE: LazyWinAdmin.com
# TWiTTER: @lazywinadm
#  
# COMMENT: This function get the local group membership on a local or remote  
#          machine using ADSI/WinNT. By default it will run on the localhost 
#          and check the group "Administrators".
# 
# VERSION HISTORY 
# 1.0 2012.12.27 Initial Version.
# 2.0 2013.06.03 Verbose,Error Handeling, Testing added.
#                ComputerName Parameter now accept multiple computers
#
# ############################################################################# 

Function Get-LocalGroupMembership {
<#
.Synopsis
    Get the local group membership.
             
.Description
    Get the local group membership.
             
.Parameter ComputerName
    Name of the Computer to get group members. Default is "localhost".
             
.Parameter GroupName
    Name of the GroupName to get members from. Default is "Administrators".
             
.Example
    Get-LocalGroupMembership
    Description
    -----------
    Get the Administrators group membership for the localhost
             
.Example
    Get-LocalGroupMembership -ComputerName SERVER01 -GroupName "Remote Desktop Users"
    Description
    -----------
    Get the membership for the the group "Remote Desktop Users" on the computer SERVER01
 
.Example
    Get-LocalGroupMembership -ComputerName SERVER01,SERVER02 -GroupName "Administrators"
    Description
    -----------
    Get the membership for the the group "Administrators" on the computers SERVER01 and SERVER02
 
.OUTPUTS
    PSCustomObject
             
.INPUTS
    Array
             
.Link
    N/A
         
.Notes
    NAME:      Get-LocalGroupMembership
    AUTHOR:    Francois-Xavier Cat
    WEBSITE:   www.LazyWinAdmin.com
#>
 
  
 [Cmdletbinding()]
 
 PARAM (
        [alias('DnsHostName','__SERVER','Computer','IPAddress')]
  [Parameter(ValueFromPipelineByPropertyName=$true,ValueFromPipeline=$true)]
  [string[]]$ComputerName = $env:COMPUTERNAME,
   
  [string]$GroupName = "Administrators"
 
  )
    BEGIN{
    }#BEGIN BLOCK
 
    PROCESS{
        foreach ($Computer in $ComputerName){
            TRY{
                $Everything_is_OK = $true
 
                # Testing the connection
                Write-Verbose -Message "$Computer - Testing connection..."
                Test-Connection -ComputerName $Computer -Count 1 -ErrorAction Stop |Out-Null
                      
                # Get the members for the group and computer specified
                Write-Verbose -Message "$Computer - Querying..."
             $Group = [ADSI]"WinNT://$Computer/$GroupName,group"
             $Members = @($group.psbase.Invoke("Members"))
            }#TRY
            CATCH{
                $Everything_is_OK = $false
                Write-Warning -Message "Something went wrong on $Computer"
                Write-Verbose -Message "Error on $Computer"
                }#Catch
         
            IF($Everything_is_OK){
             # Format the Output
                Write-Verbose -Message "$Computer - Formatting Data"
             $members | ForEach-Object {
              $name = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
              $class = $_.GetType().InvokeMember("Class", 'GetProperty', $null, $_, $null)
              $path = $_.GetType().InvokeMember("ADsPath", 'GetProperty', $null, $_, $null)
   
              # Find out if this is a local or domain object
              if ($path -like "*/$Computer/*"){
               $Type = "Local"
               }
              else {$Type = "Domain"
              }
 
              $Details = "" | Select-Object ComputerName,Account,Class,Group,Path,Type
              $Details.ComputerName = $Computer
              $Details.Account = $name
              $Details.Class = $class
                    $Details.Group = $GroupName
              $details.Path = $path
              $details.Type = $type
   
              # Show the Output
                    $Details
             }
            }#IF(Everything_is_OK)
        }#Foreach
    }#PROCESS BLOCK
 
    END{Write-Verbose -Message "Script Done"}#END BLOCK
}#Function Get-LocalGroupMembership
