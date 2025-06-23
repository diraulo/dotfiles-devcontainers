export LANG="en_US.UTF-8"

if command -v nvim > /dev/null ; then
  export VISUAL="nvim"
  export EDITOR=$VISUAL
fi
