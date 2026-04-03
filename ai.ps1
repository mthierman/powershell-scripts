param(
    [string]$Model = "gemma4e2b"
)

$models = @{
    gemma4e2b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q4_K_M.gguf"
        gpuLayers = 999
    }
    gemma4e4b = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/gemma-4-E4B-it-GGUF/gemma-4-E4B-it-Q4_K_M.gguf"
        gpuLayers = 999
    }
    qwen359b  = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-9B-GGUF/Qwen3.5-9B-Q4_K_M.gguf"
        gpuLayers = 24   # tuned for ~6GB VRAM
    }
    qwen354b  = @{
        path      = "C:/Users/mthie/.lmstudio/models/lmstudio-community/Qwen3.5-4B-GGUF/Qwen3.5-4B-Q4_K_M.gguf"
        gpuLayers = 999
    }
}

if (-not $models.ContainsKey($Model))
{
    Write-Host "Unknown model: $Model"
    exit 1
}

$config = $models[$Model]
$modelPath = $config.path
$gpuLayers = $config.gpuLayers

$port = 8080
$cwd = (Get-Location).Path
$threads = [Environment]::ProcessorCount

$serverCmd = @"
llama-server `
  --model `"$modelPath`" `
  --port $port `
  --ctx-size 16384 `
  --gpu-layers $gpuLayers `
  --batch-size 512 `
  --ubatch-size 256 `
  --threads $threads `
  --temp 1.0 `
  --top-p 0.95 `
  --top-k 64 `
  --repeat-penalty 1.0 `
  --mirostat 0 `
  --stop "<turn|>"
"@

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
