param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ConfigurePreset,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$BuildPreset
)

cmake --preset $ConfigurePreset
cmake --build --preset $BuildPreset
