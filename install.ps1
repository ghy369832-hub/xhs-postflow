param(
  [string]$CodexHome = (Join-Path $env:USERPROFILE ".codex")
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$targetRoot = Join-Path $CodexHome "skills"
$target = Join-Path $targetRoot "xhs-postflow"

New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

if (Test-Path $target) {
  $backup = "$target.backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
  Move-Item -LiteralPath $target -Destination $backup
  Write-Host "Existing xhs-postflow backed up to: $backup"
}

New-Item -ItemType Directory -Force -Path $target | Out-Null

foreach ($name in @("SKILL.md", "agents", "references", "scripts", "README.md")) {
  $source = Join-Path $repoRoot $name
  if (Test-Path $source) {
    Copy-Item -Recurse -Force -Path $source -Destination $target
  }
}

Write-Host "Installed xhs-postflow to: $target"
Write-Host "Restart Codex or open a new chat to refresh skills."
