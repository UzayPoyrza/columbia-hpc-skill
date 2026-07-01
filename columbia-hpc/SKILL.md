---
name: columbia-hpc
description: >-
  Help users run work on Columbia University's HPC clusters (Insomnia, Ginsburg,
  Terremoto) with the SLURM scheduler — writing and submitting sbatch jobs,
  estimating the right resources, loading the correct modules, using GPUs and
  containers (Apptainer/Singularity), managing home vs scratch storage, and
  debugging job failures. Use this whenever the user mentions Columbia HPC, CUIT
  HPC, RCS, Insomnia / Ginsburg / Terremoto, a *.rcs.columbia.edu host, a SLURM
  account on a Columbia cluster, or asks how to submit / run / compile / debug a
  job with sbatch / srun / squeue / salloc on these systems — even if they don't
  name the skill or the cluster explicitly.
---

# Columbia HPC (Insomnia · Ginsburg · Terremoto)

Help the user get work running on Columbia's Research Computing (RCS) clusters
without wasted allocation, failed jobs, or overloaded login nodes.

## Cardinal rule: don't guess cluster facts — read the reference file

Module names, node sizes, storage paths, partitions, and walltime limits **differ
per cluster and drift over time**. Treat Columbia's HPC docs as the source of truth,
but **confirm specifics from the `reference/` files** rather than recalling them —
they distill the docs and, where a documented step currently fails on the live
system, note the working command and cite the source so the user can verify and
report it (see `reference/troubleshooting.md`). The files are short and task-scoped.

| Need | Read |
|------|------|
| hostnames, node specs, partitions, limits, per-cluster facts | `reference/clusters.md` |
| login, Duo, SSH config, account names | `reference/access.md` |
| home vs scratch paths, quotas, where to run | `reference/storage.md` |
| how to size cores / memory / time / GPUs | `reference/resources.md` |
| exact module names + live-system notes per cluster | `reference/modules.md` |
| error → cause → fix (the gotchas) | `reference/troubleshooting.md` |
| ready-to-edit sbatch starting points | `templates/` |

## The golden workflow

Columbia clusters have three kinds of machine. Using the wrong one is the most
common mistake:

1. **Login node** (where you land on SSH) — shared by everyone. Edit files, submit
   jobs. **Do not compute, compile, or run anything heavy here** — it degrades the
   node for all users. Also, **software modules are not visible on the login node.**
2. **Compute node, interactive** (`srun --pty ... /bin/bash`) — a real worker node
   with a live shell. Use it to **compile, install, pull containers, and test**
   before committing to a batch job. This is where "does my setup even work?"
   questions get answered fast.
3. **Compute node, batch** (`sbatch script.sh`) — unattended production runs.

So the reliable sequence is: **`srun` to a compute node → get the environment
working (modules, compile, quick test) → write a right-sized `sbatch` script →
submit → monitor → check efficiency.** Prove it interactively first; then batch it.

Interactive session (replace `<ACCOUNT>` with the user's SLURM account):
```
srun --pty -t 0-01:00 -A <ACCOUNT> /bin/bash          # CPU node
srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash   # GPU node
```

## Estimating resources — the part that matters most

The goal is **not** to request the minimum, and **not** to copy the numbers from a
doc example. It is to **size the request to the actual workload**, lean a little
conservative, and then **correct from measured data**. Over-requesting wastes the
group's allocation, schedules slower, and is antisocial on a shared system;
under-requesting gets the job killed. Aim to be *about right*, then refine.

Core habits (full method + numbers in `reference/resources.md`):

- **Size to the work, not the example.** Ask what the job actually is — serial,
  threaded, MPI, GPU? how much memory does the data need? how long will it run?
  does it truly span multiple nodes? Map *that* to the request. Requesting whole
  nodes "to be safe" is the trap — a demo script's `-N 2 --ntasks-per-node=80`
  reserves two entire nodes; a test needs a fraction of that.
- **Default to one node** unless the job genuinely needs cross-node MPI. Extra
  nodes only help code built to use them.
- **Walltime = a realistic estimate + ~25% headroom**, not "5 days to be safe."
  Shorter jobs backfill into scheduling gaps and start sooner — but never set it so
  low the job is killed mid-run.
- **Test small first**, then scale: run a short job on small data / few iterations,
  measure, and set the real request from what you saw.
- **Close the loop.** After a run, check actual usage with `seff <jobid>` (or
  `sacct`) — memory used, CPU efficiency, elapsed vs requested — and right-size the
  *next* submission. This feedback loop beats any up-front guess.

## Writing and submitting a job

Start from a `templates/` file and adapt it — don't hand-write from scratch. Every
script needs at least an account, a time limit, and a resource request:

```
#SBATCH -A <ACCOUNT>        # SLURM account (group). See reference/access.md
#SBATCH --job-name=<name>
#SBATCH -c <cores>          # cores for a single-node job
#SBATCH --time=<D-HH:MM>    # realistic estimate + headroom
#SBATCH --mem-per-cpu=<mem> # or --mem=<total>
```
Submit with `sbatch script.sh`; it returns a job ID and runs on a compute node.
Load any needed software **inside the script** with `module load ...` (see
`reference/modules.md`) — the login environment does not carry into the job.

For GPUs add `--gres=gpu:1` (and load the CUDA module in-script). For many similar
runs use a **job array** (`--array=1-N`) instead of a loop of `sbatch` calls — see
`templates/array.sh`.

## Modules, GPUs, containers — mind the per-cluster gotchas

Module names differ per cluster, and a few documented steps currently fail on the
live system. Always confirm against `reference/modules.md`. The highest-frequency
gotchas (all detailed in `reference/troubleshooting.md`):

- **Containers differ:** Insomnia uses **Apptainer**, Ginsburg/Terremoto use
  **Singularity**. On Insomnia you must `module load apptainer` first — it is *not*
  auto-loaded despite what the docs claim.
- **Insomnia CUDA:** the `cuda/12.3` module is mislabeled and has no `nvcc`; the real
  toolkit is CUDA 12.9 at `/usr/local/cuda`. Compile with `/usr/local/cuda/bin/nvcc`
  and `--cudart static` for a portable binary.
- **MATLAB:** the binary is lowercase `matlab`, and non-interactive runs need
  `-r "...; exit"` or the job hangs to walltime.
- **OpenMPI on Insomnia:** `module purge` before `module load openmpi5` (else
  `libhwloc.so.15` is missing), and add `--bind-to none` for multi-rank launches.

## Storage — run from scratch, not home

Home and scratch are network-mounted and identical on every node, so a file made on
a compute node is visible everywhere. Do job I/O in **group/scratch space**, not
home (paths and quotas in `reference/storage.md`). Node-local `/tmp` is the
exception — it is per-node and wiped when the job ends.

## Monitoring and debugging

- `squeue -u $USER` — your queued/running jobs; the `NODELIST(REASON)` column
  explains *why* a job is still pending (e.g. waiting on nodes, priority).
- `sacct -X -u $USER --starttime today --format=JobID,JobName,State,ExitCode,Elapsed`
  — pass/fail + exit codes after jobs finish.
- `seff <jobid>` — actual memory/CPU/time efficiency; use it to right-size next time.
- Output lands in `slurm-<jobid>.out` in the submit directory.

When a job fails, match the error against `reference/troubleshooting.md` before
guessing — most failures on these clusters are known module/environment quirks with
a one-line fix, not bugs in the user's code.
