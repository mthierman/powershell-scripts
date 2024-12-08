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

function Write-ScriptName
{
    param([String]$script)

    Write-Host "* $($script.Split(".ps1")[0])" -ForegroundColor Cyan
}

function Write-ScriptContent
{
    param([String]$script)

    Get-Content "scripts\$script" | ForEach-Object { "    $_" } | Write-Host -ForegroundColor Magenta
}

function Invoke-Script
{
    if ($Command -eq "--ls")
    {
        $scripts = Get-Scripts
        foreach ($script in $scripts)
        {
            Write-ScriptName($script)
        }
    }
    elseif ($Command -eq "--cmd")
    {
        $scripts = Get-Scripts
        foreach ($script in $scripts)
        {
            Write-ScriptName($script)
            Write-ScriptContent($script)
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
}

Push-Location
while ((Get-Location).Path -ne (Get-Location).Drive.Root)
{
    if (Test-Path "scripts")
    {
        Invoke-Script
        break
    }
    else
    {
        Set-Location (Get-Item (Get-Location)).Parent
    }
}
if ((Get-Location).Path -eq (Get-Location).Drive.Root)
{
    Write-Error "Scripts not found"
}
Pop-Location
