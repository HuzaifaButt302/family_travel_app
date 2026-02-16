@echo off
REM Git Setup Script for Windows
REM Run this to push your project to GitHub and enable automatic iOS builds

echo ========================================
echo  Git Setup for iOS Auto-Build
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git not installed!
    echo Download from: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo [1/5] Git initialized...
git init
git branch -M main

echo.
echo [2/5] Adding files...
git add .

echo.
echo [3/5] Creating commit...
git commit -m "Initial commit - Family Travel App ready for iOS build"

echo.
echo ========================================
echo  GitHub Repository Setup Required
echo ========================================
echo.
echo 1. Go to: https://github.com/
echo 2. Click: New Repository
echo 3. Name: family_travel_app
echo 4. Public (for free builds)
echo 5. Create Repository
echo.
echo Copy your repository URL, example:
echo https://github.com/YOUR_USERNAME/family_travel_app.git
echo.
set /p REPO_URL="Paste your GitHub repository URL here: "

echo.
echo [4/5] Adding remote repository...
git remote add origin %REPO_URL%

echo.
echo [5/5] Pushing to GitHub...
git push -u origin main

echo.
echo ========================================
echo  SUCCESS! Next Steps:
echo ========================================
echo.
echo 1. Go to: %REPO_URL%
echo 2. Click: Actions tab
echo 3. Wait for build to complete (~10 minutes)
echo 4. Download IPA from Artifacts
echo 5. Upload to: https://www.diawi.com/
echo 6. Install on iPhone via link
echo.
echo Full guide: QUICK_IPHONE_SETUP.md
echo ========================================
pause

