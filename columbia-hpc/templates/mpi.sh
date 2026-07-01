#!/bin/sh
# MPI job. Start on ONE node with a few ranks; add nodes ONLY if the code truly does
# cross-node communication. See ../reference/resources.md before scaling up.
#SBATCH -A <ACCOUNT>
#SBATCH --job-name=mpi_job
#SBATCH -N 1                   # 1 node unless you genuinely need multi-node MPI
#SBATCH --ntasks-per-node=4    # ranks; raise toward cores-per-node as the work needs
#SBATCH --time=0-01:00
#SBATCH --mem-per-cpu=4G

# Pick the stack for your cluster (exact names in ../reference/modules.md):

# --- Intel MPI (Insomnia, Intel oneAPI) ---
# module load oneapi/hpctoolkit/hpctoolkit-2024.0.0
# mpiexec -bootstrap slurm ./my_mpi_program

# --- OpenMPI5 (Insomnia): needs a CLEAN env; add --bind-to none under hyperthreading ---
# module purge && module load openmpi5
# mpiexec --bind-to none ./my_mpi_program

# --- Ginsburg / Terremoto use different MPI modules (intel-parallel-studio, openmpi/gcc) ---
