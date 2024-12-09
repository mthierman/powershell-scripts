param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

Push-Location

$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

while ((Get-Location).Path -ne (Get-Location).Drive.Root)
{
    if (Test-Path "run.ps1")
    {
        break
    }
    else
    {
        Set-Location (Get-Item (Get-Location)).Parent
    }
}

try
{
    [System.Collections.Specialized.OrderedDictionary]$entries = .\run.ps1

    try
    {
        if ($Command -eq "--ls")
        {
            foreach ($key in $entries.Keys)
            {
                Write-Host "* $key" -ForegroundColor Cyan
            }
        }
        elseif ($Command -eq "--cmd")
        {
            foreach ($key in $entries.Keys)
            {
                Write-Host "* $key" -ForegroundColor Cyan
                Write-Host $entries[$key] -ForegroundColor Magenta
            }
        }
        else
        {
            &$entries.$Command
        }
    }
    catch { Write-Host "Command not found" -ForegroundColor "Red" }
}
catch { Write-Host "Run module not found" -ForegroundColor "Red" }
finally
{
    $ErrorActionPreference = $PreviousErrorActionPreference
    Pop-Location 
}
