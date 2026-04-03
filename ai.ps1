param(
    [string]$Model = "gemma4e2b"
)

$models = @{
    gemma4e2b = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q4_K_M.gguf"
    gemma4e4b = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E4B-it-GGUF/gemma-4-E4B-it-Q4_K_M.gguf"
    qwen359b  = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-9B-GGUF/Qwen3.5-9B-Q4_K_M.gguf"
    qwen354b  = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-4B-GGUF/Qwen3.5-4B-Q4_K_M.gguf"
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
    split-pane -H --title "pi:$Model" --startingDirectory "$cwd" `
    powershell -NoExit -Command "& { $clientCmd }"
