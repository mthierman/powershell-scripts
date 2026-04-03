param(
    [string]$Model,
    [int]$Port
)

$models = @{
    gemma4e2b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q4_K_M.gguf"
        gpuLayers = 999
        type      = "gemma"
    }
    gemma4e4b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E4B-it-GGUF/gemma-4-E4B-it-Q4_K_M.gguf"
        gpuLayers = 999
        type      = "gemma"
    }
    qwen354b  = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-4B-GGUF/Qwen3.5-4B-Q4_K_M.gguf"
        gpuLayers = 999
        type      = "qwen"
    }
    qwen359b  = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-9B-GGUF/Qwen3.5-9B-Q4_K_M.gguf"
        gpuLayers = 24
        type      = "qwen"
    }
}

if (-not $models.ContainsKey($Model))
{
    Write-Host "Unknown model: $Model"
    exit 1
}

$config = $models[$Model]
$threads = [Environment]::ProcessorCount

# -----------------------------
# Qwen-specific tuning (6GB VRAM safe)
# -----------------------------
if ($config.type -eq "qwen")
{

    & llama-server `
        --model $config.path `
        --port $Port `
        --ctx-size 16384 `
        --gpu-layers $config.gpuLayers `
        --batch-size 512 `
        --ubatch-size 256 `
        --threads $threads `
        --cache-type-k f16 `
        --cache-type-v f16 `
        --temp 0.7 `
        --top-p 0.8 `
        --top-k 20 `
        --min-p 0.0 `
        --repeat-penalty 1.0 `
        --presence-penalty 1.2 `
        --mirostat 0 `
        --chat-template-kwargs "{\"enable_thinking\":false}"

    return
}

# -----------------------------
# Gemma path
# -----------------------------
& llama-server `
    --model $config.path `
    --port $Port `
    --ctx-size 16384 `
    --gpu-layers $config.gpuLayers `
    --batch-size 512 `
    --ubatch-size 256 `
    --threads $threads `
    --temp 1.0 `
    --top-p 0.95 `
    --top-k 64 `
    --repeat-penalty 1.0 `
    --mirostat 0
