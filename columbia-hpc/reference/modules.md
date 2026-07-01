# Columbia HPC — Software Modules Reference

> Source of truth: Columbia RCS Confluence wiki (columbiauniversity.atlassian.net/wiki/spaces/rcs),
> per-cluster **Software** and **Job Examples** pages for Insomnia, Ginsburg, Terremoto.
> Docs snapshot captured **2026-06-30**. On-cluster corrections verified **2026-07-01** (see last section).
> Only module names/facts present in those files are reported here. Versions drift — confirm with `module avail`.

## Module system basics

Columbia HPC uses **Lmod** environment modules. Core commands:

| Command | Purpose |
| --- | --- |
| `module avail` | List modules available on the current node (also `module avail <name>` to filter) |
| `module load <mod>` | Add a module to your environment |
| `module purge` | Unload all currently loaded modules |
| `ml <mod>` / `ml load <mod>` | Short alias for `module load` (used throughout the docs) |

Lmod user guide referenced by the docs: <https://lmod.readthedocs.io/en/latest/010_user.html>

### KEY FACT: modules are only visible on COMPUTE nodes, not login nodes

When you SSH in you land on a **login node**. Software installed as modules (and auto-loaded
software) is **only seen on a compute node** — it "will not be seen on a login node" (Insomnia Software page).
So the first thing to do is `srun` to a compute node, then run `module avail` / `module load`:

```
srun --pty -t 0-02:00 -A <ACCOUNT> /bin/bash                # CPU compute node
srun --pty -t 0-02:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash   # GPU compute node
```

