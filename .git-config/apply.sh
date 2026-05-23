#!/bin/bash

# This script is used to read and apply the git config settings configured by
# the ~/.gitconfig.base and write them to ~/.gitconfig. See the adjacent README
# for a thorough explanation of "why" we managed ~/.gitconfig this way.

set -eu

################################################################################
# Our standard bash compat check
THIS_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source $THIS_SCRIPT_DIR/../bin/system-bash-compat
################################################################################

GITCONFIG="$THIS_SCRIPT_DIR/../.gitconfig"
GITCONFIG_INIT="$GITCONFIG.init"
GITCONFIG_BASE="$GITCONFIG.base" # Not used here, just decorative..
GITCONFIG_DIFF="$GITCONFIG.diff"

# This can be used to retrieve a full global scope config list.
# It drops the global, cutting on tabs, so the lines after can just be run!
capture-global-state(){
  echo "$(git config --list --show-scope | grep "^global" | cut -d$'\t' -f2-)"
}

capture-global-state-sans-includes(){
  echo "$(capture-global-state)" | grep -v "^include\." | grep -v "^includeif\."
}

# Step 1: Read and store the current state of ~/.gitconfig
PRIOR_STATE="$(capture-global-state | sort)"

# Step 2: Copy ~/.gitconfig.init on top of ~/.gitconfig
cp "$GITCONFIG_INIT" "$GITCONFIG"

# Step 3: Capture the global state after copying init
TARGET_STATE="$(capture-global-state-sans-includes | sort)"

# Step 4: Empty ~/.gitconfig to get a clean slate
> "$GITCONFIG"

# Step 5: Write the 2nd captured global state to ~/.gitconfig (the "base" state)
# This establishes what the default configuration should be
echo "$TARGET_STATE" | while IFS='=' read -r key value; do
  git config --file "$GITCONFIG" "$key" "$value"
done

# Step 6: Compare the states
if [ "$PRIOR_STATE" != "$TARGET_STATE" ]; then
  # Step 7: Write the differing pieces from PRIOR_STATE to a diff file
  echo "Diff ~ < Prior state --- > Target state" > "$GITCONFIG_DIFF"
  set +e
  diff <(echo "$PRIOR_STATE") <(echo "$TARGET_STATE") >> "$GITCONFIG_DIFF"
  set -e
  echo "⚠️  WARNING: Git config has diverged from the managed configuration!"
  echo "⚠️  Differences saved to: $GITCONFIG_DIFF"
  echo "⚠️  Please review and merge any necessary custom settings."
  echo # Newline
  cat "$GITCONFIG_DIFF"
else
  echo "✅  Git config is in sync with managed configuration"
fi
