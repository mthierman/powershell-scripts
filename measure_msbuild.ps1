param (
    [ValidateNotNullOrEmpty()]
    $cCompiler = 'cl',
    $cxxCompiler = 'cl',
    [string]$target,
    [ValidateNotNullOrEmpty()]
    [string]$config = 'Debug',
    [switch]$fresh,
    [switch]$unityBuild

)

if ($fresh)
{
    if (Test-Path "build") { Remove-Item -Path "build" -Force -Recurse }
}

dev
cmake -S . -B build -G "Visual Studio 17 2022" -DCMAKE_C_COMPILER="$cCompiler" -DCMAKE_CXX_COMPILER="$cxxCompiler" -DCMAKE_UNITY_BUILD="$($unityBuild ? "ON" : "OFF")"

if ($target)
{
    Measure-Command { cmake --build build --target $target --config $config | Out-Default }
}
else
{
    Measure-Command { cmake --build build --config $config | Out-Default }
}
