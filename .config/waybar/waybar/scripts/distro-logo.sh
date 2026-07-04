#!/bin/sh
# Emit a Nerd Font distro-logo glyph for the waybar logo module.
# Reads /etc/os-release. The whole Arch family (ID=arch OR ID_LIKE=arch,
# i.e. EndeavourOS, Artix, Manjaro, ...) maps to the Arch triangle so the
# config is portable across machines. Fallback -> Tux.
# Glyphs are from the NotoSansM Nerd Font family (set in style.css).

[ -r /etc/os-release ] && . /etc/os-release

case "${ID:-}" in
    arch)       g='\ue732' ;;  # dev-archlinux  (the Arch triangle)
    fedora)     g='\ue7d9' ;;  # dev-fedora
    debian)     g='\ue77d' ;;  # dev-debian
    ubuntu)     g='\ue73a' ;;  # dev-ubuntu
    gentoo)     g='\ue7e6' ;;  # dev-gentoo
    nixos)      g='\ue843' ;;  # dev-nixos
    opensuse)   g='\ue857' ;;  # dev-opensuse
    *)
        case "${ID_LIKE:-}" in
            arch)    g='\ue732' ;;  # Arch family (EndeavourOS, Artix, ...) -> Arch
            debian)  g='\ue77d' ;;
            fedora)  g='\ue7d9' ;;
            *)       g='\uf31a' ;;  # linux-tux (generic fallback)
        esac ;;
esac

printf '%b' "$g"
