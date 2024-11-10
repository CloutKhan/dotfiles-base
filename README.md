# [dotfiles](https://github.com/Skenvy/dotfiles)
Proctor your user settings `~/.*` | `$HOME` with
[dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) --
[[topic](https://github.com/topics/dotfiles)]
[[io](https://dotfiles.github.io/)]
[+[codespaces](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles)]
[+[devcontainers](https://containers.dev/)]
[++["awesome"](https://github.com/webpro/awesome-dotfiles)]
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
## License
<p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/Skenvy/dotfiles">dotfiles</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://github.com/Skenvy">Nathan Levett</a> is licensed under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC-SA 4.0 <img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>
