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
  SKILL.md              # router + navigation judgment + resource principles + workflow
  docs/                 # Columbia's HPC pages, bundled locally = the FACTS (source of truth)
    INDEX.md            # topic/task → the right page (the map the agent routes through)
    Insomnia_*.md  Ginsburg_*.md  Terremoto_*.md  Free_Tier_*.md  ... (~48 pages)
  reference/            # the JUDGMENT layer (what the docs don't teach)
    resources.md        # how to size cores/mem/time/GPUs + feedback loop
    troubleshooting.md  # error → cause → fix
    ssh-config.md       # client-side SSH/login setup tip
  templates/            # right-sized, parameterized sbatch starting points
```

Two non-overlapping layers: **facts** live once, in the bundled `docs/` pages (lightly
corrected where we verified fixes on-cluster); **judgment** lives in `SKILL.md` + `reference/`.
Progressive disclosure means the agent always sees the short description, loads `SKILL.md` when
the task is Columbia-HPC-related, then opens *one* `docs/` page (via `INDEX`) or `reference/`
file only when a specific task needs it — so the whole kit ships locally but stays cheap in
context.

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
Cluster facts trace to Columbia's docs (the canonical source), bundled under
`columbia-hpc/docs/` and corrected in-place where a documented step was verified to fail
on the live system (each correction is visible in this repo's git history).

Not affiliated with or endorsed by Columbia University; community-maintained.
