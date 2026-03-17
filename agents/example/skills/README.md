# Skills

Each skill is a subdirectory with a `SKILL.md` file. The agent reads that file and follows its instructions when asked to run the skill.

## Invoking a skill

Ask the agent to run it by name:
> "Run my daily brief"
> "Generate the weekly report"
> "Do the stakeholder check-in"

The agent will find the corresponding `SKILL.md` and execute the steps.

## Creating a skill

1. Create a new subdirectory: `skills/your-skill-name/`
2. Add a `SKILL.md` following the format in `example-skill/SKILL.md`
3. Mention the skill in the agent's `AGENTS.md` so it knows it exists

## Skill format

```markdown
# Skill Name

Brief description of what this skill does and when to use it.

## Steps

1. First step — what to do and how
2. Second step
3. ...

## Output

What the skill produces (email, report, task list, etc.)
```

Skills can use any tools the agent has access to — shell commands, file reads, API calls via CLI tools, etc. Write them as step-by-step instructions the agent follows literally.
