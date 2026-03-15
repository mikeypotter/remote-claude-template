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

## Setup

There are two ways to use this template.

### Option A: Clone into a subdirectory (simple)

Good if you just want agents in a self-contained folder.

```bash
git clone https://github.com/mikeypotter/remote-claude-template ~/agents
cd ~/agents

# Rename the template agent to something meaningful
mv agents/your-agent-name agents/assistant

# Fill in the agent's personality
edit agents/assistant/CLAUDE.md

# Run all agents
./agents/run-agents.sh
```

### Option B: Use as a home directory template (recommended for remote machines)

This sets up your home directory as a git repo that tracks this template as an upstream — so you get template updates while keeping your own agents and customizations in a separate repo.

```bash
cd ~
git init
git remote add upstream https://github.com/mikeypotter/remote-claude-template
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO
git fetch upstream
git checkout -b main upstream/main
git push -u origin main
```

Your agents, skills, and any files you add or modify are committed to `origin`. When the template is updated, pull changes with:

```bash
git fetch upstream && git merge upstream/main
```

The `.gitignore` is pre-configured to exclude secrets, SSH keys, credentials, and Claude session data — only your agent config, memory, and skills are tracked.

## Running agents

```bash
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

All agent config, memory, and skills are tracked. Credentials and session data are gitignored.

Commit and push after any change — the git history is your audit trail and recovery mechanism.
