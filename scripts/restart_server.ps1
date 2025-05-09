# Change to script directory
Set-Location -Path $PSScriptRoot

# Stop services
Write-Host "Stopping and removing containers..."
& "$PSScriptRoot\stop_server.bat"

# Pull from the repo
Write-Host "Pulling changes from GitHub..."

# Change to git repo root (assumes repo is one level up from script dir)
$repoRoot = Resolve-Path "$PSScriptRoot\.."
Push-Location $repoRoot

# Check for uncommitted, staged, or untracked changes
$stashed = $false

if (-not (git diff --quiet)) { $stashed = $true }
if (-not (git diff --cached --quiet)) { $stashed = $true }
if ((git ls-files --others --exclude-standard) -ne $null) { $stashed = $true }

if ($stashed) {
    Write-Host "Stashing local changes..."
    git stash push -u -m "auto-stash before pull"
}

# Pull from current HEAD
git pull origin HEAD --ff-only

# Restore stash if it was created
if ($stashed) {
    Write-Host "Restoring stashed changes..."
    git stash pop
}

# Return to script directory
Pop-Location

# Start services
& "$PSScriptRoot\start_server.bat"