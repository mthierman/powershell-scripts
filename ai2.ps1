param(
    [string]$Model = "qwen"
)

$models = @{
    qwen = "C:\Users\mthie\.lmstudio\models\lmstudio-community\Qwen3.5-4B-GGUF\Qwen3.5-4B-Q4_K_M.gguf"
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
