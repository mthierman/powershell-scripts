Get-ChildItem -Filter "*.*" -Recurse | Get-Content | Measure-Object -Line
