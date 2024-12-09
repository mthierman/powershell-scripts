param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

$filename = "tasks.psm1"

Push-Location
$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

while ((Get-Location).Path -ne (Get-Location).Drive.Root)
{
    if (Test-Path $filename)
    {
        Import-Module -Name (Get-Item $filename).FullName
        [System.Collections.Specialized.OrderedDictionary]$Commands = &tasks\Export-Tasks

        if ($Command -eq "--ls")
        {
            foreach ($key in $Commands.Keys)
            {
                Write-Host "* $key" -ForegroundColor Cyan
            }
        }
        elseif ($Command -eq "--cmd")
        {
            foreach ($key in $Commands.Keys)
            {
                Write-Host "* $key" -ForegroundColor Cyan
                Write-Host $Commands[$key] -ForegroundColor Magenta
            }
        }
        else
        {
            &$Commands.$Command
        }

        Remove-Module -Name tasks
        break
    }
    else
    {
        Set-Location (Get-Item (Get-Location)).Parent
    }
}

$ErrorActionPreference = $PreviousErrorActionPreference
Pop-Location
