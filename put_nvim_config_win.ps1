$Source = Join-Path $env:LOCALAPPDATA "nvim"
$Destination = Join-Path $PSScriptRoot ".config\nvim"

Write-Host "Syncing Neovim configuration from $Source to local (Dry Run)..." -ForegroundColor Cyan

# Robocopy flags:
# /MIR  : Mirror a directory tree (equivalent to /E plus /PURGE).
# /L    : List only - don't copy, timestamp or delete any files.
# /MT   : Do multi-threaded copies (default is 8 threads).

$RobocopyFlags = @("/MIR", "/MT")

# Dry Run
robocopy "$Source" "$Destination" $RobocopyFlags /L

$Confirmation = Read-Host "Do you want to proceed with the actual sync? (y/n)"
if ($Confirmation -eq 'y') {
    Write-Host "Syncing..." -ForegroundColor Green
    robocopy "$Source" "$Destination" $RobocopyFlags
} else {
    Write-Host "Sync cancelled." -ForegroundColor Yellow
}
