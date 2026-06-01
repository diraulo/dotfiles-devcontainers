# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion; use cache if updated within 24h
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $HOME/.zcompdump;
else
  compinit -C;
fi;

# disable zsh bundled function mtools command mcd
# which causes a conflict.
compdef -d mcd

# fzf and mise live under mise, which isn't on PATH until it's activated.
# post/ configs load alphabetically, so this file runs *before* path.zsh does
# that activation — activate here too (idempotent; mise's activate runs its hook
# immediately, putting the tools on PATH) so the completions below can load.
if ! command -v mise > /dev/null && [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# enable fzf completion if installed
if command -v fzf > /dev/null ; then
  source <(fzf --zsh)
fi

# enable mise completion if installed
if command -v mise > /dev/null ; then
  source <(mise completion zsh)
fi
