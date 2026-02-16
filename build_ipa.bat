@echo off
REM ==================================================
REM Auto IPA Builder - Upload to GitHub, Get IPA
REM ==================================================

echo.
echo ================================================
echo   iPhone IPA Auto Builder
echo ================================================
echo.
echo Yeh script automatically:
echo 1. GitHub repository banayega
echo 2. Code upload karega
echo 3. iOS build start karega (macOS server pe)
echo 4. IPA file download link dega
echo.
echo Bas GitHub login aur repository name chahiye!
echo ================================================
echo.

REM Check Git
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git not installed!
    echo.
    echo Download: https://git-scm.com/download/win
    echo Install karo aur script dobara run karo
    pause
    exit /b 1
)

echo [Step 1/5] Git setup...
git init >nul 2>&1
git branch -M main >nul 2>&1

echo [Step 2/5] Adding files...
git add . >nul 2>&1

echo [Step 3/5] Creating commit...
git commit -m "iOS IPA build ready" >nul 2>&1

echo.
echo ================================================
echo   GitHub Repository Setup
echo ================================================
echo.
echo Pehle GitHub pe jao aur repository banao:
echo.
echo 1. https://github.com/new pe jao
echo 2. Repository name: family_travel_app
echo 3. Public select karo (FREE builds ke liye)
echo 4. "Create repository" click karo
echo.
echo Repository banne ke baad, URL copy karo
echo Example: https://github.com/username/family_travel_app.git
echo.
echo ================================================
echo.

set /p REPO_URL="GitHub Repository URL paste karo: "

if "%REPO_URL%"=="" (
    echo ERROR: URL enter nahi kiya!
    pause
    exit /b 1
)

echo.
echo [Step 4/5] Adding remote repository...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

echo [Step 5/5] Pushing to GitHub...
echo (Yeh thoda time le sakta hai - internet pe upload ho raha hai)
echo.
git push -u origin main

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Push failed!
    echo.
    echo Possible reasons:
    echo 1. Wrong URL?
    echo 2. GitHub authentication needed?
    echo 3. Repository already exists?
    echo.
    echo Fix karo aur dobara try karo
    pause
    exit /b 1
)

echo.
echo ================================================
echo   SUCCESS! IPA Build Started!
echo ================================================
echo.
echo GitHub ne automatically iOS build start kar di!
echo.
echo Next steps:
echo.
echo 1. Browser mein jao: %REPO_URL%
echo 2. "Actions" tab click karo (top menu)
echo 3. Latest workflow run dekho
echo 4. Wait karo 10-15 minutes
echo 5. Build complete hone pe "Artifacts" section se
echo    "ios-ipa-unsigned" download karo
echo.
echo Downloaded file = IPA file!
echo iPhone pe install karne ke liye:
echo - Diawi.com pe upload karo IPA
echo - Link iPhone Safari se kholo
echo - Install button dabao
echo.
echo ================================================
echo.
echo Repository URL (bookmark karo):
echo %REPO_URL%
echo.
echo Actions URL (yaha check karo build):
echo %REPO_URL%/actions
echo.
echo ================================================
pause

