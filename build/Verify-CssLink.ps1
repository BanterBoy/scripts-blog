Param(
  [Parameter(Mandatory)][string]$SiteRoot,   # e.g. "$(Build.SourcesDirectory)/_site" or "dist"
  [Parameter(Mandatory)][string]$CssHint     # e.g. "main.css" or "app"
)
$ErrorActionPreference = 'Stop'

# Find a plausible main CSS file (largest match by name)
$css = Get-ChildItem -Path $SiteRoot -Recurse -Include *.css |
       Where-Object { $_.Name -match [Regex]::Escape($CssHint) } |
       Sort-Object Length -Descending | Select-Object -First 1
if (-not $css) { throw "No CSS matching '$CssHint' under $SiteRoot." }
if ($css.Length -le 256) { throw "CSS '$($css.FullName)' appears too small to be valid." }

# Ensure at least one HTML references it
$htmls = Get-ChildItem -Path $SiteRoot -Recurse -Include index.html,*.html
if (-not $htmls) { throw "No HTML found under $SiteRoot." }

$rel = [System.IO.Path]::GetRelativePath($SiteRoot, $css.FullName)
$linked = $false
foreach ($h in $htmls) {
  $c = Get-Content -Raw -Path $h.FullName
  if ($c -match [Regex]::Escape($rel) -or $c -match [Regex]::Escape($css.Name)) { $linked = $true; break }
}
if (-not $linked) { throw "No HTML references '$($css.Name)' or '$rel'." }

Write-Host "✅ CSS '$($css.Name)' exists and is referenced by at least one HTML."
