tssh() {
  tmux set-option prefix None \; set-option key-table off \; set-option status-style "bg=red" \; refresh-client -S
  ssh -t "$@" zsh -lic "tmux attach || tmux new-session"
}
