@echo off
setlocal

set "VSROOT=C:\Program Files\Microsoft Visual Studio\18\Community"
set "CMAKE=%VSROOT%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
set "ROOTSYS=C:\Root"
rem Append a dot so the quoted path does not end in a backslash, which would
rem escape the closing quote in Windows command-line parsing.
set "SOURCE_DIR=%~dp0."
set "BUILD_DIR=%SOURCE_DIR%\build\cmake"
set "PATH=%ROOTSYS%\bin;%PATH%"

if not exist "%CMAKE%" (
    echo CMake was not found in Visual Studio: "%CMAKE%" 1>&2
    exit /b 1
)
if not exist "%ROOTSYS%\cmake\ROOTConfig.cmake" (
    echo CERN ROOT CMake package was not found in "%ROOTSYS%" 1>&2
    exit /b 1
)

echo Source directory: "%SOURCE_DIR%"
echo Build directory:  "%BUILD_DIR%"
"%CMAKE%" -S "%SOURCE_DIR%" -B "%BUILD_DIR%" -G "Visual Studio 18 2026" -A x64 -DROOT_DIR="%ROOTSYS%\cmake"
if errorlevel 1 exit /b %errorlevel%

if /I "%~1"=="run" goto run_program

"%CMAKE%" --build "%BUILD_DIR%" --config Release
if errorlevel 1 exit /b 1
endlocal
exit /b 0

:run_program
"%CMAKE%" --build "%BUILD_DIR%" --config Release
if errorlevel 1 exit /b 1
pushd "%SOURCE_DIR%"
"%BUILD_DIR%\Release\Positronium.exe"
set "APP_EXIT_CODE=%ERRORLEVEL%"
popd
endlocal & exit /b %APP_EXIT_CODE%
