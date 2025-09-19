<#
.SYNOPSIS
    Retrieves drive space information for one or more computers.

.DESCRIPTION
    The Get-DriveSpaceReport function retrieves drive space information for one or more computers. It calculates the free space percentage for each fixed disk and determines the status based on predefined thresholds. The function returns a report containing the computer name, drive letter, drive name, total space, free space, free space percentage, and status for each disk.

.PARAMETER ComputerName
    Specifies the name of the computer(s) for which to retrieve drive space information. You can specify multiple computer names separated by commas.

.EXAMPLE
    Get-DriveSpaceReport -ComputerName "Server01", "Server02"
    Retrieves drive space information for Server01 and Server02.

.OUTPUTS
    System.Object
    The function returns an array of objects, where each object represents a disk and contains the following properties:
    - Computer Name: The name of the computer.
    - Drive Letter: The drive letter of the disk.
    - Drive Name: The volume name of the disk.
    - Total Space (GB): The total space of the disk in gigabytes.
    - Free Space (GB): The free space of the disk in gigabytes.
    - Free Space (%): The free space percentage of the disk.
    - Status: The status of the disk (Normal, Warning, or Critical).

.NOTES
    Author: Your Name
    Date: Today's Date
#>

function Get-DriveSpaceReport {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $ComputerName
    )

    foreach ($computer in $ComputerName) {
        # Define thresholds in percentage
        $Critical = 20
        $Warning = 70

        # Get all Fixed Disk information
        $diskObj = Get-CimInstance -ClassName CIM_LogicalDisk -ComputerName $computer | Where-Object { $_.DriveType -eq 3 }

        # Initialize an empty array that will hold the final results
        $finalReport = @()

        # Iterate each disk information
        $diskObj.foreach(
            {
                # Calculate the free space percentage
                $percentFree = [int](($_.FreeSpace / $_.Size) * 100)

                # Determine the "Status"
                if ($percentFree -gt $Warning) {
                    $Status = 'Normal'
                }
                elseif ($percentFree -gt $Critical) {
                    $Status = 'Warning'
                }
                elseif ($percentFree -le $Critical) {
                    $Status = 'Critical'
                }

                # Compose the properties of the object to add to the report
                $tempObj = [ordered]@{
                    'Computer Name'    = $Computer
                    'Drive Letter'     = $_.DeviceID
                    'Drive Name'       = $_.VolumeName
                    'Total Space (GB)' = [int]($_.Size / 1gb)
                    'Free Space (GB)'  = [int]($_.FreeSpace / 1gb)
                    'Free Space (%)'   = "{0}{1}" -f [int]$percentFree, '%'
                    'Status'           = $Status
                }

                # Add the object to the final report
                $finalReport += New-Object psobject -property $tempObj
            }
        )

        return $finalReport

    }

}
