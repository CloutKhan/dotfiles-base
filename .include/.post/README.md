# **Post** - source / include / hooks
Config files that can be sourced, included, or called as hooks, _**at the end of**_ a config file living in `$HOME`, so that the bulk of the configuration can be checked in, but also provide a way of utilising config that is possibly sensitive or machine|OS-dependent, _or_ not great to have crawlable.
## `.gitconfig`
### Non-OS dependent
```ini
[user]
    email = <???>
    name = <???>
    signingkey = <???>

[commit]
    gpgsign = true
    signingkey = <???>
```
