#!/bin/bash

# Usage: run-agents.sh [agent-name|all] [--provider claude|gemini|codex]
# No argument or "all" runs all agents (killing any existing sessions first). Otherwise runs the named agent.
# Default provider is claude.

PROVIDER="claude"
AGENT_ARG=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --provider)
            PROVIDER="$2"
            shift 2
            ;;
        *)
            AGENT_ARG="$1"
            shift
            ;;
    esac
done

get_start_cmd() {
    local dir="$1"
    case "$PROVIDER" in
        claude)
            echo "cd \"$dir\" && claude --dangerously-skip-permissions --continue --remote-control"
            ;;
        gemini)
            echo "cd \"$dir\" && gemini"
            ;;
        codex)
            echo "cd \"$dir\" && codex"
            ;;
        *)
            echo "Unknown provider: $PROVIDER. Supported: claude, gemini, codex" >&2
            exit 1
            ;;
    esac
}

get_fallback_cmd() {
    local dir="$1"
    case "$PROVIDER" in
        claude)
            echo "cd \"$dir\" && claude --dangerously-skip-permissions --remote-control"
            ;;
        *)
            echo ""
            ;;
    esac
}

start_agent() {
    local dir="$1"
    local name=$(basename "$dir")
    local display_name="$(tr '[:lower:]' '[:upper:]' <<< "${name:0:1}")${name:1}"
    tmux kill-session -t "$name" 2>/dev/null || true
    tmux new-session -d -s "$name"
    tmux send-keys -t "$name" "$(get_start_cmd "$dir")" Enter
    sleep 3
    # If no prior conversation exists, --continue exits immediately — fall back to fresh start (claude only)
    local fallback
    fallback="$(get_fallback_cmd "$dir")"
    if [ -n "$fallback" ] && tmux capture-pane -t "$name" -p | grep -q "No conversation found"; then
        tmux send-keys -t "$name" "$fallback" Enter
        sleep 5
    fi
    # /rename is a Claude Code slash command — skip for other providers
    if [ "$PROVIDER" = "claude" ]; then
        tmux send-keys -t "$name" "/rename $display_name" Enter
    fi
    echo "Started $display_name (provider: $PROVIDER)"
}

if [ -z "$AGENT_ARG" ] || [ "$AGENT_ARG" = "all" ]; then
    [ -z "$AGENT_ARG" ] && sleep 10
    for dir in ~/agents/*/; do
        [ "$(basename "$dir")" = "Your-agent-name" ] && continue
        start_agent "$dir"
    done
else
    dir="$HOME/agents/$AGENT_ARG/"
    if [ -d "$dir" ]; then
        start_agent "$dir"
    else
        echo "Agent '$AGENT_ARG' not found. Available agents:"
        ls -1 ~/agents/ | grep -v -E '\.(sh|md|json)$'
        exit 1
    fi
fi
