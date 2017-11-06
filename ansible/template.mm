#!/bin/bash
starttmux() {
     if [ -z "$HOSTS" ]; then
        echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
        read HOSTS
     fi

     local hosts=( $HOSTS )
     local target="ssh-multi ${host[0]}"


     tmux new-window -n "${target}" ssh ${hosts[0]}
     unset hosts[0];
     for i in "${hosts[@]}"; do
         tmux split-window -t :"${target}" -h  "ssh $i"
         tmux select-layout -t :"${target}" tiled > /dev/null
     done
     tmux select-pane -t 0
     tmux set-window-option -t :"${target}"  synchronize-panes on > /dev/null

 }

 HOSTS=${HOSTS:=$*}

 starttmux

