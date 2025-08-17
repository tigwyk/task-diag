# Task-Diag Codebase Guidelines

## Build/Lint/Test Commands
- `build`: No specific build required for PowerShell scripts
- `lint`: Use PSScriptAnalyzer for linting PowerShell code
- `test`: Run tests with `Invoke-Pester` or `Invoke-ScriptAnalyzer`

## Code Style Guidelines
- Use PowerShell best practices and conventions
- Follow Microsoft's PowerShell style guide
- Use camelCase for variables and functions
- Use PascalCase for classes and types
- Use consistent indentation (4 spaces)
- Include proper comments and documentation
- Use descriptive variable names
- Follow error handling patterns with try/catch blocks
- Use appropriate PowerShell cmdlet naming conventions

## PowerShell Specifics
- Use `Get-Verb` to verify cmdlet naming consistency
- Prefer pipeline over explicit loops where possible
- Use `param()` block for script parameters
- Include help comments with .SYNOPSIS, .DESCRIPTION, etc.