# [dotfiles](https://github.com/Skenvy/dotfiles)
> [!TIP]
> Proctor your user settings `~/.*` | `$HOME` with
[dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) --
[topic](https://github.com/topics/dotfiles),
[io](https://dotfiles.github.io/),
[codespaces](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles),
[devcontainers](https://containers.dev/),
["awesome"](https://github.com/webpro/awesome-dotfiles)
## Prelim
This follows the flat splat pattern of just saying "`$HOME` is a repo".

Rather than cloning into something like `~/dotfiles` and using some `install.sh` script or `stow`, this adopts the pattern that `$HOME` _is_ this repository. The magic, is a `.gitignore` of just `*`, coupled with the intentionality of `git add -f`'ing the files that I want tracked here. Using a subfolder and moving config into it and symlinking that back out to home wouldn't reduce the amount of clutter in `$HOME`, and it doesn't prevent changes from affecting change to the config files in the subfolder, so there's essentially limited to no benefit to using a subfolder and symlinking into `$HOME` (as well as intentionality of adding files to track just transitions from `-f`'ing the `add` to `mv`'ing the file and symlinking it, so there's no less overhead either), especially when I would like to use this across multiple environments that will behave differently with symlinks, including the shadow-realm of being in the context of `wsl` when open on a Windows home folder with this checked out!

This is not a unique pattern, but it's not the most common either. On the [gh dotfile io tutorial](https://dotfiles.github.io/tutorials/) page, [Drew](https://drewdevault.com/)'s [blog post](https://drewdevault.com/2019/12/30/dotfiles.html) appears to be the only example that suggests / outlines this approach, and it's worth a read.
## Adopt these configurations
* If `~` is empty:
```sh
cd ~ && git clone https://github.com/Skenvy/dotfiles.git .
```
* If `~` is _NOT_ empty:
```sh
cd ~ && git init && git remote add origin https://github.com/Skenvy/dotfiles.git && git fetch && cp -r .git/refs/remotes/origin/* .git/refs/heads/ && git remote set-head origin -a && REMOTE_HEAD=$(git name-rev origin/HEAD --name-only) && rm .git/refs/heads/* && git checkout -b $REMOTE_HEAD origin/$REMOTE_HEAD -f
```
* If `~` is _NOT_ empty, and you want to use _only_ `git`:
```sh
cd ~ && git init && git remote add origin https://github.com/Skenvy/dotfiles.git && git fetch && git remote set-head origin -a && HEADSHA=$(git rev-parse origin/HEAD) && git remote set-head origin -d && REMOTE_HEAD=$(git name-rev $HEADSHA --name-only) && git checkout -b main $REMOTE_HEAD -f
```
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
1. Now you can track this as a submodule `git submodule add git@github.com:Skenvy/dotfiles.git`
1. The submodule and `.gitmodules` are staged, so `git restore .gitignore` and commit.
1. `git submodule init && git submodule update`

Now with a `.gitmodules` file that places **this repository** in the `dotfiles` folder in the repo that has added this;
```ini
[submodule "dotfiles"]
        path = dotfiles
        url = git@github.com:Skenvy/dotfiles.git
```
With the submodule initialised and updated we can now symlink its contents into `$HOME`.
> [!CAUTION]
> This will **force** symlinks (`ln -sf`) to write over files that match the names of files in this repository
> ```bash
> find ~/dotfiles -type f ! -name '.git' ! -name '.gitignore' ! -name '.gitmodules' \
> -exec bash -c 'dotpath=$(echo "${0:$(($(pwd | wc -c)+$(echo "dotfiles" | wc -c)))}") \
> && mkdir -p $(dirname $dotpath) && ln -sf ~/dotfiles/$dotpath ~/$dotpath' '{}' \;
> ```

> [!WARNING]
> If you want to maintain a `README.md` that will display on the github page of the repository that submodules this, because this process will clobber the including repository's root `README.md` with a symlink to **this** repository's `README.md`, you can get around this by placing your `README.md` you want displayed at `.github/README.md`, which is the first path for a `README.md` file that github will look for (even before a root `README.md`).

## License
> [!NOTE]
> <p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/Skenvy/dotfiles">dotfiles</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/Skenvy">Nathan Levett</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC-BY-SA-4.0 <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>
