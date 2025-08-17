# Task-Diag - PowerShell Core Implementation

## Project Structure
- src/ - Main source code files
- tests/ - Test scripts and Pester tests
- docs/ - Documentation files
- assets/ - Supporting assets like sample data

## Initial Setup Script
This script will set up the development environment for Task-Diag.

param(
    [string]$ProjectPath = $PSScriptRoot
)

Write-Host "Setting up Task-Diag development environment..." -ForegroundColor Green

# Check PowerShell version
$psVersion = $PSVersionTable.PSVersion
if ($psVersion.Major -lt 7) {
    Write-Warning "PowerShell Core 7+ is recommended for this project"
}

# Create required directories
$directories = @('src', 'tests', 'docs', 'assets')
foreach ($dir in $directories) {
    if (!(Test-Path "$ProjectPath/$dir")) {
        New-Item -ItemType Directory -Path "$ProjectPath/$dir" -Force
        Write-Host "Created directory: $dir" -ForegroundColor Yellow
    }
}

# Create basic configuration files
$configContent = @{
    ProjectName = "Task-Diag"
    Version = "1.0.0"
    Author = "Windows Diagnostics Team"
    Description = "PowerShell tool for diagnosing backgroundTaskHost.exe processes"
} | ConvertTo-Json

$configPath = "$ProjectPath/config.json"
Set-Content -Path $configPath -Value $configContent
Write-Host "Created configuration file: config.json" -ForegroundColor Yellow

# Create main module manifest
$manifestContent = @{
    ModuleVersion = "1.0.0"
    RootModule = "TaskDiag.psm1"
    Author = "Windows Diagnostics Team"
    Description = "PowerShell tool for diagnosing backgroundTaskHost.exe processes"
    PowerShellVersion = "7.0"
    FunctionsToExport = @()
    CmdletsToExport = @()
    VariablesToExport = @()
} | ConvertTo-Json -Depth 3

$manifestPath = "$ProjectPath/TaskDiag.psd1"
Set-Content -Path $manifestPath -Value $manifestContent
Write-Host "Created module manifest: TaskDiag.psd1" -ForegroundColor Yellow

Write-Host "Task-Diag environment setup complete!" -ForegroundColor Green
```