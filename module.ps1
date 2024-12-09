param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

try
{
    Import-Module -Name (Get-Item "run.psm1").FullName
    try
    {
        Get-Command $Command | Out-Null
        &$Command
    }
    catch { Write-Host "Command not found" -ForegroundColor "Red" }
    finally
    {
        Remove-Module -Name run
    }
}
catch {}
finally { $ErrorActionPreference = $PreviousErrorActionPreference }
