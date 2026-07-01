#!/bin/sh
# Minimal CPU smoke test — confirms your account works and a job actually runs.
#SBATCH -A <ACCOUNT>           # your SLURM group account (see ../reference/access.md)
#SBATCH --job-name=helloworld
#SBATCH -c 1                   # 1 core is plenty for a smoke test
#SBATCH --time=0-0:10          # short jobs backfill and start sooner
#SBATCH --mem-per-cpu=1G

echo "Hello from $(hostname)"
date
