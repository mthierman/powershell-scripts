param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

# $script_path = ".\scripts\$Script.ps1"
# $script_count = $scripts.Count
# $current_index = 0

$scripts = {
    Get-ChildItem -Path "scripts" -Filter "*.ps1" | Select-Object -ExpandProperty Name
}

$print_script_name = {
    param([String]$script)
    Write-Host "* $($script.Split(".ps1")[0]):" -ForegroundColor Cyan
}

$print_script_content = {
    param([String]$script)
    Get-Content "scripts\$script" | ForEach-Object { "    $_" } | Write-Host -ForegroundColor Magenta
}

# $print_commands = {
#     foreach ($script in $scripts)
#     {
#         $current_index++
#         & $print_script_name($script)
#     }
# }

if ($Command -eq "--ls")
{
    foreach ($script in & $scripts)
    {
        $current_index++
        & $print_script_name($script)
    }
}

# if ($cmd -eq "--cmd")
# {
#     foreach ($script in $scripts)
#     {
#         $current_index++
#         & $print_script_name($script)
#         & $print_script_content($script)

#         if ($current_index -lt $script_count)
#         {
#             Write-Host "`n" -NoNewline
#         }
#     }
# }

# if (Test-Path $script_path)
# {
#     & $script_path
# }
