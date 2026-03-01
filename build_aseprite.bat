@echo off

:: Batch file to build Aseprite

REM Check if PowerShell is available
where pwsh >nul 2>nul
if %errorlevel% neq 0 (
    echo PowerShell is not installed.
    exit /b 1
)

:: Specify the path to the zip files
set ZIP_PATH=path_to_your_zip_files

:: Extract zip files
for %%f in (%ZIP_PATH%\*.zip) do (
    echo Extracting %%f...
    pwsh -Command "Expand-Archive %%f -DestinationPath %ZIP_PATH%"
    if %errorlevel% neq 0 (
        echo Failed to extract %%f
        exit /b 1
    )
)

:: Continue with the rest of your build process...