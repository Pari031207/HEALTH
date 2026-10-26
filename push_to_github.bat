@echo off
cd /d "%~dp0"
echo ===================================================
echo Pushing Chronic Disease Risk Project to GitHub...
echo Repository: https://github.com/Pari031207/HEALTH.git
echo ===================================================
"..\MinGit\cmd\git.exe" push -u origin main
echo.
if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] Project successfully pushed to GitHub!
) else (
    echo [NOTE] If prompted, sign in to your GitHub account in the browser/terminal.
)
pause
