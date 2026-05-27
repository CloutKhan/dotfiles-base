Invoke-Source "$HOME/.include/.pre/.pwsh_aliases.ps1" -Quiet

################################################################################
# PowerShell aliases differ from bash aliases in several meaningful ways.
# This might be called our "aliases" list, but most of the time, to achieve
# similar targets to those we set in bash, we need to make our aliases as
# functions, not with Set-Alias, which can't handle paths at invokation time.
# We also have to attach "global:*" to each function name to explicitely set
# their scope, because this whole script is loaded inside a function call that
# otherwise takes ownership of the scope.
# Hence, most aliases will be `function global:* { ... }` and not `Set-Alias`.

################################################################################
# Aliases used to proctor updating this repo when it's added as a submodule..
# https://github.com/Skenvy/dotfiles?tab=readme-ov-file#use-as-home-is-another-repo
# You'll need to manually run the dotfiles-submodule-symlinks the first time to
# put the links in place (e.g. link _this_ file in place). But once you've done
# that you can just "rehome" to update the submodule to latest.

# For using this repo as a submodule
# TODO: rehome ~ dependent on creating a pwsh equivalent of dotfiles-submodule-symlinks
# TODO: rehome_undo ~ dependent on creating a pwsh equivalent of dotfiles-submodule-symlinks

# For ensuring your ~/.gitconfig is up-to-date; per our unconvential method:
# https://github.com/Skenvy/dotfiles/blob/main/git/config/README.md
function global:gaconf { & "$HOME/git/config/apply.ps1" }

################################################################################
# The above are some aliases relevant to using this repoistory as a submodule as
# described by the README. For any additional aliases I use, I've added them
# only in https://github.com/Skenvy/dotfiles/blob/home/.bash_aliases my home.

Invoke-Source "$HOME/.include/.post/.pwsh_aliases.ps1" -Quiet
