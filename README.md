# dotfiles

## Screenshots (outdated, will update)

Hope you like it!
<img width="1280" alt="image" src="https://github.com/AlessandroZanatta/dotfiles/assets/41871589/156154f6-1079-4c62-ba81-be1fbbf96cf4">


On a bigger monitor:
![image](https://user-images.githubusercontent.com/41871589/170653467-2bda581b-1fd4-46e3-b530-a310e7b16ed4.png)

## My setup

I'm currently running:

- WM: [XMonad](https://xmonad.org/)
- Bar: [polybar](https://github.com/polybar/polybar) inspired on [siduck's one](https://github.com/siduck/dotfiles)
- Notifications: [dunst](https://github.com/dunst-project/dunst)
- IDE: NeoVim with [NvChad](https://nvchad.github.io/) by siduck with NeoVim native LSP support
- Dashboard: modified version of the one created by [siduck](https://github.com/siduck/chadwm)

## Structure

I keep my dotfiles in a separate directory (mine's `~/dotfiles`, but it can be anything really).
Then, I (soft) symlink everything to where it belongs. Every file/folder in `config` is symlinked in `~/.config`, and every file in `home` is symlinked in `~/`.
There also are some misc folders for stuff I didn't know where to put.

## Anything's not working?

Using my setup (or parts of it) and something's broken? Feel free to open an issue, I'll gladly deal with it if relevant!
