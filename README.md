# columbia-hpc-skill

An [Agent Skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills) that
helps AI coding agents help users work on **Columbia University's HPC clusters**
(Insomnia, Ginsburg, Terremoto) with the SLURM scheduler — writing and submitting
`sbatch` jobs, **right-sizing resources**, loading the correct modules, using GPUs
and containers, managing home vs scratch storage, and debugging job failures.

## Why it exists

Columbia's public HPC docs are good but **wrong in several places**, and getting
resource requests wrong wastes allocation or fails jobs. This skill packages
**distilled, verified** guidance — including corrections confirmed by actually
running jobs on the cluster (e.g. Apptainer needs an explicit `module load`, the
`cuda/12.3` module is mislabeled, MATLAB's binary is lowercase, OpenMPI5 needs a
clean environment). It also encodes the judgment that's easy to get wrong:
**estimate resources from the workload, lean conservative, and refine from measured
data** — don't copy demo-scale numbers from examples.

## What's inside

```
columbia-hpc/
  SKILL.md              # router: golden workflow, resource-estimation principles, gotchas
  reference/
    clusters.md         # hostnames, node specs, partitions, limits (per cluster)
    access.md           # login, Duo, SSH config, accounts
    storage.md          # home vs scratch paths, quotas, shared-FS model
    resources.md        # how to size cores/mem/time/GPUs + feedback loop
    modules.md          # exact module names + verified corrections per cluster
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
Corrections vs the public docs are marked in `reference/`. Cluster facts trace to the
docs; where the docs conflict, the reference files say so rather than guessing.

Not affiliated with or endorsed by Columbia University; community-maintained.
