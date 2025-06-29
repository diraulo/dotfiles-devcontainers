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

# enable fzf completion if installed
if command -v fzf > /dev/null ; then
  source <(fzf --zsh)
fi

# enable mise completion if installed
if command -v mise > /dev/null ; then
  source <(mise completion zsh)
fi
