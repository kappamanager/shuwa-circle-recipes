@echo off
chcp 65001 >nul
cd /d "%~dp0"
python build.py
if errorlevel 1 (
    echo.
    echo ====================================
    echo  BUILD FAILED. Check the error above.
    echo ====================================
    pause
    exit /b 1
)
echo.
echo ====================================
echo  BUILD OK. index.html has been updated.
echo ====================================
timeout /t 3 >nul
