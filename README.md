# dotfiles

## Screenshots
Hope you like it!
![image](https://user-images.githubusercontent.com/41871589/169685831-d8bcdd11-70df-4d9e-b0f0-08d54d6f1861.png)
![image](https://user-images.githubusercontent.com/41871589/169686036-f47d412c-4511-4a95-a26a-26eaecb43ec0.png)

## My setup

I'm currently running:
- WM: [XMonad](https://xmonad.org/)
- Bar: [polybar](https://github.com/polybar/polybar)
- Notifications: [dunst](https://github.com/dunst-project/dunst)
- IDE: nvim with [NvChad](https://nvchad.github.io/) and [CoC](https://github.com/neoclide/coc.nvim) or VS Code

## Structure
I keep my dotfiles in a separate directory (mine's `~/dotfiles`, but it can be anything really). 
Then, I (soft) symlink everything to where it belongs. Every file/folder in `config` is symlinked in `~/.config`, and every file in `home` is symlinked in `~/`.
There also are some misc folders for stuff I didn't knew where to put.

## Anything's not working?
Using my setup (or parts of it) and something's broken? Feel free to open an issue, I'll gladly deal with it if relevant!
