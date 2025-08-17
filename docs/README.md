# Task-Diag - Documentation

## Overview

Task-Diag is a PowerShell tool designed to diagnose issues with backgroundTaskHost.exe processes in Windows 11. This tool helps identify what function each backgroundTaskHost.exe process is performing and what spawned it.

## Installation

1. Ensure you have PowerShell Core 7+ installed
2. Clone or download the Task-Diag repository
3. Run the setup script: `.\src\setup.ps1`

## Usage

### Basic Commands

```powershell
# List all backgroundTaskHost.exe processes
.\src\taskdiag.ps1 list

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

## Contributing

Contributions are welcome! Please follow the existing code style and add appropriate tests.