#!/bin/zsh
cd $(tmux run "echo #{pane_current_path}")
url=$(git remote get-url origin)
open $url || echo "No remote found"
