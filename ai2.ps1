param(
    [string]$Model = "qwen4b"
)

$models = @{
    qwen4b = "C:\Users\mthie\.lmstudio\models\lmstudio-community\Qwen3.5-4B-GGUF\Qwen3.5-4B-Q4_K_M.gguf"
    qwen9b = "C:\Users\mthie\.lmstudio\models\lmstudio-community\Qwen3.5-9B-GGUF\Qwen3.5-9B-Q4_K_M.gguf"
    gemma3 = "C:\Users\mthie\.lmstudio\models\lmstudio-community\gemma-3-4b-it-GGUF\gemma-3-4b-it-Q4_K_M.gguf"
}

$modelPath = $models[$Model]
$port = 8080
$cwd = (Get-Location).Path

$serverCmd = "llama-server --model `"$modelPath`" --port $port"

$piCmd = @"
while (-not (Test-NetConnection -ComputerName localhost -Port $port).TcpTestSucceeded) {
    Start-Sleep -Milliseconds 200
}
pi
"@

# IMPORTANT: everything stays inside ONE wt invocation
wt new-tab --startingDirectory "$cwd" `
    powershell -NoExit -Command "& { $serverCmd }" `
    `; split-pane -H --startingDirectory "$cwd" `
    powershell -NoExit -Command "codex" `
    `; split-pane -V --startingDirectory "$cwd" `
    powershell -NoExit -Command "& { $piCmd }"
