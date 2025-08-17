# A powershell tool for diagnosing backgroundTaskHost.exe in Windows 11

When backgroundTaskHost.exe goes off the rails, it becomes difficult to troubleshoot due to the service itself running tasks for several other Windows features and programs. This tool is designed to diagnose what function each backgroundTaskHost.exe is performing and what spawned it.

## Features

- List all running backgroundTaskHost.exe processes
- Show detailed process information including memory usage and thread count
- Display process hierarchies to identify parent-child relationships
- Comprehensive diagnostic analysis of background tasks

## Installation

1. Ensure you have PowerShell Core 7+ installed
2. Clone or download the Task-Diag repository
3. Run the setup script: `.\src\setup.ps1`

## Usage

```powershell
# List all backgroundTaskHost.exe processes
.\src\taskdiag.ps1 list

# Show detailed information about a specific process
.\src\taskdiag.ps1 info -ProcessId 1234

# Show process tree for a specific process  
.\src\taskdiag.ps1 tree -ProcessId 1234

# Perform full diagnostic analysis
.\src\taskdiag.ps1 analyze

# Show help information
.\src\taskdiag.ps1 -Help
```

## Project Structure

- `src/` - Main source code files
  - `setup.ps1` - Environment setup script
  - `TaskDiag.psm1` - Main module file
  - `taskdiag.ps1` - Command-line interface
- `tests/` - Test scripts and Pester tests
- `docs/` - Documentation files
- `assets/` - Supporting assets like sample data

## Requirements

- Windows 10 or Windows 11 operating system
- PowerShell Core 7.0 or higher
- Administrator privileges for full diagnostic capabilities