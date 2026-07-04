#!/bin/bash
# Edge-aware window move.
# Tries a hy3 directional move within the workspace; if the window is already
# at the workspace edge in that direction, falls back to moving it to the
# adjacent monitor (located dynamically from current monitor geometry, so it
# survives re-cabling or monitor reordering).
# Usage: move-window.sh <l|r|u|d>

dir="$1"

# Snapshot focused window position + workspace before the move.
snapshot() {
    hyprctl activewindow -j 2>/dev/null | python3 -c "
import sys, json
try:
    w = json.load(sys.stdin)
    print(w['workspace']['id'], w['at'][0], w['at'][1])
except:
    print('none')
"
}

before=$(snapshot)

# No focused window — nothing to do.
[ "$before" = "none" ] && exit 0

# Attempt the within-workspace directional move. Uses hyprctl eval with the
# typed hy3 Lua API — under the Lua config, `hyprctl dispatch` routes through
# the Lua evaluator and breaks plugin dispatchers containing colons (hy3:*).
hyprctl eval "hl.dispatch(hl.plugin.hy3.move_window(\"$dir\"))" >/dev/null 2>&1

# Give the compositor a moment to settle.
sleep 0.05

after=$(snapshot)

# Window moved within workspace → done.
[ "$before" != "$after" ] && exit 0

# Window didn't move → at edge → move to adjacent monitor in the direction.
monitors=$(hyprctl monitors -j 2>/dev/null)

python3 - "$dir" "$monitors" <<'PYEOF'
import sys, json, subprocess

dir = sys.argv[1]
monitors = json.loads(sys.argv[2])

focused = next((m for m in monitors if m.get('focused')), None)
if not focused:
    sys.exit(1)

fx, fy = focused['x'], focused['y']
target = None

if dir == 'l':
    cands = [m for m in monitors if m['x'] < fx]
    if cands: target = max(cands, key=lambda m: m['x'])
elif dir == 'r':
    cands = [m for m in monitors if m['x'] > fx]
    if cands: target = min(cands, key=lambda m: m['x'])
elif dir == 'u':
    cands = [m for m in monitors if m['y'] < fy]
    if cands: target = max(cands, key=lambda m: m['y'])
elif dir == 'd':
    cands = [m for m in monitors if m['y'] > fy]
    if cands: target = min(cands, key=lambda m: m['y'])

if target:
    mon_name = target['name']
    subprocess.run(
        ['hyprctl', 'dispatch', f'hl.dsp.window.move({{monitor = "{mon_name}", follow = false}})'],
        capture_output=True
    )
PYEOF
