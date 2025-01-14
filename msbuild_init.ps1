Copy-Item -Path "$env:REPOS\mthierman\template-msbuild\*" -Destination . -Recurse | Out-Null
Remove-Item -Path ".\build" -Force -Recurse
Remove-Item -Path ".\.vscode" -Force -Recurse
Remove-Item -Path ".\.vs" -Force -Recurse
git init --quiet | Out-Null
git add . | Out-Null
git commit -m "Initialize repository" | Out-Null
Get-ChildItem
