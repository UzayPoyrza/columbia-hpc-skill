# Troubleshooting: error → cause → fix

Most job failures on these clusters are **known environment quirks**, not bugs in the
user's code. Match the symptom here before debugging deeper. Items marked
*(verified 2026-07-01)* are cases where following the documented step fails on the
live system; they were confirmed on Insomnia by running the jobs. Use the working
fix, and report persistent doc discrepancies to `hpc-support@columbia.edu` so the
official docs get corrected — this reference complements the canonical docs, it
doesn't replace them.

## Modules / environment

| Symptom | Cause | Fix |
|---|---|---|
| `apptainer: command not found` on a compute node | Insomnia's apptainer is **not** auto-loaded despite the docs *(verified)* | `module load apptainer` first — in interactive sessions **and inside the sbatch script** |
| `nvcc: command not found` after `module load cuda` | The `cuda/12.3` module is mislabeled → `/usr/local/cuda-12.3` has no `nvcc` *(verified)* | The real toolkit is CUDA 12.9 at `/usr/local/cuda`. Compile with `/usr/local/cuda/bin/nvcc`, add `--cudart static` so the binary needs no CUDA libs at runtime |
| `MATLAB: command not found` | The binary is lowercase `matlab`; docs say `MATLAB` *(verified)* | Use `matlab` (after `module load MATLAB`) |
| MATLAB job runs then hangs until walltime | `matlab -r "..."` stays at the prompt with no terminal | End the command with `; exit`: `matlab -nosplash -nodisplay -nodesktop -r "myfunc(10); exit"` |
| a program can't find a module you loaded on the login node | Modules are only visible on **compute** nodes, and the login env doesn't carry into a batch job | `srun` to a compute node for interactive work; put `module load ...` **inside** the sbatch script |
| software table module name doesn't load | Names differ per cluster / version drift | Check `reference/modules.md`; run `module avail <name>` on a compute node |

## MPI

| Symptom | Cause | Fix |
|---|---|---|
| `mpiexec: error while loading shared libraries: libhwloc.so.15: cannot open shared object file` | A dirty/leftover module environment shadows OpenMPI5's libs *(verified)* | `module purge` **before** `module load openmpi5`; recompile the binary in that clean env |
| `There are not enough slots available ... requested by the application` | You ran `mpiexec -n N` in an interactive shell that only has 1 slot | Request the slots (`srun --ntasks=N ...`) or, just to test, `mpiexec --oversubscribe -n N ./prog`. In a batch job set `--ntasks-per-node` and let `mpiexec` inherit it |
| `A request was made to bind ... more processes than cpus available ... Binding policy: CORE` | Hyperthreading exposes fewer physical cores than tasks, so OpenMPI refuses to bind *(verified)* | Add `mpiexec --bind-to none ./prog` (or `--use-hwthread-cpus`) |
| MPI binary from another cluster won't run | Built against a different MPI/toolchain | Recompile on the target cluster with that cluster's `mpicc` |

## Scheduling / job state

| Symptom | Cause | Fix |
|---|---|---|
| Job stuck `PD` with reason `Nodes required for job are DOWN, DRAINED or reserved...` | You requested whole/multiple nodes that aren't free | Right-size — usually `-N 1` and a few cores is enough (see `reference/resources.md`) |
| Job stuck `PD` with reason `Priority` / `Resources` | Normal queueing behind other jobs | Wait; smaller/shorter jobs backfill sooner |
| Job state `TIMEOUT` | Ran past `--time` and was killed | Raise walltime (from a `seff`/test estimate) and resubmit |
| Job state `OUT_OF_MEMORY` / `FAILED` with OOM | Exceeded requested memory | Raise `--mem`/`--mem-per-cpu`; check `seff <jobid>` for actual usage |
| `Invalid account` / `InvalidQOS` | Wrong `-A`/QoS | Use your group account (see `reference/access.md`) |

## Login node / housekeeping

| Symptom | Cause | Fix |
|---|---|---|
| Your process on the login node gets killed, or the login node is slow | Compute/compile on the shared login node | Never compute on login nodes — `srun` to a compute node |
| `/var` or disk-usage / quota warning emails | Often a node's system disk or *your* home filling with caches | Container image cache lives in `~/.apptainer/cache` / `~/.singularity/cache` — clear with `apptainer cache clean -f`; run jobs from scratch, not home. Node-health alerts for nodes you aren't using are cluster-admin's, not yours |

## When it's genuinely not here

Reproduce interactively on a compute node, read the full `slurm-<jobid>.out`, and
check `seff <jobid>` / `sacct`. If it's a cluster/module problem rather than the
user's code, it's worth emailing `hpc-support@columbia.edu`.
