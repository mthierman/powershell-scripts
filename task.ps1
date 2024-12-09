param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

$filename = "task.psm1"

Push-Location
$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

while ((Get-Location).Path -ne (Get-Location).Drive.Root)
{
    if (Test-Path $filename)
    {
        $module = Import-Module -Name (Get-Item $filename).FullName -Function Export-Task -PassThru
        [System.Collections.Specialized.OrderedDictionary]$Commands = &task\Export-Task

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

        Remove-Module $module
        break
    }
    else
    {
        Set-Location (Get-Item (Get-Location)).Parent
    }
}

$ErrorActionPreference = $PreviousErrorActionPreference
Pop-Location
