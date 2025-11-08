param (
    [ValidateSet('x86', 'amd64', 'arm', 'arm64')]
    [string]$Arch = 'amd64',
    [ValidateSet('x86', 'amd64')]
    [string]$HostArch = 'amd64'
)

$vspath = "C:\Program Files\Microsoft Visual Studio\18\Insiders"
& "$vspath\Common7\Tools\Launch-VsDevShell.ps1" -Arch $Arch -HostArch $HostArch -SkipAutomaticLocation
