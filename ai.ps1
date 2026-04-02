param(
    [string]$Model = "qwen4b"
)

$models = @{
    qwen4b = "C:\Users\mthie\.lmstudio\models\lmstudio-community\Qwen3.5-4B-GGUF\Qwen3.5-4B-Q4_K_M.gguf"
    qwen9b = "C:\Users\mthie\.lmstudio\models\lmstudio-community\Qwen3.5-9B-GGUF\Qwen3.5-9B-Q4_K_M.gguf"
    gemma3 = "C:\Users\mthie\.lmstudio\models\lmstudio-community\gemma-3-4b-it-GGUF\gemma-3-4b-it-Q4_K_M.gguf"
}

if (-not $models.ContainsKey($Model))
{
    Write-Host "Unknown model: $Model"
    exit 1
}

$modelPath = $models[$Model]
$port = 8080
$cwd = (Get-Location).Path

$serverCmd = "llama-server --model `"$modelPath`" --port $port"

$clientCmd = @"
while (-not (Test-NetConnection -ComputerName localhost -Port $port).TcpTestSucceeded) {
    Start-Sleep -Milliseconds 200
}
pi
"@

wt --focus --maximized `
    new-tab --title "server:$Model" --startingDirectory "$cwd" `
    powershell -NoExit -Command "& { $serverCmd }" `; `
    split-pane -V --title "pi:$Model" --startingDirectory "$cwd" `
    powershell -NoExit -Command "& { $clientCmd }"
