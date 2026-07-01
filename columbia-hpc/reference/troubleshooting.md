# Troubleshooting: error → cause → fix

Most job failures on these clusters are **known environment quirks**, not bugs in the
user's code — and most have a one-line fix. Match the symptom here before debugging deeper.

## Modules / environment

| Symptom | Cause | Fix |
|---|---|---|
| `apptainer: command not found` on a compute node | Apptainer isn't on your PATH until you load it | `module load apptainer` first — in interactive sessions **and inside the sbatch script** |
| `nvcc: command not found` after `module load cuda` | `module load cuda` + bare `nvcc` doesn't put the compiler on your PATH | Compile with the full toolkit path `/usr/local/cuda/bin/nvcc`, adding `--cudart static` so the binary needs no CUDA libs at runtime |
| `MATLAB: command not found` | The launcher is lowercase `matlab` | Use `matlab` (after `module load MATLAB`) |
| MATLAB job runs then hangs until walltime | `matlab -r "..."` stays at the prompt with no terminal | End the command with `; exit`: `matlab -nosplash -nodisplay -nodesktop -r "myfunc(10); exit"` |
| a program can't find a module you loaded on the login node | Modules are only visible on **compute** nodes, and the login env doesn't carry into a batch job | `srun` to a compute node for interactive work; put `module load ...` **inside** the sbatch script |
| software table module name doesn't load | Names differ per cluster / version drift | Check `reference/modules.md`; run `module avail <name>` on a compute node |

## MPI

| Symptom | Cause | Fix |
|---|---|---|
| `mpiexec: error while loading shared libraries: libhwloc.so.15: cannot open shared object file` | A leftover module environment shadows OpenMPI5's libs | `module purge` **before** `module load openmpi5`; recompile the binary in that clean env |
| `There are not enough slots available ... requested by the application` | You ran `mpiexec -n N` in an interactive shell that only has 1 slot | Request the slots (`srun --ntasks=N ...`) or, just to test, `mpiexec --oversubscribe -n N ./prog`. In a batch job set `--ntasks-per-node` and let `mpiexec` inherit it |
| `A request was made to bind ... more processes than cpus available ... Binding policy: CORE` | Hyperthreading exposes fewer physical cores than tasks, so OpenMPI refuses to bind | Add `mpiexec --bind-to none ./prog` (or `--use-hwthread-cpus`) |
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
