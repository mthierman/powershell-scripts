$cmd = $args[0]
$script_path = ".\scripts\$cmd.ps1"

if ($cmd -eq "--list")
{
    $scripts = Get-ChildItem -Path "scripts" -Filter "*.ps1" | Select-Object -ExpandProperty Name

    foreach ($item in $scripts)
    {
        "$($item.TrimEnd(".ps1")):"
        Get-Content "scripts\$item"
        "`n"
    }
}

if (Test-Path $script_path)
{
    & $script_path
}
