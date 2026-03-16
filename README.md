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

This template turns your home directory into a git repo that tracks the template as an upstream remote. Your agents and customizations live in your own repo, and you can pull template updates without merge conflicts.

```bash
cd ~
git init
git remote add upstream https://github.com/mikeypotter/remote-claude-template
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO
git fetch upstream
git checkout -b main upstream/main
git push -u origin main

# Enable the merge strategy so your customized files are never overwritten
git config merge.ours.driver true

# Rename the example agent
mv agents/example agents/assistant
edit agents/assistant/CLAUDE.md
```

### Pulling template updates

```bash
git fetch upstream && git merge upstream/main
```

The `.gitattributes` file protects your `CLAUDE.md`, `README.md`, `.gitignore`, and `agents/` directory from being overwritten. Infrastructure in `tools/` updates cleanly.

The `.gitignore` excludes secrets, SSH keys, credentials, and Claude session data — only agent config, memory, and skills are tracked.

## Running agents

```bash
# Run all agents
./tools/run-agents.sh

# Or run a single agent
./tools/run-agents.sh assistant

# Attach to an agent's tmux session
tmux attach-session -t assistant
```

## Adding agents

Copy `agents/example/` to a new directory, fill in `CLAUDE.md`, add skills. Then re-run `tools/run-agents.sh`.

## Utilities

| Script | Purpose |
|--------|---------|
| `tools/update-skills.sh` | Updates all skill submodules to their latest upstream versions |
| `tools/reset-agent.sh` | Sends `/clear` to one or all agent tmux sessions |
| `tools/run-agents.sh` | Launches agents in tmux sessions (one or all) |

```bash
# Update all skill submodules
./tools/update-skills.sh

# Reset all agents
./tools/reset-agent.sh all

# Reset a single agent
./tools/reset-agent.sh assistant
```

## Adding skills

See `agents/example/skills/README.md` for the skill format and `skills/example-skill/SKILL.md` for a template.

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
