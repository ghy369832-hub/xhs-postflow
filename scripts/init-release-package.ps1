param(
  [Parameter(Mandatory=$true)]
  [string]$Slug,

  [string]$Root = (Join-Path (Get-Location) "outputs\xhs-postflow")
)

$safeSlug = $Slug -replace '[<>:"/\\|?*]', '-'
$safeSlug = $safeSlug.Trim()
if ([string]::IsNullOrWhiteSpace($safeSlug)) {
  throw "Slug cannot be empty after sanitization."
}

$packageRoot = Join-Path $Root $safeSlug
$dirs = @(
  $packageRoot,
  (Join-Path $packageRoot "text"),
  (Join-Path $packageRoot "images"),
  (Join-Path $packageRoot "work"),
  (Join-Path $packageRoot "work\assets"),
  (Join-Path $packageRoot "work\output")
)

foreach ($dir in $dirs) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

[pscustomobject]@{
  PackageRoot = (Resolve-Path $packageRoot).Path
  TextDir = (Resolve-Path (Join-Path $packageRoot "text")).Path
  ImagesDir = (Resolve-Path (Join-Path $packageRoot "images")).Path
  WorkDir = (Resolve-Path (Join-Path $packageRoot "work")).Path
} | ConvertTo-Json
