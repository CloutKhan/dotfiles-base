# This is a $PROFILE.CurrentUserAllHosts script, exceuted by PowerShell (5.1)

# Windows PowerShell is governed by "-ExecutionPolicy" -- you can open a shell
# in bypass mode via "powershell.exe -ExecutionPolicy Bypass", however this will
# bypass signing for the entire duration of the session, not just the startup.
# Likely, the best approach is to enable this to work locally with..
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
# But how does RemoteSigned work? You can see an example for yourself with this!
# Visit the following URL (THIS file...) and click to download it (NOT raw).
# https://github.com/Skenvy/dotfiles/blob/main/Documents/WindowsPowerShell/profile.ps1
# Run `Get-Item .\profile.ps1 -Stream *` to get two "streams": ":$DATA" and
# "Zone.Identifier" (this is the https://en.wikipedia.org/wiki/Mark_of_the_Web)
# Run `Get-Content .\profile.ps1 -Stream Zone.Identifier` and you'll see
# "ZoneId=3". RemoteSigned requires signed certificates for ZoneId >= 3.
# Note that things like Invoke-WebRequest write raw bytes, and don't add this!

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
