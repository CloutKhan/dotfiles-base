[.devcontainer/README.md]: https://github.com/Skenvy/dotfiles/blob/main/.devcontainer/README.md
[original ~/.gitconfig]: https://github.com/Skenvy/dotfiles/blob/71e9b6a839553d01d5f8c345904c800dbace2460/.gitconfig
# [.gitconfig](https://github.com/Skenvy/dotfiles/blob/main/.gitconfig/README.md)
> [!NOTE]
> This guide is explaining a methodology, for checking-in a partial configuration for git, that had to be (temporarily) adopted to allow partial git configs to work side-by-side with [**devcontainers**][.devcontainer/README.md].
>
> See the below TLDR
---
> [!TIP]
> Some settings will usually best be set to different choices depending on your OS.
>
> This should be a minimal way to set up git for use on Mac, Windows, and WSL.
---
> [!IMPORTANT]
> [git](https://git-scm.com/) can be configured via [`.gitconfig`](https://git-scm.com/docs/git-config) files, whether they are placed in repositories, or via the "global" config in `~/.gitconfig`.
> Also see [chapter 8.1](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration).

## Dotfiles setup
With `git` being frequently one of _the_ most important tools, its configuration can be one of the most important in your dotfiles.
It is a somewhat common (at least, not uncommon...) practice to include a whole, or partial, global git config in a dotfiles repository.
> [!NOTE]
> This guide follows a different format to our [SSH](https://github.com/Skenvy/dotfiles/blob/main/.ssh/README.md) and [GPG](https://github.com/Skenvy/dotfiles/blob/main/.gnupg/README.md) guides:
> its primary intention is to explain why we shifted from one way of checking in a particular config, to another method. So the bulk of this guide will be addressing the reason for this shift.
> It will not function as a generic guide to installing or using basic commands of git, like those other two guides do.
### TLDR: Why we are changing how we handle `~/.gitconfig`
Why is this guide written about why we are shifting from one already working approach to another?

Previously, this repository suggested the use of a core global [`~/.gitconfig`][original ~/.gitconfig] with optional extension paths via `[include]`.

This worked fine up until attempting to use this approach (partial + checked-in) with [devcontainers][.devcontainer/README.md].

Being able to support devcontainers in as generic a way as possible, and the use of git, ssh and gpg with them, is a goal of this repo.

Following [this](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials) guide to setup [devcontainers][.devcontainer/README.md] with integrations for importing git config and ssh and gpg keys, I ran in to a problem.

When devcontainers import the git config, they don't dynamically retrieve the state of config by following inclusions paths. They simply copy the `~/.gitconfig` file as it exists, in to the container. So any included paths won't work inside the container, and any config you keep in files besides the main `~/.gitconfig` will simply not be included.

There are potential workarounds, that you can utilise, such as setting bind mounts on a devcontainer settings file, but these require that you control the devcontainer configuration as well.

None of the workarounds I found worked well for the situation of:
* wanting to check-in a partial state of `~/.gitconfig`
* wanting there to be a mechanism to extend the partial state of `~/.gitconfig`
* wanting the fully resolved state of `~/.gitconfig` to be loaded in to a devcontainer
* not have to edit a `devcontainer.json` to enable this, either by bind mounts or `postCreateCommand`

So I have decided to swap to an approach of utilising scripted re-setting of `git config` -- this allows us to check in partial, extendible state, without requiring the `~/.gitconfig` be added / indexed, and thus its state owned by git.

We can simply remove the existing `~/.gitconfig` file, and replace it with a script that runs on shell start. This means we end up keeping the entire resolved global state in the main global config file, and devcontainers picks up the entire resolved state when it copies it.
### What should you check-in: none, all, or some?
#### None?
Some dotfiles repositories choose to not check in any `~/.gitconfig`. This is as simple as not adding it to the index.. whether because they intentionally avoid adding it or just leave it to the user to handle.
#### All?
Some choose to check in a _complete_ `~/.gitconfig`, including local IDs for keys, emails, and other settings, that are not necessarily _secret_, but could be potentially _sensitive_, and not ideal to unintentionally distribute if you can avoid it and avoiding it is not a costly task.
#### Some?
A middle ground between either checking in an entire config _with_ possibly sensitive settings, or not checking in your git config at all, can be achieved by way of two options;
* [[include]](https://git-scm.com/docs/git-config#Documentation/git-config.txt-includepath) (always include a file, _if it exists_)
* [[includeIf]](https://git-scm.com/docs/git-config#Documentation/git-config.txt-includeIfconditionpath) (conditionally include a file)

Using either of these, it's possible to check-in a core set of configuration options that would be reasonable in any environment, and then extend them with other options in other files that don't need to be checked-in.

This also provides a means for someone to distribute core global settings, say, via a dotfiles repository, that others could adopt without requiring to change them, and provide a means for any consumer to add one of the "included" files, that will then inject their more personal settings in to git's global config.
### Examples of how other dotfiles repositories handle this:
* [paulirish/dotfiles' ~/.gitconfig](https://github.com/paulirish/dotfiles/blob/d27a39a78a36bc5548e320f9bcc064f13b3c0323/.gitconfig#L176-L178)
    * Uses `[include].path = ~/.gitconfig.local`
### Original implementation
Prior to requiring to adjust to the new method this presents to support a global `~/.gitconfig` that can work with [**devcontainers**][.devcontainer/README.md], this repository suggested the use of
[[include]](https://git-scm.com/docs/git-config#Documentation/git-config.txt-includepath) as a way of including setting that would either be different per OS, or different per person using the repository.

This approach consisted of this [`~/.gitconfig`][original ~/.gitconfig].

The highlight of which was the use of two different includes paths;
```ini
[include]
    path = .include/.pre/.gitconfig
# ... and ...
[include]
    path = .include/.post/.gitconfig
```
Where the
[.include/.pre/.gitconfig](https://github.com/Skenvy/dotfiles/blob/71e9b6a839553d01d5f8c345904c800dbace2460/.include/.pre/README.md#gitconfig)
was originally OS specific configuration, like `autocrlf`, `filemode`, `symlinks` and gpg program, and the
[.include/.post/.gitconfig](https://github.com/Skenvy/dotfiles/blob/71e9b6a839553d01d5f8c345904c800dbace2460/.include/.post/README.md#gitconfig)
was originally for settings that could be potentially sensitive like your configured email, or gpg key ID, and also included setting your name.
### Current (new) implementation
