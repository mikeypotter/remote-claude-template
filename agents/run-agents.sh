#!/bin/bash

# Usage: run-agents.sh [agent-name|all]
# No argument or "all" runs all agents (killing any existing sessions first). Otherwise runs the named agent.

start_agent() {
    local dir="$1"
    local name=$(basename "$dir")
    local display_name="$(tr '[:lower:]' '[:upper:]' <<< "${name:0:1}")${name:1}"
    tmux kill-session -t "$name" 2>/dev/null
    tmux new-session -d -s "$name"
    tmux send-keys -t "$name" "cd \"$dir\" && claude --dangerously-skip-permissions --continue --remote-control" Enter
    sleep 3
    # If no prior conversation exists, --continue exits immediately — fall back to fresh start
    if tmux capture-pane -t "$name" -p | grep -q "No conversation found"; then
        tmux send-keys -t "$name" "claude --dangerously-skip-permissions --remote-control" Enter
        sleep 5
    fi
    tmux send-keys -t "$name" "/rename $display_name" Enter
    echo "Started $display_name"
}

if [ -z "$1" ] || [ "$1" = "all" ]; then
    [ -z "$1" ] && sleep 10
    for dir in ~/agents/*/; do
        start_agent "$dir"
    done
else
    dir="$HOME/agents/$1/"
    if [ -d "$dir" ]; then
        start_agent "$dir"
    else
        echo "Agent '$1' not found. Available agents:"
        ls -1 ~/agents/ | grep -v -E '\.(sh|md|json)$'
        exit 1
    fi
fi
