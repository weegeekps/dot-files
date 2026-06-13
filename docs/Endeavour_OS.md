# EndeavourOS

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
pacman -Sy alacritty blueman dex dunst fcitx5-im feh keychain nerd-fonts networkmanager network-manager-applet neovide neovim libpulse picom polkit polkit-gnome rofi seahorse thunar tmux ttf-fira-code unicode-emoji xdg-desktop-portal xdg-desktop-portal-gtk xfce4 xfce4-pulseaudio-plugin xfce4-screenshooter xss-lock
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

Add to `.profile`:

```sh
eval $(keychain --eval --quiet id_ed25519)
```

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

## Monitor Configuration


Chances are that `xrandr` and `lightdm` have the monitors messed up, with either the wrong primary or them in the wrong order. The best approach for handling `xrandr` configuration is to create a script in `/usr/share` that can be used by `lightdm` or `~/.xprofile`.

> [!TIP]
> If this is a laptop or something else where you need more dynamic setup, check out [autorandr](https://github.com/phillipberndt/autorandr).

First, create the script `/usr/share/monitor_setup.sh`. As an example, the one used for my primary desktop:

```sh
#!/bin/sh

PRIMARY_OUTPUT="DisplayPort-0"
SECONDARY_OUTPUT="DisplayPort-3"

xrandr --output $PRIMARY_OUTPUT --mode 3840x2160 --rate 143.96 --primary
xrandr --output $SECONDARY_OUTPUT --mode 2560x1440 --rate 180.00 --left-of $PRIMARY_OUTPUT
```

To get `lightdm` using this script, add a configuration file at the path `/etc/lightdm/lightdm.conf.d/20-display-setup.conf`:

```conf
[Seat:*]
display-setup-script=/usr/share/monitor_setup.sh
```

At this point, it should "just work" regardless of display server, compositor or window manager. If it isn't, source the script in `~/.xprofile` or better yet, figure out why it's broken.
