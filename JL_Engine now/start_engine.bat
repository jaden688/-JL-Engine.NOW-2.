@echo off
setlocal

set "ROOT=%~dp0"
set "SELF_CONTAINED_EXE=%ROOT%artifacts\JLEngine-win-x64\JLEngine.Host.exe"
set "ROOT_EXE=%ROOT%JLEngine.Host.exe"
set "BUILD_EXE=%ROOT%dotnet\JLEngine.Host\bin\Release\net11.0\JLEngine.Host.exe"
set "PROJECT=%ROOT%dotnet\JLEngine.Host\JLEngine.Host.csproj"

if exist "%SELF_CONTAINED_EXE%" (
    set "EXE=%SELF_CONTAINED_EXE%"
) else if exist "%ROOT_EXE%" (
    set "EXE=%ROOT_EXE%"
) else (
    set "EXE=%BUILD_EXE%"
)

where dotnet >nul 2>nul
if errorlevel 1 if not exist "%SELF_CONTAINED_EXE%" if not exist "%ROOT_EXE%" (
    echo .NET 11 SDK is required to build from source.
    echo Install it from https://dot.net/download
    pause
    exit /b 1
)

if not exist "%EXE%" (
    echo Build not found. Building JL Engine for .NET 11...
    dotnet build "%PROJECT%" -c Release
    if errorlevel 1 (
        echo Build failed. See errors above.
        pause
        exit /b 1
    )
)

if not exist "%ROOT%data" mkdir "%ROOT%data"
cd /d "%ROOT%data"

echo Starting JL Engine...
echo Chat GUI: http://127.0.0.1:8081/
echo Press Ctrl+C in this window to stop the engine.
start "" http://127.0.0.1:8081/
"%EXE%"

endlocal
