Function Convert-fromSVG {
    param(
        [string]$path = '.',
        [string]$exec = 'C:\Program Files\Inkscape\inkscape.exe'
    )

    foreach ($filename in Get-ChildItem $path) {
        if ($filename.toString().EndsWith('.svg')) {


            $targetName = $filename.BaseName + ".png";

            Write-Output "Converting $filename ..."

            $command = "& `"$exec`" -z -e `"$targetName`" -w 64 `"$filename`"";
            Invoke-Expression $command;

        }
    }
}