(Default/max interactive time is up to 5 days on a node your group owns; 12 h on another group's node.)

## Container tool differs per cluster

| Cluster | Container tool | Load command (per docs) |
| --- | --- | --- |
| **Insomnia** | **apptainer** | docs say auto-loaded on compute nodes — **but see correction #1 below: you must `module load apptainer`** |
| **Ginsburg** | **singularity** | `module load singularity/3.7.1` (or `module load singularity`) |
| **Terremoto** | **singularity** | `module load singularity` |

On Insomnia, Singularity is now called Apptainer; the `singularity` command still appears in some
Insomnia examples (e.g. RStudio) as an alias.

## Per-cluster module map

Exact module names / load commands as they appear in the docs. Where the Software table and the
Job Examples differ, both are shown.

| Category | Insomnia | Ginsburg | Terremoto |
| --- | --- | --- | --- |
| **MPI — Intel** | `oneapi/hpctoolkit/hpctoolkit-2024.0.0` (Intel oneAPI; includes MPI, fortran); also `oneapi/hpctoolkit/mpi/2021.11`; run `mpiexec -bootstrap slurm` | `intel-parallel-studio/2020`; `intel-oneAPI-toolkit <lib>` / `intel-oneAPI-toolkit/all-modules`; run `mpiexec -bootstrap slurm` | `intel-parallel-studio/2020` (table); `intel-parallel-studio/2017` (examples); run `mpiexec -bootstrap slurm` |
| **MPI — OpenMPI** | `openmpi5` (5.0.2); table lists `openmpi/gcc/64/4.1.5a1`; also `mpi/openmpi-x86_64/4.1.1`, `mpi/mpich-x86_64/4.1.1` | `openmpi/gcc/64/4.1.5a1` (or `openmpi/gcc/64`); also `openmpi/gcc/64/4.0.3rc4`, `openmpi/gcc/64/4.1.1_cuda_11.0.3_aware` | `openmpi/gcc/64/4.0.0` (or `openmpi/gcc/64`) |
| **CUDA** | `module load cuda` (table: cuda 12.3, on GPU nodes) — **see correction #2** | `cuda12.0/toolkit` (table 12.0); also `cuda11.1/toolkit`, `cuda11.7/toolkit`, `cuda11.8/toolkit/11.8.0`; cuDNN `cudnn8.0-cuda11.1`, `cudnn8.6-cuda11.8/8.6.0.163` | `cuda11.0/toolkit` (table 11.0); `cuda92/toolkit` (examples) |
| **C / C++ compiler** | `gcc` 11.4.1 (installed directly on all compute nodes) | `gcc/13.0.1`; also `gcc/10.2.0` | `gcc/11.2.0`; also `gcc/4.8.5` (needed for older nvcc) |
| **Fortran compiler** | `oneapi/hpctoolkit/ifort` (`ifort`) | `ifort` via `intel-parallel-studio/2020`; MPI C: `mpiicc` | `ifort` via `intel-parallel-studio`; MPI C: `mpiicc` |
| **MATLAB** | `module load MATLAB/2023b` (table) / `module load MATLAB` — **binary is lowercase, see correction #3** | `module load matlab/2023a` (or `module load matlab`) | `module load matlab/2022b` (table); examples use `module load MATLAB` |
| **Python / anaconda** | Python 3.9.18 installed directly on compute nodes; `module load anaconda` (incl. numpy, torch, Tensorflow, scipy) | `module load anaconda/3-2023.09` or `anaconda/2-2019.10`; `module load anaconda` | `module load anaconda/3-2022.05` or `anaconda/2-2019.03`; also `anaconda/3-2018.12`, `anaconda/3-2019.10` |
| **R** | R 4.3.2 installed directly on compute nodes; `module load R` | `module load R/4.3.1` or `R/3.6.3` | `module load R/4.2.2` |
| **Julia** | `module load julia/1.5.3` (or `module load julia`) | `module load julia/1.5.3` (or `module load julia`) | `module load julia` |
| **Containers** | `apptainer` 1.2.5-1.el9 (see container note + correction #1) | `singularity/3.7.1` (or `singularity`) | `singularity` 3.5.3 |

### Notable other modules

| Cluster | Module (load command) — description |
| --- | --- |
| **Insomnia** | `gurobi/10/0/3` — Gurobi optimizer; `knitro/13.2.0` — nonlinear optimization; `schrodinger` — chem/biochem suite (2024-1, 2025-2); `stata` — Stata 18; Mathematica 14.0 (installed directly); `hdf5p` — parallel HDF5 (1.10.7, 1.14.3); plus (installed directly) `cmake` 3.20.2, `make` 4.3, gdal/gdal-devel 3.4.3, gsl/gsl-devel 2.6-7, hdf5/hdf5-devel 1.12.1-7, Qt5 5.15.9. VS Code Server (`code tunnel`, not a module). |
| **Ginsburg** | `gurobi/10/0/3`, `knitro/13.2.0`, `schrodinger/2024-1`, `stata/18`, `Mathematica/13.2`; QE `QE/7.2` (Quantum Espresso); `OpenFOAM/v2206`; `WIEN2k_21.1`; neuro: `AFNI/23.1.05`, `ANTs/2.4.4`, `FSL/6.0.5.2`, `freesurfer/7.4`, `workbench/1.5.0`; genomics: `bcftools/1.18`, `samtools/1.19`, `htslib/1.19`, `vcftools/0.1.17`, `cactus/2.6.7`, `lastz/1.04.15`, `nextflow/23.10.0`, `ancestry_hmm/0.94`; numerics/libs: `scalapack/2.2.0`, `glpk/5.0`, `metis/5.1.0`, `mumps/5.6.2`, `hdf5/1.10.1`, `netcdf-fortran-intel/4.5.3`, `netcdf/gcc/64/gcc/64/4.7.4`, `octave`, `candi/9.4.2-r3`, `leptonica/1.83.0`, `tesseract`, `LBPM/22.08`, `libRadtran/2.0.5`; ocean color: `ocssw`, `seadas/9.0.1`; utils: `stopos`, `vim/9.1`. VS Code Server (not a module). |
| **Terremoto** | `knitro/13.2.0`, `stata/16`. (Software table is short; most domain software lives on Ginsburg/Insomnia.) |

## Verified corrections (on-cluster 2026-07-01)

The docs snapshot is **wrong** on the following Insomnia points. These were confirmed on the cluster.

1. **apptainer is NOT auto-loaded on compute nodes.** Despite the Insomnia docs saying Apptainer is
   "automatically loaded on any compute node," you must run `module load apptainer` before using it —
   in interactive sessions **and in batch jobs**.

2. **The `cuda/12.3` module is MISLABELED.** It sets paths to `/usr/local/cuda-12.3`, which has **no
   `nvcc`**. The real toolkit is **CUDA 12.9 at `/usr/local/cuda`**. Compile with the full path and
   link the runtime statically so the binary is self-contained:
   ```
   /usr/local/cuda/bin/nvcc --cudart static -o hello_world hello_world.cu
   ```
   (Do not rely on `module load cuda` + bare `nvcc`.)

3. **The MATLAB binary is lowercase `matlab`, not `MATLAB`.** After `module load MATLAB` the executable
   is at `/insomnia001/shared/apps/MATLAB/R2025a/bin/matlab`. The docs' uppercase `MATLAB` command does
   not exist. Run non-interactively as:
   ```
   matlab -nosplash -nodisplay -nodesktop -r "...; exit"
   ```
   The trailing `; exit` is required or the process hangs.

4. **openmpi5 needs a clean environment.** Run `module purge` **before** `module load openmpi5`,
   otherwise `mpiexec` fails with `libhwloc.so.15: cannot open shared object file`. For multi-rank
   launches under hyperthreading, add `--bind-to none`:
   ```
   module purge
   module load openmpi5
   mpiexec --bind-to none -n <ranks> ./myprogram
   ```
