# Run tests
Write-Host "Running tests..."
flutter test

# Check if tests passed
if ($LASTEXITCODE -eq 0) {
    Write-Host "All tests passed! Starting the app..."
    Start-Process -NoNewWindow -FilePath "flutter" -ArgumentList "run", "-d", "07748251CH009166"
} else {
    Write-Host "Tests failed. Fix the tests before running the app."
    pause
    exit 1
}