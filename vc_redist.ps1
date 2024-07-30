param (
    [Parameter(Mandatory)]
    [string]$Outdir
)

if (!(Test-Path $Outdir)) { New-Item -ItemType Directory $Outdir }
Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vc_redist.x64.exe" -OutFile $(if ($Outdir) { $Outdir } else { "." })
