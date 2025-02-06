#!/bin/bash

srun --pty --ntasks=1 --cpus-per-task=10 --hint=nomultithread --partition=compil --account=wrb@cpu bash $WORK/build.sh

