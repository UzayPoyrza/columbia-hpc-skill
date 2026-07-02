#!/bin/bash
# Container job. Insomnia = Apptainer; Ginsburg/Terremoto = Singularity
# (swap `apptainer`/`module load apptainer` for `singularity`/`module load singularity`).
#SBATCH -A <ACCOUNT>
#SBATCH --job-name=container_job
#SBATCH -c 1
#SBATCH --time=0-0:30
#SBATCH --mem-per-cpu=5G

module load apptainer          # load it explicitly on Insomnia (not on PATH by default)

# Pull the image once beforehand on a compute node:
#   apptainer pull myimg.sif docker://<image>
apptainer exec myimg.sif <command>
