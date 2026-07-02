# Ginsburg - Software

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62128223/Ginsburg+-+Software

---

- [Running brainiak in Anaconda Python](#Ginsburg-Software-RunningbrainiakinAnacondaPython)
- [Installing Athena++](#Ginsburg-Software-InstallingAthena++)
- [Running LBPM in a Singularity container from Nvidia's NGC Catalog](#Ginsburg-Software-RunningLBPMinaSingularitycontainerfromNvidia'sNGCCatalog)
- [Running LBPM multi-node with Slurm and Singularity](#Ginsburg-Software-RunningLBPMmulti-nodewithSlurmandSingularity)
- [Running FSL in a Singularity container; notes for Mac OS X & XQuartz](#Ginsburg-Software-RunningFSLinaSingularitycontainer;notesforMacOSX&XQuartz)
- [Mathematica](#Ginsburg-Software-Mathematica)
- [OpenMPI Settings](#Ginsburg-Software-OpenMPISettings)
- [RStudio in a Singularity container](#Ginsburg-Software-RStudioinaSingularitycontainer)
- [NOTE:](#Ginsburg-Software-NOTE:)
- [Visual Studio Code Server](#Ginsburg-Software-VisualStudioCodeServer)

Ginsburg is currently running **Red Hat Enterprise Linux release 8.2.**

The table below shows software already installed on the cluster system-wide.

The list may be partial and not totally up-to-date at any given time.

Use the following command to verify whether unlisted software/packages can be found on Ginsburg otherwise:

```
$ module avail
```

***For a good guide on how to use environment modules to easily load your software environment, please see:***

<https://lmod.readthedocs.io/en/latest/010_user.html>

| **Name** | **Version** | **Location / Module** | **Category** |
| --- | --- | --- | --- |
| AFNI | 23.1.05 | module load AFNI/23.1.05 | Analysis of Functional Neuro Images |
| Anaconda Python 3.11.5 2023.09 | Python 3.11.5 | module load anaconda/3-2023.09 | Python for Scientific Computing |
| Anaconda Python  2.7.16 2019.10 | Python 2.7.16 | module load anaconda/2-2019.10 | Python for Scientific Computing |
| ancestry\_hmm | ancestry\_hmm | module load ancestry\_hmm/0.94 | Program designed to infer adaptive introgression from population genomic data. |
| ANTs | 2.4.4 | module load ANTs/2.4.4 | ANTs computes high-dimensional mappings to capture the statistics of brain structure and function |
| BCFtools | 1.18 | module load bcftools/1.18 | Reading/writing BCF2/VCF/gVCF files and calling/filtering/summarising SNP and short indel sequence variants |
| cactus | 2.6.7 | module load cactus/2.6.7 | Comparative Genomics Toolkit |
| candi | 9.4.2-r3 | module load candi/9.4.2-r3 | The `candi.sh` shell script downloads, configures, builds, and installs [deal.II](https://github.com/dealii/dealii) with common dependencies on linux-based systems |
| cuda | 12.0 | module load cuda12.0/toolkit | GPU Computing |
| cudnn | 8.0 | module load cudnn8.0-cuda11.1 | CUDA Deep Neural Network library |
| freesurfer | 7.4 | module load freesurfer/7.4 | Brain imaging software |
| FSL | 6.0.5.2 | module load FSL/6.0.5.2 | Analysis tools for FMRI, MRI and DTI brain imaging data |
| gcc | 13.0.1 | module load gcc/13.0.1 | Compiler - C / C++ |
| glpk | 5.0 | module load glpk/5.0 | C library for solving large-scale linear programming (LP), mixed integer programming (MIP) |
| gurobi | 10.0.3 | module load gurobi/10/0/3 | Prescriptive analytics platform and a decision-making technology |
| hdf5 | 1.10.1 | module load hdf5/1.10.1 | High performance data software library & file format |
| htslib | 1.19 | module load htslib/1.19 | A C library for reading/writing high-throughput sequencing data |
| Intel oneAPI toolkit | various | module load intel-oneAPI-toolkit <library>  module load intel-oneAPI-toolkit/all-modules | Core set of tools and libraries for developing high-performance, data-centric applications across diverse architectures.  intel-oneAPI-toolkit/all-modules will load all the oneapi modules including mpi\*, ifort, etc |
| intel-parallel-studio | 2020 Update 4 | module load intel-parallel-studio/2020 | Intel Compiler |
| julia | 1.5.3 | module load julia/1.5.3 | Programming Language |
| knitro | 13.2.0 | module load knitro/13.2.0 | Software package for solving large scale nonlinear mathematical optimization problems; short for "Nonlinear Interior point Trust Region Optimization" |
| lastz | 1.04.15 | module load lastz/1.04.15 | A program for aligning DNA sequences, a pairwise aligner. |
| LBPM | 22.08 | module load LBPM/22.08 | Model flow processes based on digital rock physics |
| leptonica | 1.83.0 | module load leptonica/1.83.0 | A ipedagogically-oriented open source library containing software that is broadly useful for image processing and image analysis |
| libRadtran | 2.0.5 | modulel load libRadtran/2.0.5 | A library for radiative transfer |
| Mathematica | 13.2 | module load Mathematica/13.2 | Numerical Computing |
| Matlab | 2023a | module load matlab/2023a | Numerical Computing |
| metis | 5.1.0 | module load metis/5.1.0 | A set of serial programs for partitioning graphs, partitioning finite element meshes. |
| MUMPS | 5.6.2 | module load mumps/5.6.2 | MUltifrontal Massively Parallel Sparse direct Solver |
| netcdf-fortran-intel | 4.5.3 | module load netcdf-fortran-intel/4.5.3 | Array Interface Library |
| netcdf/gcc | 4.7.4 | module load netcdf/gcc/64/gcc/64/4.7.4 | Array Interface Library |
| Nextflow | 23.10.0 | module load nextflow/23.10.0 | Enables scalable and reproducible scientific workflows using software containers. |
| occsw | V2022.3 | module load ocssw | Ocean Color Science Software, CLI version |
| octave | 5.2.0 | module load octave | Installed on all compute nodes, start with 'octave'. Mathematics-oriented syntax with built-in 2D/3D plotting and visualization |
| OpenFOAM | v2206 | module load OpenFOAM/v2206 | Computational fluid dynamics. |
| openmpi | 4.1.5a1 | openmpi/gcc/64/4.1.5a1 | OpenMPI Compiler |
| Quantum Espresso | 7.2 | module load QE/7.2 | Quantum Espresso |
| R | 3.6.3 | module load R/3.6.3 | Programming Language |
| R | 4.3.1 | module load R/4.3.1 | Programming Language |
| samtools | 1.19 | module load samtools/1.19 | Suite of programs for interacting with high-throughput sequencing data |
| ScaLAPACK | 2.2.0 | module load scalapack/2.2.0 | Scalable Linear Algebra PACKage |
| Schrodinger | 2024-1 | module load schrodinger/2024-1 | Modeling, analysis and computational tasks |
| SeaDAS | 9.0.1 | module load seadas/9.0.1 | A comprehensive software package for the processing, display, analysis, and quality control of ocean color data. Requires XQuartz on a Mac or Mobaxterm on Windows. |
| Singularity | 3.7.1 | module load singularity/3.7.1 | Run Docker-like containers |
| Stata | 18 | module load stata/18 | General-purpose statistical software |
| stopos | 0.93 | module load stopos | Create and manage computing tasks |
| tesseract | 5.3.1 | module load tesseract | OCR |
| VCFTools | 0.1.17 | module load vcftools/0.1.17 | A set of tools written in Perl and C++ for working with VCF files |
| vim | 9.1 | module load vim/9.1 | vi improved test editor |
| Visual Studio Code Server |  | Not a module | A server side Integrated Development Environment hosted on Ginsburg compute nodes |
| WIEN2k | WIEN2k\_21.1 | module load WIEN2k\_21.1 | Perform electronic structure calculations of solids using density functional theory. |
| workbench | 1.5.0 | module load workbench/1.5.0 | Visualization and Discovery tool used to map neuro-imaging data |

### **Running** [**brainiak**](https://github.com/brainiak/brainiak) **in Anaconda Python**

The Brain Imaging Analysis Kit is a package of Python modules useful for neuroscience, primarily focused on functional Magnetic Resonance Imaging (fMRI) analysis. We've managed to install it in a conda environment with `anaconda/3-2022.05`.  After loading the module run:

```
conda activate /burg/opt/anaconda3-2022.05/envs/brainiak
```

You may have to initialize a shell first, e.g., `conda init bash`, note this will update your `.bashrc` file.

### **Installing** [**Athena++**](https://github.com/PrincetonUniversity/athena)

Athena++ radiation GRMHD code and adaptive mesh refinement (AMR) framework requires specific modules and can be tricky to compile. Load the following modules and respective versions and run the fllowinng commands :

```
gcc/13.0.1 fftw3/openmpi/gcc/64/3.3.10 openmpi/gcc/64/4.1.5a1 hdf5p/hdf5p_1.14.2 anaconda
python configure.py --prob rt -b --flux hlld -mpi -hdf5 -fft --fftw_path /cm/shared/apps/fftw/openmpi/gcc/64/3.3.10 --hdf5_path /burg/opt/hdf5p-1.14.2
```

You can test an interactive session with `salloc` (not `srun`) with a sample input file:

```
mpirun -np 2 ../bin/athena -i athinput.rt3d
Setup complete, entering main loop...
cycle=0 time=0.0000000000000000e+00 dt=4.6376023638204525e-04
cycle=1 time=4.6376023638204525e-04 dt=4.6376640600387668e-04
cycle=2 time=9.2752664238592193e-04 dt=4.6377298288455065e-04
cycle=3 time=1.3912996252704725e-03 dt=4.6377996104450140e-04
cycle=4 time=1.8550795863149739e-03 dt=4.6378733390646439e-04
```

### **Running LBPM in a Singularity container from** [**Nvidia's NGC Catalog**](https://catalog.ngc.nvidia.com/orgs/hpc/containers/lbpm)

LBPM (Lattice Boltzmann Methods for Porous Media) is an open source software framework designed to model flow processes based on digital rock physics, and is freely available through the [Open Porous Media](https://github.com/OPM/LBPM) project. Digital rock physics refers to a growing class of methods that leverage microscopic data sources to obtain insight into the physical behavior of fluids in rock and other porous materials. LBPM simulation protocols are based on two-fluid lattice Boltzmann methods, focusing in particular on wetting phenomena. The Department of Earth and Environmental Engineering and the [Kelly Lab](https://www.eee.columbia.edu/faculty/shaina-kelly) are the main users

Some modifications are needed to get the water-flooding simulation to work correct. You can start with an interactive session via Slurm's `salloc` command and request a GPU as well as requesting at least 10 GB of memory.

```
salloc --mem=10gb -t 0-10:00 --gres=gpu:1  -A <your-account>
```

Update the `wget` commands as below:

```
export BENCHMARK_DIR=$PWD
wget https://gitlab.com/NVHPC/ngc-examples/-/raw/master/LBPM/2020.10/single-node/input.db
wget https://gitlab.com/NVHPC/ngc-examples/-/raw/master/LBPM/2020.10/single-node/run.sh
wget https://gitlab.com/NVHPC/ngc-examples/-/raw/master/LBPM/2020.10/single-node/mask_water_flooded_water_and_oil.raw.morphdrain.raw
chmod +x run.sh
```

Ginsburg has Singularity version 3.7.1 available. The run.sh file defaults the compute capable option as GPU\_ARCH="sm70" which works on nodes with the V100 and RTX 8000. Note you can update this option to sm80 if you use a GPU node with the A40 or A100 The file also runs the mpirun command so remember to load OpenMPI as well as CUDA toolkit.

```
module load singularity/3.7.1 openmpi/gcc/64/4.0.3rc4 cuda11.7/toolkit/11.7.1
cd $BENCHMARK_DIR
singularity run --nv -B $BENCHMARK_DIR:/benchmark --pwd /benchmark docker://nvcr.io/hpc/lbpm:2020.10 ./run.sh
```

If you see errors such as:

```
Primary job  terminated normally, but 1 process returned a non-zero exit code. Per user-direction, the job has been aborted.
--------------------------------------------------------------------------
mpirun noticed that process rank 0 with PID ##### on node g### exited on signal 11 (Segmentation fault).
```

Make sure you are on a node with a GPU and have loaded OpenMPI and/or CUDA toolkit, e.g., openmpi/gcc/64/4.0.3rc4 cuda11.7/toolkit/11.7.1

### Running LBPM multi-node with Slurm and Singularity

Modify the instructions and [sample Slurm batch file](https://gitlab.com/NVHPC/ngc-examples/-/raw/master/LBPM/2020.10/multi-node/slurm/run.sh) as follows:

```
wget https://gitlab.com/NVHPC/ngc-examples/-/raw/master/LBPM/2020.10/multi-node/slurm/run.sh
```

Update the run.sh filename, which you may want to rename to differ from the previous run.sh file:

```
#!/bin/bash
#SBATCH --job-name=lbpm      # Job name
#SBATCH --account=<accuont_name>    # Replace <account_name> accordingly    
#SBATCH --nodes=1                   # Use one node
#SBATCH --ntasks=1                  # Run a single task
#SBATCH --mem-per-cpu=10gb           # Memory per processor
#SBATCH --gres=gpu:1
module load singularity/3.7.1
module load cuda11.7/toolkit
module load openmpi/gcc/64/4.0.3rc4  
module load gcc/10.2.0
# Build SIF, if it doesn't exist
if [[ ! -f "lbpm.sif" ]]; then
    singularity build lbpm.sif docker://nvcr.io/hpc/LBPM:2020.10
fi
export BENCHMARK_DIR=$PWD
export GPU_ARCH="sm70" # Valid options are: sm60, sm70, sm75, sm80
singularity run -B $BENCHMARK_DIR:/host_pwd --nv lbpm.sif  bash -c 'cp -r /usr/local/LBPM_$GPU_ARCH/example/Sph1896/ /host_pwd/'
srun --mpi=pmi2 --ntasks-per-node=1 singularity run -B $BENCHMARK_DIR:/host_pwd --nv lbpm.sif  bash -c 'cd /host_pwd/Sph1896 && /usr/local/LBPM_$GPU_ARCH/bin/GenerateSphereTest input.db'
srun --mpi=pmi2 --ntasks-per-node=1 singularity run -B $BENCHMARK_DIR:/host_pwd --nv lbpm.sif  bash -c 'cd /host_pwd/Sph1896 && /usr/local/LBPM_$GPU_ARCH/bin/lbpm_color_simulator input.db'
```

Run the  script with sbatch:

```
sbatch run.sh
```

An output file will be created and should contain similar results:

```
********************************************************
Running Sphere Packing pre-processor for LBPM-WIA    
********************************************************
voxel length = 0.003125 micron 
Reading the sphere packing 
Reading the packing file...
Number of spheres extracted is: 1896
Domain set.
Sauter Mean Diameter (computed from sphere packing) = 34.151490 
Media porosity = 0.359970 
MorphOpen: Initializing with saturation 0.500000 
Media Porosity: 0.366707 
Maximum pore size: 14.075796 
Performing morphological opening with target saturation 0.500000 
Final saturation=0.503602
Final critical radius=4.793676
level=info msg="legacy OFED driver set: 4.9-0.1.7.0"
********************************************************
Running Color LBM    
********************************************************
MPI rank=0 will use GPU ID 0 / 1 
voxel length = 0.003125 micron 
voxel length = 0.003125 micron 
Read input media... 
Initialize from segmented data: solid=0, NWP=1, WP=2 
Media porosity = 0.359970 
Initialized solid phase -- Converting to Signed Distance function 
Domain set.
Create ScaLBL_Communicator 
Set up memory efficient layout, 11795503 | 11795520 | 33386248 
Allocating distributions 
Setting up device map and neighbor list 
Component labels: 1 
   label=0, affinity=-1.000000, volume fraction==0.652189
Initializing distributions 
Initializing phase field 
********************************************************
No. of timesteps: 3000 
Affinities - rank 0:
Main: 0
-------------------------------------------------------------------
********************************************************
CPU time = 0.046325 
Lattice update rate (per core)= 254.623329 MLUPS 
Lattice update rate (total)= 254.623329 MLUPS 
********************************************************
```

### **Running FSL in a Singularity container; notes for Mac OS X & XQuartz**

Recent versions of FSL are available in a Singularity container at the [Max Planck Institute for Human Development Git repo](https://github.com/MPIB/singularity-fsl). Follow the instructions to build the container. Using Windows, [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html) will work best. For Macs, [XQuartz](https://www.xquartz.org) is needed. If FSLEyes crashes with errors such as "The program 'fsleyes' received an X Window System error" follow the tips at [Running FSLeyes remotely](https://open.win.ox.ac.uk/pages/fsl/fsleyes/fsleyes/userdoc/troubleshooting.html#running-fsleyes-remotely) with special attention to [XQuartz - FSLeyes doesn’t start, and just shows an error](https://open.win.ox.ac.uk/pages/fsl/fsleyes/fsleyes/userdoc/troubleshooting.html#xquartz-fsleyes-doesn-t-start-and-just-shows-an-error).  If you still get errors running FSL or FSLEyes, run Apple's Software Update and reboot.

For multiple monitors on a Mac FSL and FSLEyes will start in a very stretched view and unable to see any menu options. We have a [PKL](https://fileinfo.com/extension/pkl) file that you can place in your  $HOME/.config/fsleyes/ directory. It is located in the RCS 'files' directory.

### **Mathematica**

The first time you launch Mathematica you will need to provide the host details of the MathLM (license) server. Using the [Activating Mathematica guide](https://reference.wolfram.com/language/tutorial/ActivatingMathematica.html), click 'Other ways to activate' then choose 'Connect to a Network License Server' and enter the IP address, 128.59.30.140

### **OpenMPI Settings**

The latest version of OpenMPI on Ginsburg is 4.1.5a1, which is provided by Nvidia Mellanox and optimized for the [MOFED stack](https://network.nvidia.com/products/infiniband-drivers/linux/mlnx_ofed/), and is installed on each compute node to increase performance. You will receive the following warnings when using `mpirun/mpiexec`:

```
WARNING: There was an error initializing an OpenFabrics device.

  Local host:   g###
  Local device: mlx5_0

Default device parameters will be used, which may result in lower performance. You can edit any of the files specified by the
btl_openib_device_param_files MCA parameter to set values for your device.

NOTE: You can turn off this warning by setting the MCA parameter btl_open ib_warn_no_device_params_found to 0.
```

You can pass the following option, which will use ucx which is [default as of version 3.x:](https://www.open-mpi.org/faq/?category=openfabrics#openfabrics-default-stack)

```
--mca pml ucx --mca btl '^openib' 
```

To help with the following warning:

```
Set MCA parameter "orte_base_help_aggregate" to 0 to see all help / error messages
```

You can also add:

```
--mca orte_base_help_aggregate 0
```

If you choose to use the openmpi/gcc/64/4.1.1\_cuda\_11.0.3\_aware module, this version expects a GPU and will throw the following warning on non-GPU nodes:

```
The library attempted to open the following supporting CUDA libraries, but each of them failed. CUDA-aware support is disabled.
libcuda.so.1: cannot open shared object file: No such file or directory
libcuda.dylib: cannot open shared object file: No such file or directory
/usr/lib64/libcuda.so.1: cannot open shared object file: No such file or directory
/usr/lib64/libcuda.dylib: cannot open shared object file: No such file or directory
```

If you are not interested in CUDA-aware support, then run with`--mca opal_warn_on_missing_libcuda 0` to suppress this message. If you are interested in CUDA-aware support, then try setting `LD_LIBRARY_PATH` to the location of [libcuda.so](http://libcuda.so/).1 to get passed this issue.

You can pass this option:

```
--mca opal_warn_on_missing_libcuda 0
```

### RStudio in a Singularity container

On Ginsburg, rstudio can be loaded by leveraging an interactive session, i.e., `srun`, and using a Singularity container via the [Rocker Project which provides containers](https://rocker-project.org/use/singularity.html) from where this tutorial comes . First you will need to download the Singularity image. This will require two terminal sessions. One session will be used to connect to a compute host and run `rstudio`. The other terminal session will be used to initiate [SSH Port Forwarding/Tunneling](https://www.ssh.com/academy/ssh/tunneling-example#what-is-ssh-port-forwarding,-aka-ssh-tunneling?) to access the resource. The first step is to request an interactive session so you can run `rstudio` server from a compute node as follows. Please be sure to change your group as noted by "`-A`".

```
srun -X -A <GROUP> --pty -t 0-02:00 -X /bin/bash

OR, if you want a GPU node

srun -X -A <GROUP> --pty -t 0-02:00 -X --gres=gpu:1 /bin/bash
```

**NEXT**, a number of steps need to be done that have been collected into a simple script.

Type "RSserver.sh" (without the quotes) to execute the container setup script. For those interested, the script echos the commands it's running as it runs them.

### NOTE:

IF YOU GET AN ERROR  such as `[rserver] ERROR system error 98 (Address already in use)`

simply re-run the script and enter a different port number instead of the default of 8787 (the script will prompt you). Try 8788,  or 8789, etc

**PART 2:  Port forwarding and access from your browser**

The Rstudio server is now running in a container in one window.  Now you will open another window and create a Port Forwarding connection so your web browser will be able to connect to a port on your local machine, that forwards the connection to the remote container.

If you're on a Mac or Linux machine, open a second Terminal and start the RStudio `rserver` port forwarding with the below command:

```
ssh -Nf -L 8787:10.197.16.39:8787 myUNI@burg.rcs.columbia.edu    <-- the "10.197.16.39" IP number is ONLY for demonstration. The above script will have given you the real IP you will be using.
```

NOTE FOR WINDOWS USERS:

If you are using Windows Subsystem for Linux (WSL/WSL2), then the above line work fine, BUT remember to forward the WSL session ports to the Windows browser. Set the System Browser as the WSL default to open links.

Other Windows users instead need to refer to the port forwarding directions below.

The above Port Forwarding line works on Linux/Unix/MacOS, or any virtual machine running Linux. For Windows, we are assuming you are using PuTTY and the above line would be accomplished using the alternative steps below:

I.    Launch PuTTY

II.   In the "Session" category (the default screen when you open PuTTY), enter burg`.rcs.columbia.edu` in the "Host Name (or IP address)" field.

III.   Ensure the "Port" field is set to `22`, which is the default SSH port.       Optionally, you can enter a name in the "Saved Sessions" field and click "Save" to save these settings for future re-use

IV.   In the "Category" pane on the left, expand the "SSH" category by clicking the `+` sign next to it.

V.    Click on "Tunnels" under the "SSH" category.

VI.   In the "Source port" field, enter `8787`.

VII.   In the "Destination" field, enter `10.197.16.39:8787`.    (Remember,  1`0.197.16.39` is only an example IP, your actual one may be different)

VIII.   Click the "Add" button. You should see the forwarded port appear in the list box as `L8787 10.197.16.39:8787`.

IX.     Optional but recommended,   To save this configuration for future use, go back to the "Session" category, and enter a name for the session in the "Saved Sessions" field (e.g., [<](mailto:MyAccount@thanos.nyu.edu)`myuni>@burg.rcs.columbia.edu`) and click the "Save" button.

X.      Click the "Open" button at the bottom of the PuTTY window and connect to burg.rcs.columbia.edu

**Next, use a web browser to connect to to your locally forwarded port.**

In any web browser, e.g., Google Chrome, Safari or Edge, enter `localhost:8787 (or a different number after the colon, if you received an error above and had to choose another port)`.

The login screen for RStudio will appear and you enter your UNI (without the @columbia.edu) and whatever password you entered in the setup script.

A sample Slurm bash script is available at [Rocker Project's Singularity page](https://rocker-project.org/use/singularity.html#slurm-job-script).

\*\*\*IMPORTANT NOTE\*\*\*

**When you are finished** with RStudio remember to stop the Singularity session via ctl-c, and you can kill the SSH forwarding session by finding the process ID (PID) with the following command, noting that the PID is the second column:

```
ps -ef | grep 8787
  503 82438     1   0 10:56AM ??         0:00.31 ssh -Nf -L 8787:10.197.16.39:8787 myUNI@burg.rcs.columbia.edu
kill -9 82438
```

### Visual Studio Code Server

A pre-existing Github account is now required to use the below instructions. Create one first if you do not have one.

Visual Studio Code is an Integrated Development Environment that some like to use on their laptops. If you are familiar with that, the HPC has a server-side version hosted on the compute nodes (NOT the login nodes) for users to connect their local VS Code application on their laptop to Ginsburg and open files from their Ginsburg folder directly.  To use it, do the following:

After logging into Ginsburg, start an srun session to a CPU or GPU node of your choice:

```
srun --pty -t 0-01:00  -A <ACCOUNT> /bin/bash

     OR, if you need a GPU

srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

Then type

```
$ code tunnel
```

You will get a message like the one below:

```
* Visual Studio Code Server

*

* By using the software, you agree to

* the Visual Studio Code Server License Terms (https://aka.ms/vscode-server-license) and

* the Microsoft Privacy Statement (https://privacy.microsoft.com/en-US/privacystatement).

*

[2024-04-05 16:12:16] info Using Github for authentication, run `code tunnel user login --provider <provider>` option to change this.

To grant access to the server, please log into https://github.com/login/device and use code <###-###>
```

When you use the device login url, you will first get a page asking you to use your GitHub credentials to login.

After using your GitHub login, then you will get a page asking you to input the device code  given you above (represented as <###-###> here)

Next you will see a page requesting you to authorize VS Code studio's access permissions.

After that, when you use your local VS Code application on your computer, you will see a running ssh tunnel listed. Double click to connect to it. This can take a moment to finish.

Once done, you will be able to open files in your Ginsburg folder the same as you do ones on your local computer.

It's possible that the next time you try to use the tunnel you've just made, you may not be able to re-connect. The connection may keep trying endlessly, or finally fail with an error. This is because the srun session in the first step has placed you on another node different from the one where you created the tunnel. **IF** that happens, follow the steps below:

1) In your local VSCode app (if you use a local copy of VS Code and not the browser-based window version), unregister/delete all of your existing tunnels. We’ll be making a new one.

2) Login to Ginsburg. Do not start an srun session yet.

3) Delete your invisible vscode settings folders in your home directory  (" `rm -r .vscode*`")

4) Start an srun session as described above, type "code tunnel", and follow all of the directions as normal. Open VScode in the web browser first. It will take a moment as the new tunnel is created. If you only use VS Code in the browser, you are now done.

5) If you prefer to use a local copy of VS Code on your computer, you can now connect to this tunnel in it. WINDOWS USERS, additionally you may need to downgrade your local copy of Visual Studio Code to version 1.8.1 due to a bug existing as of this writing (8/28/2024).
