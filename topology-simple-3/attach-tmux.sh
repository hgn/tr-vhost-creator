#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux -f "$DIR/tmux.conf"  new-session -s lxc -n "control"  -d 

tmux new-window -t lxc:2 -n 01r01 'sudo lxc-console -n 01r01'
tmux new-window -t lxc:3 -n 01t01 'sudo lxc-console -n 01t01'
tmux new-window -t lxc:4 -n 02r01 'sudo lxc-console -n 02r01'
tmux new-window -t lxc:5 -n 02t01 'sudo lxc-console -n 02t01'

# Select window #1 and attach to the session
tmux select-window -t lxc:2
tmux -f tmux.conf -2 attach-session -t lxc
