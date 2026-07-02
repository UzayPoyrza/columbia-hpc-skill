#!/bin/sh
# Job array — run many similar tasks with ONE submission instead of looping sbatch.
# SLURM sets $SLURM_ARRAY_TASK_ID (here 1..10); use it to pick each task's input.
#SBATCH -A <ACCOUNT>
#SBATCH --job-name=array_job
#SBATCH --array=1-10           # number of tasks
#SBATCH -c 1
#SBATCH --time=0-00:30
#SBATCH --mem-per-cpu=4G

echo "Task $SLURM_ARRAY_TASK_ID on $(hostname)"
# ./my_program input_${SLURM_ARRAY_TASK_ID}.dat
