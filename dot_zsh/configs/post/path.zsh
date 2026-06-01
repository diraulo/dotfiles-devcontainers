# ensure dotfiles bin directory is loaded first
# (~/.local/bin is where mise installs itself; it may not be on PATH yet)
PATH="$HOME/.bin:$HOME/.local/bin:/usr/local/sbin:$PATH"

# Load and activate mise if installed. Check the install location directly
# rather than `command -v mise`: on a fresh host mise isn't on PATH yet, so a
# `command -v mise` guard would skip activation and leave every mise-managed
# tool (fd, bat, starship, nvim, ...) unavailable.
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
elif command -v mise > /dev/null ; then
  eval "$(mise activate zsh)"
fi

# mkdir .git/safe in the root of repositories you trust
PATH=".git/safe/../../bin:$PATH"

export -U PATH
