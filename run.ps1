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
        Import-Module -Name (Get-Item "run.psm1").FullName
        [System.Collections.Specialized.OrderedDictionary]$Commands = &run\Export-Commands

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
        Remove-Module -Name run
        break
    }
    else
    {
        Set-Location (Get-Item (Get-Location)).Parent
    }
}

$ErrorActionPreference = $PreviousErrorActionPreference
Pop-Location
