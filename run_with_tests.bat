@echo off
echo Running tests...
flutter test

if %ERRORLEVEL% EQU 0 (
    echo All tests passed! Starting the app...
    start cmd /k "flutter run -d windows"
) else (
    echo Tests failed. Fix the tests before running the app.
    pause
    exit /b 1
)