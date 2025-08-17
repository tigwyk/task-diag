# Import required modules
Import-Module Microsoft.PowerShell.Management -Force
Import-Module Microsoft.PowerShell.Utility -Force

# Define module functions
function Initialize-TaskDiag {
    <#
    .SYNOPSIS
        Initializes the Task-Diag environment
    .DESCRIPTION
        Sets up the necessary components for Task-Diag to function properly
    #>
    Write-Host "Initializing Task-Diag environment..." -ForegroundColor Green
    
    # Check if running on Windows
    if ($IsWindows -eq $false) {
        throw "Task-Diag is designed for Windows operating systems only"
    }
    
    # Verify PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Warning "PowerShell Core 7+ is recommended for optimal performance"
    }
    
    Write-Host "Task-Diag environment initialized successfully" -ForegroundColor Green
}

function Get-BackgroundTaskHostProcesses {
    <#
    .SYNOPSIS
        Gets all backgroundTaskHost.exe processes
    .DESCRIPTION
        Retrieves information about all running backgroundTaskHost.exe processes
    #>
    try {
        $processes = Get-Process -Name "backgroundTaskHost" -ErrorAction Stop
        return $processes
    }
    catch {
        Write-Warning "No backgroundTaskHost.exe processes found: $($_.Exception.Message)"
        return @()
    }
}

function Get-ProcessTree {
    <#
    .SYNOPSIS
        Gets the process tree for a given process
    .DESCRIPTION
        Recursively retrieves parent-child relationships in the process tree
    #>
    param(
        [Parameter(Mandatory=$true)]
        [int]$ProcessId
    )
    
    $process = Get-Process -Id $ProcessId -ErrorAction Stop
    $result = @{
        Process = $process
        Children = @()
    }
    
    try {
        # Get child processes using WMI
        $childProcesses = Get-WmiObject -Class Win32_Process | 
            Where-Object { $_.ParentProcessId -eq $ProcessId }
        
        foreach ($child in $childProcesses) {
            $result.Children += Get-ProcessTree -ProcessId $child.ProcessId
        }
    }
    catch {
        Write-Warning "Could not retrieve child processes for PID $ProcessId: $($_.Exception.Message)"
    }
    
    return $result
}

function Get-ProcessDetails {
    <#
    .SYNOPSIS
        Gets detailed information about a specific process
    .DESCRIPTION
        Retrieves comprehensive details about a backgroundTaskHost.exe process including:
        - Process properties
        - Parent process information
        - Module information
        - Memory usage
        - Thread count
    #>
    param(
        [Parameter(Mandatory=$true)]
        [int]$ProcessId
    )
    
    try {
        $process = Get-Process -Id $ProcessId -ErrorAction Stop
        
        # Get parent process ID
        $parentProcessId = (Get-WmiObject -Class Win32_Process | 
            Where-Object { $_.ProcessId -eq $ProcessId }).ParentProcessId
        
        # Get parent process details
        $parentProcess = $null
        if ($parentProcessId -gt 0) {
            try {
                $parentProcess = Get-Process -Id $parentProcessId -ErrorAction Stop
            }
            catch {
                # Parent process might have terminated
                Write-Warning "Parent process with PID $parentProcessId may have terminated"
            }
        }
        
        # Get module information
        $modules = @()
        try {
            $modules = $process.Modules | Select-Object -Property FileName, FileVersion, Size
        }
        catch {
            Write-Warning "Could not retrieve module information for PID $ProcessId: $($_.Exception.Message)"
        }
        
        # Get thread count
        $threadCount = 0
        try {
            $threadCount = (Get-WmiObject -Class Win32_Process | 
                Where-Object { $_.ProcessId -eq $ProcessId }).ThreadCount
        }
        catch {
            Write-Warning "Could not retrieve thread count for PID $ProcessId: $($_.Exception.Message)"
        }
        
        # Create detailed result object
        $details = [PSCustomObject]@{
            ProcessId = $process.Id
            ProcessName = $process.ProcessName
            Path = $process.Path
            StartTime = $process.StartTime
            TotalMemory = $process.WorkingSet64
            VirtualMemory = $process.VirtualMemorySize64
            PrivateMemory = $process.PrivateMemorySize64
            ParentProcessId = $parentProcessId
            ParentProcessName = if ($parentProcess) { $parentProcess.ProcessName } else { "Unknown" }
            Modules = $modules
            ThreadCount = $threadCount
        }
        
        return $details
    }
    catch {
        Write-Error "Could not retrieve process details for PID $ProcessId: $($_.Exception.Message)"
        return $null
    }
}

function Get-TaskHostInfo {
    <#
    .SYNOPSIS
        Gets comprehensive information about backgroundTaskHost.exe processes
    .DESCRIPTION
        Retrieves detailed information about all running backgroundTaskHost.exe processes
        including process hierarchy, resource usage, and parent-child relationships.
    #>
    param(
        [Parameter(Mandatory=$false)]
        [int]$ProcessId = 0
    )
    
    try {
        if ($ProcessId -eq 0) {
            # Get all backgroundTaskHost processes
            $processes = Get-BackgroundTaskHostProcesses
            if ($processes.Count -eq 0) {
                Write-Warning "No backgroundTaskHost.exe processes found"
                return @()
            }
            
            $results = @()
            foreach ($process in $processes) {
                $details = Get-ProcessDetails -ProcessId $process.Id
                $details | Add-Member -NotePropertyName "ProcessTree" -NotePropertyValue (Get-ProcessTree -ProcessId $process.Id)
                $results += $details
            }
            
            return $results
        }
        else {
            # Get details for a specific process
            return Get-ProcessDetails -ProcessId $ProcessId
        }
    }
    catch {
        Write-Error "Could not retrieve task host information: $($_.Exception.Message)"
        return @()
    }
}

# Export functions
Export-ModuleMember -Function Initialize-TaskDiag, Get-BackgroundTaskHostProcesses, Get-ProcessTree, Get-ProcessDetails, Get-TaskHostInfo