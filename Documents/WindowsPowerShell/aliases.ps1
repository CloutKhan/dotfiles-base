Invoke-Source "$HOME/.include/.pre/.pwsh_aliases" -Quiet

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
Set-Alias -Name gaconf -Value { & "$HOME/git/config/apply.ps1" }

################################################################################
# The above are some aliases relevant to using this repoistory as a submodule as
# described by the README. For any additional aliases I use, I've added them
# only in https://github.com/Skenvy/dotfiles/blob/home/.bash_aliases my home.

Invoke-Source "$HOME/.include/.post/.pwsh_aliases" -Quiet
