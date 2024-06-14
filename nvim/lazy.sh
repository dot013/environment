#!/usr/bin/env nix
#! nix shell nixpkgs#neovim --command bash

# This is used so lazy-lock.json can be updated when I need to install a new
# plugin. Since the resulting config inside the nix derivation is read-only.

SCRIPT_DIR=$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
XDG_CONFIG_HOME=$(dirname "$SCRIPT_DIR")
nvim .
