$ErrorActionPreference = "Stop"

# Ensure TLS 1.2 is enabled
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define paths
$dest = "C:\Windows\System32\docker-compose.exe"
$source = "https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-windows-x86_64.exe"

# Check if Docker Compose is already installed
if (Test-Path $dest) {
    Write-Host "Docker Compose is already installed at $dest."
    $installedVersion = & $dest --version
    Write-Host "Installed version: $installedVersion"
} else {
    Write-Host "Downloading Docker Compose..."
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $source -OutFile $dest -UseBasicParsing
    $ProgressPreference = 'Continue'
    Write-Host "Download complete."
}

