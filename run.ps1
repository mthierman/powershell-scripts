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
    if (Test-Path "run.psm1")
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
    Import-Module -Name (Get-Item "run.psm1").FullName
    try
    {
        [System.Collections.Specialized.OrderedDictionary]$commands = & run\Export-Commands

        if ($Command -eq "--ls")
        {
            foreach ($key in $commands.Keys)
            {
                Write-Host "* $key" -ForegroundColor Cyan
            }
        }
        elseif ($Command -eq "--cmd")
        {
            foreach ($key in $commands.Keys)
            {
                Write-Host "* $key" -ForegroundColor Cyan
                Write-Host $commands[$key] -ForegroundColor Magenta
            }
        }
        else
        {
            & $commands.$Command
        }
    }
    catch { Write-Host "Command not found" -ForegroundColor "Red" }
    finally
    {
        Remove-Module -Name run
    }
}
catch { Write-Host "Run module not found" -ForegroundColor "Red" }
finally
{
    $ErrorActionPreference = $PreviousErrorActionPreference
    Pop-Location 
}
