#!/usr/bin/env bash
set -ex


shellcheck -x **/*.sh
shfmt -d -i 2  **/*.sh # fix w/ `shfmt -w -i 2  **/*.sh`
