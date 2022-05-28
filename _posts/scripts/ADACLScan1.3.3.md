---
layout: post
title: ADACLScan1.3.3.ps1
---

### something exciting

Some information about the exciting thing

- [something exciting](#something-exciting)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

---

#### Script

```powershell
#Generated Form Function
function GenerateForm {
    ################################################################################################
    # ADACLScan.ps1
    #
    # AUTHOR: Robin Granberg (robin.granberg@microsoft.com)
    #
    # THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
    # OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR
    # FITNESS FOR A PARTICULAR PURPOSE.
    #
    # This sample is not supported under any Microsoft standard support program or service.
    # The script is provided AS IS without warranty of any kind. Microsoft further disclaims all
    # implied warranties including, without limitation, any implied warranties of merchantability
    # or of fitness for a particular purpose. The entire risk arising out of the use or performance
    # of the sample and documentation remains with you. In no event shall Microsoft, its authors,
    # or anyone else involved in the creation, production, or delivery of the script be liable for
    # any damages whatsoever (including, without limitation, damages for loss of business profits,
    # business interruption, loss of business information, or other pecuniary loss) arising out of
    # the use of or inability to use the sample or documentation, even if Microsoft has been advised
    # of the possibility of such damages.
    ################################################################################################

    #region Import the Assemblies
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
    #endregion

    #region Generated Form Objects'
    $chkBoxTemplateNodes = New-Object System.Windows.Forms.CheckBox
    $gBoxReportOpt = New-Object System.Windows.Forms.GroupBox
    $gBoxScanDepth = New-Object System.Windows.Forms.GroupBox
    $gBoxEffectiveSelUser = New-Object System.Windows.Forms.GroupBox
    $lblSelectPrincipalDom = New-Object System.Windows.Forms.Label
    $lblEffectiveRightsColor = New-Object System.Windows.Forms.Label
    $lblEffectiveSelUser = New-Object System.Windows.Forms.Label
    $lblEffectiveDescText = New-Object System.Windows.Forms.Label
    $lblEffectiveText = New-Object System.Windows.Forms.Label
    $chkBoxEffectiveRights = New-Object System.Windows.Forms.CheckBox
    $chkBoxEffectiveRightsColor = New-Object System.Windows.Forms.CheckBox
    $chkBoxGetOUProtected = New-Object System.Windows.Forms.CheckBox
    $chkBoxGetOwner = New-Object System.Windows.Forms.CheckBox
    $chkBoxReplMeta = New-Object System.Windows.Forms.CheckBox
    $chkBoxACLSize = New-Object System.Windows.Forms.CheckBox
    $chkBoxType = New-Object System.Windows.Forms.CheckBox
    $chkBoxObject = New-Object System.Windows.Forms.CheckBox
    $chkBoxTrustee = New-Object System.Windows.Forms.CheckBox
    $lblStyleWin8_1 = New-Object System.Windows.Forms.Panel
    $lblStyleWin8_1 = New-Object System.Windows.Forms.Label
    $lblStyleWin8_2 = New-Object System.Windows.Forms.Label
    $lblStyleWin8_3 = New-Object System.Windows.Forms.Label
    $lblStyleWin8_4 = New-Object System.Windows.Forms.Label
    $lblStyleWin8_5 = New-Object System.Windows.Forms.Label
    $lblHeaderInfo = New-Object System.Windows.Forms.Label
    $lblRunScan	= New-Object System.Windows.Forms.Label
    $lblConnect	= New-Object System.Windows.Forms.Label
    $btnGETSPNReport = New-Object System.Windows.Forms.Button
    $btnGetSPAccount = New-Object System.Windows.Forms.Button
    $btnGetObjFullFilter = New-Object System.Windows.Forms.Button
    $btnViewLegend = New-Object System.Windows.Forms.Button
    $tabFilterTop = New-Object System.Windows.Forms.TabControl
    $tabFilter = New-Object System.Windows.Forms.TabPage
    $tabEffectiveR = New-Object System.Windows.Forms.TabPage
    $combObjectFilter = New-Object System.Windows.Forms.ComboBox
    $lblGetObj = New-Object System.Windows.Forms.Label
    $lblGetObjExtend = New-Object System.Windows.Forms.Label
    $lblAccessCtrl = New-Object System.Windows.Forms.Label
    $combAccessCtrl = New-Object System.Windows.Forms.ComboBox
    $lblFilterTrusteeExpl = New-Object System.Windows.Forms.Label
    $txtFilterTrustee = New-Object System.Windows.Forms.TextBox
    $chkBoxFilter = New-Object System.Windows.Forms.CheckBox
    $lblFilterExpl = New-Object System.Windows.Forms.Label
    $txtBoxSelectPrincipal = New-Object System.Windows.Forms.TextBox
    $textBoxResultView = New-Object System.Windows.Forms.TextBox
    $InitialFormWindowStatePop = New-Object System.Windows.Forms.FormWindowState
    $form1 = New-Object System.Windows.Forms.Form
    $txtTempFolder = New-Object System.Windows.Forms.TextBox
    $lblTempFolder = New-Object System.Windows.Forms.Label
    $txtCompareTemplate = New-Object System.Windows.Forms.TextBox
    $lblCompareTemplate = New-Object System.Windows.Forms.Label
    $lblSelectedNode = New-Object System.Windows.Forms.Label
    $lblStatusBar = New-Object System.Windows.Forms.Label
    $TextBoxStatusMessage = New-Object System.Windows.Forms.ListBox
    $lblDomain = New-Object System.Windows.Forms.Label
    $rdbCustomNC = New-Object System.Windows.Forms.RadioButton
    $rdbOneLevel = New-Object System.Windows.Forms.RadioButton
    $rdbSubtree = New-Object System.Windows.Forms.RadioButton
    $rdbDSdef = New-Object System.Windows.Forms.RadioButton
    $rdbDSConf = New-Object System.Windows.Forms.RadioButton
    $rdbDSSchm = New-Object System.Windows.Forms.RadioButton
    $btnDSConnect = New-Object System.Windows.Forms.Button
    $btnListDdomain = New-Object System.Windows.Forms.Button
    $btnListLocations = New-Object System.Windows.Forms.Button
    $gBoxRdbScan = New-Object System.Windows.Forms.GroupBox
    $gBoxRdbFile = New-Object System.Windows.Forms.GroupBox
    $tabScanTop = New-Object System.Windows.Forms.TabControl
    $tabScan = New-Object System.Windows.Forms.TabPage
    $tabOfflineScan = New-Object System.Windows.Forms.TabPage
    $txtCSVImport = New-Object System.Windows.Forms.TextBox
    $lblCSVImport = New-Object System.Windows.Forms.Label
    $rdbBase = New-Object System.Windows.Forms.RadioButton
    $chkInheritedPerm = New-Object System.Windows.Forms.CheckBox
    $chkBoxDefaultPerm = New-Object System.Windows.Forms.CheckBox
    $rdbScanOU = New-Object System.Windows.Forms.RadioButton
    $rdbScanContainer = New-Object System.Windows.Forms.RadioButton
    $rdbScanAll = New-Object System.Windows.Forms.RadioButton
    $rdbHTAandCSV = New-Object System.Windows.Forms.RadioButton
    $rdbOnlyHTA = New-Object System.Windows.Forms.RadioButton
    $rdbOnlyCSV = New-Object System.Windows.Forms.RadioButton
    $chkBoxExplicit = New-Object System.Windows.Forms.CheckBox
    $btnConfig = New-Object System.Windows.Forms.Button
    $txtBoxSelected = New-Object System.Windows.Forms.TextBox
    $txtBoxDomainConnect = New-Object System.Windows.Forms.TextBox
    $gBoxNCSelect = New-Object System.Windows.Forms.GroupBox
    $gBoxBrowse = New-Object System.Windows.Forms.GroupBox
    $rdbBrowseAll = New-Object System.Windows.Forms.RadioButton
    $rdbBrowseOU = New-Object System.Windows.Forms.RadioButton
    $btnScan = New-Object System.Windows.Forms.Button
    $btnCompare = New-Object System.Windows.Forms.Button
    $lblHeader = New-Object System.Windows.Forms.Label
    $treeView1 = New-Object System.Windows.Forms.TreeView
    $btnGetTemplateFolder = New-Object System.Windows.Forms.Button
    $btnGetCompareInput = New-Object System.Windows.Forms.Button
    $btnExit = New-Object System.Windows.Forms.Button
    $btnGetCSVFile = New-Object System.Windows.Forms.Button
    $btnConvertCSV = New-Object System.Windows.Forms.Button
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $gBoxCompare = New-Object System.Windows.Forms.GroupBox
    $gBoxImportCSV = New-Object System.Windows.Forms.GroupBox

    $txtTempFolder.Text = $CurrentFSPath
    $global:bolConnected = $false
    $global:strPinDomDC = ""
    $global:strPrinDomAttr = ""
    $global:strPrinDomDir = ""
    $global:strPrinDomFlat = ""
    $global:strPrincipalDN = ""
    $global:strDomainPrinDNName = ""
    $global:strEffectiveRightSP = ""
    $global:strEffectiveRightAccount = ""
    $global:strSPNobjectClass = ""
    $global:tokens = New-Object System.Collections.ArrayList
    $global:tokens.Clear()
    $global:strDommainSelect = "rootDSE"
    $global:bolTempValue_InhertiedChkBox = $false
    $global:redcolor = "red"
    $FontSans775 = "Microsoft Sans Serif, 7.75pt"
    $FontSans825 = "Microsoft Sans Serif, 8.25pt"
    $FontSans825B = "Microsoft Sans Serif, 8.25pt, style=Bold"
    $FontSans75B = "Microsoft Sans Serif, 7.5pt, style=Bold"
    $FontSans9B = "Microsoft Sans Serif, 9pt, style=Bold"
    $FontSans9 = "Microsoft Sans Serif, 9pt"

    #----------------------------------------------
    #Generated Event Script Blocks
    #----------------------------------------------
    $FormEvent_Load =
    {
        #TODO: Place custom script here
        #Add-Type -TypeDefinition @"
        New-Type @"
using System;
using System.Windows.Forms;

public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;

    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}
"@ -ReferencedAssemblies "System.Windows.Forms.dll"

        Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class SFW {
     [DllImport("user32.dll")]
     [return: MarshalAs(UnmanagedType.Bool)]
     public static extern bool SetForegroundWindow(IntPtr hWnd);
  }
"@

        [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

        $owner = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

    }

    $btnGETSPNReport_OnClick =
    {
        If (($global:strEffectiveRightSP -ne "") -and ($global:tokens.count -gt 0)) {

            $strFileSPNHTA = $env:temp + "\SPNHTML.hta"
            $strFileSPNHTM = $env:temp + "\" + "$global:strEffectiveRightAccount" + ".htm"
            CreateServicePrincipalReportHTA $global:strEffectiveRightSP $strFileSPNHTA $strFileSPNHTM $CurrentFSPath
            CreateSPNHTM $global:strEffectiveRightSP $strFileSPNHTM
            InitiateSPNHTM $strFileSPNHTA
            $strColorTemp = "1"
            WriteSPNHTM $global:strEffectiveRightSP $global:tokens $global:strSPNobjectClass $($global:tokens.count - 1) $strColorTemp $strFileSPNHTA $strFileSPNHTM
            Invoke-Item $strFileSPNHTA
        }
        else {

            $TextBoxStatusMessage.Items.Insert(0, "No service principal selected!")
        }
    }

    $btnViewLegened_OnClick =
    {

        $strFileLegendHTA = $env:temp + "\LegendHTML.hta"

        CreateColorLegenedReportHTA $strFileLegendHTA
        Invoke-Item $strFileLegendHTA

    }

    $btnGetSPAccount_OnClick =
    {

        if ($global:bolConnected -eq $true) {

            If (!($txtBoxSelectPrincipal.Text -eq "")) {
                GetEffectiveRightSP $txtBoxSelectPrincipal.Text $global:strDomainPrinDNName
            }
            else {
                $TextBoxStatusMessage.ForeColor = $global:redcolor
                $TextBoxStatusMessage.Items.Insert(0, "Enter a principal name!")
            }
        }
        else {
            $TextBoxStatusMessage.ForeColor = $global:redcolor
            $TextBoxStatusMessage
            $TextBoxStatusMessage.Items.Insert(0, "Connect to your naming context first!")
        }
    }

    $btnListDdomain_OnClick =
    {

        GenerateDomainPicker

        $txtBoxDomainConnect.Text = $global:strDommainSelect
    }
    $btnListLocations_OnClick =
    {

        if ($global:bolConnected -eq $true) {
            GenerateTrustedDomainPicker
        }
        else {
            $TextBoxStatusMessage.ForeColor = $global:redcolor
            $TextBoxStatusMessage
            $TextBoxStatusMessage.Items.Insert(0, "Connect to your naming context first!")
        }
    }

    $chkBoxEffectiveRights_CheckChanged =
    {
        If ($chkBoxEffectiveRights.Checked -eq $true) {
            $global:bolTempValue_InhertiedChkBox = $chkInheritedPerm.Checked
            $global:bolTempValue_chkBoxGetOwner = $chkBoxGetOwner.Checked
            $chkBoxFilter.Checked = $false
            $txtBoxSelectPrincipal.Enabled = $true
            $btnGetSPAccount.Enabled = $true
            $btnListLocations.Enabled = $true
            $btnGetSPNReport.Enabled = $true
            $chkInheritedPerm.Enabled = $false
            $chkInheritedPerm.Checked = $true
            $chkBoxGetOwner.Enabled = $false
            $btnViewLegend.Enabled = $true
            $chkBoxGetOwner.Checked = $true
            $chkBoxEffectiveRightsColor.Enabled = $true

        }
        else {
            $txtBoxSelectPrincipal.Enabled = $false
            $chkBoxEffectiveRightsColor.Enabled = $false
            $chkBoxEffectiveRightsColor.Checked = $false
            $btnGetSPAccount.Enabled = $false
            $btnListLocations.Enabled = $false
            $btnGetSPNReport.Enabled = $false
            $btnViewLegend.Enabled = $false
            $chkInheritedPerm.Enabled = $true
            $chkInheritedPerm.Checked = $global:bolTempValue_InhertiedChkBox
            $chkBoxGetOwner.Enabled = $true
            $chkBoxGetOwner.Checked = $global:bolTempValue_chkBoxGetOwner
        }

    }

    $chkBoxFilter_CheckChanged =
    {

        If ($chkBoxFilter.Checked -eq $true) {
            $chkBoxEffectiveRights.Checked = $false
            $chkBoxType.Enabled = $true
            $chkBoxObject.Enabled = $true
            $chkBoxTrustee.Enabled = $true
            $combObjectFilter.Enabled = $true
            $txtFilterTrustee.Enabled = $true
            $combAccessCtrl.Enabled = $true
            $btnGetObjFullFilter.Enabled = $true

        }
        else {
            $chkBoxType.Enabled = $false
            $chkBoxObject.Enabled = $false
            $chkBoxTrustee.Enabled = $false
            $chkBoxType.Checked = $false
            $chkBoxObject.Checked = $false
            $chkBoxTrustee.Checked = $false
            $combObjectFilter.Enabled = $false
            $txtFilterTrustee.Enabled = $false
            $combAccessCtrl.Enabled = $false
            $btnGetObjFullFilter.Enabled = $false
        }
    }

    $rdbNC_CheckChanged =
    {
        If ($rdbCustomNC.Checked -eq $true) {
            $txtBoxDomainConnect.Enabled = $true
            $btnListDdomain.Enabled = $false
            if (($txtBoxDomainConnect.Text -eq "rootDSE") -or ($txtBoxDomainConnect.Text -eq "config") -or ($txtBoxDomainConnect.Text -eq "schema")) {
                $txtBoxDomainConnect.Text = ""
            }
        }
        else {
            $btnListDdomain.Enabled = $false
            If ($rdbDSdef.Checked -eq $true) {
                $txtBoxDomainConnect.Text = $global:strDommainSelect
                $btnListDdomain.Enabled = $true

            }
            If ($rdbDSConf.Checked -eq $true) {
                $txtBoxDomainConnect.Text = "config"


            }
            If ($rdbDSSchm.Checked -eq $true) {
                $txtBoxDomainConnect.Text = "schema"


            }
            $txtBoxDomainConnect.Enabled = $false
        }



    }

    $btnGetTemplateFolder_OnClick =
    {

        $strFolderPath = Select-Folder
        $txtTempFolder.Text = $strFolderPath


    }
    $btnGetCompareInput_OnClick =
    {

        $strFilePath = Select-File
        $txtCompareTemplate.Text = $strFilePath


    }
    $btnGetCSVFile_OnClick =
    {

        $strFilePath = Select-File
        $txtCSVImport.Text = $strFilePath


    }
    $btnDSConnect_OnClick =
    {

        $global:bolRoot = $true
        $treeView1.Nodes.Clear()
        $NCSelect = $false
        If ($rdbDSConf.Checked) {
            [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)
            # Try to connect to the Domain root
            & { #Try
                [void]$Root.psbase.get_Name() }
            Trap [SystemException] {
                [boolean] $global:bolRoot = $false
                $TextBoxStatusMessage.ForeColor = $global:redcolor
                $TextBoxStatusMessage.Items.Insert(0, "Failed! Domain does not exist or can not be connected")
                $global:bolConnected = $false; Continue
            }
            if ($global:bolRoot -eq $true) {
                $arrADPartitions = GetADPartitions($root.distinguishedName)
                [string] $global:strDomainDNName = $arrADPartitions.Item("domain")
                $global:strDomainPrinDNName = $global:strDomainDNName
                $global:strDomainLongName = $global:strDomainDNName.Replace("DC=", "")
                $global:strDomainLongName = $global:strDomainLongName.Replace(",", ".")

                $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $global:strDomainLongName )
                $ojbDomain = [DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
                $global:strDC = $($ojbDomain.FindDomainController()).name
                $global:Forest = Get-Forest $global:strDC
                $global:ForestRootDomainDN = Get-DomainDNfromFQDN $global:Forest.RootDomain
                $global:strDomainShortName = GetDomainShortName $global:strDomainDNName $global:ForestRootDomainDN

                $lblSelectPrincipalDom.text = $global:strDomainShortName + ":"
                $NCSelect = $true

                $TextBoxStatusMessage.ForeColor = "black"
                $TextBoxStatusMessage.Items.Insert(0, "Connected")

                $root = New-Object system.directoryservices.directoryEntry("LDAP://$global:strDC/cn=configuration," + $global:ForestRootDomainDN)

            }
        }
        If ($rdbDSSchm.Checked) {
            [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)
            # Try to connect to the Domain root
            & { #Try
                [void]$Root.psbase.get_Name() }
            Trap [SystemException] {
                [boolean] $global:bolRoot = $false
                $TextBoxStatusMessage.ForeColor = $global:redcolor
                $TextBoxStatusMessage.Items.Insert(0, "Failed! Domain does not exist or can not be connected")
                $global:bolConnected = $false; Continue
            }
            if ($global:bolRoot -eq $true) {
                $arrADPartitions = GetADPartitions($root.distinguishedName)
                [string] $global:strDomainDNName = $arrADPartitions.Item("domain")
                $global:strDomainPrinDNName = $global:strDomainDNName
                $global:strDomainLongName = $global:strDomainDNName.Replace("DC=", "")
                $global:strDomainLongName = $global:strDomainLongName.Replace(",", ".")

                $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $global:strDomainLongName )
                $ojbDomain = [DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
                $global:strDC = $($ojbDomain.FindDomainController()).name
                $global:Forest = Get-Forest $global:strDC
                $global:ForestRootDomainDN = Get-DomainDNfromFQDN $global:Forest.RootDomain
                $global:strDomainShortName = GetDomainShortName $global:strDomainDNName $global:ForestRootDomainDN
                $lblSelectPrincipalDom.text = $global:strDomainShortName + ":"
                $NCSelect = $true

                $TextBoxStatusMessage.ForeColor = "black"
                $TextBoxStatusMessage.Items.Insert(0, "Connected")

                $root = New-Object system.directoryservices.directoryEntry("LDAP://$global:strDC/cn=schema,cn=configuration," + $global:ForestRootDomainDN)

            }
        }
        If ($rdbDSdef.Checked) {
            if (!($txtBoxDomainConnect.Text -eq "rootDSE")) {
                $strNamingContextDN = $txtBoxDomainConnect.Text
                If (CheckDNExist $strNamingContextDN) {
                    $root = New-Object system.directoryservices.directoryEntry("LDAP://" + $strNamingContextDN)
                    $global:strDomainDNName = $root.distinguishedName.tostring()
                    $global:strDomainPrintDNName = $global:strDomainDNName
                    $global:strDomainLongName = $global:strDomainDNName.Replace("DC=", "")
                    $global:strDomainLongName = $global:strDomainLongName.Replace(",", ".")


                    $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $global:strDomainLongName )
                    $ojbDomain = [DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
                    $global:strDC = $($ojbDomain.FindDomainController()).name
                    $global:Forest = Get-Forest $global:strDC
                    $global:ForestRootDomainDN = Get-DomainDNfromFQDN $global:Forest.RootDomain
                    $global:strDomainShortName = GetDomainShortName $global:strDomainDNName $global:ForestRootDomainDN
                    $lblSelectPrincipalDom.text = $global:strDomainShortName + ":"
                    $NCSelect = $true
                }
                else {
                    $TextBoxStatusMessage.ForeColor = $global:redcolor
                    $TextBoxStatusMessage.Items.Insert(0, "Failed! Domain does not exist or can not be connected")
                    $global:bolConnected = $false
                }
            }
            else {

                [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)

                # Try to connect to the Domain root
                & { #Try
                    [void]$Root.psbase.get_Name() }
                Trap [SystemException] {
                    [boolean] $global:bolRoot = $false
                    $TextBoxStatusMessage.ForeColor = $global:redcolor
                    $TextBoxStatusMessage.Items.Insert(0, "Failed! Domain does not exist or can not be connected")
                    $global:bolConnected = $false; Continue
                }
                if ($global:bolRoot -eq $true) {

                    $arrADPartitions = GetADPartitions($root.distinguishedName)
                    [string] $global:strDomainDNName = $arrADPartitions.Item("domain")
                    $global:strDomainPrinDNName = $global:strDomainDNName
                    $global:strDomainLongName = $global:strDomainDNName.Replace("DC=", "")
                    $global:strDomainLongName = $global:strDomainLongName.Replace(",", ".")

                    $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $global:strDomainLongName )
                    $ojbDomain = [DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
                    $global:strDC = $($ojbDomain.FindDomainController()).name
                    $global:Forest = Get-Forest $global:strDC
                    $global:ForestRootDomainDN = Get-DomainDNfromFQDN $global:Forest.RootDomain
                    $global:strDomainShortName = GetDomainShortName $global:strDomainDNName $global:ForestRootDomainDN
                    $lblSelectPrincipalDom.text = $global:strDomainShortName + ":"

                    $TextBoxStatusMessage.ForeColor = "black"
                    $TextBoxStatusMessage.Items.Insert(0, "Connected")
                    $strNamingContextDN = $root.distinguishedName

                    $NCSelect = $true

                }
            }
        }
        If ($rdbCustomNC.Checked) {
            if ($txtBoxDomainConnect.Text.Length -gt 0) {
                $strNamingContextDN = $txtBoxDomainConnect.Text
                If (CheckDNExist $strNamingContextDN) {
                    $root = New-Object system.directoryservices.directoryEntry("LDAP://" + $strNamingContextDN)
                    if (($root.distinguishedName.tostring() -match "cn=") -or ($root.distinguishedName.tostring() -match "ou=")) {
                        $global:strDomainDNName = Get-DomainDN $root.distinguishedName.tostring()
                    }
                    else {
                        $global:strDomainDNName = $root.distinguishedName.tostring()
                    }
                    $global:strDomainPrinDNName = $global:strDomainDNName
                    $global:strDomainLongName = $global:strDomainDNName.Replace("DC=", "")
                    $global:strDomainLongName = $global:strDomainLongName.Replace(",", ".")

                    $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $global:strDomainLongName )
                    $ojbDomain = [DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
                    $global:strDC = $($ojbDomain.FindDomainController()).name
                    $global:Forest = Get-Forest $global:strDC
                    $global:ForestRootDomainDN = Get-DomainDNfromFQDN $global:Forest.RootDomain

                    $global:strDomainShortName = GetDomainShortName $global:strDomainDNName $global:ForestRootDomainDN
                    $lblSelectPrincipalDom.text = $global:strDomainShortName + ":"
                    $NCSelect = $true
                }
                else {
                    $TextBoxStatusMessage.ForeColor = $global:redcolor
                    $TextBoxStatusMessage.Items.Insert(0, "Failed! Domain does not exist or can not be connected")
                    $global:bolConnected = $false
                }
            }
            else {
                $TextBoxStatusMessage.ForeColor = $global:redcolor
                $TextBoxStatusMessage.Items.Insert(0, "Failed! No naming context specified!")
                $global:bolConnected = $false
            }
        }
        If ($NCSelect -eq $true) {
            If (!($strLastCacheGuidsDom -eq $global:strDomainDNName)) {
                $global:dicRightsGuids = @{"Seed" = "xxx" }
                CacheRightsGuids $global:strDomainDNName
                $strLastCacheGuidsDom = $global:strDomainDNName


            }
            If ($TNRoot.Nodes.Count -gt 0) {
                $TNRoot.Nodes.Clear()
            }
            $treeView1.Nodes.Clear()
            $TNRoot = new-object System.Windows.Forms.TreeNode("Root")
            $TNRoot.Name = $root.distinguishedName
            $TNRoot.Text = $root.name
            $TNRoot.tag = "NotEnumerated"
            $TNRoot.ForeColor = "Black"
            # Add all Children found as Sub Nodes to the selected TreeNode
            $treeView1.add_AfterSelect( {
                    $txtBoxSelected.Text = $this.SelectedNode.Name

                    If ($global:prevNodeText.Length -gt 0) {
                        $global:prevNode.ForeColor = "Black"

                    }

                    $this.SelectedNode.ForeColor = "Blue"
                    if ($this.SelectedNode.tag -eq "NotEnumerated") {
                        $TextBoxStatusMessage.ForeColor = "black"
                        $TextBoxStatusMessage.Items.Insert(0, "Browsing..")
                        BuildTree $this.SelectedNode
                        # Set tag to show this node is already enumerated
                        $this.SelectedNode.tag = "Enumerated"


                    }
                    [string] $global:prevNodeText = $this.SelectedNode.name
                    $global:prevNode = $this.SelectedNode


                })
            [void]$treeView1.Nodes.Add($TNRoot)
            BuildTree $TNRoot
            $global:bolConnected = $true
            $TextBoxStatusMessage.ForeColor = "black"

        }
    }


    $btnScan_OnClick =
    {
        $bolPreChecks = $true
        If ($treeView1.SelectedNode.name) {
            If (($chkBoxFilter.Checked -eq $true) -and (($chkBoxType.Checked -eq $false) -and ($chkBoxObject.Checked -eq $false) -and ($chkBoxTrustee.Checked -eq $false))) {
                $TextBoxStatusMessage.Items.Insert(0, "Filter Enabled , but no filter is specified!")
                $bolPreChecks = $false
            }
            else {
                If (($chkBoxFilter.Checked -eq $true) -and (($combAccessCtrl.SelectedIndex -eq -1) -and ($combObjectFilter.SelectedIndex -eq -1) -and ($txtFilterTrustee.Text -eq ""))) {
                    $TextBoxStatusMessage.Items.Insert(0, "Filter Enabled , but no filter is specified!")
                    $bolPreChecks = $false
                }
            }

            If (($chkBoxEffectiveRights.Checked -eq $true) -and ($global:tokens.count -eq 0)) {
                $TextBoxStatusMessage.Items.Insert(0, "Effective rights enabled , but no service principal selected! ")
                $bolPreChecks = $false
            }
            if ($bolPreChecks -eq $true) {
                $allSubOU = New-Object System.Collections.ArrayList
                $allSubOU.Clear()
                $TextBoxStatusMessage.ForeColor = "black"
                $TextBoxStatusMessage.Items.Insert(0, "Scanning..")
                $BolSkipDefPerm = $chkBoxDefaultPerm.Checked
                $bolCSV = $rdbHTAandCSV.Checked

                $sADobjectName = "LDAP://$global:strDC/" + $treeView1.SelectedNode.name.ToString().Replace("/", "\/")
                $ADobject = [ADSI] $sADobjectName
                $strNode = $ADobject.name

                $date = get-date -uformat %Y%m%d_%H%M%S
                $strNode = fixfilename $strNode
                $strFileCSV = $txtTempFolder.Text + "\" + $strNode + "_" + $global:strDomainShortName + "_adAclOutput" + $date + ".csv"
                $strFileHTA = $env:temp + "\ACLHTML.hta"
                $strFileHTM = $env:temp + "\" + "$global:strDomainShortName-$strNode" + ".htm"
                if (!($rdbOnlyCSV.Checked)) {
                    if ($chkBoxFilter.checked) {
                        CreateHTA "$global:strDomainShortName-$strNode Filtered" $strFileHTA  $strFileHTM $CurrentFSPath
                        CreateHTM "$global:strDomainShortName-$strNode Filtered" $strFileHTM
                    }
                    else {
                        CreateHTA "$global:strDomainShortName-$strNode" $strFileHTA $strFileHTM $CurrentFSPath
                        CreateHTM "$global:strDomainShortName-$strNode" $strFileHTM
                    }

                    InitiateHTM $strFileHTA $chkBoxReplMeta.Checked $chkBoxACLsize.Checked $chkBoxGetOUProtected.Checked $chkBoxEffectiveRightsColor.Checked
                    InitiateHTM $strFileHTM $chkBoxReplMeta.Checked $chkBoxACLsize.Checked $chkBoxGetOUProtected.Checked $chkBoxEffectiveRightsColor.Checked
                }
                If ($treeView1.SelectedNode.name.ToString().Length -gt 0) {
                    If ($rdbBase.checked -eq $False) {
                        If ($rdbSubtree.checked -eq $true) {
                            $allSubOU = GetAllChildNodes $treeView1.SelectedNode.name $true
                            Get-Perm $allSubOU $global:strDomainShortName $BolSkipDefPerm $chkBoxFilter.checked $chkBoxGetOwner.checked $rdbOnlyCSV.Checked $chkBoxReplMeta.Checked $chkBoxACLsize.Checked $chkBoxEffectiveRights.Checked $chkBoxGetOUProtected.Checked
                        }
                        else {

                            $allSubOU = GetAllChildNodes $treeView1.SelectedNode.name $false
                            Get-Perm $allSubOU $global:strDomainShortName $BolSkipDefPerm $chkBoxFilter.checked $chkBoxGetOwner.checked $rdbOnlyCSV.Checked $chkBoxReplMeta.Checked $chkBoxACLsize.Checked $chkBoxEffectiveRights.Checked $chkBoxGetOUProtected.Checked
                        }
                    }
                    else {
                        $allSubOU = @($treeView1.SelectedNode.name)
                        Get-Perm $allSubOU $global:strDomainShortName $BolSkipDefPerm $chkBoxFilter.checked $chkBoxGetOwner.checked $rdbOnlyCSV.Checked $chkBoxReplMeta.Checked $chkBoxACLsize.Checked $chkBoxEffectiveRights.Checked $chkBoxGetOUProtected.Checked
                    }
                    $TextBoxStatusMessage.ForeColor = "black"
                    $TextBoxStatusMessage.Items.Insert(0, "Done")
                }
            }
        }
        else {
            $TextBoxStatusMessage.ForeColor = $global:redcolor
            $TextBoxStatusMessage.Items.Insert(0, "No object selected!")
        }
        $allSubOU = ""
        $strFileCSV = ""
        $strFileHTA = ""
        $strFileHTM = ""
        $sADobjectName = ""
        $date = ""
    }
    $btnCreateHTML =
    {
        if ($txtCSVImport.Text -eq "") {
            $TextBoxStatusMessage.ForeColor = $global:redcolor
            $TextBoxStatusMessage.Items.Insert(0, "No Template CSV file selected!")
        }
        else {
            ConvertCSVtoHTM $txtCSVImport.Text
        }

    }

    $btnCompare_OnClick =
    {
        If ($treeView1.SelectedNode.name) {
            $allSubOU = New-Object System.Collections.ArrayList
            $allSubOU.Clear()
            if ($txtCompareTemplate.Text -eq "") {
                $TextBoxStatusMessage.ForeColor = $global:redcolor
                $TextBoxStatusMessage.Items.Insert(0, "No Template CSV file selected!")
            }
            else {
                $strCompareFile = $txtCompareTemplate.Text
                ImportADSettings $strCompareFile
                $TextBoxStatusMessage.Items.Insert(0, "Scanning..")
                $BolSkipDefPerm = $chkBoxDefaultPerm.Checked
                $sADobjectName = "LDAP://$global:strDC/" + $treeView1.SelectedNode.name.ToString()
                $ADobject = [ADSI] $sADobjectName
                $strNode = fixfilename $ADobject.Name
                $strFileHTA = $env:temp + "\ACLHTML.hta"
                $strFileHTM = $env:temp + "\" + "$global:strDomainShortName-$strNode" + ".htm"
                CreateHTM "$global:strDomainShortName-$strNode" $strFileHTM
                CreateHTA "$global:strDomainShortName-$strNode" $strFileHTA $strFileHTM $CurrentFSPath
                InitiateCompareHTM $strFileHTA $chkBoxReplMeta.Checked
                InitiateCompareHTM $strFileHTM $chkBoxReplMeta.Checked

                If ($treeView1.SelectedNode.name.ToString().Length -gt 0) {
                    If ($rdbBase.checked -eq $False) {
                        If ($rdbSubtree.checked -eq $true) {
                            if ($chkBoxTemplateNodes.Checked -eq $false) {
                                $allSubOU = GetAllChildNodes $treeView1.SelectedNode.name $true
                            }
                            Get-PermCompare $allSubOU $BolSkipDefPerm $chkBoxReplMeta.Checked $chkBoxGetOwner.checked
                        }
                        else {
                            if ($chkBoxTemplateNodes.Checked -eq $false) {
                                $allSubOU = GetAllChildNodes $treeView1.SelectedNode.name $false
                            }
                            Get-PermCompare $allSubOU $BolSkipDefPerm $chkBoxReplMeta.Checked $chkBoxGetOwner.checked
                        }
                    }
                    else {
                        if ($chkBoxTemplateNodes.Checked -eq $false) {
                            $allSubOU = @($treeView1.SelectedNode.name)
                        }
                        Get-PermCompare $allSubOU $BolSkipDefPerm $chkBoxReplMeta.Checked $chkBoxGetOwner.checked
                    }# End If
                    $TextBoxStatusMessage.ForeColor = "black"
                    $TextBoxStatusMessage.Items.Insert(0, "Done")
                }# End If

            }# End If
        }
        else {
            $TextBoxStatusMessage.ForeColor = $global:redcolor
            $TextBoxStatusMessage.Items.Insert(0, "No object selected!")
        }
        $allSubOU = ""
        $strFileCSV = ""
        $strFileHTA = ""
        $strFileHTM = ""
        $sADobjectName = ""
        $date = ""
    }

    $btnExit_OnClick =
    {
        #TODO: Place custom script here
        $form1.close()

    }

    $btnGetObjFullFilter_OnClick =
    {
        if ($global:bolConnected -eq $true) {
            GetSchemaObjectGUID  -Domain $global:strDomainDNName
            $TextBoxStatusMessage.ForeColor = "black"
            $TextBoxStatusMessage.Items.Insert(0, "All schema objects and attributes listed!")
        }
        else {
            $TextBoxStatusMessage.ForeColor = $global:redcolor
            $TextBoxStatusMessage.Items.Insert(0, "Connect to your naming context first!")
        }
    }



    foreach ($ldapDisplayName in $global:dicSchemaIDGUIDs.values) {
        [void]$combObjectFilter.Items.Add($ldapDisplayName)
    }

    $OnLoadForm_StateCorrection =
    { #Correct the initial state of the form to prevent the .Net maximized form issue
        $form1.WindowState = $InitialFormWindowState
    }


    #----------------------------------------------
    #region Generated Form Code
    $form1.BackColor = [System.Drawing.Color]::FromArgb(255, 235, 235, 235)
    $form1.Text = "AD ACL Scanner"
    $form1.Name = "form1"
    $form1.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 910
    $System_Drawing_Size.Height = 730
    $form1.ClientSize = $System_Drawing_Size
    $form1.add_Load($FormEvent_Load)


    $lblStyleWin8_1.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 83, 0)
    $lblStyleWin8_1.Name = "lblStyleWin8_1"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 595
    $System_Drawing_Point.Y = 575
    $lblStyleWin8_1.Font = "Webdings, 35pt"
    $lblStyleWin8_1.Location = $System_Drawing_Point
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 60
    $lblStyleWin8_1.Size = $System_Drawing_Size
    $lblStyleWin8_1.Text = "d"
    $lblStyleWin8_1.TextAlign = 'MiddleCenter'

    $form1.Controls.Add($lblStyleWin8_1)

    $lblStyleWin8_2.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 64, 128)
    $lblStyleWin8_2.ForeColor = 'White'
    $lblStyleWin8_2.Name = "lblStyleWin8_2"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 660
    $System_Drawing_Point.Y = 630
    $lblStyleWin8_2.Location = $System_Drawing_Point
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 230
    $System_Drawing_Size.Height = 70
    $lblStyleWin8_2.Size = $System_Drawing_Size
    $lblStyleWin8_2.Font = "Microsoft Sans Serif, 9pt, style=Bold"
    $lblStyleWin8_2.Text = "written by robin.granberg@microsoft.com"

    $form1.Controls.Add($lblStyleWin8_2)

    $lblStyleWin8_3.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 174, 239)
    $lblStyleWin8_3.Name = "lblStyleWin8_3"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 595
    $System_Drawing_Point.Y = 640
    $lblStyleWin8_3.Font = "Webdings, 35pt"
    $lblStyleWin8_3.Location = $System_Drawing_Point
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 60
    $System_Drawing_Size.Height = 60
    $lblStyleWin8_3.Size = $System_Drawing_Size
    $lblStyleWin8_3.Text = "L"
    $lblStyleWin8_3.TextAlign = 'MiddleCenter'

    $form1.Controls.Add($lblStyleWin8_3)



    $lblStyleWin8_5.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 64, 128)
    $lblStyleWin8_5.ForeColor = 'White'
    $lblStyleWin8_5.Name = "lblStyleWin8_5"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 660
    $System_Drawing_Point.Y = 575
    $lblStyleWin8_5.Location = $System_Drawing_Point
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 230
    $System_Drawing_Size.Height = 60
    $lblStyleWin8_5.Size = $System_Drawing_Size
    $lblStyleWin8_5.Font = "Microsoft Sans Serif, 13pt, style=Bold"
    $lblStyleWin8_5.Text = "AD ACL Scanner 1.3.3"

    $form1.Controls.Add($lblStyleWin8_5)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 290
    $System_Drawing_Size.Height = 488
    $tabFilterTop.Size = $System_Drawing_Size
    $tabFilterTop.Text = "Filter Options"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 620
    $System_Drawing_Point.Y = 38
    $tabFilterTop.Location = $System_Drawing_Point
    $tabFilterTop.Name = "tabFilterTop"
    $tabFilterTop.DataBindings.DefaultDataSourceUpdateMode = 0

    $form1.Controls.Add($tabFilterTop)

    $tabFilter.Name = "tabFilter"
    $tabFilter.Text = "Filter Options"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 290
    $System_Drawing_Size.Height = 450
    $tabFilter.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 620
    $System_Drawing_Point.Y = 38
    $tabFilter.Location = $System_Drawing_Point
    $tabFilter.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabFilterTop.Controls.Add($tabFilter)

    $tabEffectiveR.Name = "tabEffectiveR"
    $tabEffectiveR.Text = "Effective Rights"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 290
    $System_Drawing_Size.Height = 450
    $tabEffectiveR.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 620
    $System_Drawing_Point.Y = 15
    $tabEffectiveR.Location = $System_Drawing_Point
    $tabEffectiveR.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabFilterTop.Controls.Add($tabEffectiveR)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 275
    $System_Drawing_Size.Height = 485
    $tabScanTop.Size = $System_Drawing_Size
    $tabScanTop.Text = "Scan Options"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 340
    $System_Drawing_Point.Y = 38
    $tabScanTop.Location = $System_Drawing_Point
    $tabScanTop.Name = "tbPScanTop"
    $tabScanTop.DataBindings.DefaultDataSourceUpdateMode = 0

    $form1.Controls.Add($tabScanTop)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 266
    $System_Drawing_Size.Height = 450
    $tabScan.Size = $System_Drawing_Size
    $tabScan.Text = "Scan Options"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 340
    $System_Drawing_Point.Y = 38
    $tabScan.Location = $System_Drawing_Point
    $tabScan.Name = "tbPScan"
    $tabScan.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabScanTop.Controls.Add($tabScan)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 266
    $System_Drawing_Size.Height = 450
    $tabOfflineScan.Size = $System_Drawing_Size
    $tabOfflineScan.Text = "Additional Options"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 340
    $System_Drawing_Point.Y = 38
    $tabOfflineScan.Location = $System_Drawing_Point
    $tabOfflineScan.Name = "tbPOfflineScan"
    $tabOfflineScan.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabScanTop.Controls.Add($tabOfflineScan)

    $gBoxNCSelect.TabIndex = 0
    $gBoxNCSelect.Name = "gBoxNCSelect"
    $gBoxNCSelect.Text = "Select Naming Context"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 310
    $System_Drawing_Size.Height = 120
    $gBoxNCSelect.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 25
    $System_Drawing_Point.Y = 38
    $gBoxNCSelect.Location = $System_Drawing_Point
    $gBoxNCSelect.DataBindings.DefaultDataSourceUpdateMode = 0

    $form1.Controls.Add($gBoxNCSelect)

    ################################ Filter Tab ################################

    $chkBoxFilter.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 150
    $System_Drawing_Size.Height = 24
    $chkBoxFilter.Size = $System_Drawing_Size
    $chkBoxFilter.Text = "Enable Filter"
    $chkBoxFilter.Checked = $False
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 9
    $chkBoxFilter.Location = $System_Drawing_Point
    $chkBoxFilter.CheckState = 0
    $chkBoxFilter.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxFilter.Name = "chkBoxFilter"
    $chkBoxFilter.Add_checkedChanged($chkBoxFilter_CheckChanged)


    $tabFilter.Controls.Add($chkBoxFilter)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 18
    $System_Drawing_Size.Height = 24
    $chkBoxType.Size = $System_Drawing_Size
    $chkBoxType.Text = ""
    $chkBoxType.Checked = $False
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 60
    $chkBoxType.Location = $System_Drawing_Point
    $chkBoxType.CheckState = 0
    $chkBoxType.Enabled = $False
    $chkBoxType.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxType.Name = "chkBoxType"


    $tabFilter.Controls.Add($chkBoxType)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 250
    $System_Drawing_Size.Height = 16
    $lblAccessCtrl.Size = $System_Drawing_Size
    $lblAccessCtrl.Font = $FontSans775
    $lblAccessCtrl.Text = "Filter by Access Type:(example: Allow)"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 40
    $lblAccessCtrl.Location = $System_Drawing_Point
    $lblAccessCtrl.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblAccessCtrl.Name = "lblAccessCtrl"

    $tabFilter.Controls.Add($lblAccessCtrl)

    $combAccessCtrl.FormattingEnabled = $True
    $combAccessCtrl.Sorted = $True
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 29
    $System_Drawing_Point.Y = 60
    $combAccessCtrl.Location = $System_Drawing_Point
    $combAccessCtrl.Name = "combAccessCtrl"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 100
    $System_Drawing_Size.Height = 21
    $combAccessCtrl.Size = $System_Drawing_Size
    [void]$combAccessCtrl.Items.Add("Allow")
    [void]$combAccessCtrl.Items.Add("Deny")
    $combAccessCtrl.Enabled = $false

    $tabFilter.Controls.Add($combAccessCtrl)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 250
    $System_Drawing_Size.Height = 16
    $lblFilterExpl.Size = $System_Drawing_Size
    $lblFilterExpl.Font = $FontSans775
    $lblFilterExpl.Text = "Filter by Object:(example: user)"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 90
    $lblFilterExpl.Location = $System_Drawing_Point
    $lblFilterExpl.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblFilterExpl.Name = "lblFilterExpl"

    $tabFilter.Controls.Add($lblFilterExpl)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 18
    $System_Drawing_Size.Height = 24
    $chkBoxObject.Size = $System_Drawing_Size
    $chkBoxObject.Text = ""
    $chkBoxObject.Checked = $False
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 110
    $chkBoxObject.Location = $System_Drawing_Point
    $chkBoxObject.CheckState = 0
    $chkBoxObject.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxObject.Enabled = $False
    $chkBoxObject.Name = "chkBoxObject"

    $tabFilter.Controls.Add($chkBoxObject)

    $combObjectFilter.FormattingEnabled = $True
    $combObjectFilter.Sorted = $True
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 29
    $System_Drawing_Point.Y = 110
    $combObjectFilter.Location = $System_Drawing_Point
    $combObjectFilter.Name = "combObjectFilter"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 190
    $System_Drawing_Size.Height = 21
    $combObjectFilter.Size = $System_Drawing_Size
    $combObjectFilter.Enabled = $False

    $tabFilter.Controls.Add($combObjectFilter)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 265
    $System_Drawing_Size.Height = 44
    $lblGetObj.Size = $System_Drawing_Size
    $lblGetObj.Font = $FontSans775
    $lblGetObj.Text = "The list box contains a few  number of standard objects. To load all objects from schema press Load."
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 140
    $lblGetObj.Location = $System_Drawing_Point
    $lblGetObj.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblGetObj.Name = "lblGetObj"

    $tabFilter.Controls.Add($lblGetObj)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 150
    $System_Drawing_Size.Height = 15
    $lblGetObjExtend.Size = $System_Drawing_Size
    $lblGetObjExtend.Font = "Microsoft Sans Serif, 7.75pt, style=Bold"
    $lblGetObjExtend.Text = "This may take a while!"
    $lblGetObjExtend.ForeColor = "Black"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 182
    $lblGetObjExtend.Location = $System_Drawing_Point
    $lblGetObjExtend.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblGetObjExtend.Name = "lblGetObjExtend"

    $tabFilter.Controls.Add($lblGetObjExtend)

    $btnGetObjFullFilter.Name = "btnGetObjFullFilter"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 100
    $System_Drawing_Size.Height = 23
    $btnGetObjFullFilter.Size = $System_Drawing_Size
    $btnGetObjFullFilter.UseVisualStyleBackColor = $True
    $btnGetObjFullFilter.Font = $FontSans825B
    $btnGetObjFullFilter.Text = "Load"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 160
    $System_Drawing_Point.Y = 185
    $btnGetObjFullFilter.Location = $System_Drawing_Point
    $btnGetObjFullFilter.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnGetObjFullFilter.add_Click($btnGetObjFullFilter_OnClick)
    $btnGetObjFullFilter.Enabled = $false

    $tabFilter.Controls.Add($btnGetObjFullFilter)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 270
    $System_Drawing_Size.Height = 70
    $lblFilterTrusteeExpl.Size = $System_Drawing_Size
    $lblFilterTrusteeExpl.Font = $FontSans775
    $lblFilterTrusteeExpl.Text = "Filter by Trustee:`nExamples:`nCONTOSO\User`nCONTOSO\JohnDoe*`n*Smith`n*Doe*"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 220
    $lblFilterTrusteeExpl.Location = $System_Drawing_Point
    $lblFilterTrusteeExpl.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblFilterTrusteeExpl.Name = "lblFilterTrusteeExpl"

    $tabFilter.Controls.Add($lblFilterTrusteeExpl)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 18
    $System_Drawing_Size.Height = 24
    $chkBoxTrustee.Size = $System_Drawing_Size
    $chkBoxTrustee.Text = ""
    $chkBoxTrustee.Checked = $False
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 292
    $chkBoxTrustee.Location = $System_Drawing_Point
    $chkBoxTrustee.CheckState = 0
    $chkBoxTrustee.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxTrustee.Enabled = $False
    $chkBoxTrustee.Name = "chkBoxObject"

    $tabFilter.Controls.Add($chkBoxTrustee)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 245
    $System_Drawing_Size.Height = 20
    $txtFilterTrustee.Size = $System_Drawing_Size
    $txtFilterTrustee.DataBindings.DefaultDataSourceUpdateMode = 0
    $txtFilterTrustee.Name = "txtFilterTrustee"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 29
    $System_Drawing_Point.Y = 295
    $txtFilterTrustee.Location = $System_Drawing_Point
    $txtFilterTrustee.Enabled = $false

    $tabFilter.Controls.Add($txtFilterTrustee)

    ################################ Filter Tab ################################

    $gBoxCompare.Name = "gBoxCompare"
    $gBoxCompare.Text = "Compare Options"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 260
    $System_Drawing_Size.Height = 120
    $gBoxCompare.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 335
    $gBoxCompare.Location = $System_Drawing_Point
    $gBoxCompare.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabScan.Controls.Add($gBoxCompare)


    $gBoxScanDepth.Name = "gBoxScanDepth"
    $gBoxScanDepth.Text = "Scan depth"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 260
    $System_Drawing_Size.Height = 40
    $gBoxScanDepth.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 3
    $gBoxScanDepth.Location = $System_Drawing_Point
    $gBoxScanDepth.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabScan.Controls.Add($gBoxScanDepth)

    $gBoxImportCSV.Name = "gBoxImportCSV"
    $gBoxImportCSV.Text = "CSV to HTML"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 260
    $System_Drawing_Size.Height = 160
    $gBoxImportCSV.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 10
    $gBoxImportCSV.Location = $System_Drawing_Point
    $gBoxImportCSV.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabOfflineScan.Controls.Add($gBoxImportCSV)


    $rdbDSdef.TabIndex = 99
    $rdbDSdef.TabStop = $false
    $rdbDSdef.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 75
    $System_Drawing_Size.Height = 24
    $rdbDSdef.Size = $System_Drawing_Size
    $rdbDSdef.Text = "Domain"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 20
    $rdbDSdef.Location = $System_Drawing_Point
    $rdbDSdef.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbDSdef.Name = "rdbDSdef"
    $rdbDSdef.Checked = $true
    $rdbDSdef.Add_checkedChanged($rdbNC_CheckChanged)


    $gBoxNCSelect.Controls.Add($rdbDSdef)

    $rdbCustomNC.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 75
    $System_Drawing_Size.Height = 24
    $rdbCustomNC.Size = $System_Drawing_Size
    $rdbCustomNC.Text = "Custom"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 230
    $System_Drawing_Point.Y = 20
    $rdbCustomNC.Location = $System_Drawing_Point
    $rdbCustomNC.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbCustomNC.Name = "rdbCustomNC"
    $rdbCustomNC.Checked = $false
    $rdbCustomNC.Add_checkedChanged($rdbNC_CheckChanged)


    $gBoxNCSelect.Controls.Add($rdbCustomNC)

    $rdbDSConf.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 70
    $System_Drawing_Size.Height = 24
    $rdbDSConf.Size = $System_Drawing_Size
    $rdbDSConf.Text = "Config"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 78
    $System_Drawing_Point.Y = 20
    $rdbDSConf.Location = $System_Drawing_Point
    $rdbDSConf.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbDSConf.Name = "rdbDSConf"
    $rdbDSConf.Checked = $False
    $rdbDSConf.Add_checkedChanged($rdbNC_CheckChanged)

    $gBoxNCSelect.Controls.Add($rdbDSConf)

    $rdbDSSchm.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 75
    $System_Drawing_Size.Height = 24
    $rdbDSSchm.Size = $System_Drawing_Size
    $rdbDSSchm.Text = "Schema"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 150
    $System_Drawing_Point.Y = 20
    $rdbDSSchm.Location = $System_Drawing_Point
    $rdbDSSchm.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbDSSchm.Name = "rdbDSSchm"
    $rdbDSSchm.Checked = $False
    $rdbDSSchm.Add_checkedChanged($rdbNC_CheckChanged)

    $gBoxNCSelect.Controls.Add($rdbDSSchm)


    ################################  Scan Options Tab    ################################

    $gBoxReportOpt.Name = "gBoxReportOpt"
    $gBoxReportOpt.Text = "View in report"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 260
    $System_Drawing_Size.Height = 100
    $gBoxReportOpt.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 93
    $gBoxReportOpt.Location = $System_Drawing_Point
    $gBoxReportOpt.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabScan.Controls.Add($gBoxReportOpt)

    $gBoxRdbScan.Name = "gBoxRdbScan"
    $gBoxRdbScan.Text = "Objects to scan"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 260
    $System_Drawing_Size.Height = 50
    $gBoxRdbScan.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 42
    $gBoxRdbScan.Location = $System_Drawing_Point
    $gBoxRdbScan.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabScan.Controls.Add($gBoxRdbScan)

    $gBoxRdbFile.Name = "gBoxRdbFile"
    $gBoxRdbFile.Text = "Output Options"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 260
    $System_Drawing_Size.Height = 140
    $gBoxRdbFile.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 195
    $gBoxRdbFile.Location = $System_Drawing_Point
    $gBoxRdbFile.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabScan.Controls.Add($gBoxRdbFile)

    $rdbBase.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 75
    $System_Drawing_Size.Height = 24
    $rdbBase.Size = $System_Drawing_Size
    $rdbBase.Text = "Base"
    $rdbBase.Checked = $true
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 13
    $rdbBase.Location = $System_Drawing_Point
    $rdbBase.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbBase.Name = "rdbBase"


    $gBoxScanDepth.Controls.Add($rdbBase)

    $rdbOneLevel.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 75
    $System_Drawing_Size.Height = 24
    $rdbOneLevel.Size = $System_Drawing_Size
    $rdbOneLevel.Text = "One Level"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 85
    $System_Drawing_Point.Y = 13
    $rdbOneLevel.Location = $System_Drawing_Point
    $rdbOneLevel.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbOneLevel.Name = "rdbOneLevel"


    $gBoxScanDepth.Controls.Add($rdbOneLevel)

    $rdbSubtree.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 75
    $System_Drawing_Size.Height = 24
    $rdbSubtree.Size = $System_Drawing_Size
    $rdbSubtree.Text = "Subtree"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 165
    $System_Drawing_Point.Y = 13
    $rdbSubtree.Location = $System_Drawing_Point
    $rdbSubtree.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbSubtree.Name = "rdbSubtree"


    $gBoxScanDepth.Controls.Add($rdbSubtree)

    $chkInheritedPerm.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 145
    $System_Drawing_Size.Height = 24
    $chkInheritedPerm.Size = $System_Drawing_Size
    $chkInheritedPerm.Text = "Inherited Permissions"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 33
    $chkInheritedPerm.Location = $System_Drawing_Point
    $chkInheritedPerm.CheckState = 0
    $chkInheritedPerm.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkInheritedPerm.Name = "chkInheritedPerm"


    $gBoxReportOpt.Controls.Add($chkInheritedPerm)

    $chkBoxGetOwner.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 104
    $System_Drawing_Size.Height = 24
    $chkBoxGetOwner.Size = $System_Drawing_Size
    $chkBoxGetOwner.Text = "View Owner"
    $chkBoxGetOwner.Checked = $false
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 13
    $chkBoxGetOwner.Location = $System_Drawing_Point
    $chkBoxGetOwner.CheckState = 0
    $chkBoxGetOwner.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxGetOwner.Name = "chkBoxGetOwner"

    $gBoxReportOpt.Controls.Add($chkBoxGetOwner)


    $chkBoxDefaultPerm.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 149
    $System_Drawing_Size.Height = 24
    $chkBoxDefaultPerm.Size = $System_Drawing_Size
    $chkBoxDefaultPerm.Text = "Skip Default Permissions"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 54
    $chkBoxDefaultPerm.Location = $System_Drawing_Point
    $chkBoxDefaultPerm.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxDefaultPerm.Name = "chkBoxDefaultPerm"

    $gBoxReportOpt.Controls.Add($chkBoxDefaultPerm)


    $chkBoxReplMeta.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 110
    $System_Drawing_Size.Height = 20
    $chkBoxReplMeta.Size = $System_Drawing_Size
    $chkBoxReplMeta.Text = "SD modified date"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 78
    $chkBoxReplMeta.Location = $System_Drawing_Point
    $chkBoxReplMeta.CheckState = 0
    $chkBoxReplMeta.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxReplMeta.Name = "chkBoxReplMeta"

    $gBoxReportOpt.Controls.Add($chkBoxReplMeta)

    $chkBoxGetOUProtected.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 90
    $System_Drawing_Size.Height = 29
    $chkBoxGetOUProtected.Size = $System_Drawing_Size
    $chkBoxGetOUProtected.Text = "Inheritance`nDisabled"
    $chkBoxGetOUProtected.TextAlign = "TopLeft"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 155
    $System_Drawing_Point.Y = 33
    $chkBoxGetOUProtected.Location = $System_Drawing_Point
    $chkBoxGetOUProtected.CheckState = 0
    $chkBoxGetOUProtected.CheckAlign = "TopLeft"
    $chkBoxGetOUProtected.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxGetOUProtected.Name = "chkBoxGetOUProtected"

    $gBoxReportOpt.Controls.Add($chkBoxGetOUProtected)

    $chkBoxACLSize.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 90
    $System_Drawing_Size.Height = 20
    $chkBoxACLSize.Size = $System_Drawing_Size
    $chkBoxACLSize.Text = "DACL Size"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 155
    $System_Drawing_Point.Y = 13
    $chkBoxACLSize.Location = $System_Drawing_Point
    $chkBoxACLSize.CheckState = 0
    $chkBoxACLSize.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxACLSize.Name = "chkBoxACLSize"

    $gBoxReportOpt.Controls.Add($chkBoxACLSize)

    $rdbScanOU.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 55
    $System_Drawing_Size.Height = 24
    $rdbScanOU.Size = $System_Drawing_Size
    $rdbScanOU.Text = "OUs"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 20
    $rdbScanOU.Location = $System_Drawing_Point
    $rdbScanOU.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbScanOU.Name = "rdbScanOU"
    $rdbScanOU.Checked = $true

    $gBoxRdbScan.Controls.Add($rdbScanOU)

    $rdbScanContainer.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 95
    $System_Drawing_Size.Height = 24
    $rdbScanContainer.Size = $System_Drawing_Size
    $rdbScanContainer.Text = "Containers"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 60
    $System_Drawing_Point.Y = 20
    $rdbScanContainer.Location = $System_Drawing_Point
    $rdbScanContainer.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbScanContainer.Name = "rdbScanContainer"
    $rdbScanContainer.Checked = $false

    $gBoxRdbScan.Controls.Add($rdbScanContainer)

    $rdbScanAll.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 100
    $System_Drawing_Size.Height = 24
    $rdbScanAll.Size = $System_Drawing_Size
    $rdbScanAll.Text = "All Objects"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 155
    $System_Drawing_Point.Y = 20
    $rdbScanAll.Location = $System_Drawing_Point
    $rdbScanAll.DataBindings.DefaultDataSourceUpdateMode = 0
    $rdbScanAll.Name = "rdbScanAll"

    $gBoxRdbScan.Controls.Add($rdbScanAll)

    $btnGetTemplateFolder.Name = "btnGetTemplateFolder"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 110
    $System_Drawing_Size.Height = 23
    $btnGetTemplateFolder.Size = $System_Drawing_Size
    $btnGetTemplateFolder.UseVisualStyleBackColor = $True
    $btnGetTemplateFolder.Font = $FontSans825B
    $btnGetTemplateFolder.Text = "Change Folder"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 140
    $System_Drawing_Point.Y = 110
    $btnGetTemplateFolder.Location = $System_Drawing_Point
    $btnGetTemplateFolder.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnGetTemplateFolder.add_Click($btnGetTemplateFolder_OnClick)

    $gBoxRdbFile.Controls.Add($btnGetTemplateFolder)

    $btnGetCompareInput.Name = "btnGetCompareInput"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 120
    $System_Drawing_Size.Height = 23
    $btnGetCompareInput.Size = $System_Drawing_Size
    $btnGetCompareInput.UseVisualStyleBackColor = $True
    $btnGetCompareInput.Font = $FontSans825B
    $btnGetCompareInput.Text = "Select Template"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 130
    $System_Drawing_Point.Y = 60
    $btnGetCompareInput.Location = $System_Drawing_Point
    $btnGetCompareInput.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnGetCompareInput.add_Click($btnGetCompareInput_OnClick)

    $gBoxCompare.Controls.Add($btnGetCompareInput)

    $chkBoxTemplateNodes.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 100
    $System_Drawing_Size.Height = 29
    $chkBoxTemplateNodes.Size = $System_Drawing_Size
    $chkBoxTemplateNodes.Text = "Use nodes from template"
    $chkBoxTemplateNodes.TextAlign = "TopLeft"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 60
    $chkBoxTemplateNodes.Location = $System_Drawing_Point
    $chkBoxTemplateNodes.CheckState = 0
    $chkBoxTemplateNodes.CheckAlign = "TopLeft"
    $chkBoxTemplateNodes.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxTemplateNodes.Name = "chkBoxTemplateNodes"

    $gBoxCompare.Controls.Add($chkBoxTemplateNodes)

    $btnGetCSVFile.Name = "btnGetCSVFile"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 120
    $System_Drawing_Size.Height = 23
    $btnGetCSVFile.Size = $System_Drawing_Size
    $btnGetCSVFile.UseVisualStyleBackColor = $True
    $btnGetCSVFile.Font = $FontSans75B
    $btnGetCSVFile.Text = "Select CSV"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 120
    $System_Drawing_Point.Y = 60
    $btnGetCSVFile.Location = $System_Drawing_Point
    $btnGetCSVFile.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnGetCSVFile.add_Click($btnGetCSVFile_OnClick)

    $gBoxImportCsv.Controls.Add($btnGetCSVFile)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 245
    $System_Drawing_Size.Height = 20
    $txtTempFolder.Size = $System_Drawing_Size
    $txtTempFolder.DataBindings.DefaultDataSourceUpdateMode = 0
    $txtTempFolder.Name = "txtTempFolder"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 85
    $txtTempFolder.Location = $System_Drawing_Point

    $gBoxRdbFile.Controls.Add($txtTempFolder)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 158
    $System_Drawing_Size.Height = 16
    $lblTempFolder.Size = $System_Drawing_Size
    $lblTempFolder.Text = "CSV file destination:"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 70
    $lblTempFolder.Location = $System_Drawing_Point
    $lblTempFolder.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblTempFolder.Name = "lblTempFolder"

    $gBoxRdbFile.Controls.Add($lblTempFolder)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 158
    $System_Drawing_Size.Height = 16
    $lblCompareTemplate.Size = $System_Drawing_Size
    $lblCompareTemplate.Text = "CSV Template File:"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 19
    $lblCompareTemplate.Location = $System_Drawing_Point
    $lblCompareTemplate.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblCompareTemplate.Name = "lblCompareTemplate"

    $gBoxCompare.Controls.Add($lblCompareTemplate)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 220
    $System_Drawing_Size.Height = 20
    $txtCompareTemplate.Size = $System_Drawing_Size
    $txtCompareTemplate.DataBindings.DefaultDataSourceUpdateMode = 0
    $txtCompareTemplate.Name = "txtCompareTemplate"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 35
    $txtCompareTemplate.Location = $System_Drawing_Point

    $gBoxCompare.Controls.Add($txtCompareTemplate)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 220
    $System_Drawing_Size.Height = 20
    $txtCSVImport.Size = $System_Drawing_Size
    $txtCSVImport.DataBindings.DefaultDataSourceUpdateMode = 0
    $txtCSVImport.Name = "txtCSVImport"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 35
    $txtCSVImport.Location = $System_Drawing_Point

    $gBoxImportCSV.Controls.Add($txtCSVImport)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 200
    $System_Drawing_Size.Height = 16
    $lblCSVImport.Size = $System_Drawing_Size
    $lblCSVImport.Text = "This file will be converted HTML:"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 20
    $lblCSVImport.Location = $System_Drawing_Point
    $lblCSVImport.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblCSVImport.Name = "lblCSVImport"

    $gBoxImportCSV.Controls.Add($lblCSVImport)

    $rdbOnlyHTA.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 101
    $System_Drawing_Size.Height = 24
    $rdbOnlyHTA.Size = $System_Drawing_Size
    $rdbOnlyHTA.Text = "HTML report"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 20
    $rdbOnlyHTA.Location = $System_Drawing_Point
    $rdbOnlyHTA.DataBindings.DefaultDataSourceUpdateMode = 1
    $rdbOnlyHTA.Name = "rdbOnlyHTA"
    $rdbOnlyHTA.Checked = $true

    $gBoxRdbFile.Controls.Add($rdbOnlyHTA)

    $rdbHTAandCSV.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 150
    $System_Drawing_Size.Height = 40
    $rdbHTAandCSV.Size = $System_Drawing_Size
    $rdbHTAandCSV.Text = "HTML report and CSV file"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 104
    $System_Drawing_Point.Y = 12
    $rdbHTAandCSV.Location = $System_Drawing_Point
    $rdbHTAandCSV.DataBindings.DefaultDataSourceUpdateMode = 1
    $rdbHTAandCSV.Name = "rdbHTAandCSV"

    $gBoxRdbFile.Controls.Add($rdbHTAandCSV)

    $rdbOnlyCSV.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 97
    $System_Drawing_Size.Height = 24
    $rdbOnlyCSV.Size = $System_Drawing_Size
    $rdbOnlyCSV.Text = "CSV file"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 40
    $rdbOnlyCSV.Location = $System_Drawing_Point
    $rdbOnlyCSV.DataBindings.DefaultDataSourceUpdateMode = 1
    $rdbOnlyCSV.Name = "rdbOnlyCSV"
    $rdbOnlyCSV.Checked = $false

    $gBoxRdbFile.Controls.Add($rdbOnlyCSV)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 200
    $System_Drawing_Size.Height = 17
    $lblDomain.Size = $System_Drawing_Size
    $lblDomain.Text = "Naming Context:"
    $lblDomain.ForeColor = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 48
    $lblDomain.Location = $System_Drawing_Point
    $lblDomain.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblDomain.Name = "lblDomain"

    $gBoxNCSelect.Controls.Add($lblDomain)

    $txtBoxDomainConnect.Enabled = $false
    $txtBoxDomainConnect.Text = $global:strDommainSelect
    $txtBoxDomainConnect.TabStop = $false
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 280
    $System_Drawing_Size.Height = 20
    $txtBoxDomainConnect.Size = $System_Drawing_Size
    $txtBoxDomainConnect.DataBindings.DefaultDataSourceUpdateMode = 0
    $txtBoxDomainConnect.Name = "txtBoxDomainConnect"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 65
    $txtBoxDomainConnect.Location = $System_Drawing_Point

    $gBoxNCSelect.Controls.Add($txtBoxDomainConnect)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 225
    $System_Drawing_Size.Height = 28
    $lblConnect.Size = $System_Drawing_Size
    $lblConnect.Font = $FontSans775
    $lblConnect.Text = "First click Connect to connect to a domain."
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 80
    $System_Drawing_Point.Y = 90
    $lblConnect.Location = $System_Drawing_Point
    $lblConnect.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblConnect.Name = "lblConnect"

    $btnDSConnect.TabIndex = 1
    $btnDSConnect.Name = "btnDSConnect"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 85
    $System_Drawing_Size.Height = 23
    $btnDSConnect.Size = $System_Drawing_Size
    $btnDSConnect.UseVisualStyleBackColor = $True
    $btnDSConnect.Font = $FontSans825B
    $btnDSConnect.Text = "Connect"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 90
    $btnDSConnect.Location = $System_Drawing_Point
    $btnDSConnect.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnDSConnect.add_Click($btnDSConnect_OnClick)


    $gBoxNCSelect.Controls.Add($btnDSConnect)


    $btnListDdomain.TabIndex = 1
    $btnListDdomain.Name = "btnListDdomain"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 100
    $System_Drawing_Size.Height = 23
    $btnListDdomain.Size = $System_Drawing_Size
    $btnListDdomain.UseVisualStyleBackColor = $True
    $btnListDdomain.Font = $FontSans825B
    $btnListDdomain.Text = "List Domains"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 95
    $System_Drawing_Point.Y = 90
    $btnListDdomain.Location = $System_Drawing_Point
    $btnListDdomain.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnListDdomain.add_Click($btnListDdomain_OnClick)


    $gBoxNCSelect.Controls.Add($btnListDdomain)





    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 550
    $System_Drawing_Size.Height = 20
    $txtBoxSelected.Size = $System_Drawing_Size
    $txtBoxSelected.DataBindings.DefaultDataSourceUpdateMode = 0
    $txtBoxSelected.Name = "txtBoxSelected"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 25
    $System_Drawing_Point.Y = 590
    $txtBoxSelected.Location = $System_Drawing_Point

    $form1.Controls.Add($txtBoxSelected)


    $gBoxBrowse.Name = "gBoxBrowse"
    $gBoxBrowse.Text = "Browse Options"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 310
    $System_Drawing_Size.Height = 51
    $gBoxBrowse.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 25
    $System_Drawing_Point.Y = 160
    $gBoxBrowse.Location = $System_Drawing_Point
    $gBoxBrowse.DataBindings.DefaultDataSourceUpdateMode = 0

    $form1.Controls.Add($gBoxBrowse)

    $rdbBrowseAll.Name = "rdbBrowseAll"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 98
    $System_Drawing_Size.Height = 24
    $rdbBrowseAll.Size = $System_Drawing_Size
    $rdbBrowseAll.UseVisualStyleBackColor = $True

    $rdbBrowseAll.Text = "All Objects"

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 68
    $System_Drawing_Point.Y = 19
    $rdbBrowseAll.Location = $System_Drawing_Point
    $rdbBrowseAll.DataBindings.DefaultDataSourceUpdateMode = 0


    $gBoxBrowse.Controls.Add($rdbBrowseAll)


    $rdbBrowseOU.Name = "rdbBrowseOU"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 104
    $System_Drawing_Size.Height = 24
    $rdbBrowseOU.Size = $System_Drawing_Size
    $rdbBrowseOU.UseVisualStyleBackColor = $True

    $rdbBrowseOU.Text = "OU''s"
    $rdbBrowseOU.Checked = $true

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 6
    $System_Drawing_Point.Y = 19
    $rdbBrowseOU.Location = $System_Drawing_Point
    $rdbBrowseOU.DataBindings.DefaultDataSourceUpdateMode = 0

    $gBoxBrowse.Controls.Add($rdbBrowseOU)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 200
    $System_Drawing_Size.Height = 90
    $lblRunScan.Size = $System_Drawing_Size
    $lblRunScan.Font = $FontSans9B
    $lblRunScan.Text = "1.Select a naming context.`n2.Connect to a naming context.`n3.Select a node.`n4.Press Run Scan."
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 340
    $System_Drawing_Point.Y = 525
    $lblRunScan.Location = $System_Drawing_Point
    $lblRunScan.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblRunScan.Name = "lblRunScan"

    $Form1.Controls.Add($lblRunScan)

    $btnScan.TabIndex = 2
    $btnScan.Name = "btnScan"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 85
    $System_Drawing_Size.Height = 23
    $btnScan.Size = $System_Drawing_Size
    $btnScan.UseVisualStyleBackColor = $True
    $btnScan.Font = $FontSans825B
    $btnScan.Text = "Run Scan"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 590
    $System_Drawing_Point.Y = 540
    $btnScan.Location = $System_Drawing_Point
    $btnScan.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnScan.add_Click($btnScan_OnClick)

    $Form1.Controls.Add($btnScan)

    $btnCompare.Name = "btnCompare"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 120
    $System_Drawing_Size.Height = 23
    $btnCompare.Size = $System_Drawing_Size
    $btnCompare.UseVisualStyleBackColor = $True
    $btnCompare.Font = $FontSans825B
    $btnCompare.Text = "Run Compare"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 130
    $System_Drawing_Point.Y = 90
    $btnCompare.Location = $System_Drawing_Point
    $btnCompare.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnCompare.add_Click($btnCompare_OnClick)

    $gBoxCompare.Controls.Add($btnCompare)

    $btnConvertCSV.Name = "btnConvertCSV"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 125
    $System_Drawing_Size.Height = 23
    $btnConvertCSV.Size = $System_Drawing_Size
    $btnConvertCSV.UseVisualStyleBackColor = $True
    $btnConvertCSV.Font = $FontSans75B
    $btnConvertCSV.Text = "Create HTML View"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 120
    $System_Drawing_Point.Y = 90
    $btnConvertCSV.Location = $System_Drawing_Point
    $btnConvertCSV.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnConvertCSV.add_Click($btnCreateHTML)

    $gBoxImportCSV.Controls.Add($btnConvertCSV)

    $lblHeaderInfo.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 0, 0)
    $lblHeaderInfo.ForeColor = 'White'
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 500
    $System_Drawing_Size.Height = 20
    $lblHeaderInfo.Size = $System_Drawing_Size
    $lblHeaderInfo.Font = $FontSans9
    $lblHeaderInfo.Text = "A Tool To Create Reports of Access Control Lists In Active Directory"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 380
    $System_Drawing_Point.Y = 18
    $lblHeaderInfo.Location = $System_Drawing_Point
    $lblHeaderInfo.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblHeaderInfo.Name = "lblRunScan"

    $Form1.Controls.Add($lblHeaderInfo)

    $lblHeader.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 0, 0)
    $lblHeader.ForeColor = 'White'
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 910
    $System_Drawing_Size.Height = 38
    $lblHeader.Size = $System_Drawing_Size
    $lblHeader.Text = "AD ACL Scanner"
    $lblHeader.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 18, 1, 3, 1)
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 0
    $System_Drawing_Point.Y = 0
    $lblHeader.Location = $System_Drawing_Point
    $lblHeader.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblHeader.Name = "lblHeader"

    $form1.Controls.Add($lblHeader)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 309
    $System_Drawing_Size.Height = 355
    $treeView1.Size = $System_Drawing_Size
    $treeView1.Name = "treeView1"
    $treeView1.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 25
    $System_Drawing_Point.Y = 220
    $treeView1.Location = $System_Drawing_Point
    $treeView1.DataBindings.DefaultDataSourceUpdateMode = 0

    $form1.Controls.Add($treeView1)

    $TextBoxStatusMessage.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255, 255)
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 550
    $System_Drawing_Size.Height = 78
    $TextBoxStatusMessage.Size = $System_Drawing_Size
    $TextBoxStatusMessage.Items.Insert(0, "Not Connected")
    $TextBoxStatusMessage.Font = $FontSans9B
    $TextBoxStatusMessage.ForeColor = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 25
    $System_Drawing_Point.Y = 630
    $TextBoxStatusMessage.Location = $System_Drawing_Point
    $TextBoxStatusMessage.DataBindings.DefaultDataSourceUpdateMode = 0
    $TextBoxStatusMessage.Name = "TextBoxStatusMessage"

    $form1.Controls.Add($TextBoxStatusMessage)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 158
    $System_Drawing_Size.Height = 16
    $lblSelectedNode.Size = $System_Drawing_Size
    $lblSelectedNode.Text = "Selected Object:"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 25
    $System_Drawing_Point.Y = 575
    $lblSelectedNode.Location = $System_Drawing_Point
    $lblSelectedNode.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblSelectedNode.Name = "lblSelectedNode"

    $form1.Controls.Add($lblSelectedNode)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 158
    $System_Drawing_Size.Height = 16
    $lblStatusBar.Size = $System_Drawing_Size
    $lblStatusBar.Text = "Status Message:"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 25
    $System_Drawing_Point.Y = 615
    $lblStatusBar.Location = $System_Drawing_Point
    $lblStatusBar.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblStatusBar.Name = "lblStatusBar"

    $form1.Controls.Add($lblStatusBar)

    $btnExit.TabIndex = 3
    $btnExit.Name = "btnExit"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 75
    $System_Drawing_Size.Height = 23
    $btnExit.Size = $System_Drawing_Size
    $btnExit.UseVisualStyleBackColor = $True
    $btnExit.Font = $FontSans825B
    $btnExit.Text = "Exit"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 730
    $System_Drawing_Point.Y = 540
    $btnExit.Location = $System_Drawing_Point
    $btnExit.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnExit.add_Click($btnExit_OnClick)

    $form1.Controls.Add($btnExit)

    ################################ Effective Rights Tab ################################

    $chkBoxEffectiveRights.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 200
    $System_Drawing_Size.Height = 30
    $chkBoxEffectiveRights.Size = $System_Drawing_Size
    $chkBoxEffectiveRights.Text = "Enable Effective Rights"
    $chkBoxEffectiveRights.Checked = $false
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 9
    $chkBoxEffectiveRights.Location = $System_Drawing_Point
    $chkBoxEffectiveRights.CheckState = 0
    $chkBoxEffectiveRights.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxEffectiveRights.Name = "chkBoxEffectiveRights"
    $chkBoxEffectiveRights.Add_checkedChanged($chkBoxEffectiveRights_CheckChanged)

    $tabEffectiveR.Controls.Add($chkBoxEffectiveRights)

    $chkBoxEffectiveRightsColor.UseVisualStyleBackColor = $False
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 200
    $System_Drawing_Size.Height = 30
    $chkBoxEffectiveRightsColor.Size = $System_Drawing_Size
    $chkBoxEffectiveRightsColor.Text = "Show color coded criticallity"
    $chkBoxEffectiveRightsColor.Checked = $false
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 285
    $chkBoxEffectiveRightsColor.Location = $System_Drawing_Point
    $chkBoxEffectiveRightsColor.CheckState = 0
    $chkBoxEffectiveRightsColor.DataBindings.DefaultDataSourceUpdateMode = 0
    $chkBoxEffectiveRightsColor.Name = "chkBoxEffectiveRightsColor"
    $chkBoxEffectiveRightsColor.Enabled = $false

    $tabEffectiveR.Controls.Add($chkBoxEffectiveRightsColor)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 250
    $System_Drawing_Size.Height = 45
    $lblEffectiveRightsColor.Size = $System_Drawing_Size
    $lblEffectiveDescText.Font = $FontSans825
    $lblEffectiveRightsColor.Text = "Use colors in report to identify criticality level of permissions.This might help you in implementing Least-Privilege Administrative Models"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 315
    $lblEffectiveRightsColor.Location = $System_Drawing_Point
    $lblEffectiveRightsColor.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblEffectiveRightsColor.Name = "lblEffectiveRightsColor"

    $tabEffectiveR.Controls.Add($lblEffectiveRightsColor)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 250
    $System_Drawing_Size.Height = 55
    $lblEffectiveDescText.Size = $System_Drawing_Size
    $lblEffectiveDescText.Font = $FontSans825
    $lblEffectiveDescText.Text = "Effective Access allows you to view the effective permissions for a user, group, or device account."
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 40
    $lblEffectiveDescText.Location = $System_Drawing_Point
    $lblEffectiveDescText.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblEffectiveDescText.Name = "lblEffectiveDescText"

    $tabEffectiveR.Controls.Add($lblEffectiveDescText)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 250
    $System_Drawing_Size.Height = 30
    $lblEffectiveText.Size = $System_Drawing_Size
    $lblEffectiveText.Font = $FontSans825
    $lblEffectiveText.Text = "Type the account name (samAccountName) for a user, group or computer:"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 100
    $lblEffectiveText.Location = $System_Drawing_Point
    $lblEffectiveText.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblEffectiveText.Name = "lblEffectiveText"

    $tabEffectiveR.Controls.Add($lblEffectiveText)

    $btnGetSPAccount.TabIndex = 9
    $btnGetSPAccount.Name = "btnGetSPAccount"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 95
    $System_Drawing_Size.Height = 23
    $btnGetSPAccount.Size = $System_Drawing_Size
    $btnGetSPAccount.UseVisualStyleBackColor = $True
    $btnGetSPAccount.Font = $FontSans825B
    $btnGetSPAccount.Text = "Get Account"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 175
    $btnGetSPAccount.Location = $System_Drawing_Point
    $btnGetSPAccount.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnGetSPAccount.Enabled = $false
    $btnGetSPAccount.add_Click($btnGetSPAccount_OnClick)

    $tabEffectiveR.Controls.Add($btnGetSPAccount)

    $btnGetSPNReport.TabIndex = 10
    $btnGetSPNReport.Name = "btnGetSPNReport"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 130
    $System_Drawing_Size.Height = 23
    $btnGetSPNReport.Size = $System_Drawing_Size
    $btnGetSPNReport.UseVisualStyleBackColor = $True
    $btnGetSPNReport.Font = $FontSans825B
    $btnGetSPNReport.Text = "View Account"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 260
    $btnGetSPNReport.Location = $System_Drawing_Point
    $btnGetSPNReport.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnGetSPNReport.Enabled = $false
    $btnGetSPNReport.add_Click($btnGetSPNReport_OnClick)

    $tabEffectiveR.Controls.Add($btnGetSPNReport)

    $btnViewLegend.TabIndex = 10
    $btnViewLegend.Name = "btnViewLegend"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 130
    $System_Drawing_Size.Height = 23
    $btnViewLegend.Size = $System_Drawing_Size
    $btnViewLegend.UseVisualStyleBackColor = $True
    $btnViewLegend.Font = $FontSans825B
    $btnViewLegend.Text = "View Color Legend"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 360
    $btnViewLegend.Location = $System_Drawing_Point
    $btnViewLegend.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnViewLegend.Enabled = $false
    $btnViewLegend.add_Click($btnViewLegened_OnClick)

    $tabEffectiveR.Controls.Add($btnViewLegend)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 110
    $System_Drawing_Size.Height = 20
    $lblSelectPrincipalDom.Size = $System_Drawing_Size
    $lblSelectPrincipalDom.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblSelectPrincipalDom.Name = "lblSelectPrincipalDom"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 130
    $lblSelectPrincipalDom.Location = $System_Drawing_Point
    $lblSelectPrincipalDom.Enabled = $true
    $lblSelectPrincipalDom.TextAlign = "MiddleLeft"
    $lblSelectPrincipalDom.Font = $FontSans75B
    $lblSelectPrincipalDom.text = ":"

    $tabEffectiveR.Controls.Add($lblSelectPrincipalDom)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 210
    $System_Drawing_Size.Height = 20
    $txtBoxSelectPrincipal.Size = $System_Drawing_Size
    $txtBoxSelectPrincipal.DataBindings.DefaultDataSourceUpdateMode = 0
    $txtBoxSelectPrincipal.Name = "txtBoxSelectPrincipal"
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 9
    $System_Drawing_Point.Y = 150
    $txtBoxSelectPrincipal.Location = $System_Drawing_Point
    $txtBoxSelectPrincipal.Enabled = $false
    $tabEffectiveR.Controls.Add($txtBoxSelectPrincipal)


    $gBoxEffectiveSelUser.TabIndex = 0
    $gBoxEffectiveSelUser.Name = "gBoxEffectiveSelUser"
    $gBoxEffectiveSelUser.Text = "Selected Security Principal:"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 270
    $System_Drawing_Size.Height = 45
    $gBoxEffectiveSelUser.Size = $System_Drawing_Size
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 210
    $gBoxEffectiveSelUser.Location = $System_Drawing_Point
    $gBoxEffectiveSelUser.DataBindings.DefaultDataSourceUpdateMode = 0

    $tabEffectiveR.Controls.Add($gBoxEffectiveSelUser)

    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 250
    $System_Drawing_Size.Height = 25
    $lblEffectiveSelUser.Size = $System_Drawing_Size
    $lblEffectiveSelUser.Font = $FontSans825B
    $lblEffectiveSelUser.Text = ""
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 3
    $System_Drawing_Point.Y = 15
    $lblEffectiveSelUser.Location = $System_Drawing_Point
    $lblEffectiveSelUser.DataBindings.DefaultDataSourceUpdateMode = 0
    $lblEffectiveSelUser.Name = "lblEffectiveSelUser"

    $gBoxEffectiveSelUser.Controls.Add($lblEffectiveSelUser)


    $btnListLocations.TabIndex = 1
    $btnListLocations.Name = "btnListLocations"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Width = 100
    $System_Drawing_Size.Height = 23
    $btnListLocations.Size = $System_Drawing_Size
    $btnListLocations.UseVisualStyleBackColor = $True
    $btnListLocations.Font = $FontSans825B
    $btnListLocations.Text = "Locations..."
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 120
    $System_Drawing_Point.Y = 175
    $btnListLocations.Location = $System_Drawing_Point
    $btnListLocations.Enabled = $false
    $btnListLocations.DataBindings.DefaultDataSourceUpdateMode = 0
    $btnListLocations.add_Click($btnListLocations_OnClick)


    $tabEffectiveR.Controls.Add($btnListLocations)

    ################################ Effective Rights Tab ################################

    #endregion Generated Form Code

    #Save the initial state of the form
    $InitialFormWindowState = $form1.WindowState
    #Init the OnLoad event to correct the initial state of the form
    $form1.add_Load($OnLoadForm_StateCorrection)
    #Show the Form
    $form1.ShowDialog() | Out-Null

} #End Function

