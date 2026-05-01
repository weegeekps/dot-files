#!/usr/bin/zsh

_print_dotfiles_help() {
    cat << HEREDOC
** rsync_dotfiles Function Help **

rsync_dotfiles is the entrypoint to synchronize configs from the
dot-files directory to the home directory.

If you are looking for something new yourself, there are better
options for you. Look elsewhere.

rsync_options(<direction>, <config_opt>)

Possible <direction>:
 - g, get = Copies from dot-files to home.
 - p, put = Copies from home to dot-files.

Possible <config_opt>:
 - term = Terminal related configs; alacritty, oh-my-zsh, tmux, etc.
 - i3   = i3wm and required xfce configs
 - vim  = Classic Vim related configs
 - nvim = Neovim related configs

You can only pass a single config_opt to prevent you from being a
dumbass who screws up and overwrites stuff you don't want to.

Don't forget to do a gitdiff and then git commit and push.
HEREDOC
}

_put_term() {
    # TODO
}

_get_term() {
    # TODO
}

_put_i3() {
    # TODO
}

_get_i3() {
    # TODO
}

_put_vim() {
    # TODO
}

_get_vim() {
    # TODO
}

_put_nvim() {
    local src="$HOME/.config/nvim/"
    local dst="$HOME/dot-files/.config/nvim/"

    prompt_rsync $src $dst
}

_get_nvim() {
    local src="$HOME/dot-files/.config/nvim/"
    local dst="$HOME/.config/nvim/"

    prompt_rsync $src $dst
}

rsync_dotfiles() {
    # Check we have arguments.
    if (( $# < 2 )); then
        print "Not enough arguments." >&2
        _print_dotfiles_help()
        exit 1
    fi

    local valid_dirs=(g get p put)
    local valid_opts=(term i3 vim nvim)

    local direction=$1
    local config_opt=$2

    # Check our direction is valid
    if ! [[ ${valid_dirs[(ie)$direction]} -le ${#valid_dirs} ]]; then
        print "Invalid direction." >&2
        _print_dotfiles_help()
        exit 1
    fi

    # Check our config_opt is valid
    if ! [[ ${valid_opts[(ie)$config_opt]} -le ${#valid_opts} ]]; then
        print "Invalid option." >&2
        _print_dotfiles_help()
        exit 1
    fi

    if [[ "$config_opt" == "nvim" ]]; then
        if [[ "$direction" == "g" || "$direction" == "get" ]]; then
            _get_nvim
        elif [[ "$direction" == "p" || "$direction" == "put" ]]; then
            _put_nvim
        fi
    fi
}
