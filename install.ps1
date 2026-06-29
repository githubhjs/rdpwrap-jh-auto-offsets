#Requires -RunAsAdministrator
# install.ps1 - One-click install RDP Wrapper with latest auto-generated offsets
# Usage: irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/install.ps1 | iex

$ErrorActionPreference = "Stop"
$rdpwrapDir = "C:\Program Files\RDP Wrapper"
$rdpwrapRelease = "https://github.com/stascorp/rdpwrap/releases/download/v1.6.2/RDPWrap-v1.6.2.zip"
$iniUrl = "https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/rdpwrap.ini"
$zip = "$env:TEMP\rdpwrap.zip"

Write-Host "[1/4] Creating install directory..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $rdpwrapDir | Out-Null

Write-Host "[2/4] Downloading RDP Wrapper binaries..." -ForegroundColor Cyan
# Use curl.exe (built-in since Windows 10 1803) — more reliable than Invoke-WebRequest for GitHub redirects
curl.exe -L $rdpwrapRelease -o $zip --silent --show-error --fail
if ($LASTEXITCODE -ne 0) { throw "Download failed (exit $LASTEXITCODE)" }
Expand-Archive -Path $zip -DestinationPath $rdpwrapDir -Force
Remove-Item $zip

Write-Host "[3/4] Downloading latest offsets..." -ForegroundColor Cyan
curl.exe -L $iniUrl -o "$rdpwrapDir\rdpwrap.ini" --silent --show-error --fail
if ($LASTEXITCODE -ne 0) { throw "INI download failed (exit $LASTEXITCODE)" }

Write-Host "[4/4] Installing RDP Wrapper service..." -ForegroundColor Cyan
# install.bat calls RDPWInst -i -o and then pauses — run the exe directly to avoid the pause
& "$rdpwrapDir\RDPWInst.exe" -i -o

Write-Host ""
Write-Host "Done! RDP Wrapper installed." -ForegroundColor Green
Write-Host "Run RDPConf.exe in '$rdpwrapDir' to verify status." -ForegroundColor Green
