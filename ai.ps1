param(
    [string]$Model = "gemma4e2b"
)

$port = 8080
$cwd = (Get-Location).Path

# -----------------------------
# Model registry (Gemma 4 + Qwen)
# -----------------------------
$models = @{
    gemma4e2b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q4_K_M.gguf"
        ctx       = 8192
        gpuLayers = 999
        batch     = 256
    }
    gemma4e4b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E4B-it-GGUF/gemma-4-E4B-it-Q4_K_M.gguf"
        ctx       = 8192
        gpuLayers = 999
        batch     = 256
    }
    qwen354b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-4B-GGUF/Qwen3.5-4B-Q4_K_M.gguf"
        ctx       = 8192
        gpuLayers = 999
        batch     = 256
    }
    qwen359b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-9B-GGUF/Qwen3.5-9B-Q4_K_M.gguf"
        ctx       = 6144
        gpuLayers = 24
        batch     = 128
    }
}

if (-not $models.ContainsKey($Model)) {
    throw "Unknown model: $Model"
}

$config = $models[$Model]
$threads = [Environment]::ProcessorCount

# -----------------------------
# Common server args
# -----------------------------
$baseArgs = @(
    "--model", $config.path,
    "--port", $port,
    "--ctx-size", $config.ctx,
    "--gpu-layers", $config.gpuLayers,
    "--batch-size", $config.batch,
    "--ubatch-size", [Math]::Min(256, $config.batch),
    "--threads", $threads,
    "--cache-type-k", "f16",
    "--cache-type-v", "f16",
    "--repeat-penalty", "1.05",
    "--mirostat", "0"
)

# -----------------------------
# Model-specific tuning
# -----------------------------
switch -Wildcard ($Model) {

    "qwen*" {
        $args = $baseArgs + @(
            "--temp", "0.7",
            "--top-p", "0.85",
            "--top-k", "40",
            "--min-p", "0.05",
            "--presence-penalty", "0.8"
        )
    }

    "gemma4*" {
        $args = $baseArgs + @(
            "--temp", "1.0",
            "--top-p", "0.95",
            "--top-k", "64"
        )
    }

    default {
        throw "Unhandled model type: $Model"
    }
}

# -----------------------------
# Launch layout (server + pi)
# -----------------------------
wt --maximized `
    new-tab --title "server:$Model" --startingDirectory "$cwd" `
    powershell -NoExit -Command `
        "llama-server @args" `
    ; split-pane -H --title "pi:$Model" --startingDirectory "$cwd" `
    powershell -NoExit -Command `
        "while (\$true) { try { Invoke-RestMethod http://localhost:$port/v1/models | ConvertTo-Json -Depth 5 } catch {} ; Start-Sleep 5 }"
