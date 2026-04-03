param(
    [int]$Port
)

while (-not (Test-NetConnection localhost -Port $Port).TcpTestSucceeded)
{
    Start-Sleep -Milliseconds 200
}

pi
