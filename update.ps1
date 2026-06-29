#Requires -RunAsAdministrator
# update.ps1 - Pull latest offsets and restart Terminal Services
# Usage: irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/update.ps1 | iex

$ErrorActionPreference = "Stop"
$rdpwrapDir = "C:\Program Files\RDP Wrapper"
$iniUrl = "https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/rdpwrap.ini"

if (-not (Test-Path $rdpwrapDir)) {
    Write-Error "RDP Wrapper not found at '$rdpwrapDir'. Run install.ps1 first."
    exit 1
}

$v = (Get-Item "$env:SystemRoot\System32\termsrv.dll").VersionInfo.FileVersion.Trim()
Write-Host "Current termsrv.dll: $v" -ForegroundColor Cyan

Write-Host "[1/3] Stopping Terminal Services..." -ForegroundColor Cyan
Stop-Service -Name TermService -Force

Write-Host "[2/3] Downloading latest offsets..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $iniUrl -OutFile "$rdpwrapDir\rdpwrap.ini"

Write-Host "[3/3] Starting Terminal Services..." -ForegroundColor Cyan
Start-Service -Name TermService

Write-Host ""
Write-Host "Done! Offsets updated for Windows $v" -ForegroundColor Green
