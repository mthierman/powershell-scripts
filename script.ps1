$cmd = $args[0]
$script_path = ".\scripts\$cmd.ps1"

if ($cmd -eq "--list")
{
    $scripts = Get-ChildItem -Path "scripts" -Filter "*.ps1" | Select-Object -ExpandProperty Name

    foreach ($script in $scripts)
    {
        Write-Host "$($script.TrimEnd(".ps1")):" -ForegroundColor Green
        Get-Content "scripts\$script" | ForEach-Object { "    $_" } | Write-Host -ForegroundColor Magenta
        Write-Host "`n"
    }
}

if (Test-Path $script_path)
{
    & $script_path
}
