# Estimating resources

The single most valuable thing this skill does is help a user request the *right*
amount of compute — not the minimum, not a copy of a doc example, but a size that
matches the workload. This file is the method.

## Mindset

- **Size to the work, lean conservative, refine from data.** A first submission is
  an educated guess; the real number comes from measuring one run and adjusting.
- **Over-asking is not "safe."** It wastes the group's shared allocation, makes the
  job wait longer (bigger requests are harder to schedule), and blocks colleagues.
  Under-asking gets the job killed. Aim to be *about right*, then correct.
- **Never inherit numbers from a doc/example just because they're there.** Doc
  examples often demonstrate *scale* (e.g. multi-node MPI across whole nodes), which
  is the opposite of what a first run or a test needs.

## The five questions to size a job

Ask (or infer) these before writing `#SBATCH` lines:

1. **What kind of parallelism?**
   - *Serial* → 1 core (`-c 1`).
   - *Threaded / shared-memory* (OpenMP, numpy/BLAS, `parfor`) → cores on **one**
     node (`-c N`), N ≤ cores-per-node for that cluster.
   - *MPI / distributed* → tasks, possibly across nodes (`-N`, `--ntasks`). Only use
     >1 node if the code actually does cross-node communication.
   - *GPU* → `--gres=gpu:1` (more only if the code uses multiple GPUs).
2. **How much memory does the data need?** Estimate peak resident size. Request
   `--mem-per-cpu` or total `--mem` a bit above that — not the whole node.
3. **How long will it run?** Estimate from a small test; add ~25% headroom.
4. **Does it truly span nodes?** If unsure, it doesn't — start on one node.
5. **Does it need a GPU?** Only if the software has GPU support and you'll use it.

## Cores, nodes, and hyperthreading

- Match tasks/cores to what the code uses. A single-node job should keep
  `-c` ≤ that cluster's cores-per-node (see `reference/clusters.md`; e.g. Insomnia
  standard nodes are 80 physical cores).
- **Hyperthreading caveat:** the scheduler may hand out "CPUs" that map to fewer
  physical cores, which trips up MPI process binding. If an MPI launch complains
  about "binding more processes than cpus available," add `--bind-to none` (see
  `reference/troubleshooting.md`).
- **1 node is the default.** Two nodes is not "twice as safe" — it's twice the wait
  and half the courtesy, and it does nothing unless the program is built for it.

## Walltime

- Format: `D-HH:MM` (e.g. `0-02:30` = 2.5 h). Acceptable SLURM forms include
  `minutes`, `HH:MM:SS`, `D-HH`, `D-HH:MM:SS`.
- **Estimate then buffer ~25%.** If a test run took 40 min, request ~1 h, not 5 days.
- Shorter jobs **backfill** into gaps the scheduler can't fill with big jobs, so they
  often start sooner. But a job that exceeds its walltime is **killed** — so don't
  shave it too close on a real run.
- Walltime caps differ by node ownership (owned vs shared) — see
  `reference/clusters.md`.

## Memory

- Two mutually exclusive ways to ask: `--mem-per-cpu=<X>` (per core) or `--mem=<X>`
  (per node). Pick one.
- If you don't set it, you get a per-core default (cluster-specific). Set it when you
  know the job needs more, or when using a full node.
- Over-requesting memory packs fewer jobs per node and slows *your* scheduling too —
  request what the data needs plus a margin, not the node maximum.
- For very large memory, clusters have high-memory nodes behind a constraint
  (`-C mem1024` etc.) — see `reference/clusters.md`.

## Close the loop: measure, then right-size

After a job finishes, look at what it *actually* used and fix the next request:

```
seff <jobid>       # memory used vs requested, CPU efficiency, elapsed vs walltime
sacct -j <jobid> --format=JobID,State,Elapsed,MaxRSS,ReqMem,AllocCPUS,TotalCPU
```
- **MaxRSS ≪ requested mem** → lower the memory ask next time.
- **CPU efficiency low** → you asked for more cores than the code used; drop `-c`.
- **Elapsed ≪ walltime** → tighten the time (helps backfill).
- **OOM / TIMEOUT states** → the opposite: bump memory/time and resubmit.

This measured feedback beats any static rule. Encourage the user to do one small
run, read `seff`, and set the production request from it.

## Worked cautionary example

A "hello-world" MPI job copied verbatim from the docs requested
`-N 2 --ntasks-per-node=80` — **two entire 80-core nodes (160 cores)** to compute a
tiny value. It sat in the queue waiting for two whole free nodes. Right-sized to
`-N 1 --ntasks-per-node=4`, it scheduled instantly and proved exactly the same
thing (that MPI launches and runs). The lesson: **the example's job was to
demonstrate multi-node scale; your job is usually just to get a result** — size for
your job, not the demo.
