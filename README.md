# columbia-hpc-skill

An [Agent Skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills) that
helps AI coding agents help users work on **Columbia University's HPC clusters**
(Insomnia, Ginsburg, Terremoto) with the SLURM scheduler — writing and submitting
`sbatch` jobs, **right-sizing resources**, loading the correct modules, using GPUs
and containers, managing home vs scratch storage, and debugging job failures.

## Why it exists

When an AI agent helps someone on Columbia's clusters, it needs accurate,
system-specific guidance — the right login, storage, module, and scheduling workflow —
to produce **correct and consistent** results instead of plausible guesses. This skill
packages Columbia's HPC documentation into an agent-usable form (progressive
disclosure) and **references those docs as the source of truth**.

Two things make it more than a doc dump:

- **Resource-estimation judgment the docs don't teach:** size the request to the
  workload, lean conservative, and refine from measured data (`seff`) — don't copy
  demo-scale numbers from examples.
- **The exact commands that work on the current system:** the specific module loads,
  paths, and invocations that make things run — so the agent follows the right step
  instead of a plausible guess. Columbia's docs remain the source of truth; the skill
  just carries the current operational form (e.g. a module you need to load, a
  lowercase binary name).

## What's inside

```
columbia-hpc/
  SKILL.md              # router: golden workflow, resource-estimation principles, gotchas
  reference/
    clusters.md         # hostnames, node specs, partitions, limits (per cluster)
    access.md           # login, Duo, SSH config, accounts
    storage.md          # home vs scratch paths, quotas, shared-FS model
    resources.md        # how to size cores/mem/time/GPUs + feedback loop
    modules.md          # exact module names + live-system notes per cluster
    troubleshooting.md  # error → cause → fix
  templates/            # right-sized, parameterized sbatch starting points
```

Progressive disclosure: the agent always sees the short description, loads `SKILL.md`
when the task is Columbia-HPC-related, and opens a `reference/` file only when a
specific task needs it — so the whole kit ships locally but stays cheap in context.

## Install

As a skill via the [skills CLI](https://skills.sh):
```
npx skills add UzayPoyrza/columbia-hpc-skill@columbia-hpc
```
Or drop the `columbia-hpc/` folder into `~/.claude/skills/` (Claude Code) or your
agent's skills directory.

## Provenance

Distilled from Columbia's RCS Confluence docs (snapshot captured 2026-06-30) and
**verified on-cluster on 2026-07-01** by running a suite of jobs on Insomnia.
Cluster facts trace to Columbia's docs (the canonical source); where the docs conflict,
the reference files flag it rather than guessing. Where a documented step currently fails
on the live system, the reference files note the working command and cite the source page
so it can be verified and reported to RCS.

Not affiliated with or endorsed by Columbia University; community-maintained.
