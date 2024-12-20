param (
    [switch]$fresh,

    [ValidateNotNullOrEmpty()]
    $cCompiler = 'cl',
    [ValidateNotNullOrEmpty()]
    $cxxCompiler = 'cl',
    [switch]$unityBuild,

    [ValidateNotNullOrEmpty()]
    [string]$target = 'all',
    [ValidateNotNullOrEmpty()]
    [string]$config = 'Debug'
)

if ($fresh)
{
    if (Test-Path "build") { Remove-Item -Path "build" -Force -Recurse }
}

dev
cmake -S . -B build -G "Ninja Multi-Config" -DCMAKE_C_COMPILER="$cCompiler" -DCMAKE_CXX_COMPILER="$cxxCompiler" -DCMAKE_UNITY_BUILD="$($unityBuild ? "ON" : "OFF")"
Measure-Command { cmake --build build --target $target --config $config | Out-Default }
