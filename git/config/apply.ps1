# Windows is shebangless
# ~

# This script is used to read and apply the git config settings configured by
# the ~/.gitconfig.base and write them to ~/.gitconfig. See the adjacent README
# for a thorough explanation of "why" we managed ~/.gitconfig this way.

# NOTE: The git command that this relies on, `git config --list`, only behaves
# as we require it to for this, if it is NOT given a --file option, and instead
# left to the default of the home gitconfig. Because of this, we can't build in
# a way to allow a "test" run, at least, we can make a "dry" run by simply not
# writing output on to the ~/.gitconfig, but we can't test running it on a
# different global config, without manually tweaking the actual global config
# anyway! So changes made to this need to be tested on the home checkout, not
# in a nested workspace checkout -- at least for final verification.

# Save current shell options
$SAVED_ERROR_ACTION = $ErrorActionPreference

$ErrorActionPreference = "Stop"

################################################################################
# Get script directory
$THIS_SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
# There is no powershell compat checking script (yet?)
################################################################################

$GITCONFIG = Join-Path $THIS_SCRIPT_DIR "..\\..\\.gitconfig"
$GITCONFIG_INIT = "$GITCONFIG.init"
$GITCONFIG_BASE = "$GITCONFIG.base"
$GITCONFIG_DIFF = "$GITCONFIG.diff"

# This can be used to retrieve a full global scope config list.
# It drops the global scope prefix, so the lines after can just be run!
function Capture-GlobalState {
    git config --list --show-scope | Where-Object { $_ -match "^global" } | ForEach-Object { $_ -replace "^global\s+", "" }
}

function Capture-GlobalStateSansIncludes {
    Capture-GlobalState | Where-Object { $_ -notmatch "^include\." -and $_ -notmatch "^includeif\." }
}

# Step 1: Read and store the current state of ~/.gitconfig
$PRIOR_STATE = (Capture-GlobalState | Sort-Object) -join "`n"

# Step 2: Copy ~/.gitconfig.init on top of ~/.gitconfig
Copy-Item $GITCONFIG_INIT $GITCONFIG -Force

# Step 3: Capture the global state after copying init
$TARGET_STATE = (Capture-GlobalStateSansIncludes | Sort-Object) -join "`n"

# Step 4: Empty ~/.gitconfig to get a clean slate
"" | Out-File $GITCONFIG

# Step 5: Write the captured global state to ~/.gitconfig (the "base" state)
# This establishes what the default configuration should be
$TARGET_STATE -split "`n" | ForEach-Object {
    if ($_ -match "^(.+?)=(.*)$") {
        $key = $matches[1]
        $value = $matches[2]
        git config --file $GITCONFIG $key $value
    }
}

# Step 6: Compare the states
if ($PRIOR_STATE -ne $TARGET_STATE) {
    # Step 7: Write the differing pieces from PRIOR_STATE to a diff file
    "Diff ~ < Prior state --- > Target state" | Out-File $GITCONFIG_DIFF
    $PRIOR_OBJ = $PRIOR_STATE -split "`n" | Sort-Object
    $TARGET_OBJ = $TARGET_STATE -split "`n" | Sort-Object
    Compare-Object $PRIOR_OBJ $TARGET_OBJ | Out-File $GITCONFIG_DIFF -Append
    Write-Host "⚠️  WARNING: Git config has diverged from the managed configuration!"
    Write-Host "⚠️  Differences saved to: $GITCONFIG_DIFF"
    Write-Host "⚠️  Please review and merge any necessary custom settings."
    Write-Host ""
    Get-Content $GITCONFIG_DIFF
} else {
    Write-Host "✅  Git config is in sync with managed configuration"
}

# Restore original PowerShell preferences
$ErrorActionPreference = $SAVED_ERROR_ACTION
