#!/bin/bash

# This script is used to read and apply the git config settings configured by
# the ~/.gitconfig.base and write them to ~/.gitconfig. See the adjacent README
# for a thorough explanation of "why" we managed ~/.gitconfig this way.

################################################################################
# Our standard bash compat check
THIS_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
source $THIS_SCRIPT_DIR/../bin/system-bash-compat
################################################################################

# Read the existing state of ~/.gitconfig and remember current settings
# Copy ~/.gitconfig.init on top of ~/.gitconfig
# Capture the global state again, and empty ~/.gitconfig
# Write the 2nd captured global state to a new ~/.gitconfig
# Drop any "include" / "includeIf"
# Compare the 2nd state with the 1st state
# If they are different, write the differing pieces of the 1st state to a
#     ~/.gitconfig.diff, and print a warning to the terminal to review.
