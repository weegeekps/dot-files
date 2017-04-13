# https://github.com/blinks zsh theme

function _prompt_char() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo "%{%F{blue}%}±%{%f%b%}"
  else
    echo ' '
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=" [%{%B%F{blue}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%b%B%F{green}%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}*%{%f%b%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%{%f%b%}
%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%}%~%{%B%F{green}%}$(git_prompt_info)%E%{%f%b%}
$(_prompt_char) %#%{%f%b%} '

RPROMPT='!%{%B%F{cyan}%}%!%{%f%b%}'
