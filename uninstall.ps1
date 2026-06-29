#Requires -RunAsAdministrator
# uninstall.ps1 - Remove RDP Wrapper completely
# Usage: irm https://raw.githubusercontent.com/githubhjs/rdpwrap-jh-auto-offsets/main/uninstall.ps1 | iex

$ErrorActionPreference = "Stop"
$rdpwrapDir = "C:\Program Files\RDP Wrapper"

if (-not (Test-Path $rdpwrapDir)) {
    Write-Host "RDP Wrapper is not installed. Nothing to do." -ForegroundColor Yellow
    exit 0
}

Write-Host "[1/3] Running RDP Wrapper uninstaller..." -ForegroundColor Cyan
$uninstall = "$rdpwrapDir\uninstall.bat"
if (Test-Path $uninstall) {
    & $uninstall
    Start-Sleep -Seconds 3
} else {
    # Fallback: manual removal
    Write-Host "  uninstall.bat not found, removing service manually..." -ForegroundColor Yellow
    Stop-Service -Name TermService -Force -ErrorAction SilentlyContinue
    $svc = Get-WmiObject Win32_Service -Filter "Name='termservice'" -ErrorAction SilentlyContinue
    if ($svc) { $svc.Delete() | Out-Null }
    Start-Service -Name TermService -ErrorAction SilentlyContinue
}

Write-Host "[2/3] Removing RDP Wrapper directory..." -ForegroundColor Cyan
Remove-Item -Recurse -Force $rdpwrapDir -ErrorAction SilentlyContinue

Write-Host "[3/3] Restarting Terminal Services..." -ForegroundColor Cyan
Restart-Service -Name TermService -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Done. RDP Wrapper has been removed." -ForegroundColor Green
Write-Host "Windows is back to its default single-session RDP behavior." -ForegroundColor Green
