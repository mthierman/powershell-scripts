rustup update
deno upgrade
npm install -g npm@latest
npm install -g pnpm@latest
pnpm update -g --latest
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
