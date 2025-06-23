# ensure dotfiles bin directory is loaded first
PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# Load and activate mise if installed
if command -v mise > /dev/null ; then
  eval "$($HOME/.local/bin/mise activate zsh)"
fi

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

export -U PATH
