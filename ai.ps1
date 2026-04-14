param(
    [string]$Model = "gemma4e2b"
)

$models = @{
    gemma4e2b = "C:\Users\mthie\.cache\huggingface\hub\models--unsloth--gemma-4-E2B-it-GGUF\snapshots\f064409f340b34190993560b2168133e5dbae558\gemma-4-E2B-it-Q4_K_M.gguf"
    gemma4e4b = "C:\Users\mthie\.lmstudio\models\lmstudio-community\gemma-4-E4B-it-GGUF\gemma-4-E4B-it-Q4_K_M.gguf"
}

if (-not $models.ContainsKey($Model))
{
    throw "Unknown model: $Model"
}

$port = 8080
$cwd = (Get-Location).Path
$modelPath = $models[$Model]

# -----------------------------
# derive pi model from filename
# -----------------------------
$modelFile = Split-Path $modelPath -Leaf
$modelName = [System.IO.Path]::GetFileNameWithoutExtension($modelFile)
$piModel = "llama-cpp/$modelName"

# -----------------------------
# server arguments (NO STRING COMMANDS)
# -----------------------------
$serverArgs = @(
    "--model", $modelPath,
    "--port", $port,
    "--ctx-size", "32768",
    "--gpu-layers", "999",
    "--temperature", "1.0",
    "--top-p", "0.95",
    "--top-k", "64",
    "--chat-template-kwargs", '{"enable_thinking":true}'
)

# -----------------------------
# client wait loop (fixed quoting)
# -----------------------------
$clientCmd = @"
while (-not (Test-NetConnection localhost -Port $port).TcpTestSucceeded) {
    Start-Sleep -Milliseconds 200
}
pi --model $piModel
"@

# -----------------------------
# Windows Terminal layout
# -----------------------------
wt --focus --maximized `
    new-tab --title "gemma4-server" --startingDirectory "$cwd" `
    powershell -NoExit -Command "& llama-server @serverArgs" `
    `; `
    split-pane -H --title "pi-client" --startingDirectory "$cwd" `
    powershell -NoExit -Command $clientCmd
