#!/bin/bash
# Re-handshake displays after a KVM switch by cycling DPMS off→on.
#
# Symptom this fixes: switching a KVM (or a shared monitor's input) away from
# this Hyprland machine and back leaves the screens black, even though Hyprland
# still reports the monitors active (dpmsStatus: 1). Hyprland emits no monitor
# event on an input switch, so nothing re-trains the HDMI/DisplayPort link. A
# real dpms off→on forces a modeset that re-trains the link — the same cycle
# that wakes the screens from the idle/lock path; this just triggers it on demand.
#
# Called by:
#   • the SUPER+B keybind in keybindings.lua   (manual — always works)
#   • kvm-watch-drm.sh via kvm-recover.service (automatic — when the kernel
#                                                emits a DRM hotplug event)
#
# Escalation: if DPMS cycling alone does not recover a particular monitor, a VT
# switch (chvt) is the deeper refresh — see docs/Endeavour_OS_Hyprland.md
# §KVM / Monitor Recovery. Kept out of the default path so recovery stays
# privilege-free.

set -u

# Seconds to hold DPMS off before re-enabling. Long enough that the "on" is a
# real transition (not a no-op), short enough to keep the black flash brief.
OFF_HOLD="${KVM_RECOVER_OFF_HOLD:-1}"

hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' >/dev/null 2>&1
sleep "$OFF_HOLD"
hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'  >/dev/null 2>&1
