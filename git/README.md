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

A global `.gitignore` and global `.gitattributes` can also be set and would be kept in your dotfiles repository, but we discuss those in the below sections and keep this "Dotfiles setup" section focused solely on our `.gitconfig` approach.
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
>     * [apply.sh](./config/apply.sh) for Linux/MacOS
>     * [apply.ps1](./config/apply.ps1) for Windows
> 1. If some config had been intermittently set in `~/.gitconfig` but not adopted by `~/.gitconfig.base` (or anything included by it), then these `apply.*` scripts will produce a `~/.gitconfig.diff` with the differing config captured. This is per run, so be sure to check it after each run if there was a difference!
## Be OS aware
> [!CAUTION]
> When choosing what settings you actually want in your config, you should be aware that different settings are suggested for different OS.

We cover what we recommend you adopt for some OS specific settings in our ["pre include"](../.include/.pre/README.md#gitconfig) guide.

Because different OS use different settings, our recommended approach for handling your `~/.gitconfig` when on Windows + WSL, is that you keep separate copies in both OS contexts, with separate `~/.include/*/.gitconfig` and run either version of the `apply.*` scripts depending on context.

If you are setting a gpg `signingkey` in your `~/.include/*/.gitconfig` like we [recommend](../.include/.post/README.md#gitconfig), the key you set it to will need to also follow the downstream instructions linked to from there.
## Install
See [git downloads](https://git-scm.com/downloads), it already has very helpful instructions for:
* [Windows](https://git-scm.com/install/windows) (you probably want to download one of these [releases](https://github.com/git-for-windows/git/releases/))
* [MacOS](https://git-scm.com/install/mac) ("system git" from `xcode-select --install`, or `brew install git`)
* [Linux](https://git-scm.com/install/linux) (_probably_ just `apt install git` or `dnf install git`, or any other pkg manager..)
* [_source_](https://git-scm.com/install/source) (if you choose this then you know what you're doing already)
## [`.gitignore`](https://git-scm.com/docs/gitignore)
### Global/Dotfiles
> [!TIP]
> Set your user global `.gitignore` with [`core.excludesFile`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-coreexcludesFile).
> Local settings will take precedence.
>
> In the context of `.gitignore`, local precedence means that a pattern you ignore globally can be unignored by a local `.gitignore`, so you can't blindly trust your global `.gitignore` will always prevent every commit of every pattern it ignores, universally.
>
> We use [~/.config/git/.gitignore](../.config/git/.gitignore).
>
> We use several [github/gitignore:./Global](https://github.com/github/gitignore/tree/main/Global);
> OS ignores:
> [Linux](https://github.com/github/gitignore/blob/main/Global/Linux.gitignore),
> [MacOS](https://github.com/github/gitignore/blob/main/Global/macOS.gitignore),
> [Windows](https://github.com/github/gitignore/blob/main/Global/Windows.gitignore),
> other:
> [Images](https://github.com/github/gitignore/blob/main/Global/Images.gitignore),
> `node_modules/`,
> `.ve/`, `.venv/`
### Local/Repo
More often than not, you will best be served by having a look at some pre-existing ignore templates.
Of course, you should edit these as necessary, and some tools / languages might be more or less likely to _have_ a template you can start from.

Comprehensive community collections of templates exist, like [github/gitignore](https://github.com/github/gitignore).
#### `-f` it
We use a single `*` in the local ignore [here](../.gitignore), to ignore _everything_ (unless we `-f` it).

You can make an exception to an ignore pattern for a specific file, by `-f`'ing it e.g. `git add -f <ignored-file>`.
## [`.gitattributes`](https://git-scm.com/docs/gitattributes)
### Global/Dotfiles
> [!TIP]
> Set your user global `.gitattributes` with [`core.attributesFile`](https://git-scm.com/docs/git-config#Documentation/git-config.txt-coreattributesFile).
> Local settings will take precedence.
>
> We use [~/.config/git/.gitattributes](../.config/git/.gitattributes).
>
> The below suggestion for what `.gitattributes` to use locally are also good for global settings.
### Local/Repo
The following is what we both use [here](../.gitattributes), and what we generally recommend anyone use in their `.gitattributes`, if you don't already have a good reason for using some other attributes.

See docs:
[[(vsc docs)](https://code.visualstudio.com/docs/devcontainers/tips-and-tricks#_resolving-git-line-ending-issues-in-containers-resulting-in-many-modified-files)]
[[(vsc docs permalink)](https://github.com/microsoft/vscode-docs/blob/499d8d142949f9b55f8731920d942c1baec6779b/docs/devcontainers/tips-and-tricks.md?plain=1#L70-L80)]
```conf
* text=auto eol=lf
*.cmd text eol=crlf
*.bat text eol=crlf
```
> [!IMPORTANT]
> If you're adding these to your `.gitattributes` later in development, remember to `git add --renormalize .` to apply these setting to the indexed state.
> Then add and commit the renormalised indexed state, so any new clone / pull will get a fully normalised state.
> Any future changes will get normalised by this `.gitattributes` as they happen, now.
## [`.gitmodules`](https://git-scm.com/docs/gitmodules)
Purely for completeness of including the last of the `.git*` files, we'll also mention `.gitmodules` here, although only as an honourable mention.
### Global/Dotfiles
_There are none._ It's not a thing.. at all..
### Local/Repo
`.gitmodules` only applies to the context of being defined on a repository, and lists other repositories that you want to have copies of embedded in the repository submoduling.
From `git`'s perspective, a submodule is tracked in the repository that lists it in its own `.gitmodules` as the sha-pin of the submoduled repository.
See the entry in the git book, [7.11 Git Tools - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
Fwiw, some people have strong opinions on the difference between [submodule](https://www.atlassian.com/git/tutorials/git-submodule) and [subtree](https://www.atlassian.com/git/tutorials/git-subtree). I don't necessarily take a side in this, but they are worth reading if you are still shopping around.
### _This repo_
Even though "`.gitmodules` has no dotfiles component" is true _for `.gitmodules` itself,_ **this** is a _dotfiles repository_, that **does** have a suggested use case for which it provides a `.gitmodules` example that can be used to submodule **this repository** in to any other dotfiles repository.

The "base" branch, an example of a dotfiles repository piggybacking off this via our provided [Use as "$HOME is another repo"](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#use-as-home-is-another-repo) methodology, provides this [`.gitmodules`](https://github.com/Skenvy/dotfiles/blob/base/.gitmodules) example.
More specific instructions can be found under [Use as "$HOME is another repo" :: Starting from an existing repository](https://github.com/Skenvy/dotfiles/tree/main?tab=readme-ov-file#starting-from-an-existing-repository).
