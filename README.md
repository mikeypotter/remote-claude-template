# Claude Agents

A framework for running persistent, specialized Claude agents — each with its own personality, memory, and skills — backed up via git.

## How it works

Each agent runs in its own [tmux](https://github.com/tmux/tmux) session and has three components:

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Personality, tone, rules, and context for this agent |
| `MEMORY.md` | Persists context across sessions — updated by the agent at end of each session |
| `skills/` | Capabilities — each skill is a subdirectory with a `SKILL.md` the agent reads and follows |

## Prerequisites

- [tmux](https://github.com/tmux/tmux)
- [Claude CLI](https://docs.anthropic.com/en/docs/claude-code)
- Git

## Quickstart

```bash
# Clone the repo
git clone <your-repo-url> ~/agents-repo
cd ~/agents-repo

# Rename the template agent to something meaningful
mv agents/your-agent-name agents/assistant   # or whatever fits

# Fill in the agent's personality
edit agents/assistant/CLAUDE.md

# Add skills under agents/assistant/skills/

# Run all agents
./agents/run-agents.sh

# Or run a single agent
./agents/run-agents.sh assistant

# Attach to an agent's tmux session
tmux attach-session -t assistant
```

## Adding agents

Copy `agents/your-agent-name/` to a new directory, fill in `CLAUDE.md`, add skills. Then re-run `run-agents.sh`.

## Adding skills

See `agents/your-agent-name/skills/README.md` for the skill format and `skills/example-skill/SKILL.md` for a template.

## Memory

Agents read `MEMORY.md` at the start of each session and update it at the end. This gives them continuity across restarts without needing persistent sessions. Keep `MEMORY.md` files concise — they summarize context, not raw transcripts.

## Talking to your agents

### From your desktop
The [Claude Code desktop app](https://docs.anthropic.com/en/docs/claude-code) lets you connect to a remote machine running your agents. Once connected, you can chat with any agent directly from the app — no terminal required.

### From your phone
Use the Claude Code iOS or Android app and connect to the same remote session. Since agents run in persistent tmux sessions, they're always available — you can pick up a conversation from your phone that you started on your desktop, or kick off a skill while away from your computer.

### Switching between agents
Each agent is its own tmux session. To switch, just tell Claude Code to connect to a different session, or attach manually:

```bash
tmux attach-session -t assistant
tmux attach-session -t coach
```

## Git backup

This repo is designed to be pushed to GitHub. All agent config, memory, and skills are tracked. Credentials and session data are gitignored.

Commit and push after any change — the git history is your audit trail and recovery mechanism.
