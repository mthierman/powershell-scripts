param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    $in,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    $out
)

magick $in `
    -trim +repage `
    -gravity center `
    -background none `
    -extent "%[fx:max(w,h)]x%[fx:max(w,h)]" `
    -define icon:auto-resize="256,128,96,80,72,64,60,48,40,36,32,30,24,20,16" `
    $out
