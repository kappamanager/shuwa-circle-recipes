@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM === Settings ===
set "SRC_HTML=%~dp0003_site\index.html"
set "SRC_DATA=%~dp0003_site\data.js"
set "SRC_ROBOTS=%~dp0003_site\robots.txt"
set "SRC_SITEMAP=%~dp0003_site\sitemap.xml"
set "SRC_IMAGES=%~dp0003_site\images"
set "REPO=%~dp0004_pages_repo"
set "DST_HTML=%REPO%\index.html"
set "DST_DATA=%REPO%\data.js"
set "DST_ROBOTS=%REPO%\robots.txt"
set "DST_SITEMAP=%REPO%\sitemap.xml"
set "DST_IMAGES=%REPO%\images"

REM === 1. Copy site files to repo ===
if not exist "%SRC_HTML%" (
    echo ERROR: source not found: %SRC_HTML%
    pause
    exit /b 1
)
if not exist "%SRC_DATA%" (
    echo ERROR: source not found: %SRC_DATA%
    pause
    exit /b 1
)
if not exist "%REPO%" (
    echo ERROR: repo not found: %REPO%
    pause
    exit /b 1
)
copy /Y "%SRC_HTML%" "%DST_HTML%" >nul
if errorlevel 1 (
    echo ERROR: copy index.html failed
    pause
    exit /b 1
)
copy /Y "%SRC_DATA%" "%DST_DATA%" >nul
if errorlevel 1 (
    echo ERROR: copy data.js failed
    pause
    exit /b 1
)
if exist "%SRC_ROBOTS%" (
    copy /Y "%SRC_ROBOTS%" "%DST_ROBOTS%" >nul
)
if exist "%SRC_SITEMAP%" (
    copy /Y "%SRC_SITEMAP%" "%DST_SITEMAP%" >nul
)
if exist "%SRC_IMAGES%" (
    if not exist "%DST_IMAGES%" mkdir "%DST_IMAGES%"
    xcopy /Y /E /I /Q "%SRC_IMAGES%\*" "%DST_IMAGES%\" >nul
    if errorlevel 1 (
        echo ERROR: copy images failed
        pause
        exit /b 1
    )
)
REM Tools (kept in repo so the site can be rebuilt from a fresh clone)
for %%F in (build.py init_xlsx.py build.bat) do (
    copy /Y "%~dp0003_site\%%F" "%REPO%\%%F" >nul
    if errorlevel 1 (
        echo ERROR: copy %%F failed
        pause
        exit /b 1
    )
)
if not exist "%REPO%\tools" mkdir "%REPO%\tools"
copy /Y "%~f0" "%REPO%\tools\publish.bat" >nul
echo Copied: index.html, data.js, robots.txt, sitemap.xml, images/, build.py, init_xlsx.py, build.bat, tools/publish.bat -^> 004_pages_repo

REM === 2. Build commit message ===
if "%~1"=="" (
    for /f "tokens=1-3 delims=/-. " %%a in ("%DATE%") do set "TODAY=%%a-%%b-%%c"
    set "MSG=Update site (!TODAY!)"
) else (
    set "MSG=%~1"
)

REM === 3. Git operations ===
cd /d "%REPO%"

git add index.html data.js robots.txt sitemap.xml images build.py init_xlsx.py build.bat README.md tools
if errorlevel 1 (
    echo ERROR: git add failed
    pause
    exit /b 1
)

git diff --cached --quiet
if not errorlevel 1 (
    echo No changes to commit.
    timeout /t 3 >nul
    exit /b 0
)

git commit -m "!MSG!"
if errorlevel 1 (
    echo ERROR: git commit failed
    pause
    exit /b 1
)

git push
if errorlevel 1 (
    echo ERROR: git push failed
    pause
    exit /b 1
)

echo.
echo ====================================
echo  PUBLISHED: !MSG!
echo  https://kappamanager.github.io/shuwa-circle-recipes/
echo ====================================
timeout /t 5 >nul
endlocal
