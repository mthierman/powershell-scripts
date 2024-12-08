param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

# $script_path = ".\scripts\$Script.ps1"
# $script_count = $scripts.Count
# $current_index = 0

$get_scripts = {
    Get-ChildItem -Path "scripts" -Filter "*.ps1" | Select-Object -ExpandProperty Name
}

$print_script_name = {
    param([String]$script)
    Write-Host "* $($script.Split(".ps1")[0])" -ForegroundColor Cyan
}

$print_script_content = {
    param([String]$script)
    Get-Content "scripts\$script" | ForEach-Object { "    $_" } | Write-Host -ForegroundColor Magenta
}

if ($Command -eq "--ls")
{
    $scripts = &$get_scripts

    foreach ($script in $scripts)
    {
        &$print_script_name($script)
    }
}

if ($Command -eq "--cmd")
{
    $scripts = &$get_scripts

    foreach ($script in $scripts)
    {
        $current_index++
        &$print_script_name($script)
        &$print_script_content($script)

        if ($current_index -lt $scripts.Count)
        {
            Write-Host "`n" -NoNewline
        }
    }
}

# if (Test-Path $script_path)
# {
#     & $script_path
# }
