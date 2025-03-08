@echo off

REM Step 1: Clean existing directories
SET ASEPRITE_DIR=C:\aseprite
SET SKIA_DIR=C:\deps\skia
SET NINJA_DIR=C:\ninja
IF EXIST %ASEPRITE_DIR% (
    rmdir /s /q %ASEPRITE_DIR%
)
IF EXIST C:\deps (
    rmdir /s /q C:\deps
)
IF EXIST %NINJA_DIR% (
    rmdir /s /q %NINJA_DIR%
)

REM Step 2: Recreate necessary directories
mkdir %ASEPRITE_DIR%
mkdir %SKIA_DIR%
mkdir %NINJA_DIR%

REM Step 3: Download Aseprite source
SET ASEPRITE_URL=https://github.com/aseprite/aseprite/releases/download/v1.3.14-beta1/Aseprite-v1.3.14-beta1-Source.zip
curl -L -o %ASEPRITE_DIR%\Aseprite-Source.zip %ASEPRITE_URL%
tar -xf %ASEPRITE_DIR%\Aseprite-Source.zip -C %ASEPRITE_DIR%

REM Step 4: Download Skia binaries
SET SKIA_URL=https://github.com/aseprite/skia/releases/download/m124-08a5439a6b/Skia-Windows-Release-x64.zip
curl -L -o %SKIA_DIR%\Skia-Windows-Release-x64.zip %SKIA_URL%
tar -xf %SKIA_DIR%\Skia-Windows-Release-x64.zip -C %SKIA_DIR%

REM Step 5: Download Ninja build tool
SET NINJA_URL=https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-win.zip
curl -L -o %NINJA_DIR%\ninja-win.zip %NINJA_URL%
tar -xf %NINJA_DIR%\ninja-win.zip -C %NINJA_DIR%

REM Step 6: Clean and Add Ninja to user environment variable
for /f "delims=" %%A in ('reg query "HKCU\Environment" /v PATH ^| findstr PATH') do set EXISTING_PATH=%%A
set NEW_PATH=
for %%A in (%EXISTING_PATH%) do (
    if /i not "%%A"=="C:\ninja" (
        set NEW_PATH=!NEW_PATH!;%%A
    )
)
set NEW_PATH=!NEW_PATH!;C:\ninja
setx PATH "%NEW_PATH%" /M

REM Step 7: Set up build directory
cd %ASEPRITE_DIR%
IF NOT EXIST build (
    mkdir build
)
cd build

REM Step 8: Set up Visual Studio environment
call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -arch=x64

REM Step 9: Run CMake
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLAF_BACKEND=skia -DSKIA_DIR=%SKIA_DIR% -DSKIA_LIBRARY_DIR=%SKIA_DIR%\out\Release-x64 -DSKIA_LIBRARY=%SKIA_DIR%\out\Release-x64\skia.lib -G Ninja ..

REM Step 10: Build Aseprite
ninja aseprite

REM Completion message
echo Build completed successfully!