#==========================================================================
# Function		: ConvertTo-ObjectArrayListFromPsCustomObject
# Arguments     : Defined Object
# Returns   	: Custom Object List
# Description   : Convert a defined object to a custom, this will help you  if you got a read-only object
#
#==========================================================================
function ConvertTo-ObjectArrayListFromPsCustomObject {
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )] $psCustomObject
    );

    process {

        $myCustomArray = New-Object System.Collections.ArrayList

        foreach ($myPsObject in $psCustomObject) {
            $hashTable = @{};
            $myPsObject | Get-Member -MemberType *Property | ForEach-Object {
                $hashTable.($_.name) = $myPsObject.($_.name);
            }
            $Newobject = new-object psobject -Property  $hashTable
            [void]$myCustomArray.add($Newobject)
        }
        return $myCustomArray
    }
}
#==========================================================================
# Function		: GetDomainController
# Arguments     : Domain FQDN,bol using creds, PSCredential
# Returns   	: Domain Controller
# Description   : Locate a domain controller in a specified domain
#==========================================================================
Function GetDomainController {
    Param([string] $strDomainFQDN,
        [bool] $bolCreds,
        [parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $Creds)

    $strDomainController = ""

    if ($bolCreds -eq $true) {

        $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $strDomainFQDN, $Creds.UserName, $Creds.GetNetworkCredential().Password)
        $ojbDomain = [DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
        $strDomainController = $($ojbDomain.FindDomainController()).name
    }
    else {

        $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("Domain", $strDomainFQDN )
        $ojbDomain = [DirectoryServices.ActiveDirectory.Domain]::GetDomain($Context)
        $strDomainController = $($ojbDomain.FindDomainController()).name
    }

    return $strDomainController

}
#==========================================================================
# Function		: GenerateDomainPicker
# Arguments     : -
# Returns   	: Domain DistinguishedName
# Description   : Windows Form List AD Domains in Forest
#==========================================================================
Function GenerateDomainPicker {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $objForm = New-Object System.Windows.Forms.Form
    $objForm.Text = "Select a Domain"
    $objForm.Size = New-Object System.Drawing.Size(400, 200)
    $objForm.StartPosition = "CenterScreen"

    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown( { if ($_.KeyCode -eq "Enter")
            { $x = $objListBoxDomainList.SelectedItem; $objForm.Close() } })
    $objForm.Add_KeyDown( { if ($_.KeyCode -eq "Escape")
            { $objForm.Close() } })

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(75, 120)
    $OKButton.Size = New-Object System.Drawing.Size(75, 23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click( { $global:strDommainSelect = $objListBoxDomainList.SelectedItem; $objForm.Close() })
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(150, 120)
    $CancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click( { $objForm.Close() })
    $objForm.Controls.Add($CancelButton)

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10, 20)
    $objLabel.Size = New-Object System.Drawing.Size(300, 20)
    $objLabel.Text = "Please select a domain:"
    $objForm.Controls.Add($objLabel)

    $objListBoxDomainList = New-Object System.Windows.Forms.ListBox
    $objListBoxDomainList.Location = New-Object System.Drawing.Size(10, 40)
    $objListBoxDomainList.Size = New-Object System.Drawing.Size(300, 20)
    $objListBoxDomainList.Height = 80


    $Config = ([adsi]"LDAP://rootdse").ConfigurationNamingContext
    $dse = [adsi]"LDAP://CN=Partitions,$config"

    $searcher = new-object System.DirectoryServices.DirectorySearcher($dse)
    [void]$searcher.PropertiesToLoad.("cn", "name", "trustParent", "nETBIOSName", "nCName")
    $searcher.filter = "(&(cn=*))"
    $colResults = $searcher.FindAll()
    $intCounter = 0

   	foreach ($objResult in $colResults) {
        $objExtendedRightsObject = $objResult.Properties
        if ( $objExtendedRightsObject.item("systemflags") -eq 3) {
            $strNetbios = $($objExtendedRightsObject.item("nETBIOSName"))
            $strDN = $($objExtendedRightsObject.item("nCName"))
            [void] $objListBoxDomainList.Items.Add($strDN)
        }
    }

    $objForm.Controls.Add($objListBoxDomainList)

    $objForm.Topmost = $True

    $objForm.Add_Shown( { $objForm.Activate() })
    [void] $objForm.ShowDialog()


}

#==========================================================================
# Function		: GenerateTrustedDomainPicker
# Arguments     : -
# Returns   	: Trusted Domain DistinguishedName
# Description   : Windows Form List AD Domains trusted by this Domain
#==========================================================================
Function GenerateTrustedDomainPicker {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

    $global:strPrinDomDir = ""

    $objForm = New-Object System.Windows.Forms.Form
    $objForm.Text = "Locations"
    $objForm.Size = New-Object System.Drawing.Size(400, 200)
    $objForm.StartPosition = "CenterScreen"

    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown( { if ($_.KeyCode -eq "Enter")
            { $x = $objListBoxDomainList.SelectedItem; $objForm.Close() } })
    $objForm.Add_KeyDown( { if ($_.KeyCode -eq "Escape")
            { $objForm.Close() } })

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Size(75, 120)
    $OKButton.Size = New-Object System.Drawing.Size(75, 23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click( {
            $global:strDomainPrinDNName = $objListBoxDomainList.SelectedItem

            if ( $global:strDomainPrinDNName -eq $global:strDomainLongName ) {
                $lblSelectPrincipalDom.text = $global:strDomainShortName + ":"
            }
            else {
                $dse = ([adsi]"LDAP://$global:strDC/CN=System,$global:strDomainDNName")


                $searcher = new-object System.DirectoryServices.DirectorySearcher($dse)
                [void]$searcher.PropertiesToLoad.("cn", "name", "trustParent", "nETBIOSName", "nCName")
                $searcher.filter = "(&(trustPartner=$global:strDomainPrinDNName))"
                $colResults = $searcher.FindOne()
                $intCounter = 0

                if ($colResults) {
                    $objExtendedRightsObject = $colResults.Properties
                    $global:strPrinDomDir = $objExtendedRightsObject.item("trustDirection")
                    $global:strPrinDomAttr = "{0:X2}" -f [int]  $objExtendedRightsObject.item("trustAttributes")[0]
                    $global:strPrinDomFlat = $objExtendedRightsObject.item("flatname")
                    $lblSelectPrincipalDom.text = $global:strPrinDomFlat + ":"
                }
            }
            $objForm.Close() })
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(150, 120)
    $CancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click( { $objForm.Close() })
    $objForm.Controls.Add($CancelButton)

    $objLabel = New-Object System.Windows.Forms.Label
    $objLabel.Location = New-Object System.Drawing.Size(10, 20)
    $objLabel.Size = New-Object System.Drawing.Size(300, 20)
    $objLabel.Text = "Select the location you want to search."
    $objForm.Controls.Add($objLabel)

    $objListBoxDomainList = New-Object System.Windows.Forms.ListBox
    $objListBoxDomainList.Location = New-Object System.Drawing.Size(10, 40)
    $objListBoxDomainList.Size = New-Object System.Drawing.Size(300, 20)
    $objListBoxDomainList.Height = 80



    $dse = ([adsi]"LDAP://$global:strDC/CN=System,$global:strDomainDNName")


    $searcher = new-object System.DirectoryServices.DirectorySearcher($dse)
    [void]$searcher.PropertiesToLoad.("cn", "name", "trustParent", "nETBIOSName", "nCName")
    $searcher.filter = "(&(cn=*))"
    $colResults = $searcher.FindAll()
    $intCounter = 0

   	foreach ($objResult in $colResults) {
        $objExtendedRightsObject = $objResult.Properties
        if ( $objExtendedRightsObject.item("trustDirection") -gt 1) {
            $strNetbios = $($objExtendedRightsObject.item("flatName"))
            $strDN = $($objExtendedRightsObject.item("trustPartner"))
            [void] $objListBoxDomainList.Items.Add($strDN)
        }
    }
    [void] $objListBoxDomainList.Items.Add($global:strDomainLongName)
    $objForm.Controls.Add($objListBoxDomainList)

    $objForm.Topmost = $True

    $objForm.Add_Shown( { $objForm.Activate() })
    [void] $objForm.ShowDialog()


}

Function BuildSchemaDic {
    $global:dicSchemaIDGUIDs = @{"BF967ABA-0DE6-11D0-A285-00AA003049E2" = "user"; `
            "BF967A86-0DE6-11D0-A285-00AA003049E2"                      = "computer"; `
            "BF967A9C-0DE6-11D0-A285-00AA003049E2"                      = "group"; `
            "BF967ABB-0DE6-11D0-A285-00AA003049E2"                      = "volume"; `
            "F30E3BBE-9FF0-11D1-B603-0000F80367C1"                      = "gPLink"; `
            "F30E3BBF-9FF0-11D1-B603-0000F80367C1"                      = "gPOptions"; `
            "BF967AA8-0DE6-11D0-A285-00AA003049E2"                      = "printQueue"; `
            "4828CC14-1437-45BC-9B07-AD6F015E5F28"                      = "inetOrgPerson"; `
            "5CB41ED0-0E4C-11D0-A286-00AA003049E2"                      = "contact"; `
            "BF967AA5-0DE6-11D0-A285-00AA003049E2"                      = "organizationalUnit"; `
            "BF967A0A-0DE6-11D0-A285-00AA003049E2"                      = "pwdLastSet"
    }
    $global:dicSpecialIdentities = @{"S-1-0" = "Null Authority"; `
            "S-1-0-0"                        = "Nobody"; `
            "S-1-1"                          = "World Authority"; `
            "S-1-1-0"                        = "Everyone"; `
            "S-1-2"                          = "Local Authority"; `
            "S-1-2-0"                        = "Local "; `
            "S-1-2-1"                        = "Console Logon "; `
            "S-1-3"                          = "Creator Authority"; `
            "S-1-3-0"                        = "Creator Owner"; `
            "S-1-3-1"                        = "Creator Group"; `
            "S-1-3-2"                        = "Creator Owner Server"; `
            "S-1-3-3"                        = "Creator Group Server"; `
            "S-1-3-4"                        = "Owner Rights"; `
            "S-1-4"                          = "Non-unique Authority"; `
            "S-1-5"                          = "NT Authority"; `
            "S-1-5-1"                        = "Dialup"; `
            "S-1-5-2"                        = "Network"; `
            "S-1-5-3"                        = "Batch"; `
            "S-1-5-4"                        = "Interactive"; `
            "S-1-5-6"                        = "Service"; `
            "S-1-5-7"                        = "Anonymous"; `
            "S-1-5-8"                        = "Proxy"; `
            "S-1-5-9"                        = "Enterprise Domain Controllers"; `
            "S-1-5-10"                       = "Principal Self"; `
            "S-1-5-11"                       = "Authenticated Users"; `
            "S-1-5-12"                       = "Restricted Code"; `
            "S-1-5-13"                       = "Terminal Server Users"; `
            "S-1-5-14"                       = "Remote Interactive Logon"; `
            "S-1-5-15"                       = "This Organization"; `
            "S-1-5-17"                       = "IUSR"; `
            "S-1-5-18"                       = "Local System"
    }

    $global:dicNameToSchemaIDGUIDs = @{"user" = "BF967ABA-0DE6-11D0-A285-00AA003049E2"; `
            "computer"                        = "BF967A86-0DE6-11D0-A285-00AA003049E2"; `
            "group"                           = "BF967A9C-0DE6-11D0-A285-00AA003049E2"; `
            "volume"                          = "BF967ABB-0DE6-11D0-A285-00AA003049E2"; `
            "gPLink"                          = "F30E3BBE-9FF0-11D1-B603-0000F80367C1"; `
            "gPOptions"                       = "F30E3BBF-9FF0-11D1-B603-0000F80367C1"; `
            "printQueue"                      = "BF967AA8-0DE6-11D0-A285-00AA003049E2"; `
            "inetOrgPerson"                   = "4828CC14-1437-45BC-9B07-AD6F015E5F28"; `
            "contact"                         = "5CB41ED0-0E4C-11D0-A286-00AA003049E2"; `
            "organizationalUnit"              = "BF967AA5-0DE6-11D0-A285-00AA003049E2"; `
            "pwdLastSet"                      = "BF967A0A-0DE6-11D0-A285-00AA003049E2"
    }
}
BuildSchemaDic
$global:dicRightsGuids = @{"Seed" = "xxx" }
$global:dicSidToName = @{"Seed" = "xxx" }
$global:dicDCSpecialSids = @{"BUILTIN\Incoming Forest Trust Builders" = "S-1-5-32-557"; `
        "BUILTIN\Account Operators"                                   = "S-1-5-32-548"; `
        "BUILTIN\Server Operators"                                    = "S-1-5-32-549"; `
        "BUILTIN\Pre-Windows 2000 Compatible Access"                  = "S-1-5-32-554"; `
        "BUILTIN\Terminal Server License Servers"                     = "S-1-5-32-561"; `
        "BUILTIN\Windows Authorization Access Group"                  = "S-1-5-32-560"
}
$global:dicWellKnownSids = @{"S-1-0" = "Null Authority"; `
        "S-1-0-0"                    = "Nobody"; `
        "S-1-1"                      = "World Authority"; `
        "S-1-1-0"                    = "Everyone"; `
        "S-1-2"                      = "Local Authority"; `
        "S-1-2-0"                    = "Local "; `
        "S-1-2-1"                    = "Console Logon "; `
        "S-1-3"                      = "Creator Authority"; `
        "S-1-3-0"                    = "Creator Owner"; `
        "S-1-3-1"                    = "Creator Group"; `
        "S-1-3-2"                    = "Creator Owner Server"; `
        "S-1-3-3"                    = "Creator Group Server"; `
        "S-1-3-4"                    = "Owner Rights"; `
        "S-1-4"                      = "Non-unique Authority"; `
        "S-1-5"                      = "NT Authority"; `
        "S-1-5-1"                    = "Dialup"; `
        "S-1-5-2"                    = "Network"; `
        "S-1-5-3"                    = "Batch"; `
        "S-1-5-4"                    = "Interactive"; `
        "S-1-5-6"                    = "Service"; `
        "S-1-5-7"                    = "Anonymous"; `
        "S-1-5-8"                    = "Proxy"; `
        "S-1-5-9"                    = "Enterprise Domain Controllers"; `
        "S-1-5-10"                   = "Principal Self"; `
        "S-1-5-11"                   = "Authenticated Users"; `
        "S-1-5-12"                   = "Restricted Code"; `
        "S-1-5-13"                   = "Terminal Server Users"; `
        "S-1-5-14"                   = "Remote Interactive Logon"; `
        "S-1-5-15"                   = "This Organization"; `
        "S-1-5-17"                   = "IUSR"; `
        "S-1-5-18"                   = "Local System"; `
        "S-1-5-19"                   = "NT Authority"; `
        "S-1-5-20"                   = "NT Authority"; `
        "S-1-5-22"                   = "ENTERPRISE READ-ONLY DOMAIN CONTROLLERS BETA"; `
        "S-1-5-32-544"               = "Administrators"; `
        "S-1-5-32-545"               = "Users"; `
        "S-1-5-32-546"               = "Guests"; `
        "S-1-5-32-547"               = "Power Users"; `
        "S-1-5-32-548"               = "BUILTIN\Account Operators"; `
        "S-1-5-32-549"               = "Server Operators"; `
        "S-1-5-32-550"               = "Print Operators"; `
        "S-1-5-32-551"               = "Backup Operators"; `
        "S-1-5-32-552"               = "Replicator"; `
        "S-1-5-32-554"               = "BUILTIN\Pre-Windows 2000 Compatible Access"; `
        "S-1-5-32-555"               = "BUILTIN\Remote Desktop Users"; `
        "S-1-5-32-556"               = "BUILTIN\Network Configuration Operators"; `
        "S-1-5-32-557"               = "BUILTIN\Incoming Forest Trust Builders"; `
        "S-1-5-32-558"               = "BUILTIN\Performance Monitor Users"; `
        "S-1-5-32-559"               = "BUILTIN\Performance Log Users"; `
        "S-1-5-32-560"               = "BUILTIN\Windows Authorization Access Group"; `
        "S-1-5-32-561"               = "BUILTIN\Terminal Server License Servers"; `
        "S-1-5-32-562"               = "BUILTIN\Distributed COM Users"; `
        "S-1-5-32-568"               = "BUILTIN\IIS_IUSRS"; `
        "S-1-5-32-569"               = "BUILTIN\Cryptographic Operators"; `
        "S-1-5-32-573"               = "BUILTIN\Event Log Readers "; `
        "S-1-5-32-574"               = "BUILTIN\Certificate Service DCOM Access"; `
        "S-1-5-32-575"               = "BUILTIN\RDS Remote Access Servers"; `
        "S-1-5-32-576"               = "BUILTIN\RDS Endpoint Servers"; `
        "S-1-5-32-577"               = "BUILTIN\RDS Management Servers"; `
        "S-1-5-32-578"               = "BUILTIN\Hyper-V Administrators"; `
        "S-1-5-32-579"               = "BUILTIN\Access Control Assistance Operators"; `
        "S-1-5-32-580"               = "BUILTIN\Remote Management Users"; `
        "S-1-5-64-10"                = "NTLM Authentication"; `
        "S-1-5-64-14"                = "SChannel Authentication"; `
        "S-1-5-64-21"                = "Digest Authentication"; `
        "S-1-5-80"                   = "NT Service"; `
        "S-1-16-0"                   = "Untrusted Mandatory Level"; `
        "S-1-16-4096"                = "Low Mandatory Level"; `
        "S-1-16-8192"                = "Medium Mandatory Level"; `
        "S-1-16-8448"                = "Medium Plus Mandatory Level"; `
        "S-1-16-12288"               = "High Mandatory Level"; `
        "S-1-16-16384"               = "System Mandatory Level"; `
        "S-1-16-20480"               = "Protected Process Mandatory Level"; `
        "S-1-16-28672"               = "Secure Process Mandatory Level"
}
#==========================================================================
# Function		: Get-Forest
# Arguments     : string domain controller,credentials
# Returns   	: Forest
# Description   : Get AD Forest
#==========================================================================
function Get-Forest {
    Param($DomainController, [Management.Automation.PSCredential]$Credential)
    if (!$DomainController) {
        [DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
        return
    }
    if ($Creds) {
        $Context = new-object DirectoryServices.ActiveDirectory.DirectoryContext("DirectoryServer", $DomainController, $Creds.UserName, $Creds.GetNetworkCredential().Password)
    }
    else {
        $Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("DirectoryServer", $DomainController)
    }
    $ojbForest = [DirectoryServices.ActiveDirectory.Forest]::GetForest($Context)

    return $ojbForest
}
#==========================================================================
# Function		: TestCreds
# Arguments     : System.Management.Automation.PSCredential
# Returns   	: Boolean
# Description   : Check If username and password is valid
#==========================================================================
Function TestCreds {
    Param([System.Management.Automation.PSCredential] $psCred)

    [void][reflection.assembly]::LoadWithPartialName("System.DirectoryServices.AccountManagement")

    if ($psCred.UserName -match "\\") {
        If ($psCred.UserName.split("\")[0] -eq "") {
            [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)

            $ctx = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $root.name)
        }
        else {

            $ctx = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $psCred.UserName.split("\")[0])
        }
        $bolValid = $ctx.ValidateCredentials($psCred.UserName.split("\")[1], $psCred.GetNetworkCredential().Password)
    }
    else {
        [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)

        $ctx = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $root.name)

        $bolValid = $ctx.ValidateCredentials($psCred.UserName, $psCred.GetNetworkCredential().Password)
    }

    return $bolValid
}
#==========================================================================
# Function		: GetTokenGroups
# Arguments     : Principal DistinguishedName string
# Returns   	: ArrayList of groups names
# Description   : Group names of all sids in tokenGroups
#==========================================================================
Function GetTokenGroups {
    Param($PrincipalDN,
        [bool] $bolCreds,
        [parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $Creds)


    $script:bolErr = $false
    $tokenGroups = New-Object System.Collections.ArrayList

    $tokenGroups.Clear()
    if ($bolCreds -eq $true) {

        $objADObject = new-object DirectoryServices.DirectoryEntry("LDAP://$global:strPinDomDC/$PrincipalDN", $Creds.UserName, $Creds.GetNetworkCredential().Password)

    }
    else {

        $objADObject = new-object DirectoryServices.DirectoryEntry("LDAP://$global:strPinDomDC/$PrincipalDN")

    }
    if ( $global:strDomainPrinDNName -eq $global:strDomainDNName ) {
        $objADObject.psbase.RefreshCache("tokenGroups")
        $SIDs = $objADObject.psbase.Properties.Item("tokenGroups")
    }
    else {
        $objADObject.psbase.RefreshCache("tokenGroupsGlobalandUniversal")
        $SIDs = $objADObject.psbase.Properties.Item("tokenGroupsGlobalandUniversal")
    }
    $ownerSIDs = $objADObject.psbase.Properties.Item("objectSID").tostring()
    # Populate hash table with security group memberships.


    $arrForeignSecGroups = FindForeignSecPrinMemberships $global:strDomainDNName $global:strDC $(GenerateSearchAbleSID $ownerSIDs)

    foreach ($ForeignMemb in $arrForeignSecGroups) {
        if ($null -ne $ForeignMemb ) {
            if ($ForeignMemb.tostring().length -gt 0 ) {
                [void]$tokenGroups.add($ForeignMemb)
            }
        }
    }



    ForEach ($Value In $SIDs) {



        $SID = New-Object System.Security.Principal.SecurityIdentifier $Value, 0


        # Translate into "pre-Windows 2000" name.
        & { #Try
            $Script:Group = $SID.Translate([System.Security.Principal.NTAccount])
        }
        Trap [SystemException] {
            $script:bolErr = $true
            $script:sidstring = GetSidStringFromSidByte $Value
            continue
        }
        if ($script:bolErr -eq $false) {

            [void]$tokenGroups.Add($Script:Group.Value)
        }
        else {

            [void]$tokenGroups.Add($script:sidstring)
            $script:bolErr = $false
        }

        $arrForeignSecGroups = FindForeignSecPrinMemberships $global:strDomainDNName $global:strDC $(GenerateSearchAbleSID $Value)

        foreach ($ForeignMemb in $arrForeignSecGroups) {
            if ($null -ne $ForeignMemb ) {
                if ($ForeignMemb.tostring().length -gt 0 ) {
                    [void]$tokenGroups.add($ForeignMemb)
                }
            }
        }

    }

    [void]$tokenGroups.Add("Everyone")
    [void]$tokenGroups.Add("NT AUTHORITY\Authenticated Users")
    if (($global:strPrinDomAttr -eq 14) -or ($global:strPrinDomAttr -eq 18) -or ($global:strPrinDomAttr -eq "5C") -or ($global:strPrinDomAttr -eq "1C") -or ($global:strPrinDomAttr -eq "44") -or ($global:strPrinDomAttr -eq "54") -or ($global:strPrinDomAttr -eq "50")) {
        [void]$tokenGroups.Add("NT AUTHORITY\Other Organization")
    }
    else {
        [void]$tokenGroups.Add("NT AUTHORITY\This Organization")
    }
    Return $tokenGroups

}
#==========================================================================
# Function		: GenerateSearchAbleSID
# Arguments     : SID Decimal form Value as string
# Returns   	: SID in String format for LDAP searcheds
# Description   : Convert SID from decimal to hex with "\" for searching with LDAP
#==========================================================================
Function GenerateSearchAbleSID {
    Param([String] $SidValue)

    $SidDec = $SidValue.tostring().split("")
    Foreach ($intSID in $SIDDec) {
        [string] $SIDHex = "{0:X2}" -f [int] $intSID
        $strSIDHextString = $strSIDHextString + "\" + $SIDHex

    }

    return $strSIDHextString
}
#==========================================================================
# Function		: FindForeignSecPrinMemberships
# Arguments     : SID Decimal form Value as string
# Returns   	: SID in String format for LDAP searcheds
# Description   : Convert SID from decimal to hex with "\" for searching with LDAP
#==========================================================================
Function FindForeignSecPrinMemberships {
    Param([string] $strLocalDomDN, [string] $strDC, [string] $strSearchAbleSID)

    $arrForeignMembership = New-Object System.Collections.ArrayList
    [void]$arrForeignMembership.clear()
    $domaininfo = new-object DirectoryServices.DirectoryEntry("LDAP://$strDC/CN=ForeignSecurityPrincipals,$strLocalDomDN")

    $srch = New-Object System.DirectoryServices.DirectorySearcher($domaininfo)

    $srch.SizeLimit = 100
    $strFilter = "(&(objectSID=$strSearchAbleSID))"
    $srch.Filter = $strFilter
    $srch.SearchScope = "Subtree"
    $res = $srch.FindOne()
    if ($res) {
        $objPrincipal = $res.GetDirectoryEntry()

        $objPrincipal.psbase.RefreshCache("memberof")
        Foreach ($member in @($objPrincipal.psbase.Properties.Item("memberof"))) {
            $objmember = new-object DirectoryServices.DirectoryEntry("LDAP://$strDC/$member")

            $objmember.psbase.RefreshCache("msDS-PrincipalName")
            $strPrinName = $($objmember.psbase.Properties.Item("msDS-PrincipalName"))
            if (($strPrinName -eq "") -or ($null -eq $strPrinName)) {
                $strNETBIOSNAME = $global:strPrinDomFlat
                $strPrinName = "$strNETBIOSNAME\$($objmember.psbase.Properties.Item("samAccountName"))"
            }
            [void]$arrForeignMembership.add($strPrinName)
        }


    }
    return $arrForeignMembership
}
#==========================================================================
# Function		: GetSidStringFromSidByte
# Arguments     : SID Value in Byte[]
# Returns   	: SID in String format
# Description   : Convert SID from Byte[] to String
#==========================================================================
Function GetSidStringFromSidByte {
    Param([byte[]] $SidByte)

    $objectSid = [byte[]]$SidByte
    $sid = New-Object System.Security.Principal.SecurityIdentifier($objectSid, 0)
    $sidString = ($sid.value).ToString()
    return $sidString
}
#==========================================================================
# Function		: GetSecPrinDN
# Arguments     : samAccountName
# Returns   	: DistinguishedName
# Description   : Search Security Principal and Return DistinguishedName
#==========================================================================
Function GetSecPrinDN {
    Param([string] $samAccountName,
        [string] $strDomainDN,
        [bool] $bolCreds,
        [parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential] $Creds)


    if ($bolCreds -eq $true) {


        $domaininfo = new-object DirectoryServices.DirectoryEntry("LDAP://$strDomainDN", $Creds.UserName, $Creds.GetNetworkCredential().Password)

    }
    else {

        $domaininfo = new-object DirectoryServices.DirectoryEntry("LDAP://$strDomainDN")
    }
    $srch = New-Object System.DirectoryServices.DirectorySearcher($domaininfo)

    $srch.SizeLimit = 100
    $strFilter = "(&(samAccountName=$samAccountName))"
    $srch.Filter = $strFilter
    $srch.SearchScope = "Subtree"
    $res = $srch.FindOne()
    if ($res) {
        $objPrincipal = $res.GetDirectoryEntry()
        $global:strPrincipalDN = $objPrincipal.distinguishedName
    }
    else {
        $global:strPrincipalDN = ""
    }

    return $global:strPrincipalDN

}


#==========================================================================
# Function		: GetSchemaObjectGUID
# Arguments     : Object Guid or Rights Guid
# Returns   	: LDAPDisplayName or DisplayName
# Description   : Searches in the dictionaries(Hash) dicRightsGuids and $global:dicSchemaIDGUIDs  and in Schema
#				for the name of the object or Extended Right, if found in Schema the dicRightsGuids is updated.
#				Then the functions return the name(LDAPDisplayName or DisplayName).
#==========================================================================
Function GetSchemaObjectGUID {
    Param([string] $Domain)
    [string] $strOut = ""
    [string] $objSchemaRecordset = ""
    [string] $strLDAPname = ""

    [void]$combObjectFilter.Items.Clear()
    BuildSchemaDic
    foreach ($ldapDisplayName in $global:dicSchemaIDGUIDs.values) {
        [void]$combObjectFilter.Items.Add($ldapDisplayName)
    }
			 if ($Domain -eq "") {
        # Connect to RootDSE
        $rootDSE = [ADSI]"LDAP://$global:strDC/RootDSE"
        #Connect to the Configuration Naming Context
        $schemaSearchRoot = [ADSI]("LDAP://$global:strDC/" + $rootDSE.Get("schemaNamingContext"))
			 }
			 else {
        $rootDSE = [ADSI]"LDAP://$global:strDC/$Domain"
        $schemaSearchRoot = [ADSI]("LDAP://$global:strDC/" + $rootDSE.Get("objectCategory"))
        $schemaSearchRoot = $schemaSearchRoot.path.replace("LDAP://$global:strDC/CN=Domain-DNS,", "")
        $schemaSearchRoot = [ADSI]("LDAP://$global:strDC/" + $schemaSearchRoot)
			 }
			 $searcher = new-object System.DirectoryServices.DirectorySearcher($schemaSearchRoot)
			 $searcher.PropertiesToLoad.addrange(('cn', 'name', 'distinguishedNAme', 'lDAPDisplayName', 'schemaIDGUID'))
			 $searcher.PageSize = 1000
    $searcher.filter = "(&(schemaIDGUID=*))"
			 $colResults = $searcher.FindAll()
    $intCounter = 0


		 	foreach ($objResult in $colResults) {
        $objSchemaObject = $objResult.Properties
        $strLDAPname = $objSchemaObject.item("lDAPDisplayName")[0]
        $guidGUID = [System.GUID]$objSchemaObject.item("schemaIDGUID")[0]
        $strGUID = $guidGUID.toString().toUpper()
        If (!($global:dicSchemaIDGUIDs.ContainsKey($strGUID))) {
            $global:dicSchemaIDGUIDs.Add($strGUID, $strLDAPname)
            $global:dicNameToSchemaIDGUIDs.Add($strLDAPname, $strGUID)
            [void]$combObjectFilter.Items.Add($strLDAPname)
        }

			 }

    return $strOut
}

#==========================================================================
# Function		: Get-ADSchemaClass
# Arguments     : string class,string domain controller,credentials
# Returns   	: Class Object
# Description   : Get AD Schema Class
#==========================================================================
function Get-ADSchemaClass {
    Param($Class = ".*")

    $ADSchemaClass = $global:Forest.Schema.FindAllClasses() | Where-Object { $_.Name -match "^$Class`$" }

    return $ADSchemaClass
}



#==========================================================================
# Function		: CheckDNExist
# Arguments     : string distinguishedName
# Returns   	: Boolean
# Description   : Check If distinguishedName exist
#==========================================================================
function CheckDNExist {
    Param (
        $sADobjectName
    )
    $sADobjectName = "LDAP://" + $sADobjectName
    $ADobject = [ADSI] $sADobjectName
    If ($null -eq $ADobject.distinguishedName)
    { return $false }
    else
    { return $true }

}
#==========================================================================
# Function		: ReverseString
# Arguments     : string
# Returns   	: string backwards
# Description   : Turn a string backwards
#==========================================================================
Function ReverseString {

    param ($string)
    ForEach ($char in $string) {
        ([regex]::Matches($char, '.', 'RightToLeft') | ForEach-Object { $_.value }) -join ''
    }

}


#==========================================================================
# Function		: GetAllChildNodes
# Arguments     : Node distinguishedName
# Returns   	: List of Nodes
# Description   : Search for a Node and returns distinguishedName
#==========================================================================
function GetAllChildNodes {
    param ($firstnode,
        [boolean] $bolSubtree)
    $nodelist = New-Object System.Collections.ArrayList
    $nodelist2 = New-Object System.Collections.ArrayList
    $nodelist.Clear()
    $nodelist2.Clear()
    # Add all Children found as Sub Nodes to the selected TreeNode

    $strFilterAll = "(&(objectClass=*))"
    $strFilterContainer = "(&(|(objectClass=organizationalUnit)(objectClass=container)(objectClass=DomainDNS)(objectClass=dMD)))"
    $strFilterOU = "(&(|(objectClass=organizationalUnit)(objectClass=DomainDNS)(objectClass=dMD)))"
    $srch = New-Object System.DirectoryServices.DirectorySearcher

    if ($firstnode -match "/") {
        $firstnode = $firstnode.Replace("/", "\/")
    }

    $srch.SearchRoot = "LDAP://$firstnode"
    If ($rdbScanAll.checked -eq $true) {
        $srch.Filter = $strFilterAll
    }
    If ($rdbScanOU.checked -eq $true) {
        $srch.Filter = $strFilterOU
    }
    If ($rdbScanContainer.checked -eq $true) {
        $srch.Filter = $strFilterContainer
    }
    if ($bolSubtree -eq $true) {
        $srch.SearchScope = "Subtree"
    }
    else {
        $srch.SearchScope = "onelevel"
    }
    $srch.PageSize = 1000
    $srch.PropertiesToLoad.addrange(('cn', 'distinguishedNAme'))
    foreach ($res in $srch.FindAll()) {
        $oNode = $res.GetDirectoryEntry()
        [void] $nodelist.Add($(ReverseString -String $oNode.distinguishedName))
    }
    if ($bolSubtree -eq $false) {
        [void] $nodelist.Add($(ReverseString -String $firstnode))
    }
    foreach ($bkwrNode in $($nodelist | Sort-Object)) {
        [void] $nodelist2.Add($(ReverseString -String $bkwrNode))

    }

    return $nodelist2

}
#==========================================================================
# Function		: Get-DomainDNfromFQDN
# Arguments     : Domain FQDN
# Returns   	: Domain DN
# Description   : Take domain FQDN as input and returns Domain name
#                  in DN
#==========================================================================
function Get-DomainDNfromFQDN {
    Param($strDomainFQDN)

    $strADObjectDNModified = $strDomainFQDN.tostring().Replace(".", ",DC=")

    $strDomDN = "DC=" + $strADObjectDNModified


    return $strDomDN
}

#==========================================================================
# Function		: Get-DomainDN
# Arguments     : string AD object distinguishedName
# Returns   	: Domain DN
# Description   : Take dinstinguishedName as input and returns Domain name
#                  in DN
#==========================================================================
function Get-DomainDN {
    Param($strADObjectDN)

    $strADObjectDNModified = $strADObjectDN.Replace(",DC=", "*")

    [array]$arrDom = $strADObjectDNModified.split("*")
    $intSplit = ($arrDom).count - 1
    $strDomDN = ""
    for ($i = $intSplit; $i -ge 1; $i-- ) {
        if ($i -eq 1) {
            $strDomDN = "DC=" + $arrDom[$i] + $strDomDN
        }
        else {
            $strDomDN = ",DC=" + $arrDom[$i] + $strDomDN
        }
    }

    return $strDomDN
}

#==========================================================================
# Function		: Get-DomainFQDN
# Arguments     : string AD object distinguishedName
# Returns   	: Domain FQDN
# Description   : Take dinstinguishedName as input and returns Domain name
#                  in FQDN
#==========================================================================
function Get-DomainFQDN {
    Param($strADObjectDN)

    $strADObjectDNModified = $strADObjectDN.Replace(",DC=", "*")

    [array]$arrDom = $strADObjectDNModified.split("*")
    $intSplit = ($arrDom).count - 1
    $strDomName = ""
    for ($i = $intSplit; $i -ge 1; $i-- ) {
        if ($i -eq $intSplit) {
            $strDomName = $arrDom[$i] + $strDomName
        }
        else {
            $strDomName = $arrDom[$i] + "." + $strDomName
        }
    }

    return $strDomName
}
#==========================================================================
# Function		: GetDomainShortName
# Arguments     : domain name
# Returns   	: N/A
# Description   : Search for short domain name
#==========================================================================
function GetDomainShortName {
    Param($strDomain,
        [string]$strForestDN)

    $objDomain = [ADSI]"LDAP://$global:strDC/$strDomain"

    $ReturnShortName = ""


    $strRootPath = "LDAP://$global:strDC/CN=Partitions,CN=Configuration,$strForestDN"

    $root = [ADSI]$strRootPath

    $ads = New-Object System.DirectoryServices.DirectorySearcher($root)
    $ads.PropertiesToLoad.addrange(('cn', 'distinguishedNAme', 'nETBIOSName'))
    $ads.filter = "(&(objectClass=crossRef)(nCName=$strDomain))"
    $s = $ads.FindOne()
    If ($s) {
        $ReturnShortName = $s.GetDirectoryEntry().nETBIOSName
    }
    else {
        $ReturnShortName = ""
    }
    return $ReturnShortName
}
#==========================================================================
# Function		: GetNCShortName
# Arguments     : AD NamingContext distinguishedName
# Returns   	: N/A
# Description   : Return CN of NC
#==========================================================================
function GetNCShortName {
    Param($strNode)
    $objNC = [ADSI]"LDAP://$global:strDC/$strNode"
    Switch -regex ($objNC.objectCategory) {
        "CN=Domain-DNS,CN=Schema,CN=Configuration"
        { [string]$strNCcn = $objNC.name }
        "CN=Configuration,CN=Schema,CN=Configuration"
        { [string]$strNCcn = $objNC.cn }
        "CN=DMD,CN=Schema,CN=Configuration"
        { [string]$strNCcn = $objNC.cn }
    }
    return $strNCcn
}

#==========================================================================
# Function		: Check-PermDef
# Arguments     : Trustee Name,Right,Allow/Deny,object guid,Inheritance,Inheritance object guid
# Returns   	: Boolean
# Description   : Compares the Security Descriptor with the DefaultSecurity
#==========================================================================
Function Check-PermDef {
    Param($objNodeDefSD,
        [string]$strTrustee,
        [string]$adRights,
        [string]$InheritanceType,
        [string]$ObjectTypeGUID,
        [string]$InheritedObjectTypeGUID,
        [string]$ObjectFlags,
        [string]$AccessControlType,
        [string]$IsInherited,
        [string]$InheritedFlags,
        [string]$PropFlags)
    $SDResult = $false
    $Identity = "$strTrustee"

    $sdOUDef = $objNodeDefSD | ForEach-Object { $_.DefaultObjectSecurityDescriptor } | ForEach-Object { $objNodeDefSD.DefaultObjectSecurityDescriptor.access }
    $index = 0
    while ($index -le $sdOUDef.count - 1) {
        if (($sdOUDef[$index].IdentityReference -eq $strTrustee) -and ($sdOUDef[$index].ActiveDirectoryRights -eq $adRights) -and ($sdOUDef[$index].AccessControlType -eq $AccessControlType) -and ($sdOUDef[$index].ObjectType -eq $ObjectTypeGUID) -and ($sdOUDef[$index].InheritanceType -eq $InheritanceType) -and ($sdOUDef[$index].InheritedObjectType -eq $InheritedObjectTypeGUID)) {
            $SDResult = $true
        }#} #End If
        $index++
    } #End While

    return $SDResult

}

#==========================================================================
# Function		: CacheRightsGuids
# Arguments     : none
# Returns   	: nothing
# Description   : Enumerates all Extended Rights and put them in a Hash dicRightsGuids
#==========================================================================
Function CacheRightsGuids([string] $Domain) {
    if (!$Domain) {
        # Connect to RootDSE
        $rootDSE = [ADSI]"LDAP://RootDSE"
        #Connect to the Configuration Naming Context
        $configSearchRoot = [ADSI]("LDAP://CN=Extended-Rights," + $rootDSE.Get("configurationNamingContext"))
    }
    else {
        $rootDSE = [ADSI]"LDAP://$global:strDC/$Domain"
        $configSearchRoot = [ADSI]("LDAP://$global:strDC/" + $rootDSE.Get("objectCategory"))
        $configSearchRoot = $configSearchRoot.psbase.path.replace("LDAP://CN=Domain-DNS,CN=Schema,", "")

        $configSearchRoot = [ADSI]("LDAP://$global:strDC/CN=Extended-Rights,CN=Configuration," + $global:ForestRootDomainDN)
    }

    $searcher = new-object System.DirectoryServices.DirectorySearcher($configSearchRoot)
    $searcher.PropertiesToLoad.("cn", "name", "distinguishedNAme", "rightsGuid")
    $searcher.filter = "(&(objectClass=controlAccessRight))"
    $colResults = $searcher.FindAll()
    $intCounter = 0


    foreach ($objResult in $colResults) {
        $objExtendedRightsObject = $objResult.Properties
        If (($objExtendedRightsObject.item("validAccesses") -eq 48) -or ($objExtendedRightsObject.item("validAccesses") -eq 256)) {

            $strRightDisplayName = $objExtendedRightsObject.item("displayName")
            $strRightGuid = $objExtendedRightsObject.item("rightsGuid")
            $strRightGuid = $($strRightGuid).toString()
            $global:dicRightsGuids.Add($strRightGuid, $strRightDisplayName)

        }
        $intCounter++
    }


}
#==========================================================================
# Function		: MapGUIDToMatchingName
# Arguments     : Object Guid or Rights Guid
# Returns   	: LDAPDisplayName or DisplayName
# Description   : Searches in the dictionaries(Hash) dicRightsGuids and $global:dicSchemaIDGUIDs  and in Schema
#				for the name of the object or Extended Right, if found in Schema the dicRightsGuids is updated.
#				Then the functions return the name(LDAPDisplayName or DisplayName).
#==========================================================================
Function MapGUIDToMatchingName {
    Param([string] $strGUIDAsString, [string] $Domain)
    [string] $strOut = ""
    [string] $objSchemaRecordset = ""
    [string] $strLDAPname = ""
    If ($strGUIDAsString -eq "") {
        Break
    }
    $strGUIDAsString = $strGUIDAsString.toUpper()
    $strOut = ""
    if ($global:dicRightsGuids.ContainsKey($strGUIDAsString)) {
        $strOut = $global:dicRightsGuids.Item($strGUIDAsString)
    }

    If ($strOut -eq "") {
        #Didn't find a match in extended rights
        If ($global:dicSchemaIDGUIDs.ContainsKey($strGUIDAsString)) {
            $strOut = $global:dicSchemaIDGUIDs.Item($strGUIDAsString)
        }
        else {

            if ($strGUIDAsString -match ("^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$")) {

                $ConvertGUID = ConvertGUID($strGUIDAsString)
                if (!($Domain -eq "")) {
                    # Connect to RootDSE
                    $rootDSE = [ADSI]"LDAP://RootDSE"
                    #Connect to the Configuration Naming Context
                    $schemaSearchRoot = [ADSI]("LDAP://" + $rootDSE.Get("schemaNamingContext"))
                }
                else {
                    $rootDSE = [ADSI]"LDAP://$global:strDC/$Domain"
                    $schemaSearchRoot = [ADSI]("LDAP://$global:strDC/" + $rootDSE.Get("objectCategory"))
                    $schemaSearchRoot = $schemaSearchRoot.path.replace("LDAP://CN=Domain-DNS,", "")
                    $schemaSearchRoot = [ADSI]("LDAP://$global:strDC/" + $schemaSearchRoot)
                }
                $searcher = new-object System.DirectoryServices.DirectorySearcher($schemaSearchRoot)
                $searcher.PropertiesToLoad.addrange(('cn', 'name', 'distinguishedNAme', 'lDAPDisplayName'))
                $searcher.filter = "(&(schemaIDGUID=$ConvertGUID))"
                $Object = $searcher.FindOne()
                if ($Object) {
                    $objSchemaObject = $Object.Properties
                    $strLDAPname = $objSchemaObject.item("lDAPDisplayName")[0]
                    $global:dicSchemaIDGUIDs.Add($strGUIDAsString.toUpper(), $strLDAPname)
                    $strOut = $strLDAPname

                }
            }
        }
    }
    return $strOut
}
#==========================================================================
# Function		: ConvertGUID
# Arguments     : Object Guid or Rights Guid
# Returns   	: AD Searchable GUID String
# Description   : Convert a GUID to a string

#==========================================================================
function ConvertGUID($guid) {

    $test = "(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})"
    $pattern = '"\$4\$3\$2\$1\$6\$5\$8\$7\$9\$10\$11\$12\$13\$14\$15\$16"'
    $ConvertGUID = [regex]::Replace($guid.replace("-", ""), $test, $pattern).Replace("`"", "")
    return $ConvertGUID
}
#==========================================================================
# Function		: fixfilename
# Arguments     : Text for naming text file
# Returns   	: Text with replace special characters
# Description   : Replace characters that be contained in a file name.

#==========================================================================
function fixfilename([string] $strFileName) {

    $strFileName = $strFileName.Replace("*", "#")
    $strFileName = $strFileName.Replace("/", "#")
    $strFileName = $strFileName.Replace("\", "#")
    $strFileName = $strFileName.Replace(":", "#")
    $strFileName = $strFileName.Replace("<", "#")
    $strFileName = $strFileName.Replace(">", "#")
    $strFileName = $strFileName.Replace("|", "#")
    $strFileName = $strFileName.Replace('"', "#")
    $strFileName = $strFileName.Replace('?', "#")

    return $strFileName
}
#==========================================================================
# Function		: WritePermCSV
# Arguments     : Security Descriptor, OU distinguishedName, Ou put text file
# Returns   	: n/a
# Description   : Writes the SD to a text file.
#==========================================================================
function WritePermCSV($sd, [string]$ou, [string] $fileout, [bool] $ACLMeta, [string]  $strACLDate, [string] $strInvocationID, [string] $strOrgUSN) {

    $sd  | ForEach-Object {
        If ($global:dicDCSpecialSids.ContainsKey($_.IdentityReference.toString())) {
            $strAccName = $global:dicDCSpecialSids.Item($_.IdentityReference.toString())
        }
        else {
            $strAccName = $_.IdentityReference.toString()
        }
        If ($ACLMeta -eq $true) {
            $ou + ";" + `
                $_.IdentityReference.toString() + ";" + `
                $_.ActiveDirectoryRights.toString() + ";" + `
                $_.InheritanceType.toString() + ";" + `
                $_.ObjectType.toString() + ";" + `
                $_.InheritedObjectType.toString() + ";" + `
                $_.ObjectFlags.toString() + ";" + `
                $_.AccessControlType.toString() + ";" + `
                $_.IsInherited.toString() + ";" + `
                $_.InheritanceFlags.toString() + ";" + `
                $_.PropagationFlags.toString() + ";" + `
                $strACLDate.toString() + ";" + `
                $strInvocationID.toString() + ";" + `
                $strOrgUSN.toString() + ";" | Out-File -Append -FilePath $fileout
        }
        else {
            $ou + ";" + `
                $_.IdentityReference.toString() + ";" + `
                $_.ActiveDirectoryRights.toString() + ";" + `
                $_.InheritanceType.toString() + ";" + `
                $_.ObjectType.toString() + ";" + `
                $_.InheritedObjectType.toString() + ";" + `
                $_.ObjectFlags.toString() + ";" + `
                $_.AccessControlType.toString() + ";" + `
                $_.IsInherited.toString() + ";" + `
                $_.InheritanceFlags.toString() + ";" + `
                $_.PropagationFlags.toString() + ";;;;" | Out-File -Append -FilePath $fileout
        }
    }

}
#==========================================================================
# Function		: ConvertSidTo-Name
# Arguments     : SID string
# Returns   	: Friendly Name of Security Object
# Description   : Try to translate the SID if it fails it try to match a Well-Known.
#==========================================================================
function ConvertSidTo-Name($server, $sid) {
    $ID = New-Object System.Security.Principal.SecurityIdentifier($sid)

    & { #Try
        $User = $ID.Translate( [System.Security.Principal.NTAccount])
        $strAccName = $User.Value
    }
    Trap [SystemException] {
        If ($global:dicWellKnownSids.ContainsKey($sid)) {
            $strAccName = $global:dicWellKnownSids.Item($sid)
            return $strAccName
        }
        ; Continue
    }
    If ($global:dicSidToName.ContainsKey($sid)) {
        $strAccName = $global:dicSidToName.Item($sid)
    }
    else {
        $objSID = [ADSI]"LDAP://$server/<SID=$sid>"
        $strAccName = $objSID.samAccountName
        $global:dicSidToName.Add($sid, $strAccName)
    }
    If ($strAccName -eq $nul) {
        $strAccName = $sid
    }

    return $strAccName
}

#==========================================================================
# Function		: WriteHTM
# Arguments     : Security Descriptor, OU dn string, Output htm file
# Returns   	: n/a
# Description   : Wites the SD info to a HTM table, it appends info if the file exist
#==========================================================================
function WriteHTM([bool] $bolACLExist, $sd, [string]$ou, [bool] $OUHeader, [string] $strColorTemp, [string] $htmfileout, [bool] $CompareMode, [bool] $FilterMode, [bool]$boolReplMetaDate, [string]$strReplMetaDate, [bool]$boolACLSize, [string]$strACLSize, [bool]$boolOUProtected, [bool]$bolOUPRotected, [bool]$bolCriticalityLevel) {


    $strTHOUColor = "E5CF00"
    $strTHColor = "EFAC00"
    $strLegendColor = ""
    $strLegendTextVal = "Info"
    $strLegendTextInfo = "Info"
    $strLegendTextLow = "Low"
    $strLegendTextMedium = "Medium"
    $strLegendTextWarning = "Warning"
    $strLegendTextCritical = "Critical"
    $strLegendColorInfo = @"
bgcolor="#A4A4A4"
"@
    $strLegendColorLow = @"
bgcolor="#0099FF"
"@
    $strLegendColorMedium = @"
bgcolor="#FFFF00"
"@
    $strLegendColorWarning = @"
bgcolor="#FFCC00"
"@
    $strLegendColorCritical = @"
bgcolor="#DF0101"
"@
    $strFont = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontRights = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontOU = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontTH = @"
<FONT size="2" face="verdana, hevetica, arial">
"@
    If ($OUHeader -eq $true) {
        if ($boolReplMetaDate -eq $true) {
            if ($boolACLSize -eq $true) {
                if ($boolOUProtected -eq $true) {
                    if ($bolOUProtected -eq $true) {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strReplMetaDate</b><TD><b>$strFontOU $strACLSize bytes</b><TD bgcolor="FF0000"><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                    else {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strReplMetaDate</b><TD><b>$strFontOU $strACLSize bytes</b><TD><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                }
                else {
                    $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strReplMetaDate</b><TD><b>$strFontOU $strACLSize bytes</b><TD><b>$strFontOU $ou</b></TR>
"@
                }
            }
            else {
                if ($boolOUProtected -eq $true) {
                    if ($bolOUProtected -eq $true) {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strReplMetaDate</b><TD bgcolor="FF0000"><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                    else {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strReplMetaDate</b><TD><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                }
                else {
                    $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strReplMetaDate</b><TD><b>$strFontOU $ou</b></TR>
"@
                }
            }
        }
        else {
            if ($boolACLSize -eq $true) {
                if ($boolOUProtected -eq $true) {
                    if ($bolOUProtected -eq $true) {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strACLSize bytes</b><TD bgcolor="FF0000"><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                    else {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strACLSize bytes</b><TD><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                }
                else {
                    $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strACLSize bytes</b><TD><b>$strFontOU $ou</b></TR>
"@
                }
            }
            else {
                if ($boolOUProtected -eq $true) {
                    if ($bolOUProtected -eq $true) {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD bgcolor="FF0000"><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                    else {
                        $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $bolOUProtected</b><TD><b>$strFontOU $ou</b></TR>
"@
                    }
                }
                else {
                    $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $ou</b></TR>
"@
                }
            }
        }
    } #End If
    Switch ($strColorTemp) {

        "1" {
            $strColor = "DDDDDD"
            $strColorTemp = "2"
        }
        "2" {
            $strColor = "AAAAAA"
            $strColorTemp = "1"
        }
        "3" {
            $strColor = "FF1111"
        }
        "4" {
            $strColor = "00FFAA"
        }
        "5" {
            $strColor = "FFFF00"
        }
    }# End Switch

    if ($bolACLExist) {
        $sd  | ForEach-Object {
            $objAccess = $($_.AccessControlType.toString())
            $objFlags = $($_.ObjectFlags.toString())
            $objType = $($_.ObjectType.toString())
            $objInheritedType = $($_.InheritedObjectType.toString())
            $objRights = $($_.ActiveDirectoryRights.toString())
            $objInheritanceType = $($_.InheritanceType.toString())



            if ($chkBoxEffectiveRightsColor.checked -eq $false) {
                Switch ($objRights) {
                    "DeleteChild, DeleteTree, Delete" {
                        $objRights = "DeleteChild, DeleteTree, Delete"

                    }
                    "GenericRead" {
                        $objRights = "Read Permissions,List Contents,Read All Properties,List"
                    }
                    "CreateChild" {
                        $objRights = "Create"
                    }
                    "DeleteChild" {
                        $objRights = "Delete"
                    }
                    "GenericAll" {
                        $objRights = "Full Control"
                    }
                    "CreateChild, DeleteChild" {
                        $objRights = "Create/Delete"
                    }
                    "ReadProperty" {
                        Switch ($objInheritanceType) {
                            "None" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }
                                    default
                                    { $objRights = "Read All Properties"	}
                                }#End switch



                            }
                            "Children" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }
                                    default
                                    { $objRights = "Read All Properties"	}
                                }#End switch
                            }
                            "Descendents" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }
                                    default
                                    { $objRights = "Read All Properties"	}
                                }#End switch
                            }
                            default
                            { $objRights = "Read All Properties"	}
                        }#End switch


                    }
                    "ReadProperty, WriteProperty" {
                        $objRights = "Read All Properties;Write All Properties"
                    }
                    "WriteProperty" {
                        Switch ($objInheritanceType) {
                            "None" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }
                                    default
                                    { $objRights = "Write All Properties"	}
                                }#End switch



                            }
                            "Children" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }
                                    default
                                    { $objRights = "Write All Properties"	}
                                }#End switch
                            }
                            "Descendents" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }
                                    default
                                    { $objRights = "Write All Properties"	}
                                }#End switch
                            }
                            default
                            { $objRights = "Write All Properties"	}
                        }#End switch
                    }
                }# End Switch
            }
            else {
                Switch ($objRights) {
                    "ListChildren" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorInfo
                            $strLegendTextVal = $strLegendTextInfo
                        }
                    }
                    "Modify permissions" {
                        $strLegendColor = $strLegendColorCritical
                        $strLegendTextVal = $strLegendTextCritical
                    }
                    "DeleteChild, DeleteTree, Delete" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorWarning
                            $strLegendTextVal = $strLegendTextWarning
                        }
                        $objRights = "DeleteChild, DeleteTree, Delete"

                    }
                    "Delete" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorWarning
                            $strLegendTextVal = $strLegendTextWarning
                        }
                    }
                    "GenericRead" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorLow
                            $strLegendTextVal = $strLegendTextLow
                        }
                        $objRights = "Read Permissions,List Contents,Read All Properties,List"
                    }
                    "CreateChild" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorWarning
                            $strLegendTextVal = $strLegendTextWarning
                        }
                        $objRights = "Create"
                    }
                    "DeleteChild" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorWarning
                            $strLegendTextVal = $strLegendTextWarning
                        }
                        $objRights = "Delete"
                    }
                    "ExtendedRight" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorWarning
                            $strLegendTextVal = $strLegendTextWarning
                        }
                    }
                    "GenericAll" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorCritical
                            $strLegendTextVal = $strLegendTextCritical
                        }
                        $objRights = "Full Control"
                    }
                    "CreateChild, DeleteChild" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorWarning
                            $strLegendTextVal = $strLegendTextWarning
                        }
                        $objRights = "Create/Delete"
                    }
                    "ReadProperty" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorLow
                            $strLegendTextVal = $strLegendTextLow
                        }
                        Switch ($objInheritanceType) {
                            "None" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {

                                        $objRights = "Read"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }
                                    default
                                    { $objRights = "Read All Properties"	}
                                }#End switch



                            }
                            "Children" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }
                                    default
                                    { $objRights = "Read All Properties"	}
                                }#End switch
                            }
                            "Descendents" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Read"
                                    }
                                    default
                                    { $objRights = "Read All Properties"	}
                                }#End switch
                            }
                            default
                            { $objRights = "Read All Properties"	}
                        }#End switch


                    }
                    "ReadProperty, WriteProperty" {
                        If ($objAccess -eq "Allow") {
                            $strLegendTextVal = $strLegendTextMedium
                            $strLegendColor = $strLegendColorMedium
                        }
                        $objRights = "Read All Properties;Write All Properties"
                    }
                    "WriteProperty" {
                        If ($objAccess -eq "Allow") {
                            $strLegendColor = $strLegendColorMedium
                            $strLegendTextVal = $strLegendTextMedium
                        }
                        Switch ($objInheritanceType) {
                            "None" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }
                                    default {
                                        $objRights = "Write All Properties"
                                    }
                                }#End switch

                            }
                            "Children" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }

                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }
                                    default {
                                        $objRights = "Write All Properties"
                                    }
                                }#End switch
                            }
                            "Descendents" {

                                Switch ($objFlags) {
                                    "ObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }
                                    "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                                        $objRights = "Write"
                                    }
                                    default {
                                        $objRights = "Write All Properties"
                                    }
                                }#End switch
                            }
                            default {
                                $objRights = "Write All Properties"
                            }
                        }#End switch
                    }
                    default {
                        If ($objAccess -eq "Allow") {
                            if ($objRights -match "Write") {
                                $strLegendColor = $strLegendColorMedium
                                $strLegendTextVal = $strLegendTextMedium
                            }
                            if ($objRights -match "Create") {
                                $strLegendColor = $strLegendColorWarning
                                $strLegendTextVal = $strLegendTextWarning
                            }
                            if ($objRights -match "Delete") {
                                $strLegendColor = $strLegendColorWarning
                                $strLegendTextVal = $strLegendTextWarning
                            }
                            if ($objRights -match "ExtendedRight") {
                                $strLegendColor = $strLegendColorWarning
                                $strLegendTextVal = $strLegendTextWarning
                            }
                            if ($objRights -match "WriteDacl") {
                                $strLegendColor = $strLegendColorCritical
                                $strLegendTextVal = $strLegendTextCritical
                            }
                            if ($objRights -match "WriteOwner") {
                                $strLegendColor = $strLegendColorCritical
                                $strLegendTextVal = $strLegendTextCritical
                            }
                        }
                    }
                }# End Switch
            }
            $strNTAccount = $($_.IdentityReference.toString())

            If ($strNTAccount.contains("S-1-5")) {
                $strNTAccount = ConvertSidTo-Name -server $global:strDomainLongName -Sid $strNTAccount

            }

            Switch ($strColorTemp) {

                "1" {
                    $strColor = "DDDDDD"
                    $strColorTemp = "2"
                }
                "2" {
                    $strColor = "AAAAAA"
                    $strColorTemp = "1"
                }
                "3" {
                    $strColor = "FF1111"
                }
                "4" {
                    $strColor = "00FFAA"
                }
                "5" {
                    $strColor = "FFFF00"
                }
            }# End Switch

            Switch ($objInheritanceType) {
                "All" {
                    Switch ($objFlags) {
                        "InheritedObjectAceTypePresent" {
                            $strPerm = "$strFont This object and all child objects</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD>"
                        }
                        "ObjectAceTypePresent" {
                            $strPerm = "$strFont This object and all child objects</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                            $strPerm = "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        "None" {
                            $strPerm = "$strFont This object and all child objects</TD><TD $strLegendColor>$strFontRights $objRights</TD>"
                        }
                        default {
                            $strPerm = "Error: Failed to display permissions 1K"
                        }

                    }# End Switch

                }
                "Descendents" {

                    Switch ($objFlags) {
                        "InheritedObjectAceTypePresent" {
                            $strPerm = "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD><TD $strLegendColor>$strFontRights $objRights</TD>"
                        }
                        "None" {
                            $strPerm = "$strFont Child Objects Only</TD><TD $strLegendColor>$strFontRights $objRights</TD>"
                        }
                        "ObjectAceTypePresent" {
                            $strPerm = "$strFont Child Objects Only</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                            $strPerm =	"$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        default {
                            $strPerm = "Error: Failed to display permissions 2K"
                        }

                    }
                }
                "None" {
                    Switch ($objFlags) {
                        "ObjectAceTypePresent" {
                            $strPerm = "$strFont This Object Only</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        "None" {
                            $strPerm = "$strFont This Object Only</TD><TD $strLegendColor>$strFontRights $objRights</TD>"
                        }
                        default {
                            $strPerm = "Error: Failed to display permissions 4K"
                        }

                    }
                }
                "SelfAndChildren" {
                    Switch ($objFlags) {
                        "ObjectAceTypePresent" {
                            $strPerm = "$strFont This object and all child objects within this conatainer only</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        "InheritedObjectAceTypePresent" {
                            $strPerm = "$strFont Children within this conatainer only</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD>"
                        }

                        "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                            $strPerm = "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        "None" {
                            $strPerm = "$strFont This object and all child objects</TD><TD $strLegendColor>$strFontRights $objRights</TD>"
                        }
                        default {
                            $strPerm = "Error: Failed to display permissions 5K"
                        }

                    }
                }
                "Children" {
                    Switch ($objFlags) {
                        "InheritedObjectAceTypePresent" {
                            $strPerm = "$strFont Children within this conatainer only</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD>"
                        }
                        "None" {
                            $strPerm = "$strFont Children  within this conatainer only</TD><TD $strLegendColor>$strFontRights $objRights</TD>"
                        }
                        "ObjectAceTypePresent, InheritedObjectAceTypePresent" {
                            $strPerm = "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainDNName)</TD><TD>$strFont $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName) $objRights</TD>"
                        }
                        "ObjectAceTypePresent" {
                            $strPerm = "$strFont Children within this conatainer only</TD><TD $strLegendColor>$strFontRights $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainDNName)</TD>"
                        }
                        default {
                            $strPerm = "Error: Failed to display permissions 6K"
                        }

                    }
                }
                default {
                    $strPerm = "Error: Failed to display permissions 7K"
                }
            }# End Switch
            if ($CompareMode) {
                if ($boolReplMetaDate -eq $true) {
                    if ($bolCriticalityLevel -eq $true) {
                        $objColor = $($_.Color.toString())
                        $strStatus = "<TD>$strFont $objColor</TD>"
                        $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
$strStatus
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                    }
                    else {
                        $objColor = $($_.Color.toString())
                        $strStatus = "<TD>$strFont $objColor</TD>"
                        $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
$strStatus
</TR>
"@
                    }
                }
                else {
                    if ($bolCriticalityLevel -eq $true) {
                        $objColor = $($_.Color.toString())
                        $strStatus = "<TD>$strFont $objColor</TD>"
                        $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
$strStatus
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                    }
                    else {
                        $objColor = $($_.Color.toString())
                        $strStatus = "<TD>$strFont $objColor</TD>"
                        $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
$strStatus
</TR>
"@
                    }
                } #End If ReplMeta Data

            }
            else {
                if ($boolReplMetaDate -eq $true) {
                    if ($boolACLSize -eq $true) {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected </TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected </TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                    }
                    else {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                    }
                }
                else {
                    if ($boolACLSize -eq $true) {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                    }
                    else {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
<TD $strLegendColor>$strFont $strLegendTextVal</TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
                            }
                        }
                    }
                } #End If ReplMeta Data
            }# End if CompareMode

        }# End foreach
    }
    else {
        if (!$CompareMode) {
            if ($FilterMode) {
                if ($boolReplMetaDate -eq $true) {
                    if ($bolCriticalityLevel -eq $true) {
                        $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Matching Permissions Set</TD><TD>
</TR>
"@
                    }
                    else {
                        $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Matching Permissions Set</TD>
</TR>
"@
                    }
                }
                else {
                    if ($bolCriticalityLevel -eq $true) {
                        $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Matching Permissions Set</TD><TD>
</TR>
"@
                    }
                    else {
                        $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Matching Permissions Set</TD>
</TR>
"@
                    }
                }#End If ReplMeta Data
            }
            else {
                if ($boolReplMetaDate -eq $true) {
                    if ($boolACLSize -eq $true) {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                    }
                    else {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                    }
                }
                else {
                    if ($boolACLSize -eq $true) {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont $bolOUPRotected</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strACLSize bytes</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                    }
                    else {
                        if ($boolOUProtected -eq $true) {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $bolOUPRotected</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                        else {
                            if ($bolCriticalityLevel -eq $true) {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD><TD>
</TR>
"@
                            }
                            else {
                                $strACLHTMLText = @"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
                            }
                        }
                    }
                }#End If ReplMeta Data
            }
        }# End if
    }# End If

    $strHTMLText = $strHTMLText + $strACLHTMLText

    Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout
    Out-File -InputObject $strHTMLText -Append -FilePath $strFileHTM

    $strHTMLText = ""

}

#==========================================================================
# Function		: InitiateHTM
# Arguments     : Output htm file
# Returns   	: n/a
# Description   : Wites base HTM table syntax, it appends info if the file exist
#==========================================================================
Function InitiateHTM([string] $htmfileout, [bool]$RepMetaDate , [bool]$ACLSize, [bool]$bolACEOUProtected, [bool]$bolCirticaltiy) {
    $strHTMLText = "<TABLE BORDER=1>"
    $strTHOUColor = "E5CF00"
    $strTHColor = "EFAC00"
    $strFont = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontOU = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontTH = @"
<FONT size="2" face="verdana, hevetica, arial">
"@
    if ($RepMetaDate -eq $true) {
        if ($ACLSize -eq $true) {
            if ($bolACEOUProtected -eq $true) {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
            else {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
        }
        else {
            if ($bolACEOUProtected -eq $true) {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
            else {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
        }
    }
    else {
        if ($ACLSize -eq $true) {
            if ($bolACEOUProtected -eq $true) {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
            else {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH DACL Size</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
        }
        else {
            if ($bolACEOUProtected -eq $true) {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Inheritance Disabled</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
            else {
                if ($bolCirticaltiy -eq $true) {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH Criticality Level</font></th>
"@
                }
                else {
                    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
                }
            }
        }

    }
    Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout
}
#==========================================================================
# Function		: InitiateCompareHTM
# Arguments     : Output htm file
# Returns   	: n/a
# Description   : Wites base HTM table syntax, it appends info if the file exist
#==========================================================================
Function InitiateCompareHTM([string] $htmfileout, [boolean]$RepMetaDate) {
    $strHTMLText = "<TABLE BORDER=1>"
    $strTHOUColor = "E5CF00"
    $strTHColor = "EFAC00"
    $strFont = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontOU = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontTH = @"
<FONT size="2" face="verdana, hevetica, arial">
"@
    if ($RepMetaDate -eq $true) {
        $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Security Descriptor Modified</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH State</font></th>
"@
    }
    else {
        $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH State</font></th>
"@
    }
    Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout
}
#==========================================================================
# Function		: CreateHTA
# Arguments     : OU Name, Ou put HTA file
# Returns   	: n/a
# Description   : Initiates a base HTA file with Export(Save As),Print and Exit buttons.
#==========================================================================
function CreateHTA([string]$NodeName, [string]$htafileout, [string]$htmfileout, [string] $folder) {
    $strHTAText = @"
<html>
<head>
<hta:Application ID="hta"
ApplicationName="Report">
<title>Report on $NodeName</title>
<script type="text/vbscript">
Sub ExportToCSV()
Dim objFSO,objFile,objNewFile,oShell,oEnv
Set oShell=CreateObject("wscript.shell")
Set oEnv=oShell.Environment("System")
strTemp=oShell.ExpandEnvironmentStrings("%USERPROFILE%")
strTempFile="$htmfileout"
strOutputFolder="$folder"
strFile=SaveAs("$NodeName.htm",strOutputFolder)
If strFile="" Then Exit Sub
Set objFSO=CreateObject("Scripting.FileSystemObject")
objFSO.CopyFile strTempFile,strFile, true
MsgBox "Finished exporting to " & strFile,vbOKOnly+vbInformation,"Export"
End Sub
Function SaveAs(strFile,strOutFolder)
Dim objDialog
SaveAs=InputBox("Enter the filename and path."&vbCrlf&vbCrlf&"Example: "&strOutFolder&"\CONTOSO-contoso.htm","Export",strOutFolder&"\"&strFile)
End Function
</script>
</head>
<body>
<input type="button" value="Export" onclick="ExportToCSV" tabindex="9">
<input id="print_button" type="button" value="Print" name="Print_button" class="Hide" onClick="Window.print()">
<input type="button" value="Exit" onclick=self.close name="B3" tabindex="1" class="btn">
"@
    Out-File -InputObject $strHTAText -Force -FilePath $htafileout
}
#==========================================================================
# Function		: WriteSPNHTM
# Arguments     : Security Principal Name,  Output htm file
# Returns   	: n/a
# Description   : Wites the account membership info to a HTM table, it appends info if the file exist
#==========================================================================
function WriteSPNHTM([string] $strSPN, $tokens, [string]$objType, [int]$intMemberOf, [string] $strColorTemp, [string] $htafileout, [string] $htmfileout) {


    $strTHOUColor = "E5CF00"
    $strTHColor = "EFAC00"
    $strFont = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontOU = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontTH = @"
<FONT size="2" face="verdana, hevetica, arial">
"@

    $strHTMLText = @"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strSPN</b><TD><b>$strFontOU $objType</b><TD><b>$strFontOU $intMemberOf</b></TR>
"@
    $strHTMLText = @"
$strHTMLText
<TR bgcolor="$strTHColor"><TD><b>$strFontTH Groups</b></TD><TD></TD><TD></TD></TR>
"@


    $tokens  | ForEach-Object {
        if ($($_.toString()) -ne $strSPN) {
            Switch ($strColorTemp) {

                "1" {
                    $strColor = "DDDDDD"
                    $strColorTemp = "2"
                }
                "2" {
                    $strColor = "AAAAAA"
                    $strColorTemp = "1"
                }
                "3" {
                    $strColor = "FF1111"
                }
                "4" {
                    $strColor = "00FFAA"
                }
                "5" {
                    $strColor = "FFFF00"
                }
            }# End Switch
            $strGroupText = $strGroupText + @"
<TR bgcolor="$strColor"><TD>
$strFont $($_.toString())</TD></TR>
"@
        }
    }
    $strHTMLText = $strHTMLText + $strGroupText


    Out-File -InputObject $strHTMLText -Append -FilePath $htafileout
    Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout

    $strHTMLText = ""

}
#==========================================================================
# Function		: CreateColorLegenedReportHTA
# Arguments     : OU Name, Ou put HTA file
# Returns   	: n/a
# Description   : Initiates a base HTA file with Export(Save As),Print and Exit buttons.
#==========================================================================
function CreateColorLegenedReportHTA([string]$htafileout) {
    $strHTAText = @"
<html>
<head>
<hta:Application ID="hta"
ApplicationName="Legend">
<title>Color Code</title>
<script type="text/vbscript">
Sub Window_Onload

 	self.ResizeTo 500,500
End sub
</script>
</head>
<body>

<input type="button" value="Exit" onclick=self.close name="B3" tabindex="1" class="btn">
"@

    $strTHOUColor = "E5CF00"
    $strTHColor = "EFAC00"
    $strFont = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontOU = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontTH = @"
<FONT size="2" face="verdana, hevetica, arial">
"@
    $strLegendColorInfo = @"
bgcolor="#A4A4A4"
"@
    $strLegendColorLow = @"
bgcolor="#0099FF"
"@
    $strLegendColorMedium = @"
bgcolor="#FFFF00"
"@
    $strLegendColorWarning = @"
bgcolor="#FFCC00"
"@
    $strLegendColorCritical = @"
bgcolor="#DF0101"
"@

    $strHTAText = @"
$strHTAText
<h4>Use colors in report to identify criticality level of permissions.<br>This might help you in implementing <B>Least-Privilege</B> Administrative Models.</h4>
<TABLE BORDER=1>
<th bgcolor="$strTHColor">$strFontTH Permissions</font></th><th bgcolor="$strTHColor">$strFontTH Criticality</font></th>
<TR><TD> $strFontTH <B>Deny Permissions<TD $strLegendColorInfo> Info</TR>
<TR><TD> $strFontTH <B>List<TD $strLegendColorInfo>Info</TR>
<TR><TD> $strFontTH <B>Read Properties<TD $strLegendColorLow>Low</TR>
<TR><TD> $strFontTH <B>Read Object<TD $strLegendColorLow>Low</TR>
<TR><TD> $strFontTH <B>Read Permissions<TD $strLegendColorLow>Low</TR>
<TR><TD> $strFontTH <B>Write Propeties<TD $strLegendColorMedium>Medium</TR>
<TR><TD> $strFontTH <B>Create Object<TD $strLegendColorWarning>Warning</TR>
<TR><TD> $strFontTH <B>Delete Object<TD $strLegendColorWarning>Warning</TR>
<TR><TD> $strFontTH <B>ExtendedRight<TD $strLegendColorWarning>Warning</TR>
<TR><TD> $strFontTH <B>Modify Permisions<TD $strLegendColorCritical>Critical</TR>
<TR><TD> $strFontTH <B>Full Control<TD $strLegendColorCritical>Critical</TR>

"@


    ##
    Out-File -InputObject $strHTAText -Force -FilePath $htafileout
}
#==========================================================================
# Function		: CreateServicePrincipalReportHTA
# Arguments     : OU Name, Ou put HTA file
# Returns   	: n/a
# Description   : Initiates a base HTA file with Export(Save As),Print and Exit buttons.
#==========================================================================
function CreateServicePrincipalReportHTA([string]$SPN, [string]$htafileout, [string]$htmfileout, [string] $folder) {
    $strHTAText = @"
<html>
<head>
<hta:Application ID="hta"
ApplicationName="Report">
<title>Membership Report on $SPN</title>
<script type="text/vbscript">
Sub ExportToCSV()
Dim objFSO,objFile,objNewFile,oShell,oEnv
Set oShell=CreateObject("wscript.shell")
Set oEnv=oShell.Environment("System")
strTemp=oShell.ExpandEnvironmentStrings("%USERPROFILE%")
strTempFile="$htmfileout"
strOutputFolder="$folder"
strFile=SaveAs("$SPN.htm",strOutputFolder)
If strFile="" Then Exit Sub
Set objFSO=CreateObject("Scripting.FileSystemObject")
objFSO.CopyFile strTempFile,strFile, true
MsgBox "Finished exporting to " & strFile,vbOKOnly+vbInformation,"Export"
End Sub
Function SaveAs(strFile,strOutFolder)
Dim objDialog
SaveAs=InputBox("Enter the filename and path."&vbCrlf&vbCrlf&"Example: "&strOutFolder&"\CONTOSO-contoso.htm","Export",strOutFolder&"\"&strFile)
End Function
</script>
</head>
<body>
<input type="button" value="Export" onclick="ExportToCSV" tabindex="9">
<input id="print_button" type="button" value="Print" name="Print_button" class="Hide" onClick="Window.print()">
<input type="button" value="Exit" onclick=self.close name="B3" tabindex="1" class="btn">
"@
    Out-File -InputObject $strHTAText -Force -FilePath $htafileout
}
#==========================================================================
# Function		: CreateHTM
# Arguments     : OU Name, Ou put HTM file
# Returns   	: n/a
# Description   : Initiates a base HTM file with Export(Save As),Print and Exit buttons.
#==========================================================================
function CreateSPNHTM([string]$SPN, [string]$htmfileout) {
    $strHTAText = @"
<html>
<head[string]$SPN
<title>Membership Report on $SPN</title>
"@
    Out-File -InputObject $strHTAText -Force -FilePath $htmfileout

}
#==========================================================================
# Function		: InitiateHTM
# Arguments     : Output htm file
# Returns   	: n/a
# Description   : Wites base HTM table syntax, it appends info if the file exist
#==========================================================================
Function InitiateSPNHTM([string] $htmfileout) {
    $strHTMLText = "<TABLE BORDER=1>"
    $strTHOUColor = "E5CF00"
    $strTHColor = "EFAC00"
    $strFont = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontOU = @"
<FONT size="1" face="verdana, hevetica, arial">
"@
    $strFontTH = @"
<FONT size="2" face="verdana, hevetica, arial">
"@


    $strHTMLText = @"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH Account Name</font></th><th bgcolor="$strTHColor">$strFontTH Object Type</font></th><th bgcolor="$strTHColor">$strFontTH Number of Groups</font></th>
"@



    Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout
}
#==========================================================================
# Function		: CreateHTM
# Arguments     : OU Name, Ou put HTM file
# Returns   	: n/a
# Description   : Initiates a base HTM file with Export(Save As),Print and Exit buttons.
#==========================================================================
function CreateHTM([string]$NodeName, [string]$htmfileout) {
    $strHTAText = @"
<html>
<head>
<title>Report on $NodeName</title>
"@

    Out-File -InputObject $strHTAText -Force -FilePath $htmfileout
}
#==========================================================================
# Function		: BuildTree
# Arguments     : TreeView Node
# Returns   	: TreeView Node
# Description   : Build the Tree with AD objects
#==========================================================================
Function BuildTree($treeNode) {
    #$de = New-Object system.directoryservices.directoryEntry("LDAP://$strDC/$($treeNode.Name)")
    # Add all Children found as Sub Nodes to the selected TreeNode

    $strFilterOUCont = "(&(|(objectClass=organizationalUnit)(objectClass=container)))"
    $strFilterAll = "(&(name=*))"
    $srch = New-Object System.DirectoryServices.DirectorySearcher
    $srch.SizeLimit = 100
    $treeNodePath = $treeNode.name

    $treeNodePath = $treeNodePath.Replace("/", "\/")

    $srch.SearchRoot = "LDAP://$global:strDC/" + $treeNodePath
    If ($rdbBrowseAll.checked -eq $true) {
        $srch.Filter = $strFilterAll

    }
    else {
        $srch.Filter = $strFilterOUCont
    }
    $srch.SearchScope = "OneLevel"
    foreach ($res in $srch.FindAll()) {
        $oOU = $res.GetDirectoryEntry()
        If ($null -ne $oOU.name) {
            $TN = New-Object System.Windows.Forms.TreeNode
            $TN.Name = $oOU.distinguishedName
            $TN.Text = $oOU.name
            $TN.tag = "NotEnumerated"
            $treeNode.Nodes.Add($TN)
        }
    }
    $treeNode.tag = "Enumerated"

}
#==========================================================================
# Function		: GetADPartitions
# Arguments     : domain name
# Returns   	: N/A
# Description   : Returns AD Partitions
#==========================================================================
function GetADPartitions {
    Param($strDomain)
    $ADPartlist = @{"domain" = $strDomain }
    $objDomain = [ADSI]"LDAP://$strDomain"
    [string]$strDomainObjectCateory = $objDomain.objectCategory
    [array] $dnSplit = $strDomainObjectCateory.split(",")
    $intSplit = ($dnSplit).count - 1
    $strConfig = ""
    for ($i = $intSplit; $i -ge 0; $i-- ) {
        If ($dnSplit[$i] -match "CN=Configuration") {
            $intConfig = $i
            $strDomainConfig = $dnSplit[$i]
        }
        If ($i -gt $intConfig) {
            If ($strConfig.Length -eq 0) {
                $strConfig = $dnSplit[$i]
            }
            else {
                $strConfig = $dnSplit[$i] + "," + $strConfig
            }
        }
    }
    $strDomainConfig = $strDomainConfig + "," + $strConfig
    $strDNSchema = "LDAP://CN=Enterprise Schema,CN=Partitions," + $strDomainConfig
    $ojbSchema = [ADSI]$strDNSchema

    $ADPartlist.Add("config", $strDomainConfig)
    $ADPartlist.Add("schema", $ojbSchema.nCName)

    return $ADPartlist
}
#==========================================================================
# Function		: Select-File
# Arguments     : n/a
# Returns   	: folder path
# Description   : Dialogbox for selecting a file
#==========================================================================
function Select-File {
    param (
        [System.String]$Title = "Select Template File",
        [System.String]$InitialDirectory = $CurrentFSPath,
        [System.String]$Filter = "All Files(*.csv)|*.csv"
    )

    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = $filter
    $dialog.InitialDirectory = $initialDirectory
    $dialog.ShowHelp = $true
    $dialog.Title = $title
    $result = $dialog.ShowDialog($owner)

    if ($result -eq "OK") {
        return $dialog.FileName
    }
    else {
        return ""

    }
}
#==========================================================================
# Function		: Select-Folder
# Arguments     : n/a
# Returns   	: folder path
# Description   : Dialogbox for selecting a folder
#==========================================================================
function Select-Folder($message = 'Select a folder', $path = 0) {
    $object = New-Object -comObject Shell.Application

    $folder = $object.BrowseForFolder(0, $message, 0, $path)
    if ($null -ne $folder) {
        $folder.self.Path
    }
}
#==========================================================================
# Function		: Get-Perm
# Arguments     : List of OU Path
# Returns   	: All Permissions on a speficied object
# Description   : Enumerates all access control entries on a speficied object
#==========================================================================
Function Get-Perm {
    Param([System.Collections.ArrayList]$ALOUdn, [string]$DomainNetbiosName, [boolean]$SkipDefaultPerm, [boolean]$FilterEna, [boolean]$bolGetOwnerEna, [boolean]$bolCSVOnly, [boolean]$bolRepMeta, [boolean]$bolACLsize, [boolean]$bolEffectiveR, [boolean] $bolGetOUProtected)
    $SDResult = $false
    $strOwner = ""
    $strACLSize = ""
    $bolOUProtected = $false
    $aclcount = 0

    If ($bolCSV) {
        If ((Test-Path $strFileCSV) -eq $true) {
            Remove-Item $strFileCSV
        }
    }
    $count = 0
    while ($count -le $ALOUdn.count - 1) {
        $sd = New-Object System.Collections.ArrayList
        $GetOwnerEna = $bolGetOwnerEna
        $ADObjDN = $($ALOUdn[$count])

        if ($ADObjDN -match "/") {
            #if ($rdbOneLevel.checked -eq $false)
            #{

            #   if ($ADObjDN -match "/")
            #   {
            $ADObjDN = $ADObjDN.Replace("/", "\/")
            #   }
            #}
            #else
            #{
            #if($count -lt $ALOUdn.count -1)
            #{

            #  if ($ADObjDN -match "/")
            #  {

            #     $ADObjDN = $ADObjDN.Replace("/", "\/")
            # }
            #}
            #}
        }

        $DSobject = [adsi]("LDAP://$global:strDC/$ADObjDN")


        $secd = $DSobject.psbase.get_objectSecurity().getAccessRules($true, $chkInheritedPerm.checked, [System.Security.Principal.NTAccount])
        $sd.clear()
        $(ConvertTo-ObjectArrayListFromPsCustomObject  $secd) | ForEach-Object { [void]$sd.add($_) }

        If ($GetOwnerEna -eq $true) {

            $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
            $newSdOwnerObject = New-Object psObject | `
                Add-Member NoteProperty IdentityReference $strOwner -PassThru |`
                Add-Member NoteProperty ActiveDirectoryRights "Modify permissions" -PassThru |`
                Add-Member NoteProperty InheritanceType "None" -PassThru |`
                Add-Member NoteProperty ObjectType  "None" -PassThru |`
                Add-Member NoteProperty ObjectFlags "None" -PassThru |`
                Add-Member NoteProperty AccessControlType "Owner" -PassThru |`
                Add-Member NoteProperty IsInherited "False" -PassThru |`
                Add-Member NoteProperty InheritanceFlags "None" -PassThru |`
                Add-Member NoteProperty InheritedObjectType "None" -PassThru |`
                Add-Member NoteProperty PropagationFlags "None"  -PassThru
            [void]$sd.insert(0, $newSdOwnerObject)

        }
        If ($SkipDefaultPerm) {
            $strNodeObjectClass = $DSobject.objectClass.tostring()
            [array] $arrObjClassSplit = $strNodeObjectClass.split(" ")
            foreach ($strObjClass in $arrObjClassSplit) {
            }
            $objNodeDefSD = Get-ADSchemaClass $strObjClass
        }
        if ($bolACLsize -eq $true) {
            $strACLSize = $DSobject.psbase.get_objectSecurity().GetSecurityDescriptorBinaryForm().length
        }
        if ($bolGetOUProtected -eq $true) {
            $bolOUProtected = $DSobject.psbase.get_objectSecurity().areaccessrulesprotected
        }
        if ($bolRepMeta -eq $true) {

            $AclChange = $(GetACLMeta  $global:strDC $ADObjDN)
            $objLastChange = $AclChange.split(";")[0]
            $strOrigInvocationID = $AclChange.split(";")[1]
            $strOrigUSN = $AclChange.split(";")[2]
        }


        If (($FilterEna -eq $true) -and ($bolEffectiveR -eq $false)) {
            If ($chkBoxType.Checked) {
                if ($combAccessCtrl.SelectedIndex -gt -1) {
                    $sd = @($sd | Where-Object { $_.AccessControlType -eq $combAccessCtrl.SelectedItem })
                }
            }
            If ($chkBoxObject.Checked) {
                if ($combObjectFilter.SelectedIndex -gt -1) {

                    $sd = @($sd | Where-Object { ($_.ObjectType -eq $global:dicNameToSchemaIDGUIDs.Item($combObjectFilter.SelectedItem)) -or ($_.InheritedObjectType -eq $global:dicNameToSchemaIDGUIDs.Item($combObjectFilter.SelectedItem)) })
                }
            }
            If ($chkBoxTrustee.Checked) {
                if ($txtFilterTrustee.Text.Length -gt 0) {

                    $sd = @($sd | Where-Object { $_.IdentityReference -like $txtFilterTrustee.Text })

                }
            }

        }


        if ($bolEffectiveR -eq $true) {

            if ($global:tokens.count -gt 0) {


                $indexet = 0
                $sdtemp2 = New-Object System.Collections.ArrayList

                if ($global:strPrincipalDN -eq $ADObjDN) {
                    $sdtemp = ""
                    $sdtemp = $sd | Where-Object { $_.IdentityReference -eq "NT AUTHORITY\SELF" }
                    if ($sdtemp) {
                        $sdtemp2.Add( $sdtemp)
                    }
                }
                foreach ($tok in $global:tokens) {

                    $sdtemp = ""
                    $sdtemp = $sd | Where-Object { $_.IdentityReference -eq $tok }
                    if ($sdtemp) {
                        $sdtemp2.Add( $sdtemp)
                    }


                }
                $sd = $sdtemp2
            }

        }
        $intSDCount = $sd.count

        if (!($null -eq $sd)) {



            $index = 0
            $permcount = 0

            if ($intSDCount -gt 0) {

                while ($index -le $sd.count - 1) {

                    if (($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sd[$index].IdentityReference $sd[$index].ActiveDirectoryRights $sd[$index].InheritanceType $sd[$index].ObjectType $sd[$index].InheritedObjectType $sd[$index].ObjectFlags $sd[$index].AccessControlType $sd[$index].IsInherited $sd[$index].InheritanceFlags $sd[$index].PropagationFlags)) {
                    }
                    else {
                        If ($bolCSV -or $bolCSVOnly) {

                            WritePermCSV $sd[$index] $DSobject.distinguishedName.toString() $strFileCSV $bolRepMeta $objLastChange $strOrigInvocationID $strOrigUSN

                        }# End If
                        If (!($bolCSVOnly)) {
                            If ($strColorTemp -eq "1") {
                                $strColorTemp = "2"
                            }# End If
                            else {
                                $strColorTemp = "1"
                            }# End If
                            if ($permcount -eq 0) {

                                WriteHTM $true $sd[$index] $DSobject.distinguishedName.toString() $true $strColorTemp $strFileHTA $false $FilterEna $bolRepMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked

                            }
                            else {

                                WriteHTM $true $sd[$index] $DSobject.distinguishedName.toString() $false $strColorTemp $strFileHTA $false $FilterEna $bolRepMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked

                            }# End If
                        }
                        $aclcount++
                        $permcount++
                    }# End If
                    $index++
                }# End while

            }
            else {
                if (($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sd.IdentityReference $sd.ActiveDirectoryRights $sd.InheritanceType $sd.ObjectType $sd.InheritedObjectType $sd.ObjectFlags $sd.AccessControlType $sd.IsInherited $sd.InheritanceFlags $sd.PropagationFlags)) {

                }
                else {

                    If (!($bolCSVOnly)) {
                        If ($strColorTemp -eq "1") {
                            $strColorTemp = "2"
                        }
                        else {
                            $strColorTemp = "1"
                        }
                        if ($permcount -eq 0) {
                            WriteHTM $true $sd $DSobject.distinguishedName.toString() $true $strColorTemp $strFileHTA $false $FilterEna $bolRepMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked


                        }
                        else {
                            $GetOwnerEna = $false
                            WriteHTM $true $sd $DSobject.distinguishedName.toString() $false $strColorTemp $strFileHTA $false $FilterEna $bolRepMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked
                            $aclcount++
                        }
                    }

                    $permcount++
                }#End if Check-PermDef

            }#End if array

            If (!($bolCSVOnly)) {
                if (($permcount -eq 0) -and ($index -gt 0)) {
                    WriteHTM $false $sd $DSobject.distinguishedName.toString() $true "1" $strFileHTA $false $FilterEna $bolRepMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked
                    $aclcount++
                }# End If
            }
            else {
                #if isNull
                WriteHTM $false $sd $DSobject.distinguishedName.toString() $true "1" $strFileHTA $false $FilterEna $bolRepMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked

            }# End if isNull
        }
        $count++
    }# End while


    if (($count -gt 0)) {
        if ($aclcount -eq 0) {
            [System.Windows.Forms.MessageBox]::Show("No Permissions found!" , "Status")
        }
        else {
            if ($bolCSVOnly) {

                [System.Windows.Forms.MessageBox]::Show("Done!" , "Status")
            }
            else {
                Invoke-Item $strFileHTA
            }

        }# End If
    }
    else {
        [System.Windows.Forms.MessageBox]::Show("No objects found!" , "Status")
    }

    return $SDResult

}
#==========================================================================
# Function		: Get-PermCompare
# Arguments     : OU Path
# Returns   	: N/A
# Description   : Compare Permissions on node with permissions in CSV file
#==========================================================================
Function Get-PermCompare {
    Param([System.Collections.ArrayList]$ALOUdn, [boolean]$SkipDefaultPerm, [boolean]$bolReplMeta, [boolean]$bolGetOwnerEna)
    & { #Try
        $arrFilecheck = New-Object System.Collections.ArrayList
        $arrOUList = New-Object System.Collections.ArrayList
        $bolOUProtected = $false
        $bolGetOUProtected = $false
        $bolACLsize = $false
        $strACLSize = ""
        $bolAClMeta = $false
        $strOwner = ""
        $count = 0
        $aclcount = 0
        $global:intDiffCol = 0

        if ($chkBoxTemplateNodes.Checked -eq $true) {
            $index = 0
            while ($index -le $HistACLs.count - 1) {
                $txtPerm = $HistACLs[$index].split(";")
                if ($txtPerm.count -gt $global:intColCount) {
                    $global:intDiffCol = ($txtPerm.count ) - $global:intColCount
                    $countCol = 0
                    $strOUcol = ""
                    while ($countCol -le $global:intDiffCol) {
                        if ($countCol -eq 0) {
                            $strOUcol = $txtPerm[$countCol]
                        }
                        else {
                            $strOUcol = $strOUcol + ";" + $txtPerm[$countCol]

                        }
                        $countCol++

                    }
                    $arrOUList.Add($strOUcol)
                }
                else {
                    $arrOUList.Add($txtPerm[0])
                    $global:intDiffCol = 0
                }


                $index++
            }
            $arrOUListUnique = $arrOUList | Select-Object -Unique
            $ALOUdn = @($arrOUListUnique)
        }
        If ($bolReplMeta -eq $true) {
            if ($HistACLs[0].split(";").count -ge $global:intColCount) {
                If ($HistACLs[0].split(";")[$HistACLs[0].split(";").count - 2].length -gt 1) {
                    $bolAClMeta = $true
                }
            }
        }

        while ($count -le $ALOUdn.count - 1) {
            $SDUsnCheck = $false
            $OUMatchResultOverall = $false
            $OUdn = $($ALOUdn[$count])

            #Save the orginal name for AD for compare
            $OUdnorgDN = $OUdn


            if ($OUdn -match "/") {
                if ($rdbOneLevel.checked -eq $false) {

                    if ($OUdn -match "/") {
                        $OUdn = $OUdn.Replace("/", "\/")
                    }
                }
                else {
                    if ($count -lt $ALOUdn.count - 1) {

                        if ($OUdn -match "/") {

                            $OUdn = $OUdn.Replace("/", "\/")
                        }
                    }
                }
            }

            If ($bolReplMeta -eq $true) {

                $AclChange = $(GetACLMeta  $global:strDC $OUdn)

                $objLastChange = $AclChange.split(";")[0]
                $strOrigInvocationID = $AclChange.split(";")[1]
                $strOrigUSN = $AclChange.split(";")[2]
            }

            $DSobject = [adsi]("LDAP://$global:strDC/$OUdn")

            WriteHTM $false $sd $DSobject.distinguishedName.toString() $true $strColorTemp $strFileHTA $true $false $bolReplMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked


            $sd = New-Object System.Collections.ArrayList

            $GetOwnerEna = $bolGetOwnerEna
            $DSobject = [adsi]("LDAP://$global:strDC/$OUdn")
            $secd = $DSobject.psbase.get_objectSecurity().getAccessRules($true, $chkInheritedPerm.checked, [System.Security.Principal.NTAccount])
            $sd.clear()
            $(ConvertTo-ObjectArrayListFromPsCustomObject  $secd) | ForEach-Object { [void]$sd.add($_) }

            If ($GetOwnerEna -eq $true) {

                $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
                $newSdOwnerObject = New-Object psObject | `
                    Add-Member NoteProperty IdentityReference $strOwner -PassThru |`
                    Add-Member NoteProperty ActiveDirectoryRights "Modify permissions" -PassThru |`
                    Add-Member NoteProperty InheritanceType "None" -PassThru |`
                    Add-Member NoteProperty ObjectType  "None" -PassThru |`
                    Add-Member NoteProperty ObjectFlags "None" -PassThru |`
                    Add-Member NoteProperty AccessControlType "Owner" -PassThru |`
                    Add-Member NoteProperty IsInherited "False" -PassThru |`
                    Add-Member NoteProperty InheritanceFlags "None" -PassThru |`
                    Add-Member NoteProperty InheritedObjectType "None" -PassThru |`
                    Add-Member NoteProperty PropagationFlags "None"  -PassThru
                [void]$sd.insert(0, $newSdOwnerObject)

            }

            $rar = @($($sd | Select-Object -Property *))


            $index = 0
            $SDResult = $false
            $OUMatchResult = $false



            If ($SkipDefaultPerm) {


                $strNodeObjectClass = $DSobject.objectClass.tostring()
                [array] $arrObjClassSplit = $strNodeObjectClass.split(" ")
                foreach ($strObjClass in $arrObjClassSplit) {
                }
                $objNodeDefSD = Get-ADSchemaClass $strObjClass
            }

            foreach ($sdObject in $rar) {

                if (($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sdObject.IdentityReference $sdObject.ActiveDirectoryRights $sdObject.InheritanceType $sdObject.ObjectType $sdObject.InheritedObjectType $sdObject.ObjectFlags $sdObject.AccessControlType $sdObject.IsInherited $sdObject.InheritanceFlags $sdObject.PropagationFlags)) {
                }
                else {


                    $index = 0
                    $SDResult = $false
                    $OUMatchResult = $false
                    $aclcount++
                    $newSdObject = New-Object psObject | `
                        Add-Member NoteProperty IdentityReference $sdObject.IdentityReference.value -PassThru |`
                        Add-Member NoteProperty ActiveDirectoryRights $sdObject.ActiveDirectoryRights -PassThru |`
                        Add-Member NoteProperty InheritanceType $sdObject.InheritanceType -PassThru |`
                        Add-Member NoteProperty ObjectType  $sdObject.ObjectType -PassThru |`
                        Add-Member NoteProperty ObjectFlags $sdObject.ObjectFlags -PassThru |`
                        Add-Member NoteProperty AccessControlType $sdObject.AccessControlType -PassThru |`
                        Add-Member NoteProperty IsInherited $sdObject.IsInherited -PassThru |`
                        Add-Member NoteProperty InheritanceFlags $sdObject.InheritanceFlags -PassThru |`
                        Add-Member NoteProperty InheritedObjectType $sdObject.InheritedObjectType -PassThru |`
                        Add-Member NoteProperty PropagationFlags $sdObject.PropagationFlags  -PassThru |`
                        Add-Member NoteProperty Color "Match"  -PassThru

                    if ($SDUsnCheck -eq $true) {
                        $SDResult = $true
                    }
                    else {
                        while ($index -le $HistACLs.count - 1) {
                            $txtPerm = $HistACLs[$index].split(";")
                            if ($txtPerm.count -gt $global:intColCount) {
                                $global:intDiffCol = ($txtPerm.count ) - $global:intColCount
                                $countCol = 0
                                $strOUcol = ""
                                while ($countCol -le $global:intDiffCol) {
                                    if ($countCol -eq 0) {
                                        $strOUcol = $txtPerm[$countCol]
                                    }
                                    else {
                                        $strOUcol = $strOUcol + ";" + $txtPerm[$countCol]

                                    }
                                    $countCol++

                                }

                            }
                            else {
                                $strOUcol = $txtPerm[0]
                                $global:intDiffCol = 0
                            }
                            if (($rdbOneLevel.checked -eq $true) -and ($count -eq $ALOUdn.count - 1)) {
                                $strOUcol = $strOUcol.Replace("/", "\/")
                            }

                            if ($OUdnorgDN -eq $strOUcol ) {
                                $OUMatchResult = $true
                                $OUMatchResultOverall = $true
                                $strIdentityReference = $txtPerm[1 + $global:intDiffCol]
                                $strTmpActiveDirectoryRights = $txtPerm[2 + $global:intDiffCol]
                                $strTmpInheritanceType = $txtPerm[3 + $global:intDiffCol]
                                $strTmpObjectTypeGUID = $txtPerm[4 + $global:intDiffCol]
                                $strTmpInheritedObjectTypeGUID = $txtPerm[5 + $global:intDiffCol]
                                $strTmpObjectFlags = $txtPerm[6 + $global:intDiffCol]
                                $strTmpAccessControlType = $txtPerm[7 + $global:intDiffCol]
                                $strTmpIsInherited = $txtPerm[8 + $global:intDiffCol]
                                $strTmpInheritedFlags = $txtPerm[9 + $global:intDiffCol]
                                $strTmpPropFlags = $txtPerm[10 + $global:intDiffCol]

                                If (($newSdObject.IdentityReference -eq $strIdentityReference) -and ($newSdObject.ActiveDirectoryRights -eq $strTmpActiveDirectoryRights) -and ($newSdObject.AccessControlType -eq $strTmpAccessControlType) -and ($newSdObject.ObjectType -eq $strTmpObjectTypeGUID) -and ($newSdObject.InheritanceType -eq $strTmpInheritanceType) -and ($newSdObject.InheritedObjectType -eq $strTmpInheritedObjectTypeGUID)) {
                                    $SDResult = $true
                                }

                            }
                            $index++
                        }# End While
                    }

                    if ($SDResult) {

                        WriteHTM $true $newSdObject $OUdn $false "4" $strFileHTA $true $false $bolReplMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked

                    }
                    If ($OUMatchResult -And !($SDResult)) {

                        $newSdObject.Color = "New"
                        WriteHTM $true $newSdObject $OUdn $false "5" $strFileHTA $true $false $bolReplMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked

                    }

                }


            }

            If ($SDUsnCheck -eq $false) {
                $index = 0
                while ($index -le $HistACLs.count - 1) {
                    $SDHistResult = $false
                    $txtPerm = $HistACLs[$index].split(";")
                    if ($txtPerm.count -gt $global:intColCount) {
                        $global:intDiffCol = ($txtPerm.count ) - $global:intColCount
                        $countCol = 0
                        $strOUcol = ""
                        while ($countCol -le $global:intDiffCol) {
                            if ($countCol -eq 0) {
                                $strOUcol = $txtPerm[$countCol]
                            }
                            else {
                                $strOUcol = $strOUcol + ";" + $txtPerm[$countCol]

                            }
                            $countCol++

                        }

                    }
                    else {
                        $strOUcol = $txtPerm[0]
                        $global:intDiffCol = 0
                    }

                    if (($rdbOneLevel.checked -eq $true) -and ($count -eq $ALOUdn.count - 1)) {
                        $strOUcol = $strOUcol.Replace("/", "\/")
                    }


                    if ($OUdnorgDN -eq $strOUcol ) {
                        $OUMatchResult = $true
                        $strIdentityReference = $txtPerm[1 + $global:intDiffCol]
                        $strTmpActiveDirectoryRights = $txtPerm[2 + $global:intDiffCol]
                        $strTmpInheritanceType = $txtPerm[3 + $global:intDiffCol]
                        $strTmpObjectTypeGUID = $txtPerm[4 + $global:intDiffCol]
                        $strTmpInheritedObjectTypeGUID = $txtPerm[5 + $global:intDiffCol]
                        $strTmpObjectFlags = $txtPerm[6 + $global:intDiffCol]
                        $strTmpAccessControlType = $txtPerm[7 + $global:intDiffCol]
                        $strTmpIsInherited = $txtPerm[8 + $global:intDiffCol]
                        $strTmpInheritedFlags = $txtPerm[9 + $global:intDiffCol]
                        $strTmpPropFlags = $txtPerm[10 + $global:intDiffCol]

                        #$sdHistCheck = $DSobject.psbase.get_objectSecurity().getAccessRules($true, $chkInheritedPerm.checked, [System.Security.Principal.NTAccount])
                        $rarHistCheck = @($($sd | Select-Object -Property *))

                        foreach ($sdObject in $rarHistCheck) {
                            if (($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sdObject.IdentityReference $sdObject.ActiveDirectoryRights $sdObject.InheritanceType $sdObject.ObjectType $sdObject.InheritedObjectType $sdObject.ObjectFlags $sdObject.AccessControlType $sdObject.IsInherited $sdObject.InheritanceFlags $sdObject.PropagationFlags)) {
                            }
                            else {
                                $newSdObject = New-Object psObject | `
                                    Add-Member NoteProperty IdentityReference $sdObject.IdentityReference.value -PassThru |`
                                    Add-Member NoteProperty ActiveDirectoryRights $sdObject.ActiveDirectoryRights -PassThru |`
                                    Add-Member NoteProperty InheritanceType $sdObject.InheritanceType -PassThru |`
                                    Add-Member NoteProperty ObjectType  $sdObject.ObjectType -PassThru |`
                                    Add-Member NoteProperty ObjectFlags $sdObject.ObjectFlags -PassThru |`
                                    Add-Member NoteProperty AccessControlType $sdObject.AccessControlType -PassThru |`
                                    Add-Member NoteProperty IsInherited $sdObject.IsInherited -PassThru |`
                                    Add-Member NoteProperty InheritanceFlags $sdObject.InheritanceFlags -PassThru |`
                                    Add-Member NoteProperty InheritedObjectType $sdObject.InheritedObjectType -PassThru |`
                                    Add-Member NoteProperty PropagationFlags $sdObject.PropagationFlags  -PassThru


                                If (($newSdObject.IdentityReference -eq $strIdentityReference) -and ($newSdObject.ActiveDirectoryRights -eq $strTmpActiveDirectoryRights) -and ($newSdObject.AccessControlType -eq $strTmpAccessControlType) -and ($newSdObject.ObjectType -eq $strTmpObjectTypeGUID) -and ($newSdObject.InheritanceType -eq $strTmpInheritanceType) -and ($newSdObject.InheritedObjectType -eq $strTmpInheritedObjectTypeGUID)) {
                                    $SDHistResult = $true
                                }#End If $newSdObject
                            }
                        }# End foreach



                        If ($OUMatchResult -And !($SDHistResult)) {
                            $histSDObject = New-Object psObject | `
                                Add-Member NoteProperty IdentityReference $txtPerm[1 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty ActiveDirectoryRights $txtPerm[2 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty InheritanceType $txtPerm[3 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty ObjectType  $txtPerm[4 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty ObjectFlags $txtPerm[6 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty AccessControlType $txtPerm[7 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty IsInherited $txtPerm[8 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty InheritanceFlags $txtPerm[9 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty InheritedObjectType $txtPerm[5 + $global:intDiffCol] -PassThru |`
                                Add-Member NoteProperty PropagationFlags $txtPerm[10 + $global:intDiffCol] -PassThru   |`
                                Add-Member NoteProperty Color "Missing" -PassThru

                            WriteHTM $true $histSDObject $OUdn $false "3" $strFileHTA $true $false $bolReplMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked
                            $histSDObject = ""
                        }# End If $OUMatchResult
                    }# End if $OUdn
                    $index++
                }# End While
            } #End If If ($SDUsnCheck -eq $false)

            If (!$OUMatchResultOverall) {

                foreach ($sdObject in $rar) {

                    $MissingOUSdObject = New-Object psObject | `
                        Add-Member NoteProperty IdentityReference $sdObject.IdentityReference.value -PassThru |`
                        Add-Member NoteProperty ActiveDirectoryRights $sdObject.ActiveDirectoryRights -PassThru |`
                        Add-Member NoteProperty InheritanceType $sdObject.InheritanceType -PassThru |`
                        Add-Member NoteProperty ObjectType  $sdObject.ObjectType -PassThru |`
                        Add-Member NoteProperty ObjectFlags $sdObject.ObjectFlags -PassThru |`
                        Add-Member NoteProperty AccessControlType $sdObject.AccessControlType -PassThru |`
                        Add-Member NoteProperty IsInherited $sdObject.IsInherited -PassThru |`
                        Add-Member NoteProperty InheritanceFlags $sdObject.InheritanceFlags -PassThru |`
                        Add-Member NoteProperty InheritedObjectType $sdObject.InheritedObjectType -PassThru |`
                        Add-Member NoteProperty PropagationFlags $sdObject.PropagationFlags  -PassThru |`
                        Add-Member NoteProperty Color "Node not in file"  -PassThru

                    WriteHTM $true $MissingOUSdObject $OUdn $false "5" $strFileHTA $true $false $bolReplMeta $objLastChange $bolACLsize $strACLSize $bolGetOUProtected $bolOUProtected $chkBoxEffectiveRightsColor.Checked
                }
            }
            $count++
        }# End While

        if (($count -gt 0)) {
            if ($aclcount -eq 0) {
                [System.Windows.Forms.MessageBox]::Show("No Permissions found!" , "Status")
            }
            else {
                if ($bolCSVOnly) {

                    [System.Windows.Forms.MessageBox]::Show("Done!" , "Status")
                }
                else {
                    Invoke-Item $strFileHTA
                }

            }# End If
        }
        else {
            [System.Windows.Forms.MessageBox]::Show("No objects found!" , "Status")
        }
    }# End Try
    Trap [SystemException] {
        #
        Invoke-Item $strFileHTA
        ; Continue
    }

    $histSDObject = ""
    $sdObject = ""
    $arrObjClassSplit = ""
    $MissingOUSdObject = ""
    $newSdObject = ""
    $DSobject = ""
    $strOwner = ""
    $HistACLs = ""
    $txtPerm = ""
    $objNodeDefSD = ""
    $MissingOUOwnerObject = ""

}

#==========================================================================
# Function		:  ConvertCSVtoHTM
# Arguments     : Fle Path
# Returns   	: N/A
# Description   : Convert CSV file to HTM Output
#==========================================================================
Function ConvertCSVtoHTM {
    Param($CSVInput)
    $bolRepMeta = $false
    $global:intDiffCol = 0
    If (Test-Path $CSVInput) {

        $fileName = $(Get-ChildItem $CSVInput).BaseName
        $strFileHTA = $env:temp + "\ACLHTML.hta"
        $strFileHTM = $env:temp + "\" + "$fileName" + ".htm"

        $fs = [System.IO.File]::OpenText($CSVInput)
        while ($fs.Peek() -ne -1) {
            $line = $fs.ReadLine();
            $arrline = $line.split(";")
            #Check if CSV contains the least number of columns for metadata info
            if ($arrline.count -ge $global:intColCount) {
                If ($arrline[$arrline.count - 2].length -gt 1) {
                    $bolRepMeta = $true
                }
            }
        }
        $fs.close()

        CreateHTA $fileName $strFileHTA $strFileHTM $CurrentFSPath
        CreateHTM $fileName $strFileHTM
        InitiateHTM $strFileHTA $bolRepMeta $false $false
        InitiateHTM $strFileHTM $bolRepMeta $false $false

        $tmpOU = ""
        $fs = [System.IO.File]::OpenText($CSVInput)
        while ($fs.Peek() -ne -1) {
            $line = $fs.ReadLine();

            $txtPerm = $line.split(";")

            if ($txtPerm.count -gt $global:intColCount) {
                $global:intDiffCol = ($txtPerm.count ) - $global:intColCount
                $countCol = 0
                $strOUcol = ""
                while ($countCol -le $global:intDiffCol) {
                    if ($countCol -eq 0) {
                        $strOUcol = $txtPerm[$countCol]
                    }
                    else {
                        $strOUcol = $strOUcol + ";" + $txtPerm[$countCol]

                    }
                    $countCol++

                }

            }
            else {
                $strOUcol = $txtPerm[0]
                $global:intDiffCol = 0
            }



            If ($bolRepMeta -eq $true) {

                $strOU = $strOUcol
                $strOU = ($strOU.Replace($OldDomDN, $strDomainDN))
                $strTrustee = $txtPerm[1 + $global:intDiffCol]
                $strRights = $txtPerm[2 + $global:intDiffCol]
                $strInheritanceType = $txtPerm[3 + $global:intDiffCol]
                $strObjectTypeGUID = $txtPerm[4 + $global:intDiffCol]
                $strInheritedObjectTypeGUID = $txtPerm[5 + $global:intDiffCol]
                $strObjectFlags = $txtPerm[6 + $global:intDiffCol]
                $strAccessControlType = $txtPerm[7 + $global:intDiffCol]
                $strIsInherited = $txtPerm[8 + $global:intDiffCol]
                $strInheritedFlags = $txtPerm[9 + $global:intDiffCol]
                $strPropFlags = $txtPerm[10 + $global:intDiffCol]
                $strTmpACLDate = $txtPerm[11 + $global:intDiffCol]

            }
            else {

                $strOU = $strOUcol
                $strOU = ($strOU.Replace($OldDomDN, $strDomainDN))
                $strTrustee = $txtPerm[1 + $global:intDiffCol]
                $strRights = $txtPerm[2 + $global:intDiffCol]
                $strInheritanceType = $txtPerm[3 + $global:intDiffCol]
                $strObjectTypeGUID = $txtPerm[4 + $global:intDiffCol]
                $strInheritedObjectTypeGUID = $txtPerm[5 + $global:intDiffCol]
                $strObjectFlags = $txtPerm[6 + $global:intDiffCol]
                $strAccessControlType = $txtPerm[7 + $global:intDiffCol]
                $strIsInherited = $txtPerm[8 + $global:intDiffCol]
                $strInheritedFlags = $txtPerm[9 + $global:intDiffCol]
                $strPropFlags = $txtPerm[10 + $global:intDiffCol]

            }
            $txtSdObject = New-Object psObject | `
                Add-Member NoteProperty IdentityReference $strTrustee -PassThru |`
                Add-Member NoteProperty ActiveDirectoryRights $strRights -PassThru |`
                Add-Member NoteProperty InheritanceType $strInheritanceType -PassThru |`
                Add-Member NoteProperty ObjectType  $strObjectTypeGUID -PassThru |`
                Add-Member NoteProperty ObjectFlags $strObjectFlags -PassThru |`
                Add-Member NoteProperty AccessControlType $strAccessControlType -PassThru |`
                Add-Member NoteProperty IsInherited $strIsInherited -PassThru |`
                Add-Member NoteProperty InheritanceFlags $strInheritedFlags -PassThru |`
                Add-Member NoteProperty InheritedObjectType $strInheritedObjectTypeGUID -PassThru |`
                Add-Member NoteProperty PropagationFlags $strPropFlags -PassThru



            If ($strColorTemp -eq "1") {
                $strColorTemp = "2"
            }# End If
            else {
                $strColorTemp = "1"
            }# End If
            if ($tmpOU -ne $strOU) {
                WriteHTM $true $txtSdObject $strOU $true $strColorTemp $strFileHTA $false $false $bolRepMeta $strTmpACLDate $false $strACLSize $false $false $chkBoxEffectiveRightsColor.Checked


                $tmpOU = $strOU
            }
            else {
                WriteHTM $true $txtSdObject $strOU $false $strColorTemp $strFileHTA $false $false $bolRepMeta $strTmpACLDate  $false $strACLSize $false $false $chkBoxEffectiveRightsColor.Checked

            }



        }
        #Close the CSV file
        $fs.close()
        Invoke-Item $strFileHTA
    }
    else {
        $TextBoxStatusMessage.ForeColor = $global:redcolor
        $TextBoxStatusMessage.Items.Insert(0, "Failed! $CSVInput does not exist!")
    }

}# End Function


#==========================================================================
# Function		: ImportADSettings
# Arguments     : strDN
# Returns   	: n/a
# Description   : bla bla
#==========================================================================
function ImportADSettings {
    Param ([string] $Template )

    [void] $HistACLs.Clear()
    $fs = [System.IO.File]::OpenText($Template)
    while ($fs.Peek() -ne -1) {
        $line = $fs.ReadLine();
        [void] $HistACLs.Add($line)
    }#End While

    #Close the CSV file
    $fs.close()


}
#==========================================================================
# Function		: New-Type
# Arguments     : C# Code, dll
# Returns   	: n/a
# Description   : Takes C# source code, and compiles it (in memory) for use in scri ...
#==========================================================================
function New-Type {
    param([string]$TypeDefinition, [string[]]$ReferencedAssemblies)

    $provider = New-Object Microsoft.CSharp.CSharpCodeProvider
    $dllName = [PsObject].Assembly.Location
    $compilerParameters = New-Object System.CodeDom.Compiler.CompilerParameters

    $assemblies = @("System.dll", $dllName)
    $compilerParameters.ReferencedAssemblies.AddRange($assemblies)
    if ($ReferencedAssemblies) {
        $compilerParameters.ReferencedAssemblies.AddRange($ReferencedAssemblies)
    }

    $compilerParameters.IncludeDebugInformation = $true
    $compilerParameters.GenerateInMemory = $true

    $compilerResults = $provider.CompileAssemblyFromSource($compilerParameters, $TypeDefinition)
    if ($compilerResults.Errors.Count -gt 0) {
        $compilerResults.Errors | ForEach-Object { Write-Error ("{0}:`t{1}" -f $_.Line, $_.ErrorText) }
    }
}
#==========================================================================
# Function		: GetACLMeta
# Arguments     : Domain Controller, AD Object DN
# Returns   	: Semi-colon separated string
# Description   : Get AD Replication Meta data LastOriginatingChange, LastOriginatingDsaInvocationID
#                  usnOriginatingChange and returns as string
#==========================================================================
Function GetACLMeta() {
    Param($DomainController, $objDN)

    $objADObj = [ADSI]"LDAP://$DomainController/$objDN"
    $objADObj.psbase.RefreshCache("msDS-ReplAttributeMetaData")
    foreach ($childMember in $objADObj.psbase.Properties.Item("msDS-ReplAttributeMetaData")) {
        If ($([xml]$childMember).DS_REPL_ATTR_META_DATA.pszAttributeName -eq "nTSecurityDescriptor") {
            $strLastChangeDate = $([xml]$childMember).DS_REPL_ATTR_META_DATA.ftimeLastOriginatingChange
            $strInvocationID = $([xml]$childMember).DS_REPL_ATTR_META_DATA.uuidLastOriginatingDsaInvocationID
            $strOriginatingChange = $([xml]$childMember).DS_REPL_ATTR_META_DATA.usnOriginatingChange
        }
    }

    if ($strLastChangeDate -eq $nul) {
        $ACLdate = $(get-date "1601-01-01" -UFormat "%Y-%m-%d %H:%M:%S")
        $strInvocationID = "00000000-0000-0000-0000-000000000000"
        $strOriginatingChange = "000000"
    }
    else {
        $ACLdate = $(get-date $strLastChangeDate -UFormat "%Y-%m-%d %H:%M:%S")
    }
    return "$ACLdate;$strInvocationID;$strOriginatingChange"
}

#==========================================================================
# Function		: GetACLSize
# Arguments     :
# Returns   	: Lenght of Security Descriptor
# Description   : Return the size of the Security Descriptor in bytes
#==========================================================================
Function GetACLSize() {
    $DSobject = [adsi]("LDAP://$($ALOUdn[$count])")
    $DSobject.psbase.get_objectSecurity().GetSecurityDescriptorBinaryForm().length
}
#==========================================================================
# Function		: GetEffectiveRightSP
# Arguments     :
# Returns   	:
# Description   : Rs
#==========================================================================
Function GetEffectiveRightSP() {
    param([string] $strPrincipal,
        [string] $strDomainDistinguishedName
    )
    $global:strEffectiveRightSP = ""
    $global:strEffectiveRightAccount = ""
    $global:strSPNobjectClass = ""
    $global:strPrincipalDN = ""
    $strPrinName = ""
    $global:Creds = ""
    if ($global:strPrinDomDir -eq 2) {
        & { #Try

            $global:Creds = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "$global:strPrinDomFlat")
        }
        Trap [SystemException] {
            continue
        }
        $h = (get-process -id $global:myPID).MainWindowHandle # just one notepad must be opened!
        [SFW]::SetForegroundWindow($h)
        if ($null -ne $global:Creds.UserName) {
            if (TestCreds $global:Creds) {
                $global:strPinDomDC = $(GetDomainController $global:strDomainPrinDNName $true $global:Creds)
                $global:strPrincipalDN = (GetSecPrinDN $strPrincipal $strDomainDistinguishedName $true $global:Creds)
            }
            else {
                $TextBoxStatusMessage.ForeColor = $global:redcolor
                $TextBoxStatusMessage.Items.Insert(0, "Bad user name or password!")
                $lblEffectiveSelUser.Text = ""
            }
        }
        else {
            $TextBoxStatusMessage.ForeColor = $global:redcolor
            $TextBoxStatusMessage.Items.Insert(0, "Faild to insert credentials!")

        }
    }
    else {
        if ( $global:strDomainPrinDNName -eq $global:strDomainDNName ) {
            $lblSelectPrincipalDom.text = $global:strDomainShortName + ":"
            $global:strPinDomDC = $global:strDC
            $global:strPrincipalDN = (GetSecPrinDN $strPrincipal $strDomainDistinguishedName $false)
        }
        else {
            $global:strPinDomDC = $(GetDomainController $global:strDomainPrinDNName $false)
            $global:strPrincipalDN = (GetSecPrinDN $strPrincipal $strDomainDistinguishedName $false)
        }
    }
    if ($global:strPrincipalDN -eq "") {
        $TextBoxStatusMessage.ForeColor = $global:redcolor
        $TextBoxStatusMessage.Items.Insert(0, "Could not find $strPrincipal!")
        $lblEffectiveSelUser.Text = ""
    }
    else {
        $global:strEffectiveRightAccount = $strPrincipal
        $TextBoxStatusMessage.Items.Insert(0, "Found security principal")
        $TextBoxStatusMessage.ForeColor = "black"
        if ($global:strPrinDomDir -eq 2) {
            [System.Collections.ArrayList] $global:tokens = @(GetTokenGroups $global:strPrincipalDN $true $global:Creds)

            $objADPrinipal = new-object DirectoryServices.DirectoryEntry("LDAP://$global:strPinDomDC/$global:strPrincipalDN", $global:Creds.UserName, $global:Creds.GetNetworkCredential().Password)


            $objADPrinipal.psbase.RefreshCache("msDS-PrincipalName")
            $strPrinName = $($objADPrinipal.psbase.Properties.Item("msDS-PrincipalName"))
            $global:strSPNobjectClass = $($objADPrinipal.psbase.Properties.Item("objectClass"))[$($objADPrinipal.psbase.Properties.Item("objectClass")).count - 1]
            if (($strPrinName -eq "") -or ($null -eq $strPrinName)) {
                $strNETBIOSNAME = $global:strPrinDomFlat
                $strPrinName = "$strNETBIOSNAME\$($objADPrinipal.psbase.Properties.Item("samAccountName"))"
            }
            $global:strEffectiveRightSP = $strPrinName
            $global:tokens.Add($strPrinName)
            $lblEffectiveSelUser.Text = $strPrinName
        }
        else {
            [System.Collections.ArrayList] $global:tokens = @(GetTokenGroups $global:strPrincipalDN $false)


            $objADPrinipal = new-object DirectoryServices.DirectoryEntry("LDAP://$global:strPinDomDC/$global:strPrincipalDN")


            $objADPrinipal.psbase.RefreshCache("msDS-PrincipalName")
            $strPrinName = $($objADPrinipal.psbase.Properties.Item("msDS-PrincipalName"))
            $global:strSPNobjectClass = $($objADPrinipal.psbase.Properties.Item("objectClass"))[$($objADPrinipal.psbase.Properties.Item("objectClass")).count - 1]
            if (($strPrinName -eq "") -or ($null -eq $strPrinName)) {
                $strNETBIOSNAME = $global:strPrinDomFlat
                $strPrinName = "$strNETBIOSNAME\$($objADPrinipal.psbase.Properties.Item("samAccountName"))"
            }
            $global:strEffectiveRightSP = $strPrinName
            $global:tokens.Add($strPrinName)
            $lblEffectiveSelUser.Text = $strPrinName
        }

    }

}

#Number of columns in CSV import
$global:intColCount = 15
#Sidestepping columns when DN contains semicolon
$global:intDiffCol = 0

$global:myPID = $PID
$HistACLs = New-Object System.Collections.ArrayList
$CurrentFSPath = split-path -parent $MyInvocation.MyCommand.Path
$strLastCacheGuidsDom = ""
$TNRoot = ""
$global:prevNodeText = ""
$sd = ""
##Call the Function
GenerateForm
```

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

---

#### Download

Please feel free to copy parts of the script or if you would like to download the entire script, simple click the download button. You can download the complete repository in a zip file by clicking the Download link in the menu bar on the left hand side of the page.

<button class="btn" type="submit" onclick="window.open('/PowerShell/scripts/activeDirectory/ADACLScan1.3.3.ps1')">
    <i class="fa fa-cloud-download-alt">
    </i>
        Download
</button>

---

#### Report Issues

You can report an issue or contribute to this site on <a href="https://github.com/BanterBoy/scripts-blog/issues">GitHub</a>. Simply click the button below and add any relevant notes. I will attempt to respond to all issues as soon as possible.

<!-- Place this tag where you want the button to render. -->

<a class="github-button" href="https://github.com/BanterBoy/scripts-blog/issues/new?title=ADACLScan1.3.3.ps1&body=There is a problem with this function. Please find details below." data-show-count="true" aria-label="Issue BanterBoy/scripts-blog on GitHub">Issue</a>

---

<span style="font-size:11px;"><a href="#"><i class="fas fa-caret-up" aria-hidden="true" style="color: white; margin-right:5px;"></i>Back to Top</a></span>

<a href="/menu/_pages/scripts.html">
    <button class="btn">
        <i class='fas fa-reply'>
        </i>
            Back to Scripts
    </button>
</a>

[1]: http://ecotrust-canada.github.io/markdown-toc
[2]: https://github.com/googlearchive/code-prettify
