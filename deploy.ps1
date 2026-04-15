# Quran Platform - Full Project Deploy Script
# Run from the root of your Studies repository clone
# Usage: powershell -ExecutionPolicy Bypass -File deploy.ps1

$ErrorActionPreference = "Stop"
Write-Host "=== Quran Platform Deploy ===" -ForegroundColor Green

# Step 1: Create branch
Write-Host "Creating branch..." -ForegroundColor Yellow
git checkout -b claude/quran-learning-app-8gRGl 2>$null
if ($LASTEXITCODE -ne 0) {
    git checkout claude/quran-learning-app-8gRGl
}

# Step 2: Read base64 data and decode
Write-Host "Decoding project archive..." -ForegroundColor Yellow
$b64File = Join-Path $PSScriptRoot "project_data.b64"
if (-not (Test-Path $b64File)) {
    Write-Host "ERROR: project_data.b64 not found! Place it next to this script." -ForegroundColor Red
    exit 1
}

$b64Content = Get-Content $b64File -Raw
$bytes = [System.Convert]::FromBase64String($b64Content.Trim())

$tarGzPath = Join-Path $env:TEMP "quran_project.tar.gz"
[System.IO.File]::WriteAllBytes($tarGzPath, $bytes)

# Step 3: Extract archive
Write-Host "Extracting files..." -ForegroundColor Yellow
tar xzf $tarGzPath -C $PSScriptRoot

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: tar extraction failed" -ForegroundColor Red
    exit 1
}

# Step 4: Commit
Write-Host "Committing..." -ForegroundColor Yellow
git add quran_platform/
git commit -m "feat: Full Quran learning platform with comprehensive test suite

- 102 source files: Clean Architecture + BLoC + Firebase
- 34 test files: unit, widget, BLoC tests
- 3 roles: Student, Teacher, Admin
- Prayer times, booking, reviews system"

# Step 5: Push
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin claude/quran-learning-app-8gRGl

Write-Host ""
Write-Host "=== DONE! ===" -ForegroundColor Green
Write-Host "Branch pushed: claude/quran-learning-app-8gRGl"
