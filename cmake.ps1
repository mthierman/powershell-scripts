param (
    [ValidateNotNullOrEmpty()]
    [string]$ConfigurePreset,
    [string]$BuildPreset
)

cmake --preset $ConfigurePreset
cmake --build --preset $BuildPreset
