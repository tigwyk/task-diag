# Task-Diag - Unit Tests

This file contains Pester tests for the Phase 2 implementation.

```powershell
# tests/TaskDiag.Tests.ps1

Describe "Task-Diag Module" {
    BeforeAll {
        # Import the module
        Import-Module "$PSScriptRoot/../src/TaskDiag.psm1" -Force
    }
    
    Context "Module Initialization" {
        It "Should initialize without errors" {
            { Initialize-TaskDiag } | Should -Not -Throw
        }
        
        It "Should be able to import the module successfully" {
            $module = Get-Module TaskDiag
            $module | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "Process Retrieval" {
        It "Should return an array when getting backgroundTaskHost processes" {
            # This test may not be able to execute in a test environment
            # but it demonstrates the expected behavior
            $processes = Get-BackgroundTaskHostProcesses
            $processes | Should -BeOfType System.Array
        }
    }
    
    Context "Process Details" {
        It "Should have the expected functions available" {
            Get-Command Get-ProcessDetails | Should -Not -BeNullOrEmpty
            Get-Command Get-ProcessTree | Should -Not -BeNullOrEmpty
            Get-Command Get-TaskHostInfo | Should -Not -BeNullOrEmpty
        }
    }
}
```