[.devcontainer/README.md]: https://github.com/Skenvy/dotfiles/blob/main/.devcontainer/README.md
[original ~/.gitconfig]: https://github.com/Skenvy/dotfiles/blob/71e9b6a839553d01d5f8c345904c800dbace2460/.gitconfig
[includepath]: https://git-scm.com/docs/git-config#Documentation/git-config.txt-includepath
[includeIfconditionpath]: https://git-scm.com/docs/git-config#Documentation/git-config.txt-includeIfconditionpath
[vsc devcontainers git]: https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials
[reason]: #reason-for-the-unconvential-method-this-guide-suggests
# [.gitconfig](https://github.com/Skenvy/dotfiles/blob/main/.git-config/README.md)
> [!WARNING]
> This guide explains a likely highly unconvential method for handling your `.gitconfig` files; by way of scripting their creation, rather than just checking in the actual `.gitconfig` itself.
>
> It would not be worthwhile following this guide unless you are intentionally seeking a method that allows you to;
> 1. Use the regular `ini`-ish format of `.gitconfig`
> 1. Use [`[include]`][includepath] or [`[includeIf]`][includeIfconditionpath] directives in your "global" `.gitconfig`
> 1. Have the state of these **inclusion directives** resolved _"""externally"""_ to `git`
> 1. Use **inclusion directives**, but _avoid_ them being present in the "resolved" `.gitconfig`.
>
> You can see more about _why_ in the below "[_Reason_ for the unconvential method this guide suggests][reason]"
---
> [!TIP]
> Some settings will usually best be set to different choices depending on your OS.
>
> This should be a minimal way to set up git for use on Mac, Windows, and WSL.
---
> [!IMPORTANT]
> [`git`](https://git-scm.com/) can be configured via [`.gitconfig`](https://git-scm.com/docs/git-config) files, whether they are placed in repositories ("local" scope), or via the "global" config in `~/.gitconfig`.
> Or one of the _other_ [scopes](https://git-scm.com/docs/git-config#SCOPES).
> Also see [chapter 8.1](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration).

## Dotfiles setup
With `git` being frequently one of _the_ most important tools, its configuration can be one of the most important in your dotfiles.
It is a somewhat common (at least, not uncommon...) practice to include a whole, or partial, global git config in a dotfiles repository.
> [!NOTE]
> This guide follows a different format to our [SSH](https://github.com/Skenvy/dotfiles/blob/main/.ssh/README.md) and [GPG](https://github.com/Skenvy/dotfiles/blob/main/.gnupg/README.md) guides:
>
> Its primary intention is to explain why we shifted from one way of checking in a particular config, to another method.
> So the bulk of this guide will be addressing the reason for this shift.
>
> It will not function as a generic guide to installing or using basic commands of git, like those other two guides do.
### The method
#### This is a TLDR
> [!TIP]
> Every other section below this is a more thorough explanation for why this was necessary or how we justified this as the best middle of the road approach.
> If all you want to know is what is the method we suggest without reading anything else unnecessarily, here's the top level description.
#### What are the steps to follow the method
> [!IMPORTATION]
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
#### What are these steps doing under the hood?
> [!NOTE]
> What are these steps doing under the hood?
> How are the `apply.*` scripts actually working?
> You can find a much more thorough answer below in the [Current Implementation](#current-implementation) description.
> But to summarise here:
>
> Each time you run a `./.git-config/apply.*`:
> 1. The current state of `~/.gitconfig` is captured
> 1. `~/.gitconfig.init` gets copied over the top of `~/.gitconfig`
> 1. The new "init" state of `~/.gitconfig` is captured
>     * This step hides a lot of magic baked in to this process...
>     * `~/.gitconfig.init` `[includes]` `~/.gitconfig.base`
>         * `~/.gitconfig.init` being the _temporary_ `~/.gitconfig`...
>             * lets `~/.gitconfig.base` be our _actual_ `~/.gitconfig`
> 1. `~/.gitconfig` is reset to empty.
> 1. All of the "init" captured state is written to `~/.gitconfig`
> 1. The previous state and the new state are compared.
> 1. If there's a difference, it's written to a `~/.gitconfig.diff`
>     * The diff just uses `diff` / `Compare-Object` so _might_ take effort to parse.
### _Reason_ for the unconvential method this guide suggests
Historically, my personal push to adopt this method came about while figuring out how to adopt [devcontainers][.devcontainer/README.md], and stumbling on the clash between my _already existing_ use of `[includes]` in my _already-checked-in_ [`~/.gitconfig`][original ~/.gitconfig], clashing with the manner in which the [devcontainers automatic git integration][vsc devcontainers git] copies exclusively the one global file, and doesn't resolve the global state, thus dropping any `[include]`'d settings. Which is where I kept / keep my username and email, amongst other OS specific settings.

That is to say, I used `[include]` to prevent the check-in of OS settings / gpg settings / username / email, but when setting up devcontainers with the git integration for the first time, learnt that `[include]`'d settings don't propagate in to the container, because it simply copies the `~/.gitconfig` file without trying to follow `[include]`'d, or injecting a resolved state.

Being able to support devcontainers in as generic a way as possible, and the use of git, ssh and gpg with them, is a goal of this repo.

Thus I needed to find a way to preserve my original intention of utilising `[include]`, but simultaneously avoid any `[include]` being required by `~/.gitconfig`, hence I needed to find the best method for maintaining my config _elsewhere_ (not in the `~/.gitconfig`), and periodically resolving the _state_ of my config and writing the config, in its resolved entirety, in to a "not checked in" `~/.gitconfig`.
### Finding the best new method
There are potential workarounds, such as setting bind mounts on a devcontainer settings file, but these require that you control the devcontainer configuration as well.

> [!IMPORTANT]
> None of the workarounds I found worked well for the situation of:
> * wanting to check-in a _partial state_ (`[include]` reliant) of `~/.gitconfig`
> * wanting there to be a mechanism to extend the partial state of `~/.gitconfig`
> * wanting the fully resolved state of `~/.gitconfig` to be loaded in to a devcontainer
> * **not have to edit a `devcontainer.json` to enable this**; _either by_ `type=bind` `mounts` _or_ `postCreateCommand`

If we want our config to work with _any_ devcontainer, the fix must be to the way we maintain the `~/.gitconfig`, assuming we can't justify setting other repository's `devcontainer.json`'s to handle our specific dotfiles setup in _their_ bind mounts / scripted lifecycle commands.
Unfortunately, currently, to the best of my knowledge, there is no mechanism to provide a devcontainer implementation with "devcontainer dotfiles" that instruct it to override a `devcontainer.json` with personally configured mount options or override the scripted lifecycle commands set in each `devcontainer.json`.
So handling this through the `devcontainer.json` settings is out of the question.

So I have decided to swap to an approach of utilising scripted re-setting of `~/.gitconfig` -- this allows us to check in partial, extendible state, without requiring the `~/.gitconfig` be added / indexed, and thus its state won't be owned by git going forward.

We can simply remove the existing `~/.gitconfig` file, and replace it with a script that runs on shell start. This means we end up keeping the entire resolved global state in the main global config file, and devcontainers picks up the entire resolved state when it copies it.
### What should you check-in: none, all, or some?
It's worth wondering whether or not, or why or why not, it's a good idea to check-in _any_ of our `~/.gitconfig`. There certainly is a wide variety amongst other example dotfile repositories of varying notoriety. Some don't bother checking in any `~/.gitconfig` at all. So why should we go to all this effort? What _should_ we check-in?
#### None?
Some dotfiles repositories choose to not check in any `~/.gitconfig`. This is as simple as not adding it to the index.. whether because they intentionally avoid adding it or just leave it to the user to handle.
#### All?
Some choose to check in a _complete_ `~/.gitconfig`, including local IDs for keys, emails, and other settings, that are not necessarily _secret_, but could be potentially _sensitive_, and not ideal to unintentionally distribute if you can avoid it and avoiding it is not a costly task.
#### Some?
A middle ground between either checking in an entire config _with_ possibly sensitive settings, or not checking in your git config at all, can be achieved by way of two options;
* [`[include]`][includepath] (always include a file, _if it exists_)
* [`[includeIf]`][includeIfconditionpath] (conditionally include a file)

Using either of these **inclusion directives**, it's possible to check-in a _core set_ of configuration options that would be reasonable in any environment, and then extend them with other options in other files that don't need to be checked-in.

This also provides a means for someone to distribute _core global settings_, say, via a dotfiles repository, that others could adopt without requiring to change them, and provide a means for any consumer to add one of the "included" files, that will then inject their more personal settings in to git's global config.
### Examples of how other dotfiles repositories check-in their `~/.gitconfig`:
This isn't strictly necessary info, just nice to take the pulse on what others are doing. This list is just some examples from [dotfiles.github.io](https://dotfiles.github.io/bootstrap/) and from asking copilot if it had any tricks in mind.
* [mathiasbynens/dotfiles' ~/.gitconfig](https://github.com/mathiasbynens/dotfiles/blob/b7c7894e7bb2de5d60bfb9a2f5e46d01a61300ea/.gitconfig) (most starred repo on [dotfiles.github.io](https://dotfiles.github.io/bootstrap/))
    * Doesn't use `[include]`
    * _Does_ provide an alternative repo specific _general_ inclusion mechanism via "[`~/.extra`](https://github.com/mathiasbynens/dotfiles/blob/b7c7894e7bb2de5d60bfb9a2f5e46d01a61300ea/README.md#add-custom-commands-without-creating-a-new-fork)", though..
* [paulirish/dotfiles' ~/.gitconfig](https://github.com/paulirish/dotfiles/blob/d27a39a78a36bc5548e320f9bcc064f13b3c0323/.gitconfig#L176-L178)
    * Uses `[include].path = ~/.gitconfig.local`
* [jessfraz/dotfiles'  ~/.gitconfig](https://github.com/jessfraz/dotfiles/blob/60001dd6638daa0275020807fd948c4d22fb7741/.gitconfig#L195-L200)
    * Checks-in their user specific settings and machine specific key setting.
### Original implementation
The approach originally used by this dotfiles repository consisted of this [`~/.gitconfig`][original ~/.gitconfig].
Checked-in as the `./.gitconfig`, it would be checked-out on to your `~/.gitconfig` directly, or symlinked to it if you used this repository's suggested "use as a submodule" approach.
_Either way_, the resulting `~/.gitconfig` would rely heavily on `[include]`.

Specifically we used two different includes paths;
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
### Current implementation
We can maintain many of the niceties we had originally.
If you understand the original implementation described above, with that as a starting point, we can achieve the current implementation by making a handful of changes:
1. Move the respository's existing `./.gitconfig` to `./.gitconfig.base`
1. Create a new file which we will call `./.gitconfig.init`, populated with:
    ```ini
    [include]
        path = ./.gitconfig.base
    ```
1. Create a script that reproduces a re-resolved state
    1. by copying our `./.gitconfig.init` on to our `~/.gitconfig`
    1. then using `git config --list --show-scope`
    1. and capturing only the resolved "global" scope's state
    1. then writing all of these to the `~/.gitconfig`.
#### Why?
Why do we do it this way?
##### Why `./.gitconfig.base`
The first and easiest to answer, why do we just rename the existing `./.gitconfig` to `./.gitconfig.base`?
We get to keep our desired core config, with its inclusion directives (_still intact!_), checked-in!
Eventually we will also be able to utilise `git` to navigate the included paths for us, e.g. we don't need to write any custom scripting to handle resolving inclusions outside of git, because we can just use git to do.. what it was made to do!
We also get to keep all the logic of inclusions locally consistent; we don't need to edit the contents of this file at all, simply rename it.
##### Why `./.gitconfig.init` -- part one
Why use a `./.gitconfig.init`? There's two reasons that simultaneously hold for this.

The first part of this reason is that `git config --list --show-scope` only follows **inclusion directives** when it's _not_ a "command" scope. That is to say, if we wanted to try and skip needing the `./.gitconfig.init`, and instead using `git config --list --show-scope` _with the `--file` option_ to point it to a specific file, even if we pointed it at the existing global scope `~/.gitconfig`, it would register the scope as "command", which would stop it from following any of the **inclusion directives** -- for example if we used the `--file` option on the [original `~/.gitconfig`][original ~/.gitconfig]
```sh
git config --list --show-scope --file ~/.gitconfig
# command include.path=.include/.pre/.gitconfig
# command filter.lfs.clean=git-lfs clean -- %f
# command filter.lfs.smudge=git-lfs smudge -- %f
# command filter.lfs.process=git-lfs filter-process
# command filter.lfs.required=true
# command pull.ff=only
# command include.path=.include/.post/.gitconfig
```
Where-as if we had _not_ used the `--file` option, the `include.path`'s would have been followed and resolved appropriately.
So to make sure we actually keep using our **inclusion directives**, and keep relying on git to handle them for us, we have to avoid using the `--file` option.

We also have to have a way to get a global `~/.gitconfig` to _temporarily_ act as its own _initialisation_ point -- because we have to avoid the "command" scope, we _have_ to rely on the "global" scope being an _automorphism_ -- or, at least, _temporarily_ being an _automorphism_.
##### Why `./.gitconfig.init` -- part two
The other reason why we need to _keep_ a `./.gitconfig.init`, and have our process for re-resolving the "global" state always start by copying our `./.gitconfig.init` anew, is that _self-referential_ **inclusion directives** simply result in an error.
For example, if we had simply moved our existing `~/.gitconfig` to `~/.gitconfig.base`, but also added an `[include]` at the top of it to always re-include itself, git would not _short-circuit_ the _self-referential_ **inclusion directive** -- it would attempt it and error with something akin to this example error message:
```sh
fatal: exceeded maximum include depth (10) while including
        /home/you/.gitconfig.base
from
        /home/you/.gitconfig.base
This might be due to circular includes.
```
So to avoid _circular includes_, we need a separate temporary "`init`-only" `~/.gitconfig`.
##### Why overall?
Even though there is depth to the reason for why each of these choices were made -- the end result, despite being more work, at least to understand, than the old approach -- actually ends up being a much smaller "new method" than would have seemed necessary initially. All we have to do is rename our existing config (no changes required to its contents, or downstream included paths..), add an init config file, and script some basic procedures (a file copy, run a command and capture its output, iterate the lines of that output and run a command for each).

By keeping the settings in a native format we also get away with not needing to make any changes at all to the two inclusion READMEs, and we can script recreating our `~/.gitconfig` for multiple OS e.g. Ubuntu / Mac / Windows all use the same `git config ...` commands that will all read the same state, rather than shifting config state in to a script that would only work on any one of them.

Admittedly I can't say for certain how well this would work performance wise if you had a very very large git config, but with a modest / small config, it should be negligible to do this on each shell start.
