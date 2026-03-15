# your-agent-name

Rename this directory to something meaningful (e.g., `assistant`, `coach`, `researcher`).

## Files

### `CLAUDE.md`
The agent's personality, rules, and context. This is what Claude reads to understand its role. Fill in:
- Who it is and what it does
- The user's name, role, and relevant context
- Tone and communication style
- Any tools or integrations it should use
- Which skills are available

### `MEMORY.md`
Persists context across sessions. The agent reads this at the start of each session and updates it at the end. You don't edit this manually — the agent maintains it. It should stay concise (a few hundred words at most).

### `skills/`
Each subdirectory is a skill — a specific capability the agent can run on demand. See `skills/README.md` for how to create them.

## Customizing

1. Rename this directory
2. Edit `CLAUDE.md` with the agent's personality and context
3. Add skills under `skills/`
4. Run `../run-agents.sh your-agent-name`
