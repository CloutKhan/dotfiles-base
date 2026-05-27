# This is a $PROFILE.CurrentUserAllHosts script, exceuted by PowerShell (5.1)

$ProfileDir = Split-Path -Path $PROFILE.CurrentUserAllHosts -Parent

function Invoke-Source {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [switch]$Quiet
    )
    # Resolve the path to handle relative and variable paths correctly, into abs
    $ResPath = Resolve-Path -Path $Path -ErrorAction SilentlyContinue
    if ($ResPath -and (Test-Path -Path $ResPath.Path -PathType Leaf)) {
        # Dot-source the file into the current scope
        . $ResPath.Path
        if (-not $Quiet) {
            Write-Verbose "Successfully sourced: $($ResPath.Path)"
        }
    } else {
        if (-not $Quiet) {
            Write-Warning "Cannot source file. Path does not exist or is not a file: $Path"
        }
    }
}

# Get aliases.
$AliasFile  = Join-Path -Path $ProfileDir -ChildPath "aliases.ps1"
Invoke-Source $AliasFile -Quiet
