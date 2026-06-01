# dotfiles-devcontainers

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/), built to bootstrap a
ready-to-use shell environment inside devcontainers and on fresh Linux servers.

A single `setup` run installs the toolchain (via [mise](https://mise.jdx.dev/)),
writes the shell config, and switches the login shell to zsh.

## Quick start

On a new machine:

```sh
git clone git@github.com:diraulo/dotfiles-devcontainers.git
cd dotfiles-devcontainers
./setup
exec zsh -l   # start a zsh login shell so the new config loads immediately
```

`setup` is idempotent — it only installs what's missing, so it's safe to re-run.

> **Why `exec zsh -l`?** `setup` changes your *default* shell with `chsh`, but that
> only takes effect on your next login. `exec zsh -l` replaces the current shell now
> so you don't have to log out and back in.

## What `setup` does

1. **Installs zsh** if it isn't already present (auto-detects `apt-get`, `dnf`,
   `pacman`, `zypper`, or `apk`). Devcontainers usually ship with zsh; bare servers
   often don't.
2. **Sets zsh as the default login shell** via `sudo chsh`.
3. **Installs chezmoi and applies the dotfiles** with
   `chezmoi init --apply git@github.com:diraulo/dotfiles-devcontainers.git`.
   This single command clones this repo into `~/.local/share/chezmoi` and applies it.

Applying the dotfiles runs the chezmoi scripts below, so installing the CLI tools
is part of `init --apply` — there is no separate "install tools" step.

## What gets installed & configured

- **Toolchain (via mise)** — declared in
  [`dot_config/mise/config.toml`](dot_config/mise/config.toml):
  `bat`, `chezmoi`, `direnv`, `fd`, `fzf`, `lsd`, `neovim`, `node`, `ripgrep`,
  `starship`, `usage`.
- **Shell** — [`dot_zshrc`](dot_zshrc) loads `~/.zsh/functions/*`, sources the
  modular configs under `~/.zsh/configs/{pre,,post}`, loads `~/.aliases`, and
  initializes starship and direnv.
- **Neovim** — [LazyVim starter](https://github.com/LazyVim/starter) is fetched into
  `~/.config/nvim` (see [`.chezmoiexternals/neovim.toml`](.chezmoiexternals/neovim.toml)).
- **Git** — `private_dot_gitconfig`.

### How tools end up on `PATH`

mise is installed as `~/.local/bin/mise` (see
[`.chezmoiexternals/mise.toml`](.chezmoiexternals/mise.toml)).
[`dot_zsh/configs/post/path.zsh`](dot_zsh/configs/post/path.zsh) adds `~/.local/bin`
to `PATH` and runs `mise activate zsh`, which puts the mise-managed tools (`fd`,
`bat`, `starship`, `nvim`, ...) on `PATH`. The activation is keyed off the
`~/.local/bin/mise` binary existing rather than `mise` already being on `PATH` —
otherwise it would never activate on a fresh host. If a tool still isn't found,
run `~/.local/bin/mise reshim` and start a fresh shell with `exec zsh -l`.

## Repository layout (chezmoi conventions)

| Path | Becomes / does |
| --- | --- |
| `dot_zshrc` | `~/.zshrc` |
| `dot_aliases` | `~/.aliases` |
| `dot_zsh/` | `~/.zsh/` (functions + modular configs) |
| `dot_config/` | `~/.config/` (incl. `mise/config.toml`) |
| `private_dot_gitconfig` | `~/.gitconfig` (private perms) |
| `.chezmoiexternals/` | external archives/binaries (mise, neovim starter) |
| `.chezmoiscripts/` | run scripts (e.g. `mise install` after changes) |
| `.chezmoiignore` | paths chezmoi should not apply to `$HOME` (`setup`, `README.md`) |
| `setup` | bootstrap script (not applied to `$HOME`) |

## Day-to-day with chezmoi

```sh
chezmoi status     # what would change / is out of sync
chezmoi diff       # preview pending changes
chezmoi apply      # apply changes from the source repo
chezmoi update     # git pull the source repo, then apply
chezmoi edit ~/.zshrc   # edit the source file behind a target
```

## Troubleshooting

- **`zsh: command not found` after `setup`** — your distro had no zsh and an
  unsupported package manager; install zsh manually, then re-run `./setup`.
- **`chsh` says zsh isn't a valid shell** — add it to `/etc/shells`:
  `echo "$(command -v zsh)" | sudo tee -a /etc/shells`, then re-run `chsh`.
- **`chezmoi update` fails to pull** — the source remote uses the SSH URL
  `git@github.com:...`, which needs your GitHub SSH key loaded. On unattended
  servers, switch it to HTTPS:
  `chezmoi git remote set-url origin https://github.com/diraulo/dotfiles-devcontainers.git`.
- **CLI tools missing on `PATH`** — `mise reshim`, then `exec zsh -l`.
