<###############################################
	Variables
################################################>

$MyDir = Split-Path $MyInvocation.MyCommand.Definition
. "$MyDir\Variablen-Visio.ps1"
$WarningPreference='SilentlyContinue'

<###############################################
	Functions
################################################>

function connect-visioobject ($firstObj, $secondObj)
{
 $shpConn = $pagObj.Drop($pagObj.Application.ConnectorToolDataObject, 0, 0)
 #// Connect its Begin to the 'From' shape:
 $connectBegin = $shpConn.CellsU("BeginX").GlueTo($firstObj.CellsU("PinX"))
 #// Connect its End to the 'To' shape:
 $connectEnd = $shpConn.CellsU("EndX").GlueTo($secondObj.CellsU("PinX"))
 }

function add-visioobject ($mastObj, $item, $x, $y)
{
 Write-Host "Adding $item"
 # Drop the selected stencil on the active page, with the coordinates x, y
 $shpObj = $pagObj.Drop($mastObj, $x, $y)
 # Enter text for the object
 $shpObj.Text = $item
 #Return the visioobject to be used
 return $shpObj
 }

function New-VisioDocument ($visible)
{
$AppVisio = New-Object -ComObject Visio.Application
$AppVisio.Visible = $visible
$docsObj = $AppVisio.Documents
$DocObj = $docsObj.Add("ActDir_M.vst")

$pagsObj = $AppVisio.ActiveDocument.Pages
$pagObj = $pagsObj.Item(1)
$ADStencil = $docsObj.Item("ADO_M.vss")

$AppVisio
}

function recFileStructure ($item, $parent, $iterator)
{
Write-Host $item
$dirs = Get-ChildItem -Path $item | Where-Object {$_.Psiscontainer}
if ($dirs -and ($iterator -lt 3))
{
	foreach($dir in $dirs)
	{
		$accessList = Get-ACL $dir.FullName -WarningAction $WarningPreference
		$ok = $false
		Foreach ($list in $accessList.Access) {if ($list.IsInherited -eq $false){$ok = $true}}

		if ($accessList -and $ok) {
			$x += 0.3
			$object = add-visioobject $OUItem $dir.Name $x $y
			Foreach ($shape in $object.Shapes) {$shape.Cells("FillForegnd").FormulaU = "RGB(255,0,0)"}
			$notiz = $NotizItem.Masters.ItemU("Box Callout")

			$f = $pagObj.DropCallout($notiz, $object)

			$f.CellsSRC($visSectionCharacter, 0, $visCharacterSize).FormulaU = "6 pt"
			$f.CellsSRC($visSectionParagraph, 0, $visHorzAlign).FormulaU = "0"
			$f.CellsSRC($visSectionObject, $visRowText, $visTxtBlkVerticalAlign).FormulaU = "0"
			$f.CellsSRC($visSectionObject, $visRowFill, $visFillForegnd).FormulaU = "THEMEGUARD(MSOTINT(THEME(""AccentColor4""),80))"

			$f.Text = $dir.Fullname + "`n"

			Foreach ($access in $accessList.Access) {
				if (!$access.isInherited) {
				$zeile = $access.IdentityReference.ToString() + " | " + $access.FileSystemRights.ToString() + "`n"
				$f.Text += $zeile}
			}
			$f.Text = $f.Text.Substring(0,$f.Text.Length - 1)
			$f.CellsU("Width").Formula = "MAX(TEXTWIDTH(theText), 6 * Char.Size)"
			$f.CellsU("PinX").FormulaU = "0"
			$f.CellsU("PinY").FormulaU = "0"

			$color = $Host.UI.RawUI.ForegroundColor
			$Host.UI.RawUI.ForegroundColor = "cyan"
			$accessList
		 	$Host.UI.RawUI.ForegroundColor = $color
			connect-visioobject $parent $object
			$y += 0.3
		}
		$pagObj.PageSheet.CellsSRC($visSectionObject, $visRowPageLayout, $visPLOPlaceStyle).FormulaForceU = "7"
		$pagObj.PageSheet.CellsSRC($visSectionObject, $visRowPageLayout, $visPLORouteStyle).FormulaForceU = "3"
		$pagObj.Layout()
		recFileStructure $dir.FullName $object ($iterator+1)
	}
}
}


<###############################################
	MAIN
################################################>

# Definitions
$VisioDocu = New-VisioDocument $true
$pagObj = $VisioDocu.ActiveDocument.Pages.Item(1)
$domainItem = $VisioDocu.Documents.Item("ADO_M.vss").Masters.ItemU("Domain")
$OUItem = $VisioDocu.Documents.Item("ADO_M.vss").Masters.ItemU("Container")   # 'Folder'
$NotizItem = $VisioDocu.Documents.OpenEx($VisioDocu.GetBuiltInStencilFile($visBuiltinStencilCallouts, $visMSDefault), $visOpenHidden) # CallOut

# Define Path and start recursion
$PathtoScan = "\\servername\sharename\foldername\"
$root = add-visioobject $domainItem $PathtoScan
recFileStructure $PathtoScan $root 0

# Set Layout
# Reset coordinates of all CallOuts
Foreach ($id in $pagObj.GetCallouts(0)) {
	$pagObj.Shapes.ItemFromID($id).CellsU("PinX").FormulaU = "CALLOUTTARGETREF()!PinX + 2"
	$pagObj.Shapes.ItemFromID($id).CellsU("PinY").FormulaU = "CALLOUTTARGETREF()!PinY + 1"
	$pagObj.Shapes.ItemFromID($id).SendToBack()
}

$pagObj.Layout()
$pagObj.ResizeToFitContents()

$Background = $VisioDocu.Documents.OpenEx($VisioDocu.GetBuiltInStencilFile($visBuiltinStencilBackgrounds, $visMSDefault), $visOpenHidden)
$nil = $pagObj.Drop($Background.Masters.ItemU("Vertical Gradient"), 4.133858, 5.850394)
$Titel = $VisioDocu.Documents.OpenEx($VisioDocu.GetBuiltinStencilFile($visBuiltinStencilBorders, $visMSDefault), $visOpenHidden)
$Titel_drop = $pagObj.Drop($Titel.Masters.ItemU("Blocks"), 7.723097, 7.46063)

Foreach ($id in $pagObj.GetCallouts(0)) {
	$pagObj.Shapes.ItemFromID($id).CellsU("PinX").FormulaU = "CALLOUTTARGETREF()!PinX + 2"
	$pagObj.Shapes.ItemFromID($id).CellsU("PinY").FormulaU = "CALLOUTTARGETREF()!PinY + 1"
	$pagObj.Shapes.ItemFromID($id).SendToBack()
}
