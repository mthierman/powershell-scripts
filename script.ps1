$cmd = $args[0]
$script_path = ".\scripts\$cmd.ps1"

if ($cmd -eq "--list")
{
    $scripts = Get-ChildItem -Path "scripts" -Filter "*.ps1" | Select-Object -ExpandProperty Name
    $script_count = $scripts.Count
    $current_index = 0

    foreach ($script in $scripts)
    {
        $current_index++
        Write-Host "$($script.TrimEnd(".ps1")):" -ForegroundColor Green
        Get-Content "scripts\$script" | ForEach-Object { "    $_" } | Write-Host -ForegroundColor Magenta

        if ($current_index -lt $script_count)
        {
            Write-Host "`n" -NoNewline
        }
    }
}

if (Test-Path $script_path)
{
    & $script_path
}
