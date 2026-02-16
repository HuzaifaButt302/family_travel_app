@echo off
REM iPhone Installation Script - Start Local Server
REM Run this to test on iPhone

echo ========================================
echo  iPhone App - Local Server
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Trying Node.js...
    npx --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo.
        echo ERROR: Neither Python nor Node.js found!
        echo.
        echo Install one of these:
        echo 1. Python: https://www.python.org/downloads/
        echo 2. Node.js: https://nodejs.org/
        echo.
        pause
        exit /b 1
    )

    echo Starting Node.js server...
    echo.
    cd build\web
    npx serve -l 8080
) else (
    echo Starting Python server...
    echo.
    echo Server URL: http://localhost:8080
    echo.
    echo For iPhone access:
    echo 1. Find your computer IP: ipconfig
    echo 2. On iPhone Safari, open: http://YOUR_IP:8080
    echo 3. Share -^> Add to Home Screen
    echo.
    cd build\web
    python -m http.server 8080
)

