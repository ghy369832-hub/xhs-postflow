param(
  [string]$StagingDir = "C:\Users\ghy36\Documents\Codex\xhs-download-staging",
  [string]$RunId = "",
  [switch]$WhatIfOnly
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $StagingDir).Path
$target = $root
if ($RunId.Trim().Length -gt 0) {
  $target = Join-Path $root $RunId
}

if (-not (Test-Path -LiteralPath $target)) {
  Write-Output "No staging target found: $target"
  exit 0
}

$resolvedTarget = (Resolve-Path -LiteralPath $target).Path
if (-not $resolvedTarget.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Refusing to clean outside staging root: $resolvedTarget"
}

$patterns = @("*.mp4", "*.mov", "*.m4a", "*.wav", "*.mp3", "*.jpg", "*.jpeg", "*.png", "*.webp", "*.heic", "*.json", "*.log")
$files = foreach ($pattern in $patterns) {
  Get-ChildItem -LiteralPath $resolvedTarget -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue
}
$files = $files | Sort-Object FullName -Unique

if ($WhatIfOnly) {
  $files | Select-Object FullName, Length, LastWriteTime
  Write-Output "WhatIfOnly: $($files.Count) files would be deleted."
  exit 0
}

foreach ($file in $files) {
  Remove-Item -LiteralPath $file.FullName -Force
}
Write-Output "Deleted $($files.Count) temporary staging files under $resolvedTarget"