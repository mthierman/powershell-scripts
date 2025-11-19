param (
    [ValidateSet('x86', 'amd64', 'arm', 'arm64')]
    [string]$Arch = 'amd64',
    [ValidateSet('x86', 'amd64')]
    [string]$HostArch = 'amd64'
)

& "$(vswhere -latest -property installationPath)\Common7\Tools\Launch-VsDevShell.ps1" -Arch $Arch -HostArch $HostArch -SkipAutomaticLocation
