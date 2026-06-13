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

### Core Configuration

Create your user temporary folder, `~/tmp`. This is used by vim, neovim, and other configurations.

Now install dependencies.

From `pacman`:

```zsh
pacman -Sy alacritty blueman dex dunst fcitx5-im feh keychain nerd-fonts networkmanager network-manager-applet neovide neovim libpulse picom polkit polkit-gnome rofi seahorse thunar tmux ttf-fira-code unicode-emoji xdg-desktop-portal xdg-desktop-portal-gtk xfce4 xfce4-pulseaudio-plugin xfce4-screenshooter xss-lock
```

From AUR:

```zsh
yay -Sy betterlockscreen gtk-engine-murrine pamac-aur qogir-gtk-theme rofi-power-menu
```

Pull your `dot-files`.

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

The `systemd` target `graphical-session.target` and `i3` [don't get along well](https://github.com/i3/i3/issues/5186). We can create a user target that is manually started by our `.xprofile` after we've imported essential environment variables from X11. This can then be used for `satpaper` and similar user units that need display related environment variables.

Create `~/.config/systemd/user/x11-ready.target`:

```sh
# Start in ~/.xprofile and use for anything that needs to wait on X11 being ready.
#
# This exists because graphical-session.target is a fucking mess where X11 & i3wm are involved.
[Unit]
Description=X11 display is available
```

Add to `.xprofile`:

```sh
# fcitx5 configuration
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx

systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP
systemctl --user start x11-ready.target
```

Optionally, copy over the `neovim` configuration from `dot-files` now.

Reboot before continuing.

### Configure satpaper & betterlockscreen

The wallpaper and lock screen depends on [satpaper](https://github.com/Colonial-Dev/satpaper). There are several scripts that are used to ensure the wallpaper is updated correctly. We also need to set up the user unit for `systemd`.

Copy the [scripts](/scripts) folder over from `dot-files` if you haven't already. This contains the necessary scripts, among others.

The two essential scripts are:

 - [scripts/update_wallpaper.sh](/scripts/update_wallpaper.sh), called by `satpaper` to update the wallpaper & `betterlockscreen` cache.
 - [scripts/betterlockscreen_post.zsh](/scripts/betterlockscreen_post), which is used to update the wallpaper and cache with the latest image after unlocking.

Symlink `betterlockscreen_post.zsh` to `.config/betterlockscreen/custom-post.sh`.

Finally, create the user unit `~/.config/systemd/user/satpaper.service`:

```sh
# Satpaper unit configuration for use with i3wm
#   Place in ~/.config/systemd/user/satpaper.service and enable
#   using `systemctl --user enable satpaper`

[Unit]
Description=Run Satpaper on login.
After=x11-ready.target
PartOf=x11-ready.target

[Service]
Environment=SATPAPER_SATELLITE=goes-east
Environment=SATPAPER_RESOLUTION_X=3840
Environment=SATPAPER_RESOLUTION_Y=2160
Environment=SATPAPER_DISK_SIZE=94
Environment=SATPAPER_TARGET_PATH=%h/tmp/satpaper/
Environment=SATPAPER_WALLPAPER_COMMAND="%h/scripts/update_wallpaper.sh"
PassEnvironment=XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY

# For use with feh directly. Comment out the wallpaper command above and replace with this.
# Environment=SATPAPER_WALLPAPER_COMMAND=feh --bg-scale %h/tmp/satpaper/satpaper_latest.png

ExecStart=%h/.cargo/bin/satpaper
Restart=on-failure
RestartSec=5

[Install]
WantedBy=x11-ready.target
```

### Copy i3 configuration

Copy over `.config/i3/config` and `.config/xfce4/xfconf/xfce-perchannel-xml/*` from `dot-files`.

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
