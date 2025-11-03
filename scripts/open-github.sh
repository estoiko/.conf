#!/bin/bash
cd $(PWD)
url=$(git remote get-url origin)
open $url || echo "No remote found"