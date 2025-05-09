@echo off
setlocal enabledelayedexpansion

:: Change to script directory
cd /d %~dp0

REM Default compose files
set COMPOSE_FILES=-f docker-compose.yml

cd ..
REM Read .env and check USE_CONTENT_DB_CONTAINER
for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
    if /i "%%a"=="USE_CONTENT_DB_CONTAINER" (
        set "USE_CONTENT_DB_CONTAINER=%%b"
    )
)

REM Trim any surrounding quotes
set "USE_CONTENT_DB_CONTAINER=!USE_CONTENT_DB_CONTAINER:"=!"

REM Conditionally add db compose file
if /i "!USE_CONTENT_DB_CONTAINER!"=="true" (
    set COMPOSE_FILES=%COMPOSE_FILES% -f docker-compose-db.yml
)

echo Starting services

docker-compose %COMPOSE_FILES% up --build -d