#!/bin/zsh
cd $(tmux run "echo #{pane_current_path}")
url=$(git remote get-url origin 2>/dev/null)
open $url 2>/dev/null || echo "No remote found"