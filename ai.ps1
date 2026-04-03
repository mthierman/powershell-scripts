param(
    [string]$Model = "gemma4e2b"
)

$port = 8080
$cwd = (Get-Location).Path

$models = @{
    gemma4e2b = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q4_K_M.gguf"
    gemma4e4b = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E4B-it-GGUF/gemma-4-E4B-it-Q4_K_M.gguf"
    qwen354b  = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-4B-GGUF/Qwen3.5-4B-Q4_K_M.gguf"
    qwen359b  = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-9B-GGUF/Qwen3.5-9B-Q4_K_M.gguf"
}

if (-not $models.ContainsKey($Model))
{
    throw "Unknown model: $Model"
}

$modelPath = $models[$Model]

# -----------------------------
# ENCODE BOTH PANE COMMANDS
# -----------------------------
$serverCmd = "llama-server --model `"$modelPath`" --port $port --ctx-size 8192 --gpu-layers 24"
$serverEncoded = [Convert]::ToBase64String(
    [Text.Encoding]::Unicode.GetBytes($serverCmd)
)

$piScript = @"
while (`$true) {
    try {
        Invoke-RestMethod http://localhost:$port/v1/models | Out-Null
        Write-Host "$(Get-Date -f HH:mm:ss)  server ready"
    } catch {
        Write-Host "$(Get-Date -f HH:mm:ss)  waiting..."
    }
    Start-Sleep 5
}
"@
$piEncoded = [Convert]::ToBase64String(
    [Text.Encoding]::Unicode.GetBytes($piScript)
)

# -----------------------------
# WT LAUNCH
# Use cmd /c to hand off the full wt command as one string,
# avoiding PowerShell eating the ; subcommand separators.
# -----------------------------
$wtArgs = (
    "--maximized " +
    "new-tab --title `"server:$Model`" --startingDirectory `"$cwd`" " +
    "powershell -NoExit -EncodedCommand $serverEncoded " +
    "; split-pane -H --title `"pi:$Model`" --startingDirectory `"$cwd`" " +
    "powershell -NoExit -EncodedCommand $piEncoded"
)

Start-Process "wt.exe" -ArgumentList $wtArgs
