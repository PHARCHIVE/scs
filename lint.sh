#!/usr/bin/env bash
set -ex

shellcheck -x **/*.sh
shfmt -w -i 2  **/*.sh
