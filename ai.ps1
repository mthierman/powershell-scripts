param(
    [string]$Model = "qwen354b"
)

$port = 8080
$cwd = (Get-Location).Path

wt --focus --maximized `
    new-tab --title "server:$Model" --startingDirectory "$cwd" `
    powershell -NoExit -File "$PSScriptRoot\ai-server.ps1" -Model $Model -Port $port `
    `; split-pane -H --title "pi:$Model" --startingDirectory "$cwd" `
    powershell -NoExit -File "$PSScriptRoot\ai-client.ps1" -Port $port
