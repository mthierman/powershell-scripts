Get-Content run.psd1
[Hashtable]$import = Import-PowerShellDataFile run.psd1 -SkipLimitCheck
$import.GetType()
$import.ContainsKey("path")
# Get-Item $import.path
[string]$path = $import.path
(Get-Item $path).FullName
