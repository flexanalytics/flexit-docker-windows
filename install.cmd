@echo off
setlocal EnableDelayedExpansion

powershell -Command "Write-Host Welcome to the FlexIt installation setup. This will install the needed tools and allow you to configure the application"

powershell -Command "Start-Sleep -Seconds 1.5"

:: Run install-docker-ce.ps1

powershell -Command "Write-Host Installing docker..."
powershell -ExecutionPolicy Bypass -File ".\scripts\install\install-docker-ce.ps1

:: Ensure TLS 1.2 is enabled for PowerShell
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"

:: Download docker-compose
powershell -ExecutionPolicy Bypass -File ".\scripts\install\install-docker-compose.ps1"

:: Prompt for database details
powershell -Command "Write-Host "
powershell -Command "Write-Host Please configure the backend database. Keep these credentials secure, you will only be asked once."

set /p DB_USER="Enter database username: "
set /p DB_PASSWORD="Enter database password: "
set /p DB_NAME="Enter database name: "

:: Export as environment variable
set POSTGRES_USER=%DB_USER%
set POSTGRES_PASSWORD=%DB_PASSWORD%
set POSTGRES_DB=%DB_NAME%

:: Construct PostgreSQL URI
set DATABASE_URL=postgresql://%DB_USER%:%DB_PASSWORD%@flexit-content-database:5432/%DB_NAME%

powershell -Command "Write-Host Installing FlexIt "

docker-compose up -d

echo Process completed successfully. 
:: Read FLEXIT_PORT from .env file
for /f "tokens=2 delims==" %%A in ('findstr "^FLEXIT_PORT=" .env') do set FLEXIT_PORT=%%A

:: Echo the message with the port
echo Configure the application by navigating to http://localhost:%FLEXIT_PORT%

