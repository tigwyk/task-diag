# Task-Diag - Command Line Interface

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "list",
    
    [Parameter(Mandatory=$false)]
    [int]$ProcessId,
    
    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Get the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Dot-source the main module functions
. "$scriptDir/TaskDiag.psm1"

# Show help if requested
if ($Help) {
    Write-Host "Task-Diag - Windows backgroundTaskHost.exe Diagnostics Tool" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: taskdiag.ps1 [Action] [Options]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Actions:" -ForegroundColor Cyan
    Write-Host "  list     List all backgroundTaskHost.exe processes" -ForegroundColor White
    Write-Host "  info     Show detailed information about a specific process" -ForegroundColor White
    Write-Host "  tree     Show process tree for a specific process" -ForegroundColor White
    Write-Host "  analyze  Perform full diagnostic analysis" -ForegroundColor White
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  -ProcessId PID   Specify process ID for detailed info" -ForegroundColor White
    Write-Host "  -Help            Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\taskdiag.ps1 list" -ForegroundColor White
    Write-Host "  .\taskdiag.ps1 info -ProcessId 1234" -ForegroundColor White
    Write-Host "  .\taskdiag.ps1 tree -ProcessId 1234" -ForegroundColor White
    Write-Host "  .\taskdiag.ps1 analyze" -ForegroundColor White
    exit
}

# Initialize the tool
Initialize-TaskDiag

# Process the action
switch ($Action) {
    "list" {
        Write-Host "Listing backgroundTaskHost.exe processes..." -ForegroundColor Yellow
        $processes = Get-BackgroundTaskHostProcesses
        if ($processes.Count -gt 0) {
            $processes | Format-Table -Property Id, ProcessName, Path, StartTime -AutoSize
        }
        else {
            Write-Host "No backgroundTaskHost.exe processes found." -ForegroundColor Gray
        }
    }
    
    "info" {
        Write-Host "Showing process information..." -ForegroundColor Yellow
        if ($ProcessId -gt 0) {
            $details = Get-TaskHostInfo -ProcessId $ProcessId
            if ($details) {
                $details | Format-List
            }
        }
        else {
            $processes = Get-BackgroundTaskHostProcesses
            if ($processes.Count -gt 0) {
                Write-Host "Please specify a ProcessId using -ProcessId parameter" -ForegroundColor Yellow
                $processes | Format-Table -Property Id, ProcessName, Path, StartTime -AutoSize
            }
            else {
                Write-Host "No backgroundTaskHost.exe processes found." -ForegroundColor Gray
            }
        }
    }
    
    "tree" {
        Write-Host "Showing process tree..." -ForegroundColor Yellow
        if ($ProcessId -gt 0) {
            $processTree = Get-ProcessTree -ProcessId $ProcessId
            if ($processTree) {
                # Simple tree display
                Write-Host "Process Tree for PID: $($processTree.Process.Id)" -ForegroundColor Cyan
                Write-Host "  Process: $($processTree.Process.ProcessName) (PID: $($processTree.Process.Id))" -ForegroundColor White
                
                $children = $processTree.Children
                if ($children.Count -gt 0) {
                    Write-Host "  Children:" -ForegroundColor Yellow
                    foreach ($child in $children) {
                        Write-Host "    - $($child.Process.ProcessName) (PID: $($child.Process.Id))" -ForegroundColor White
                    }
                }
                else {
                    Write-Host "  No child processes found." -ForegroundColor Gray
                }
            }
        }
        else {
            Write-Host "Please specify a ProcessId using -ProcessId parameter" -ForegroundColor Yellow
        }
    }
    
    "analyze" {
        Write-Host "Performing diagnostic analysis..." -ForegroundColor Yellow
        $processes = Get-BackgroundTaskHostProcesses
        if ($processes.Count -gt 0) {
            foreach ($process in $processes) {
                Write-Host "Analyzing process: $($process.ProcessName) (PID: $($process.Id))" -ForegroundColor Cyan
                $details = Get-TaskHostInfo -ProcessId $process.Id
                if ($details) {
                    $details | Format-List
                    Write-Host ""
                }
            }
        }
        else {
            Write-Host "No backgroundTaskHost.exe processes found." -ForegroundColor Gray
        }
    }
    
    default {
        Write-Error "Unknown action: $Action"
        exit 1
    }
}