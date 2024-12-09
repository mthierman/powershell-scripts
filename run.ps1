param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

$PreviousErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

try
{
    Import-Module -Name (Get-Item "run.psm1").FullName -Prefix runner.
    try
    {
        if ($Command -eq "--ls")
        {
            $commands = (Get-Module run).ExportedCommands.Values.Name
            foreach ($command in $commands)
            {
                Write-Host "* $command" -ForegroundColor Cyan
            }
        }
        elseif ($Command -eq "--cmd")
        {
            $commands = (Get-Module run).ExportedCommands.Values.Name
            foreach ($command in $commands)
            {
                Write-Host "* $command" -ForegroundColor Cyan
                Write-Host (Get-Command "runner.$command").Definition -ForegroundColor Magenta
            }
        }
        else
        {
            Get-Command "runner.$Command" | Out-Null
            &"runner.$Command"
        }
    }
    catch { Write-Host "Command not found" -ForegroundColor "Red" }
    finally
    {
        Remove-Module -Name run
    }
}
catch { Write-Host "Run module not found" -ForegroundColor "Red" }
finally { $ErrorActionPreference = $PreviousErrorActionPreference }
