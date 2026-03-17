# Remote Agent Template

A framework for running persistent, specialized AI agents — each with its own personality, memory, and skills — backed up via git. Works with Claude, Gemini, Codex, or any AI CLI tool.

## How it works

Each agent runs in its own [tmux](https://github.com/tmux/tmux) session and has three components:

| File | Purpose |
|------|---------|
| `AGENTS.md` | Personality, tone, rules, and context for this agent |
| `MEMORY.md` | Persists context across sessions — updated by the agent at end of each session |
| `skills/` | Capabilities — each skill is a subdirectory with a `SKILL.md` the agent reads and follows |

## Prerequisites

- [tmux](https://github.com/tmux/tmux)
- An AI CLI tool — [Claude Code](https://docs.anthropic.com/en/docs/claude-code), [Gemini CLI](https://github.com/google-gemini/gemini-cli), [Codex CLI](https://github.com/openai/codex), or similar
- Git

## Setup

This template turns your home directory into a git repo that tracks the template as an upstream remote. Your agents and customizations live in your own repo, and you can pull template updates without merge conflicts.

```bash
cd ~
git init
git remote add upstream https://github.com/mikeypotter/remote-agent-template
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO
git fetch upstream
git checkout -b main upstream/main
git push -u origin main

# Enable the merge strategy so your customized files are never overwritten
git config merge.ours.driver true

# Rename the example agent to something meaningful
mv agents/example agents/my-agent
edit agents/my-agent/AGENTS.md
```

### Pulling template updates

```bash
git fetch upstream && git merge upstream/main
```

The `.gitattributes` file protects your `AGENTS.md`, `README.md`, `.gitignore`, and `agents/` directory from being overwritten. Infrastructure in `tools/` updates cleanly.

The `.gitignore` excludes secrets, SSH keys, credentials, and AI session data — only agent config, memory, and skills are tracked.

## Running agents

```bash
# Run all agents (defaults to claude)
./tools/run-agents.sh

# Or run a single agent
./tools/run-agents.sh my-agent

# Use a different provider
./tools/run-agents.sh my-agent --provider gemini
./tools/run-agents.sh my-agent --provider codex

# Attach to an agent's tmux session
tmux attach-session -t my-agent
```

## Adding agents

Copy `agents/example/` to a new directory, fill in `AGENTS.md`, add skills. Then re-run `tools/run-agents.sh`.

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
./tools/reset-agent.sh my-agent
```

## Adding skills

See `agents/example/skills/README.md` for the skill format and `skills/example-skill/SKILL.md` for a template.

## Memory

Agents read `MEMORY.md` at the start of each session and update it at the end. This gives them continuity across restarts without needing persistent sessions. Keep `MEMORY.md` files concise — they summarize context, not raw transcripts.

## Talking to your agents

### From your desktop
Connect to the remote machine running your agents via SSH or a remote development tool. Once connected, you can chat with any agent directly from your terminal or IDE — no extra setup required.

### From your phone
SSH into your remote machine from a mobile terminal app. Since agents run in persistent tmux sessions, they're always available — pick up a conversation from your phone that you started on your desktop, or kick off a task while away from your computer.

### Switching between agents
Each agent is its own tmux session. To switch, attach to a different session:

```bash
tmux attach-session -t my-agent
```

## Git backup

All agent config, memory, and skills are tracked. Credentials and session data are gitignored.

Commit and push after any change — the git history is your audit trail and recovery mechanism.
