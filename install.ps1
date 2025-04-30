# install-flexit.ps1

$ErrorActionPreference = "Stop"

Write-Host "`n=== FlexIt Installation Setup ===" -ForegroundColor Cyan
Write-Host "This will install the needed tools and allow you to configure the application." -ForegroundColor Cyan
Start-Sleep -Seconds 1.5

# Install Docker
Write-Host "`n--- Installing Docker ---" -ForegroundColor Yellow
& "$PSScriptRoot\scripts\install\install-docker-ce.ps1"

# Ensure TLS 1.2 is enabled
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install Docker Compose
Write-Host "`n--- Installing Docker Compose ---" -ForegroundColor Yellow
& "$PSScriptRoot\scripts\install\install-docker-compose.ps1"

# Install FlexIt
Write-Host "`n--- Building and Starting Server ---" -ForegroundColor Yellow
docker-compose up --build -d | ForEach-Object { Write-Host $_ }

# Load .env variables
$envFile = ".env"
$flexitPort = Select-String -Path $envFile -Pattern "^FLEXIT_PORT=" | ForEach-Object {
    ($_ -split '=', 2)[1].Trim()
}

Write-Host "`nProcess completed successfully." -ForegroundColor Green
Write-Host "Configure the application by navigating to http://localhost:$flexitPort" -ForegroundColor Green
