param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Script,
    [ValidateNotNullOrEmpty()]
    [string]$Folder
)

$get_scripts = {
    param([bool]$custom_folder)
    if ($custom_folder)
    {
        Write-Host "using $Folder..."
        Get-ChildItem -Path $Folder -Filter "*.ps1" | Select-Object -ExpandProperty Name
    }
    else
    {
        Write-Host "using default scripts folder..."
        Get-ChildItem -Path "scripts" -Filter "*.ps1" | Select-Object -ExpandProperty Name
    }
}

$print_script_name = {
    param([String]$script)
    Write-Host "* $($script.Split(".ps1")[0]):" -ForegroundColor Cyan
}

$print_script_content = {
    param([String]$script)
    Get-Content "scripts\$script" | ForEach-Object { "    $_" } | Write-Host -ForegroundColor Magenta
}

$print_commands = {
    param([Object[]]$scripts)
    $current_index = 0

    foreach ($script in $scripts)
    {
        $current_index++
        & $print_script_name($script)
    }
}

$script_path = ".\scripts\$Name.ps1"
$scripts = & $get_scripts($PSBoundParameters.ContainsKey("Folder"))
$script_count = $scripts.Count

if ($cmd -eq "--ls")
{
    & $print_commands($scripts)
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
