# Zip the skill for upload to claude.ai (Settings -> Capabilities -> Skills).
# Produces dist\second-brain-skill.zip containing the second-brain/ folder.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$zip = Join-Path $dist "second-brain-skill.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $root "second-brain") -DestinationPath $zip
Write-Host "Packed: $zip" -ForegroundColor Green
Write-Host "Upload it in Claude: Settings -> Capabilities -> Skills -> Upload skill."
