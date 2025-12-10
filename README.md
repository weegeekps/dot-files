# dot-files

Repository for all of my dot files.

These are pretty exclusively used on Arch but several are compatible with Fedora, RHEL, and even macOS.

## i3 Checklist

My i3 environment uses the xfce4 bar instead of another bar. Assuming you are on a fresh EndeavourOS install of i3, these commands install requirements. Pure Arch installs may require additional packages and configuration.

```zsh
pacman -Syy alacritty blueman dunst fcitx5-im feh networkmanager network-manager-applet pactl picom polkit polkit-gnome rofi thunar tmux unicode-emoji xfce4 xfce4-popup-whiskermenu xfce4-screenshooter xss-lock
```

Configure:

 - Blueman: https://wiki.archlinux.org/title/Blueman
 - Fcitx5: https://wiki.archlinux.org/title/Fcitx5
 - NetworkManager: https://wiki.archlinux.org/title/NetworkManager
 - Polkit: https://wiki.archlinux.org/title/Polkit

This would also be a good time to install and configure [satpaper](https://github.com/Colonial-Dev/satpaper), `pamac` from the AUR, and Jetbrains Toolbox.

Run this command **before** you copy over `.config/i3/config` from `dot-files`.

