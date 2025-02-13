@echo off
setlocal enabledelayedexpansion

echo Stopping and removing containers with: docker-compose down --remove-orphans
docker-compose down --remove-orphans

