# dotfiles

## Screenshots

Hope you like it!
![image](https://user-images.githubusercontent.com/41871589/170653122-48f35b49-e4df-4f11-80cf-b74526cace83.png)
![image](https://user-images.githubusercontent.com/41871589/170653379-ad51b72b-ffce-47da-81a1-ca14606c500a.png)

On a bigger monitor:
![image](https://user-images.githubusercontent.com/41871589/170653467-2bda581b-1fd4-46e3-b530-a310e7b16ed4.png)

## My setup

I'm currently running:

- WM: [XMonad](https://xmonad.org/)
- Bar: [polybar](https://github.com/polybar/polybar) inspired on [siduck's one](https://github.com/siduck/dotfiles)
- Notifications: [dunst](https://github.com/dunst-project/dunst)
- IDE: NeoVim with [NvChad](https://nvchad.github.io/) by siduck with NeoVim native LSP support
- Dashboard: eww with a fixed and modified version of the one created by [Axarva](https://github.com/Axarva/dotfiles-2.0)

## Structure

I keep my dotfiles in a separate directory (mine's `~/dotfiles`, but it can be anything really).
Then, I (soft) symlink everything to where it belongs. Every file/folder in `config` is symlinked in `~/.config`, and every file in `home` is symlinked in `~/`.
There also are some misc folders for stuff I didn't know where to put.

## Anything's not working?

Using my setup (or parts of it) and something's broken? Feel free to open an issue, I'll gladly deal with it if relevant!
