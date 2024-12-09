param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command
)

$module_file = "task.psm1"

Push-Location

while ((Get-Location).Path -ne (Get-Location).Drive.Root)
{
    if (Test-Path $module_file)
    {
        $module = Import-Module -Name (Get-Item $module_file).FullName -Function Export-Task -PassThru
        [System.Collections.Specialized.OrderedDictionary]$Commands = &"$($module.Name)\$($module.ExportedCommands.Keys)"

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

Pop-Location
