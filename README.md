# [dotfiles](https://github.com/Skenvy/dotfiles)
> [!TIP]
> Proctor your user settings `~/.*` | `$HOME` with
[dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) --
[topic](https://github.com/topics/dotfiles),
[io](https://dotfiles.github.io/),
[codespaces](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles),
[devcontainers](https://containers.dev/),
["awesome"](https://github.com/webpro/awesome-dotfiles)

_This_ is _**my**_ dotfile repository. It follows the ["`$HOME` is a repo"](https://github.com/Skenvy/dotfiles/blob/main/devlog.md#home-is-a-repo) pattern, with bells attached. See the [devlog](https://github.com/Skenvy/dotfiles/blob/main/devlog.md) for more.

This dotfile repository is setup in a way that it follows "`$HOME` is a repo", in multiple ways.
1. "`$HOME` is _this_ repo" -- you can directly clone this on top of `$HOME`.
1. "`$HOME` is _another_ repo" -- you add this as a submodule in your own dotfiles repo ~= `$HOME`.
## Pre-use
### `git`+`ssh`
To use any approach, you'll need to have `git` installed, as well as `ssh`, and have the `ssh-agent` running, and your key added to the agent, and uploaded to GitHub. See [my ssh gist](https://gist.github.com/Skenvy/8e16d4f044707e63c670f5b487da02c0) for steps on how to handle setting up `ssh` on Ubuntu or Windows (pay close attention to the step for setting `"GIT_SSH"` if you're on Windows). If you already have `ssh` setup and `git` installed, then you're ready to continue to one of the below steps!
### `~/.include/*`
A critical feature that underpins all approaches to using these dotfiles effectively, you should be aware of this directory. Different config files are allowed to independently expect or optionally hook various files that should or must be kept under `~/.include/*`. They provide a means for "core" or "centralised" or "shared" configuration to be kept in this repository, but also allows "extensible" configuration files, that are "core" files with the ability to seek out "extension" configuration files, that needn't or shouldn't be checked-in here. "Extensible" just means files that can attempt to parse other files in `~/.include/*` and will composite or allow overwriting of "core" (checked-in here) config, by the "extension" configuration files that you will have to independently maintain in `~/.include/*`.

See both [`~/.include/.pre/README.md`](https://github.com/Skenvy/dotfiles/blob/main/.include/.pre/README.md) and [`~/.include/.post/README.md`](https://github.com/Skenvy/dotfiles/blob/main/.include/.post/README.md) for the two most commonly parsed folders, that provide suggestions on what config files to add in either place. For an illustrative example of this, have a look at [how to add your ssh key setup to `.bashrc`](https://github.com/Skenvy/dotfiles/blob/main/.include/.post/README.md#bashrc-example).
## Use as "`$HOME` is _this_ repo"
If you're planning to accept this repo into your `$HOME`, you're doing so aware that these steps will <span style="color:red">destructively</span> replace files of the same name that exist in your `$HOME` already.
You would typically be interested in following this step as one of the first things you do setting up a new machine, so the destructivity would be limited to only replacing the user files that the system had generated for you. If you're following this step at some other point well after you've been using your machine for a while, chances are that customisations and personal settings might have crept in to your local dotfiles.
* If `~` is _NOT_ empty, and you want to use _only_ `git`, and you want to use ssh:
```sh
cd ~ && git init && git remote add origin git@github.com:Skenvy/dotfiles.git && git fetch && git remote set-head origin -a && HEADSHA=$(git rev-parse origin/HEAD) && git remote set-head origin -d && REMOTE_HEAD=$(git name-rev $HEADSHA --name-only) && git checkout -b main $REMOTE_HEAD -f
```
* If `~` is _NOT_ empty, you want to use ssh, and force the cutover to these settings:
```sh
rm -rf .git/ && cd ~ && git init && git remote add origin git@github.com:Skenvy/dotfiles.git && git fetch && cp -r .git/refs/remotes/origin/* .git/refs/heads/ && git remote set-head origin -a && REMOTE_HEAD=$(git name-rev origin/HEAD --name-only) && rm .git/refs/heads/* && git checkout -b $REMOTE_HEAD origin/$REMOTE_HEAD -f
```
## Use this as a base with your own `.include`'s
To use these configs as an extensible base, where you can track this repository and use its contents, you should add this repository as a submodule in your own dotfiles repository, and symlink its contents into `$HOME`. This lets you use and stay up-to-date with changes to **this**, but also allows you to commit any additional files you need, provided they wont just get symlinked over by following this process.

> [!IMPORTANT]
> This is specifically geared to my use case of wanting to maintain personal, public, dotfiles that I utilise on personal machines, that I can also utilise on any work machine, for which it would be convenient to use a private repository such that I can commit the `.include/*` hooks relevant for work that shouldn't be public, but that I don't want to lose to the ether. This method allows for maintaining these personal, public, dotfiles, that I can submodule into a private, work specific, dotfiles repository, symlink into `$HOME`, and commit any `.include/*` hooks as they grow.

Of course, this goes against the intentional lack of symlinks in **this** flat splat of the "`$HOME` is a repo" design, but I'm ok with that. You might say that forking this, and tracking **this** as an upstream would be simpler, but that lacks that immediacy of seperation between "what am I editting in 'my changes on top of this'?" and "am I editting something that I'll need to move back upstream?" -- whereas working with a module lets me see the small changeset of hooks for what they are, and immediately know from a `git status` if I need to relocate config changes.

Anyway, here's how you would submodule this into another repository and symlink it into `$HOME`.
1. If you use a `.gitignore` that is just `*`, this can conflict with adding a submodule, so temporarily `rm .gitignore`
1. If you'd like to fork this first, you can, and, say, call it `dotfiles-base`
1. Now you can track this as a submodule `git submodule add git@github.com:Skenvy/dotfiles.git`
1. Or if you forked `git submodule add -- git@github.com:<YOU>/dotfiles-base.git dotfiles`
1. The submodule and `.gitmodules` are staged, so `git restore .gitignore` and commit.
1. `git submodule init && git submodule update`

Now with a `.gitmodules` file that places **this repository** in the `dotfiles` folder in the repo that has added this;
```ini
[submodule "dotfiles"]
        path = dotfiles
        url = git@github.com:Skenvy/dotfiles.git
# OR
[submodule "dotfiles"]
        path = dotfiles
        url = git@github.com:<YOU>/dotfiles-base.git
```
With the submodule initialised and updated we can now symlink its contents into `$HOME`.
> [!CAUTION]
> `CLOBBER_HOME=DESTRUCTIVELY` will **force** symlinks (`ln -sf`) to write over files.
> ```bash
> cd ~ && ./dotfiles/bin/dotfiles-submodule-symlinks # Safest. Or, if you prefer to live on the edge..
> CLOBBER_CHECKEDIN_ROOT=REPLACE CLOBBER_HOME=GRACEFULLY ./dotfiles/bin/dotfiles-submodule-symlinks
> ```

> [!WARNING]
> If you want to maintain a `README.md` that will display on the github page of the repository that submodules this, because this process will clobber the including repository's root `README.md` with a symlink to **this** repository's `README.md`, you can get around this by placing your `README.md` you want displayed at `.github/README.md`, which is the first path for a `README.md` file that github will look for (even before a root `README.md`).

> [!IMPORTANT]
> Note that the process of linking files into `$HOME` wont touch several files, listed in the script. You should ideally have a `~/.gitignore` of just `*` and a `~/.gitattributes` of just `* text=auto`.

## License
> [!NOTE]
> <p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/Skenvy/dotfiles">dotfiles</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/Skenvy">Nathan Levett</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC-BY-SA-4.0 <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>
