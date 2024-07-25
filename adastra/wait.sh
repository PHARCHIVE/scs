#!/bin/bash
# watch queue to stay connected via ssh
shopt -s expand_aliases
alias cls="clear; printf '\033[3J'"
while true; do
  cls && squeue -u "$USER" && sleep 100
done
