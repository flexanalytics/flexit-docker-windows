@echo off
setlocal enabledelayedexpansion

:: Change to script directory
cd /d %~dp0

:: Stop services
echo Stopping and removing containers...
call stop_server.bat

:: Pull from the repo
echo Pulling changes from GitHub...

:: Check for changes (uncommitted, staged, or untracked)
set STASHED=0
git diff --quiet || set STASHED=1
git diff --cached --quiet || set STASHED=1
for /f %%F in ('git ls-files --others --exclude-standard') do set STASHED=1

if "%STASHED%"=="1" (
    echo Stashing local changes...
    git stash push -u -m "auto-stash before pull"
)

:: Pull from the current HEAD
git pull origin HEAD --ff-only

:: Restore stash if one was created
if "%STASHED%"=="1" (
    echo Restoring stashed changes...
    git stash pop
)

:: Start services
call start_server.bat

endlocal
