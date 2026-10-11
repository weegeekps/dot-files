# ---
# ripgrep | less
#
# This plugin makes using less on pretty printed ripgrep output easier.
# ---

# Guard so we don't load multipel versions
if [[ -n "$ZSH_PLUGIN_RGLESS" ]]; then
    return
fi
export ZSH_PLUGIN_RGLESS="1"

function ripgrep_pipe_less() {
    rg --pretty "$@" | less
}

alias rgless="ripgrep_pipe_less"
