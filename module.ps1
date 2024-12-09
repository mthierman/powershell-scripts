param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

function Invoke-ModuleCommand
{
    $PreviousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

    try
    {
        Get-Command $Command | Out-Null
        &$Command
    }
    catch { Write-Host "Command not found" -ForegroundColor "Red" }
    finally
    {
        $ErrorActionPreference = $PreviousErrorActionPreference
    }
}

Import-Module -Name (Get-Item "run.psm1").FullName
Invoke-ModuleCommand
Remove-Module -Name run
