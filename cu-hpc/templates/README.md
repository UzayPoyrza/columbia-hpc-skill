# templates/

Right-sized, parameterized `sbatch` starting points. Replace `<ACCOUNT>` with the
user's SLURM group account and adjust cores/memory/time/GPUs to the **actual
workload** — don't submit the defaults blindly (see `../reference/resources.md`).

| File | Use |
|------|-----|
| `helloworld.sh` | minimal smoke test (does my account + a job work?) |
| `cpu.sh` | single-node serial or threaded CPU job |
| `mpi.sh` | MPI job (starts on 1 node; scale deliberately) |
| `gpu.sh` | GPU / CUDA job |
| `apptainer.sh` | container job (Apptainer on Insomnia; Singularity elsewhere) |
| `array.sh` | job array for many similar runs |

These values are **conservative defaults, not recommendations for a specific job**.
Load modules in-script, run from scratch space, and check `seff <jobid>` afterward to
right-size the next run.
