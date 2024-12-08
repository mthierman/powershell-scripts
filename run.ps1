param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Name,
    [ValidateNotNullOrEmpty()]
    [string]$Folder
)

$print_script_name = {
    param([String]$script)
    Write-Host "* $($script.Split(".ps1")[0]):" -ForegroundColor Cyan
}

$print_script_content = {
    param([String]$script)
    Get-Content "scripts\$script" | ForEach-Object { "    $_" } | Write-Host -ForegroundColor Magenta
}

$print_commands = {
    foreach ($script in $scripts)
    {
        $current_index++
        & $print_script_name($script)
    }
}

$script_path = ".\scripts\$Name.ps1"
if ($Folder)
{
    $scripts = Get-ChildItem -Path "scripts" -Filter "*.ps1" | Select-Object -ExpandProperty Name
}
else
{
    $scripts = Get-ChildItem -Path $Folder -Filter "*.ps1" | Select-Object -ExpandProperty Name
}
$script_count = $scripts.Count
$current_index = 0

if (!$cmd)
{
    Write-Error "Specify a script:"
    & $print_commands
}

if ($cmd -eq "--ls")
{
    & $print_commands
}

if ($cmd -eq "--cmd")
{
    foreach ($script in $scripts)
    {
        $current_index++
        & $print_script_name($script)
        & $print_script_content($script)

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
