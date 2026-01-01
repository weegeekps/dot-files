# dot-files

Repository for all of my dot files.

These are pretty exclusively used on Arch/EndeavourOS but most are compatible with Fedora, RHEL, and even macOS.

I prefer EndeavourOS over basic Arch these days due to:

 - Calamares makes installation fast.
 - Inclusion of `yay`, `inxi`, etc. upfront.
 - Easy post-install configuration scripts.
 - `dracut` by default.
 - MDNS with Avahi is preconfigured.
 - Cleanup scripts.

Basically, if you're a long-time Arch user, EndeavourOS has sensible defaults that a large majority of the community already rely on.

## EndeavourOS i3 Checklist

My i3 environment in EndeavourOS uses the xfce4 bar instead of another bar. Assuming you are on a fresh EndeavourOS install of i3, these commands install requirements. Pure Arch installs may require additional packages and configuration.

From `pacman`:

```zsh
pacman -Sy alacritty blueman dex dunst fcitx5-im feh nerd-fonts networkmanager network-manager-applet libpulse picom polkit polkit-gnome rofi thunar tmux ttf-fira-code unicode-emoji xfce4 xfce4-pulseaudio-plugin xfce4-screenshooter xss-lock
```

From AUR:

```zsh
yay -Sy betterlockscreen gtk-engine-murrine pamac-aur qogir-gtk-theme rofi-power-menu
```

Configure:

 - Blueman: https://wiki.archlinux.org/title/Blueman
 - Fcitx5: https://wiki.archlinux.org/title/Fcitx5
 - NetworkManager: https://wiki.archlinux.org/title/NetworkManager
   - Don't forget to configure firewall!
 - Polkit: https://wiki.archlinux.org/title/Polkit
 - Betterlockscreen: https://github.com/betterlockscreen/betterlockscreen

Add to `.xprofile`:

```sh
# fcitx5 configuration
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx

# Pass XDG_CURRENT_DESKTOP to systemd for user units
systemctl --user import-environment XDG_CURRENT_DESKTOP
```

This would also be a good time to install and configure [satpaper](https://github.com/Colonial-Dev/satpaper) and Jetbrains Toolbox.

For satpaper, you need to copy over the systemd user unit and `scripts/update_wallpaper.sh`.

Do all of this **before** you copy over `.config/i3/config` and `.config/xfce4/xfconf/xfce-perchannel-xml/*` from `dot-files`. These should be the last things you copy.

