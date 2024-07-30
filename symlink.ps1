param (
    [ValidateNotNullOrEmpty()]
    [string]$Target,
    [string]$Path
)

New-Item -ItemType SymbolicLink -Target $Target -Path $Path -Force
