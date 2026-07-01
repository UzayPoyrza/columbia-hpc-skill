#!/bin/sh
# GPU job. Request 1 GPU unless the code uses more.
#SBATCH -A <ACCOUNT>
#SBATCH --job-name=gpu_job
#SBATCH --gres=gpu:1
#SBATCH -c 4
#SBATCH --time=0-01:00
#SBATCH --mem-per-cpu=8G

# COMPILING CUDA on Insomnia: compile with the full toolkit path (/usr/local/cuda), not a
# bare `nvcc`. Do this once, interactively on a GPU node:
#   /usr/local/cuda/bin/nvcc --cudart static -o my_gpu_prog my_gpu_prog.cu
# (--cudart static makes the binary self-contained.) See ../reference/troubleshooting.md.
# Ginsburg/Terremoto: `module load cudaXX/toolkit` (see ../reference/modules.md).

# module load cuda
./my_gpu_prog
