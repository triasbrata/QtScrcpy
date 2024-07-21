@echo off

:: Define paths
set TEMP_FOLDER=%TEMP%
set VS_BUILD_TOOLS_URL=https://aka.ms/vs/17/release/vs_buildtools.exe
set VS_BUILD_TOOLS_EXE=%TEMP_FOLDER%\vs_buildtools.exe
set VSCONFIG_FILE=%~dp0.vsconfig

:: Download Visual Studio Build Tools
echo Downloading Visual Studio Build Tools...
powershell -Command "Invoke-WebRequest -Uri %VS_BUILD_TOOLS_URL% -OutFile %VS_BUILD_TOOLS_EXE%"
if %errorlevel% neq 0 (
    echo Failed to download Visual Studio Build Tools.
    exit /b %errorlevel%
)

:: Run Visual Studio Build Tools installer
echo Installing Visual Studio Build Tools...
%VS_BUILD_TOOLS_EXE% --quiet --wait --norestart --config %VSCONFIG_FILE%
if %errorlevel% neq 0 (
    echo Failed to install Visual Studio Build Tools.
    exit /b %errorlevel%
)
:: Install necessary Python packages
python -m pip install setuptools wheel
if %errorlevel% neq 0 (
    echo Failed to install setuptools and wheel.
    exit /b %errorlevel%
)

python -m pip install py7zr==0.14.0
if %errorlevel% neq 0 (
    echo Failed to install py7zr.
    exit /b %errorlevel%
)

python -m pip install aqtinstall==1.1.3
if %errorlevel% neq 0 (
    echo Failed to install aqtinstall.
    exit /b %errorlevel%
)

:: Install Qt using aqt
python -m aqt install 5.15.2 windows desktop win64_msvc2019_64 -O D:\Qt
if %errorlevel% neq 0 (
    echo Failed to install Qt.
    exit /b %errorlevel%
)

echo Installation completed successfully.
pause
