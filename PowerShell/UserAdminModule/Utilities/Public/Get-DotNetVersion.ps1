function Get-DotNetVersion {
    <#
    .SYNOPSIS
    Get-DotNetVersion.ps1
    Retrieve .NET Framework version from one or more computers

    Michel de Rooij
    michel@eightwone.com

    THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE
    RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.

    Version 1.03, January 10th, 2018

    .DESCRIPTION
    Retrieve .NET Framework version from one or more computers.

    .LINK
    http://eightwone.com

    .NOTES

    Revision History
    --------------------------------------------------------------------------------
    1.0     Initial community release
    1.01    Added reporting on .NET Framework 4.6.1 and 4.7 blockades
    1.02    Added .NET Framework 4.7.1 support
            Changed reporting of blocked NET versions to single property
    1.03    Added .NET Framework 4.7.2 blockade check

    .PARAMETER ComputerName
    One or more computer names to retrieve .NET Framework version of. When omitted, the
    local computer is checked.

#>

    [cmdletbinding()]
    param(
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    # .NET Framework Versions
    $NETVERSION_45 = 378389
    $NETVERSION_451 = 378675
    $NETVERSION_452 = 379893
    $NETVERSION_452KB31467178 = 380035
    $NETVERSION_46 = 393295
    $NETVERSION_461 = 394254
    $NETVERSION_462 = 394748
    $NETVERSION_462WS2016 = 394802
    $NETVERSION_47 = 460798
    $NETVERSION_471 = 461308

    $NetVersionTags = @('452', '46', '461', '462', '47', '471', '472')

    Function Get-NetVersionText( $NetVersion = 0) {
        $NETversions = @{
            0 = 'Unknown';
            $NETVERSION_45 = '4.5'; $NETVERSION_451 = '4.5.1'; $NETVERSION_452 = '4.5.2'; $NETVERSION_452KB31467178 = '4.5.2 & KB3146717/3146718';
            $NETVERSION_46 = '4.6'; $NETVERSION_461 = '4.6.1'; $NETVERSION_462 = '4.6.2'; $NETVERSION_462WS2016 = '4.6.2 (WS2016)'; $NETVERSION_47 = '4.7';
            $NETVERSION_471 = '4.7.1'
        }
        return ($NetVersions.GetEnumerator() | Where-Object { $NetVersion -ge $_.Name } | Sort-Object Name -Descending | Select-Object -First 1).Value
    }

    Function Get-NETVersionBlockade {
        param(
            [string]$ComputerName,
            [string]$Key
        )
        $res = $false
        Try {
            $registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $ComputerName)
            Try {
                $registryKey = $registry.OpenSubKey('Software\Microsoft\NET Framework Setup\NDP\WU')
                If ( $registryKey.GetValue( $Key) -eq 1) {
                    $res = $true
                }
            }
            Catch {
                # Key doesn't exist
            }
        }
        Catch {
            Write-Warning ('Computer {0} is offline or unreachable: {1}' -f $ComputerName, $Error[0].Message)
        }
        return $res
    }

    Function Get-NETVersion {
        param(
            [string]$ComputerName
        )
        Try {
            $registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $ComputerName)
            Try {
                $registryKey = $registry.OpenSubKey('SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full')
                $NetVersion = $registryKey.GetValue( 'Release')
                $registry = $null
            }
            Catch {
                # Key not found
                $NetVersion = 0
            }
        }
        Catch {
            Write-Warning ('Computer {0} is offline or unreachable: {1}' -f $ComputerName, $Error[0].Message)
            $NetVersion = 0
        }
        return [int]$NetVersion
    }

    ForEach ( $Computer in $ComputerName) {
        If (Test-Connection -Quiet -Count 1 $Computer) {
            $NetVersion = Get-NETVersion $Computer
            If ( $NetVersion -gt 0) {
                $Blockade = @()
                $NetVersionTags | ForEach-Object { 
                    If ( Get-NETVersionBlockade $Computer ('BlockNetFramework{0}' -f $_)) { $Blockade += $_ } 
                }
                $Props = [ordered]@{
                    'Computer'     = $Computer
                    'Release'      = $NetVersion
                    'NetFramework' = Get-NetVersionText $NetVersion
                    'Blocked'      = $Blockade -Join ','
                }
                $Object = New-Object -Typename PSObject -Prop $Props
                $Object | Add-Member MemberSet PSStandardMembers $PSStandardMembers
                Write-Output $Object
            }
        }
        Else {
            Write-Warning ('Computer {0} is offline or unreachable: {1}' -f $ComputerName, $Error[0].Message)
        }
    }
}