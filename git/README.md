[.devcontainer/README.md]: https://github.com/Skenvy/dotfiles/blob/main/.devcontainer/README.md
[original ~/.gitconfig]: https://github.com/Skenvy/dotfiles/blob/71e9b6a839553d01d5f8c345904c800dbace2460/.gitconfig
[includepath]: https://git-scm.com/docs/git-config#Documentation/git-config.txt-includepath
[includeIfconditionpath]: https://git-scm.com/docs/git-config#Documentation/git-config.txt-includeIfconditionpath
[vsc devcontainers git]: https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials
[reason]: #reason-for-the-unconvential-method-this-guide-suggests
# [git](https://github.com/Skenvy/dotfiles/blob/main/git/README.md)
> [!NOTE]
> The section on managing your `~/.gitconfig` is only TLDR'd here.
>
> For the full guide on our unconvential method, see [.gitconfig](./config/README.md).
---
> [!TIP]
> Some settings will usually best be set to different choices depending on your OS.
>
> This should be a minimal way to set up `git` for use on Mac, Windows, and WSL.
---
> [!IMPORTANT]
> [`git`](https://git-scm.com/) can be configured via [`.gitconfig`](https://git-scm.com/docs/git-config) files, whether they are placed in repositories ("local" scope), or via the "global" config in `~/.gitconfig`.
> Or one of the _other_ [scopes](https://git-scm.com/docs/git-config#SCOPES).
> Also see [chapter 8.1](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration).
## Dotfiles setup
With `git` being frequently one of _the_ most important tools, its configuration can be one of the most important in your dotfiles.
It is a somewhat common (at least, not uncommon...) practice to include a whole, or partial, global git config in a dotfiles repository.
> [!NOTE]
> The method this dotfiles repository recommends for managing your `~/.gitconfig` is unconvential, and an exhaustive explanation for how and why this approach is recommended can be found in the [.gitconfig](./config/README.md) _specific_ README.
>
> The top level TLDR below is a copy of what is in the more specific and thorough README, so as to not fully abandon the point here, but for more info, read the [.gitconfig](./config/README.md) _specific_ README.
### The method
#### What are the steps to follow the method
> [!IMPORTANT]
> The method we use to maintain our `~/.gitconfig`:
> 1. Write your settings as you would normally, but add them to `~/.gitconfig.base`
> 1. Be aware of the presence of `~/.gitconfig.init`, but don't change it!
> 1. Follow the inclusion instructions in:
>     * [.include/.pre/.gitconfig](https://github.com/Skenvy/dotfiles/blob/main/.include/.pre/README.md#gitconfig) for OS specific configuration, like `autocrlf`, `filemode`, etc.
>     * [.include/.post/.gitconfig](https://github.com/Skenvy/dotfiles/blob/main/.include/.post/README.md#gitconfig) for settings like your name, email, or gpg key ID
> 1. Run one of the available "apply" scripts here that will bundle your inclusions together
>     * [apply.sh](./apply.sh) for Linux/MacOS
>     * [apply.ps1](./apply.ps1) for Windows
> 1. If some config had been intermittently set in `~/.gitconfig` but not adopted by `~/.gitconfig.base` (or anything included by it), then these `apply.*` scripts will produce a `~/.gitconfig.diff` with the differing config captured. This is per run, so be sure to check it after each run if there was a difference!
