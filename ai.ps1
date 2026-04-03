param(
    [string]$Model = "gemma4e2b"
)

$models = @{
    gemma4e2b = "C:\Users\mthie\.lmstudio\models\lmstudio-community\gemma-4-E2B-it-GGUF\gemma-4-E2B-it-Q4_K_M.gguf"
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
# Gemma 4 canonical parameters (server-side)
# -----------------------------
$serverCmd =
"llama-server --model `"$modelPath`" --port $port --ctx-size 32768 --gpu-layers 999 --temperature 1.0 --top-p 0.95 --top-k 64 --repeat-penalty 1.0"

# -----------------------------
# client wait loop
# -----------------------------
$clientCmd = @"
while (-not (Test-NetConnection localhost -Port $port).TcpTestSucceeded) {
    Start-Sleep -Milliseconds 200
}
pi --model $piModel
"@

# -----------------------------
# Windows Terminal split
# -----------------------------
wt --focus --maximized `
    new-tab --title "gemma4-server" --startingDirectory "$cwd" `
    powershell -NoExit -Command "$serverCmd" `
    `; `
    split-pane -H --title "pi-client" --startingDirectory "$cwd" `
    powershell -NoExit -Command "$clientCmd"
