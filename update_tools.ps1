rustup update
deno upgrade
npm update -g
pnpm update -g
pymanager install --update
uv self update
uv tool upgrade --all
git update-git-for-windows
Push-Location
Set-Location $env:VCPKG_ROOT
git pull
.\bootstrap-vcpkg.bat
Pop-Location
winget upgrade
