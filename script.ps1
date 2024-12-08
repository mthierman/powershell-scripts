param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

function Get-Scripts
{
    [OutputType([Object[]])]
    param()

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

Push-Location

$current_dir = Get-Location
$root = $location.Drive.Root
$parent = (Get-Item $current_dir).Parent
$parent

while ($current_dir -ne $root)
{
    if (Test-Path "scripts")
    {
        break
    }
    else
    {
        Set-Location (Get-Item $current_dir).Parent
    }
}

# if (Test-Path "scripts")
# {
#     Write-Host "scripts found"
# }
# else
# {
#     Write-Host "scripts not found"
# }

if ($Command -eq "--ls")
{
    $scripts = Get-Scripts
    foreach ($script in $scripts)
    {
        &$print_script_name($script)
    }
}
elseif ($Command -eq "--cmd")
{
    $scripts = Get-Scripts
    foreach ($script in $scripts)
    {
        &$print_script_name($script)
        &$print_script_content($script)
        $current_index++
        if ($current_index -lt $scripts.Count)
        {
            Write-Host "`n" -NoNewline
        }
    }
}
else
{
    $path = ".\scripts\$Command.ps1"
    if (Test-Path $path)
    {
        $script = Get-ChildItem $path
        &$script
    }
    else
    {
        Write-Error "Script not found"
    }
}

Pop-Location
