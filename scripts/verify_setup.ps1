#!/usr/bin/env pwsh
<#
.SYNOPSIS
Verify Notion sync setup and dependencies

.DESCRIPTION
Checks environment variables, Python availability, and required libraries
#>

Write-Host "=== Notion Diary Sync - Setup Verification ===" -ForegroundColor Cyan
Write-Host ""

# Check Python
Write-Host "1. Checking Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ Python: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found in PATH" -ForegroundColor Red
    Write-Host "   Install from: https://www.python.org/downloads/"
}
Write-Host ""

# Check NOTION_TOKEN
Write-Host "2. Checking NOTION_TOKEN..." -ForegroundColor Yellow
if ($env:NOTION_TOKEN) {
    $token = $env:NOTION_TOKEN
    $masked = $token.Substring(0, [Math]::Min(10, $token.Length)) + "..."
    Write-Host "✅ NOTION_TOKEN is set ($masked)" -ForegroundColor Green
} else {
    Write-Host "❌ NOTION_TOKEN is NOT set" -ForegroundColor Red
    Write-Host '   Set it with: $env:NOTION_TOKEN = "ntn_xxx"' -ForegroundColor Gray
}
Write-Host ""

# Check NOTION_DIARY_DB
Write-Host "3. Checking NOTION_DIARY_DB..." -ForegroundColor Yellow
if ($env:NOTION_DIARY_DB) {
    $db = $env:NOTION_DIARY_DB
    $masked = $db.Substring(0, [Math]::Min(10, $db.Length)) + "..."
    Write-Host "✅ NOTION_DIARY_DB is set ($masked)" -ForegroundColor Green
} else {
    Write-Host "❌ NOTION_DIARY_DB is NOT set" -ForegroundColor Red
    Write-Host '   Set it with: $env:NOTION_DIARY_DB = "abc123..."' -ForegroundColor Gray
}
Write-Host ""

# Check requests library
Write-Host "4. Checking Python dependencies..." -ForegroundColor Yellow
try {
    python -c "import requests; print('requests: OK')" 2>$null
    Write-Host "✅ requests library is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ requests library is NOT installed" -ForegroundColor Red
    Write-Host "   Install with: pip install requests" -ForegroundColor Gray
}
Write-Host ""

# Check paths
Write-Host "5. Checking critical paths..." -ForegroundColor Yellow

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir

$diaryRoot = if ($env:GLOBAL_DIARY_ROOT) { $env:GLOBAL_DIARY_ROOT } else { Join-Path $repoRoot "diary" }
$syncScript = Join-Path $scriptDir "sync_to_notion.py"

$paths = @{
    "Global Diary Root" = $diaryRoot
    "Notion Sync Script" = $syncScript
}

if ($env:OBSIDIAN_DAILY_NOTES) {
    $paths["Obsidian Daily Notes"] = $env:OBSIDIAN_DAILY_NOTES
}

foreach ($name in $paths.Keys) {
    $path = $paths[$name]
    if (Test-Path -Path $path) {
        Write-Host "✅ $name exists: $path" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $name not found: $path" -ForegroundColor Yellow
    }
}
Write-Host ""

# Summary
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "If all checks are green, you're ready to sync!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  - Run: python scripts/master_diary_sync.py --sync-only" -ForegroundColor Gray
Write-Host "  - See README.md for full documentation" -ForegroundColor Gray
