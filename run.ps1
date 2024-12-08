$cmd = $args[0]
$script_path = ".\scripts\$cmd.ps1"

if (Test-Path $script_path)
{
    & $script_path
}
