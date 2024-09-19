Copy-Item -Path "D:\Repos\mthierman\template-cmake\*" -Destination . | Out-Null
git init --quiet | Out-Null
git add . | Out-Null
git commit -m "Initialize repository" | Out-Null
Get-ChildItem
