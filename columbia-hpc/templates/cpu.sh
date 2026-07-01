#!/bin/sh
# Single-node CPU job (serial or threaded). Set -c to the cores your program uses;
# for threaded codes keep -c <= cores-per-node for the cluster (see ../reference/clusters.md).
#SBATCH -A <ACCOUNT>
#SBATCH --job-name=cpu_job
#SBATCH -c 4                   # cores on ONE node — size to the program, not the node
#SBATCH --time=0-02:00         # realistic estimate + ~25% headroom
#SBATCH --mem-per-cpu=4G       # near actual peak memory, not the node maximum

# export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK   # for OpenMP codes
# module load <compiler/runtime>                # see ../reference/modules.md

./my_program
