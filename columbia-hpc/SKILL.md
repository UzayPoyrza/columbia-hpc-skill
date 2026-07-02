---
name: columbia-hpc
description: >-
  Help users run work on Columbia University's Research Computing (RCS/CUIT) HPC
  clusters — Insomnia, Ginsburg, Terremoto, or the Free Tier (*.rcs.columbia.edu) —
  with the SLURM scheduler: writing, submitting, and debugging sbatch/srun jobs,
  sizing cores/memory/time/GPUs, loading modules, using GPUs and containers
  (Apptainer/Singularity), managing home vs scratch storage, and getting access.
  Naming any of these clusters — or "Columbia HPC / CUIT / RCS" — is itself enough
  to use this skill, and you should trigger even when the message is just a plain
  error or how-to that never says "skill," "HPC," or "Columbia": e.g. "command not
  found" on a compute node, "invalid account", module / CUDA / nvcc trouble, a
  killed or pending job, sizing a job, or copying data to scratch. Do NOT trigger
  for generic SLURM questions with no Columbia signal, or a clearly different
  university's cluster (e.g. Stanford).
argument-hint: "[your question or task]"
---

# Columbia HPC (Insomnia · Ginsburg · Terremoto)

Help the user get work running on Columbia's Research Computing (RCS) clusters — correctly,
consistently, and without wasted allocation or overloaded login nodes.

## How this skill is organized (read this first)

It bundles Columbia's HPC documentation locally and adds the judgment the docs don't teach.
Two kinds of thing, kept separate so there's never a question of which to trust:

- **Facts** — specs, module names, paths, limits, how to run a specific tool — live in the
  local doc pages under `docs/`. Find the right page via **`docs/INDEX.md`** and read it.
- **Judgment** — how to size a job, the submit workflow, what to do when it breaks — lives in
  this file and `reference/`.

| For… | Go to |
|------|-------|
| any cluster fact or how-to (access, storage, modules, software, node specs, job examples) | **`docs/INDEX.md`** → the right page |
| sizing a job (cores / memory / time / GPUs) | `reference/resources.md` |
| an error or failed job | `reference/troubleshooting.md` |
| a smoother SSH/login setup on the user's machine | `reference/ssh-config.md` |
| a ready-to-edit sbatch starting point | `templates/` |

## Navigation judgment: how and when to look things up

- **Don't recall cluster facts — read them.** Module names, node sizes, paths, limits, and how
  to run a given application differ per cluster and drift over time. When a task needs one, open
  the right `docs/` page (via `INDEX`) rather than answering from memory.
- **Facts from `docs/`, decisions from principles.** Use the doc pages for *what is*; use the
  principles below for *what to request, and in what order*.
- **Match the cluster.** Insomnia, Ginsburg, Terremoto, and the Free Tier differ — open the page
  for the cluster the user is actually on.
- **Load software with `module load` on a compute node** — even tools described as "available"
  may need an explicit `module load`; on Insomnia, modules aren't visible on the login node at all.
- **When the docs are silent or you're unsure, verify cheaply** in an interactive `srun` session
  instead of assuming.

## The golden workflow

Columbia clusters have three kinds of machine; using the wrong one is the most common mistake:

1. **Login node** (where you land on SSH) — shared. Edit files, submit jobs. **Never compute,
   compile, or run anything heavy here** (and on Insomnia, modules aren't even visible here).
2. **Compute node, interactive** (`srun --pty ... /bin/bash`) — a real worker with a live shell.
   Use it to compile, install, pull containers, and **test** before committing to a batch job.
3. **Compute node, batch** (`sbatch script.sh`) — unattended production runs.

So the reliable sequence is: **`srun` to a compute node → get the environment working (modules,
compile, quick test) → write a right-sized `sbatch` script → submit → monitor → check
efficiency.** Prove it interactively first, then batch it.

```
srun --pty -t 0-01:00 -A <ACCOUNT> /bin/bash               # CPU compute node
srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash  # GPU compute node
```

## Principles (these matter more than any single fact — facts drift, judgment doesn't)

The goal is **not** to request the minimum, and **not** to copy the numbers from a doc example.
It is to **size the request to the actual workload**, lean a little conservative, and then
**correct from measured data**. Over-asking wastes the group's shared allocation and schedules
slower; under-asking gets the job killed. (Full method in `reference/resources.md`.)

- **Size to the work, not the example or the maximum.** Ask what the job actually does — serial,
  threaded, MPI, GPU? how much memory? how long? does it truly span nodes? Map *that* to the
  request. Default to **one node** unless the code does real cross-node MPI.
- **Start small, measure, then scale.** Treat the first run as a cheap probe (small data, short
  walltime, one node); set the real request from what you saw.
- **Walltime = a realistic estimate + ~25% headroom**, not "5 days to be safe" — shorter jobs
  backfill and start sooner, but a job that exceeds its walltime is killed.
- **Close the loop.** After a run, check actual usage with `seff <jobid>` and right-size the
  *next* submission. Measured beats predicted.
- **Be a good citizen of a shared machine.** No compute on login nodes; don't reserve whole
  nodes you won't use.

## Writing and submitting a job

Start from a `templates/` file and adapt it. Every script needs at least an account, a time
limit, and a resource request; load software **inside the script** with `module load ...`
(the login environment doesn't carry into the job). For GPUs add `--gres=gpu:1`; for many
similar runs use a job array (`templates/array.sh`) instead of a loop of `sbatch`. For the exact
module names, submit directives, and worked examples, open the cluster's page via `docs/INDEX.md`.

## Storage

Home is small; do job I/O in **group/scratch space, not home** (paths and quotas are on each
cluster's Storage page via `INDEX`). Home and scratch are shared across all nodes, so a file made
on a compute node is visible everywhere; node-local `/tmp` is the exception (wiped after the job).

## Monitoring

- `squeue -u $USER` — your jobs; the `NODELIST(REASON)` column explains why one is still pending.
- `sacct -X -u $USER --starttime today --format=JobID,JobName,State,ExitCode,Elapsed` — pass/fail.
- `seff <jobid>` — actual efficiency; feed it back into the next request.
- `scancel <jobid>` — cancel. Output lands in `slurm-<jobid>.out` in the submit directory.

When a job fails, match the error in `reference/troubleshooting.md` before digging deeper.
