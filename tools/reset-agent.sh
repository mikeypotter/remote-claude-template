#!/bin/bash

# Usage: reset-agent.sh [agent-name|all]
# Sends /clear to one or all agent tmux sessions.

if [ -z "$1" ] || [ "$1" = "all" ]; then
    for session in $(tmux list-sessions -F '#{session_name}' 2>/dev/null); do
        tmux send-keys -t "$session" "/clear" Enter
        echo "Reset $session"
    done
else
    tmux send-keys -t "$1" "/clear" Enter
    echo "Reset $1"
fi
