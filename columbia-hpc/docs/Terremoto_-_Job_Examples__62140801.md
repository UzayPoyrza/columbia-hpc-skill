# Terremoto - Job Examples

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62140801/Terremoto+-+Job+Examples

---

- [Hello World](#Terremoto-JobExamples-HelloWorld)
- [C/C++/Fortran](#Terremoto-JobExamples-C/C++/Fortran)
- [C/C++/Fortran MPI](#Terremoto-JobExamples-C/C++/FortranMPI)
- [GPU (CUDA C/C++)](#Terremoto-JobExamples-GPU(CUDAC/C++))
- [Singularity](#Terremoto-JobExamples-Singularity)
- [Installing R Packages on Terremoto](#Terremoto-JobExamples-InstallingRPackagesonTerremoto)
- [Local Installation](#Terremoto-JobExamples-LocalInstallation)
- [MATLAB](#Terremoto-JobExamples-MATLAB)
- [Python and JULIA](#Terremoto-JobExamples-PythonandJULIA)
- [Tensorflow](#Terremoto-JobExamples-Tensorflow)
- [Jupyter Notebooks](#Terremoto-JobExamples-JupyterNotebooks)

In order for the scripts in these examples to work, you will need to replace <ACCOUNT> with your group's account name.

## Hello World

This script will print "Hello World", sleep for 10 seconds, and then print the time and date. The output will be written to a file in your current directory.

```
#!/bin/sh
#
# Simple "Hello World" submit script for Slurm.
#
# Replace <ACCOUNT> with your account name before submitting.
#
#SBATCH --account=<ACCOUNT>      # The account name for the job.
#SBATCH --job-name=HelloWorld    # The job name.
#SBATCH -c 1                     # The number of cpu cores to use.
#SBATCH --time=1:00              # The time the job will take to run.
#SBATCH --mem-per-cpu=1gb        # The memory the job will use per cpu core.

echo "Hello World"
sleep 10
date

# End of script
```

## C/C++/Fortran

To submit a precompiled binary to run on Terremoto, the script will look just as it does in the Hello World example. The difference is that you will call your executable file instead of the shell commands "echo", "sleep", and "date".

## C/C++/Fortran MPI

#### Intel Parallel Studio

Terremoto supports Intel Parallel Studio which provides a version of MPI derived from MPICH2. We encourage users to avail themselves of Intel MPI because it is faster and more modern than other versions. Also, all nodes on the cluster have Infiniband transport and that is the fabric that MPI jobs avail themselves of - which is another reason for a substantial boost of efficiency on the cluster.

To use Intel MPI, you must load the Intel module first:

```
module load intel-parallel-studio/2017
mpiexec -bootstrap slurm ./myprogram
```

In order to take advantage of Terremoto architecture, your program should be (re)compiled on the cluster even if you used Intel for compiling it on another cluster. It is important to compile with the compiler provided by the module mentioned above. Note that you may have to set additional environment variables in order to successfully compile your program.

These are the locations of the C and Fortran compilers for Intel Studio:

```
$ module load intel-parallel-studio/2017
(...)
$ which mpiicc
/moto/opt/parallel_studio_xe_2017/compilers_and_libraries_2017.0.098/linux/mpi/intel64/bin/mpiicc 

$ which ifort
/moto/opt/parallel_studio_xe_2017/compilers_and_libraries_2017.0.098/linux/bin/intel64/ifort
```

For programs written in C, use mpiicc in order to compile them:

```
$ mpiicc -o <MPI_OUTFILE> <MPI_INFILE.c>
```

The submit script below, named pi\_mpi.sh, assumes that you have compiled a simple MPI program used to compute pi, (see [mpi\_test.c](https://columbiauniversity.atlassian.net/wiki/download/attachments/62135732/mpi_test.c?version=1&modificationDate=1351290549000&cacheVersion=1&api=v2)), and created a binary called pi\_mpi:

```
#!/bin/sh

#SBATCH -A <ACCOUNT>

#SBATCH --time=30
#SBATCH -N 2
#SBATCH --exclusive

module load intel-parallel-studio/2017

mpiexec -bootstrap slurm ./pi_mpi

# End of script
```

The --exclusive flag will ensure that full nodes are being used in the runs (that's the reason why no memory specification is given). Each available core will give rise to another MPI thread. Without the flag, you can specify the number of tasks, or tasks per node, in order to limit the number of threads that will be created. For example, you can replace the directive containing the flag by:

```
#SBATCH -N 2
#SBATCH --ntasks-per-node=4
```

- and your MPI code will run on 8 threads, with 4 on each of the 2 nodes requested.

###### Job Submission

```
$ sbatch pi_mpi.sh
```

#### OpenMPI

Terremoto supports also OpenMPI from the GNU family.

To use OpenMPI, you must load the following module instead:

```
module load openmpi/gcc/64
mpiexec myprogram
```

Your program must be compiled on the cluster. You can use the the module command as explained above to set your path so that the corresponding mpicc will be found. Note that you may have to set additional environment variables in order to successfully compile your program.

```
$ module load openmpi/gcc/64
$ which mpicc
/moto/opt/openmpi-2.0.1/bin/mpicc
```

Compile your program using mpicc. For programs written in C:

```
$ mpicc -o <MPI_OUTFILE> <MPI_INFILE.c>
```

## GPU (CUDA C/C++)

The cluster includes **8 Nvidia V100 GPU servers each with 2 GPU modules** per server.

To use a GPU server you must specify the **--gres=gpu** option in your submit request, followed by a colon and the number of GPU modules you require (with a maximum of 2 per server).

Request a **v100**gpu, specify this in your submit script.

```
#SBATCH --gres=gpu
```

Not all applications have GPU support, but some, such as MATLAB, have built-in GPU support and can be configured to use GPUs.

To build your CUDA code and run it on the GPU modules you must first set your paths so that the Nvidia compiler can be found. Please note you must be logged into a GPU node to access these commands. To login interactively to a GPU node, run the following command, replacing <ACCOUNT> with your account.

```
$ srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

Load the cuda environment module which will add cuda to your PATH and set related environment variables. Note cuda 8.0 does not support gcc 6, so gcc 5 or earlier must be accessible in your environment when running nvcc.

```
$ module load gcc/4.8.5
```

Load the cuda module.

```
$ module load cuda92/toolkit
```

You then have to compile your program using [nvcc](http://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/):

```
$ nvcc -o <EXECUTABLE_NAME> <FILE_NAME.cu>
```

You can compile [hello\_world.cu](https://columbiauniversity.atlassian.net/wiki/download/attachments/62138761/hello_world.cu?version=1&modificationDate=1479195540000&cacheVersion=1&api=v2) sample code which can be built with the following command:

```
$ nvcc -o hello_world hello_world.cu
```

For non-trivial code samples, refer to Nvidia's [CUDA Toolkit Documentation](http://docs.nvidia.com/cuda/cuda-samples/#samples-reference).

A Slurm script template, gpu.sh, that can be used to submit this job is shown below:

```
#!/bin/sh
#
#SBATCH --account=<ACCOUNT>      # The account name for the job.
#SBATCH --job-name=HelloWorld    # The job name.
#SBATCH --gres=gpu:1             # Request 1 gpu (Up to 2 on Terremoto's V100 nodes).
#SBATCH -c 1                     # The number of cpu cores to use.
#SBATCH --time=1:00              # The time the job will take to run.
#SBATCH --mem-per-cpu=1gb        # The memory the job will use per cpu core.

module load cuda92/toolkit
./hello_world

# End of script
```

#### Job submission

```
$ sbatch gpu.sh
```

This program will print out "Hello World!" when run on a gpu server or print "Hello Hello" when no gpu module is found.

## Singularity

[Singularity](https://www.sylabs.io/singularity/) is a software tool that brings Docker-like containers and reproducibility to scientific computing and HPC. Singularity has Docker container support and enables users to easily  run different flavors of Linux with different software stacks. These containers provide a single universal on-ramp from the laptop, to HPC, to cloud.

Users can run Singularity containers just as they run any other program on our HPC clusters. Example usage of Singularity is listed below. For additional details on how to use Singularity, please contact us or refer to the [Singularity User Guide](https://www.sylabs.io/guides/2.6/user-guide/index.html).

### **Downloading Pre-Built Containers**

Singularity makes it easy to quickly deploy and use software stacks or new versions of software. Since Singularity has Docker support, users can simply pull existing Docker images from [Docker Hub](https://hub.docker.com/) or download docker images directly from software repositories that increasingly support the Docker format. [Singularity Container Library](https://cloud.sylabs.io/library) also provides a number of additional containers.

You can use the [pull](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#pull-command) command to download pre-built images from an external resource into your current working directory. The docker:// uri reference can be used to pull Docker images. Pulled Docker images will be automatically converted to the Singularity container format. 

This example pulls the default Ubuntu docker image from docker hub.

```
$ singularity pull docker://ubuntu
```

### Running Singularity Containers

Here's an example of pulling the latest stable release of the [Tensorflow Docker image](https://www.tensorflow.org/install/docker) and running it with Singularity. (Note: these pre-built versions may not be optimized for use with our CPUs.)

First, load the Singularity software into your environment with:

```
$ module load singularity
```

```

```

Then pull the docker image. This also converts the downloaded docker image to Singularity format and save it in your current working directory:

```
$ singularity pull docker://tensorflow/tensorflow
```

```
Done. Container is at: ./tensorflow.simg
```

Once you have download a container, you can run it interactively in a shell or in batch mode.

### Singularity - Interactive Shell

The [shell](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#shell-command) command allows you to spawn a new shell within your container and interact with it as though it were a small virtual machine:

```
$ singularity shell tensorflow.simg
```

```
Singularity: Invoking an interactive shell within container...
```

From within the Singularity shell, you will see the Singularity prompt and can run the downloaded software. In this example, python is launched and tensorflow is loaded.

```
Singularity tensorflow.simg:~> python
>>> import tensorflow as tf
>>> print(tf.__version__)
1.13.1
>>> exit()
```

When done, you may exit the Singularity interactive shell with the "exit" command.

```
Singularity tensorflow.simg:~> exit
```

### Singularity: Executing Commands

The [exec](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#exec-command) command allows you to execute a custom command within a container by specifying the image file. This is the way to invoke commands in your job submission script.

```
$ module load singularity
```

```
$ singularity exec tensorflow.simg [command]
```

```

```

For example, to run python example above using the exec command:

```
$ singularity exec tensorflow.simg python -c 'import tensorflow as tf; print(tf.__version__)'
```

```

```

### Singularity: Running a Batch Job

Below is an example of job submission script named **submit.sh** that runs Singularity. Note that you may need to specify the full path to the Singularity image you wish to run.

```
#!/bin/bash
# Singularity example submit script for Slurm.
#
# Replace <ACCOUNT> with your account name before submitting.
#
#SBATCH -A <ACCOUNT>           # Set Account name
#SBATCH --job-name=tensorflow  # The job name
#SBATCH -c 1                   # Number of cores
#SBATCH -t 0-0:30              # Runtime in D-HH:MM
#SBATCH --mem-per-cpu=4gb      # Memory per cpu core

module load singularity
singularity exec tensorflow.simg python -c 'import tensorflow as tf; print(tf.__version__)'
```

Then submit the job to the scheduler. This example prints out the tensorflow version.

```
$ sbatch submit.sh
```

```

```

For additional details on how to use Singularity, please contact us or refer to the [Singularity User Guide](https://www.sylabs.io/guides/2.6/user-guide/index.html).

### Swak4FOAM in a Singularity container

Swak4FOAM (SWiss Army Knife for Foam) can be run inside a container. Using [this Docker container](https://hub.docker.com/r/hfdresearch/swak4foamandpyfoam) as inspiration, here is a sample tutorial.

```
module load singularity 
singularity pull docker://hfdresearch/swak4foamandpyfoam:latest-v7.0
singularity shell swak4foamandpyfoam_latest-v7.0.sif
```

From the [pulsedPitzDaily tutorial](https://hub.docker.com/r/hfdresearch/swak4foamandpyfoam) about halfway down the page, change to use `/local` as it has more space than `/tmp`:

```
source /opt/openfoam7/etc/bashrc
cd /local
cp -r /opt/swak4Foam/Examples/groovyBC/pulsedPitzDaily .
cd pulsedPitzDaily
pyFoamPrepareCase.py .
```

You should see the following output:

```
Looking for template values .

Used values

              Name - Value
----------------------------------------
          caseName - "pulsedPitzDaily"
          casePath - "/local/pulsedPitzDaily"
          foamFork - openfoam
       foamVersion - 7
numberOfProcessors - 1

No script ./derivedParameters.py for derived values
Clearing .
Clearing /local/pulsedPitzDaily/PyFoam.blockMesh.logfile
Clearing /local/pulsedPitzDaily/PyFoamPrepareCaseParameters
Writing parameters to ./PyFoamPrepareCaseParameters
Writing report to ./PyFoamPrepareCaseParameters.rst
Found 0.org . Clearing 0

Looking for templates with extension .template in  /local/pulsedPitzDaily
Looking for templates with extension .template in  /local/pulsedPitzDaily/0.org
Looking for templates with extension .template in  /local/pulsedPitzDaily/constant
Looking for templates with extension .template in  /local/pulsedPitzDaily/constant/polyMesh
Found template for /local/pulsedPitzDaily/constant/LESProperties
Found template for /local/pulsedPitzDaily/constant/turbulenceProperties
Looking for templates with extension .template in  /local/pulsedPitzDaily/system

No script for mesh creation found. Looking for 'blockMeshDict'
/local/pulsedPitzDaily/constant/polyMesh/blockMeshDict found. Executing 'blockMesh'
/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Version:  7
     \\/     M anipulation  |
\*---------------------------------------------------------------------------*/
Build  : 7-1ff648926f77
Exec   : blockMesh -case /local/pulsedPitzDaily
Date   : May 03 2023
Time   : 16:23:59
PID    : 2082964
I/O    : uncollated
Case   : /local/pulsedPitzDaily
nProcs : 1
sigFpe : Enabling floating point exception trapping (FOAM_SIGFPE).
fileModificationChecking : Monitoring run-time modified files using timeStampMaster (fileModificationSkew 10)
allowSystemOperations : Allowing user-supplied system call operations

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
Create time

Not deleting polyMesh directory
    "/local/pulsedPitzDaily/constant/polyMesh"
    because it contains blockMeshDict
Creating block mesh from
    "/local/pulsedPitzDaily/constant/polyMesh/blockMeshDict"
Creating block edges
No non-planar block faces defined
Creating topology blocks
Creating topology patches

Reading patches section

Creating block mesh topology

Reading physicalType from existing boundary file

Default patch type set to empty

Check topology

    Basic statistics
        Number of internal faces : 18
        Number of boundary faces : 42
        Number of defined boundary faces : 42
        Number of undefined boundary faces : 0
    Checking patch -> block consistency

Creating block offsets
Creating merge list .

Creating polyMesh from blockMesh
Creating patches
Creating cells
Creating points with scale 0.001
    Block 0 cell size :
        i : 0.00158284 .. 0.000791418
        j : 0.000313389 .. 0.000564101
        k : 0.001
    Block 1 cell size :
        i : 0.00158284 .. 0.000791418
        j : 0.000440611 .. 0.00176244
        k : 0.001
    Block 2 cell size :
        i : 0.00158284 .. 0.000791418
        j : 0.00178262 .. 0.000445655
        k : 0.001
    Block 3 cell size :
        i : 0.000528387 .. 0.00211355
        j : 0.00113333 .. 0.00113333 0.00113283 .. 0.00113283 0.00113333 .. 0.00113333 0.00113283 .. 0.00113283
        k : 0.001
    Block 4 cell size :
        i : 0.000528464 .. 0.00211385 0.000528454 .. 0.00211383 0.000528464 .. 0.00211385 0.000528454 .. 0.00211383
        j : 0.000766355 .. 0.000383178 0.000766938 .. 0.000384514 0.000766355 .. 0.000383178 0.000766938 .. 0.000384514
        k : 0.001
    Block 5 cell size :
        i : 0.000528387 .. 0.00211355
        j : 0.000313389 .. 0.000564101 0.000314853 .. 0.00056517 0.000313389 .. 0.000564101 0.000314853 .. 0.00056517
        k : 0.001
    Block 6 cell size :
        i : 0.000528464 .. 0.00211385 0.000528492 .. 0.00211397 0.000528464 .. 0.00211385 0.000528492 .. 0.00211397
        j : 0.000440611 .. 0.00176244 0.000442137 .. 0.00176067 0.000440611 .. 0.00176244 0.000442137 .. 0.00176067
        k : 0.001
    Block 7 cell size :
        i : 0.000528502 .. 0.00211401 0.000528472 .. 0.00211389 0.000528502 .. 0.00211401 0.000528472 .. 0.00211389
        j : 0.00178262 .. 0.000445655 0.00178107 .. 0.000445268 0.00178262 .. 0.000445655 0.00178107 .. 0.000445268
        k : 0.001
    Block 8 cell size :
        i : 0.0020578 .. 0.00514451 0.00205689 .. 0.00514223 0.0020578 .. 0.00514451 0.00205689 .. 0.00514223
        j : 0.000938889 0.000929955 .. 0.000929955 0.000938889 0.000929955 .. 0.000929955
        k : 0.001
    Block 9 cell size :
        i : 0.00204731 .. 0.00511826 0.00204716 .. 0.0051179 0.00204731 .. 0.00511826 0.00204716 .. 0.0051179
        j : 0.000944444 .. 0.000944444 0.000938489 .. 0.000938489 0.000944444 .. 0.000944444 0.000938489 .. 0.000938489
        k : 0.001
    Block 10 cell size :
        i : 0.0020466 .. 0.00511651
        j : 0.000928571 .. 0.000928571 0.00092161 .. 0.00092161 0.000928571 .. 0.000928571 0.00092161 .. 0.00092161
        k : 0.001
    Block 11 cell size :
        i : 0.00204718 .. 0.00511796 0.00204744 .. 0.0051186 0.00204718 .. 0.00511796 0.00204744 .. 0.0051186
        j : 0.00105 .. 0.00105 0.00104025 .. 0.00104025 0.00105 .. 0.00105 0.00104025 .. 0.00104025
        k : 0.001
    Block 12 cell size :
        i : 0.00205182 .. 0.00512954 0.00205252 .. 0.00513131 0.00205182 .. 0.00512954 0.00205252 .. 0.00513131
        j : 0.00117906 .. 0.000294764 0.00116948 .. 0.00029237 0.00117906 .. 0.000294764 0.00116948 .. 0.00029237
        k : 0.001

Adding cell zones
    0    center

Writing polyMesh
----------------
Mesh Information
----------------
  boundingBox: (-0.0206 -0.0254 -0.0005) (0.29 0.0254 0.0005)
  nPoints: 25012
  nCells: 12225
  nFaces: 49180
  nInternalFaces: 24170
----------------
Patches
----------------
  patch 0 (start: 24170 size: 30) name: inlet
  patch 1 (start: 24200 size: 57) name: outlet
  patch 2 (start: 24257 size: 223) name: upperWall
  patch 3 (start: 24480 size: 250) name: lowerWall
  patch 4 (start: 24730 size: 24450) name: frontAndBack

End

No mesh decomposition necessary
Looking for originals in /local/pulsedPitzDaily
Looking for originals in /local/pulsedPitzDaily/constant
Looking for originals in /local/pulsedPitzDaily/constant/polyMesh
Looking for originals in /local/pulsedPitzDaily/system
Copying /local/pulsedPitzDaily/0.org to /local/pulsedPitzDaily/0

No field decomposition necessary
Looking for templates with extension .postTemplate in  /local/pulsedPitzDaily
Looking for templates with extension .postTemplate in  /local/pulsedPitzDaily/0.org
Looking for templates with extension .postTemplate in  /local/pulsedPitzDaily/constant
Looking for templates with extension .postTemplate in  /local/pulsedPitzDaily/constant/polyMesh
Looking for templates with extension .postTemplate in  /local/pulsedPitzDaily/system
Looking for templates with extension .postTemplate in  /local/pulsedPitzDaily/0

No script for case-setup found. Nothing done

No case decomposition necessary
Looking for templates with extension .finalTemplate in  /local/pulsedPitzDaily
Looking for templates with extension .finalTemplate in  /local/pulsedPitzDaily/0.org
Looking for templates with extension .finalTemplate in  /local/pulsedPitzDaily/constant
Looking for templates with extension .finalTemplate in  /local/pulsedPitzDaily/constant/polyMesh
Looking for templates with extension .finalTemplate in  /local/pulsedPitzDaily/system
Looking for templates with extension .finalTemplate in  /local/pulsedPitzDaily/0
Clearing templates
Looking for extension .template in /local/pulsedPitzDaily/0
Looking for extension .postTemplate in /local/pulsedPitzDaily/0
Looking for extension .finalTemplate in /local/pulsedPitzDaily/0

Case setup finished
```

Example of R run

For this example, the R code below is used to generate a graph ''Rplot.pdf'' of a discrete Delta-hedging of a call. It hedges along a path and repeats over many paths. There are two R files required:

[hedge.R](https://columbiauniversity.atlassian.net/wiki/download/attachments/62135816/hedge.R.txt?version=1&modificationDate=1351284524000&cacheVersion=1&api=v2)

[BlackScholesFormula.R](https://columbiauniversity.atlassian.net/wiki/download/attachments/62135816/blackscholesformula.R.txt?version=1&modificationDate=1351284673000&cacheVersion=1&api=v2)

A Slurm script, hedge.sh, that can be used to submit this job is presented below:

```
#!/bin/sh
#hedge.sh
#Slurm script to run R program that generates graph of discrete Delta-hedging call

#Slurm directives
#
#SBATCH -A astro                 # The account name for the job.
#SBATCH -J DeltaHedge            # The job name.
#SBATCH -c 6                     # The number of cpu cores to use.
#SBATCH -t 1:00                  # The time the job will take to run.
#SBATCH --mem-per-cpu 1gb        # The memory the job will use per cpu core.

module load R

#Command to execute R code
R CMD BATCH --no-save --vanilla hedge.R routput

# End of script
```

#### Batch queue submission

```
$ sbatch hedge.sh
```

This program will leave several files in the output directory: slurm-<jobid>.out, Rplots.pdf, and routput (the first one will be empty).

## Installing R Packages on Terremoto

HPC users can Install R packages locally in their home directory or group's scratch space (see below).

## Local Installation

After logging in to Terremoto, start R:

```
$ module load R

$ R
```

You can see the default library paths (where R looks for packages) by calling .libPaths():

```
> .libPaths()
[1] "/moto/opt/R-3.5.1/lib64/R/library"
```

These paths are all read-only, and so you cannot install packages to them. To fix this, we will tell R to look in additional places for packages.

Exit R and create a directory rpackages in /moto/<GROUP>/users/<UNI>/.

```
$ mkdir /moto/<GROUP>/users/<UNI>/rpackages
```

Go back into R and add this path to .libPaths()

```
$ R
> .libPaths("/moto/<GROUP>/users/<UNI>/rpackages/")
```

Call .libPaths() to make sure the path has been added

```
> .libPaths()
[1] "/moto/<GROUP>/users/<UNI>/rpackages/"
[2] "/usr/lib64/R/site-library"
[3] "/usr/lib64/R/library"
```

To install a package, such as the "sm" package, tell R to put the package in your newly created local library:

```
> install.packages("sm", lib="/moto/<GROUP>/users/<UNI>/rpackages")
```

Select appropriate mirror and follow install instructions.

Test to see if package can be called:

```
> library(sm)
Package `sm', version 2.2-3; Copyright (C) 1997, 2000, 2005, 2007 A.W.Bowman & A.Azzalinitype
help(sm) for summary information
```

In order to access this library from your programs, **make sure** you add the following line to the top of every program:

```
.libPaths("/moto/<GROUP>/users/<UNI>/rpackages/")
```

Since R will know where to look for libraries, a call to library(sm) will be successful (however, this line is not necessary per se for the install.packages(...) call, as the directory is already specified in it).

## MATLAB

### MATLAB (single thread)

The file linked below is a MATLAB M-file containing a single function, simPoissGLM, that takes one argument (lambda).

[simPoissGLM.m](https://columbiauniversity.atlassian.net/wiki/download/attachments/62135832/simpoissglm.m.txt?version=1&modificationDate=1351290771000&cacheVersion=1&api=v2)

A Slurm script, simpoiss.sh, that can be used to submit this job is presented below (implicitly, --cpu-per-task=1).

```
#!/bin/sh
#
# Simple MATLAB submit script for Slurm.
#
#
#SBATCH -A astro                 # The account name for the job.
#SBATCH -J SimpleMLJob           # The job name.
#SBATCH -t 1:00                  # The time the job will take to run.
#SBATCH --mem-per-cpu=1gb        # The memory the job will use per cpu core.

module load MATLAB  echo "Launching an MATLAB run"
date

#define parameter lambda
LAMBDA=10

#Command to execute MATLAB code MATLAB -nosplash -nodisplay -nodesktop -r "simPoissGLM($LAMBDA)" # > matoutfile

# End of script
```

#### Batch queue submission

```
$ sbatch simpoiss.sh
```

This program will leave several files in the output directory: `slurm-<jobid>.out`, `out.mat`, and `matoutfile`.

### MATLAB with Parallel Server

**Running MATLAB via X11 Forwarding**

MATLAB Parallel Server is now configured on Terremot for R2020b and R2022a. Note that MATLAB 2023a and greater cannot be installed due to [kernel and minimum version of](https://www.mathworks.com/support/requirements/matlab-linux.html) Red Hat 7.9. [X11 Forwarding](https://goteleport.com/blog/x11-forwarding/) is available and for Apple Mac computers, [XQuartz](https://www.xquartz.org/) is recommended and for Windows, [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html). The first time you run MATLAB via X11, it can take a few minutes to fully open, especially over WiFi.  You can run one simple command to enable the Toolbox:

```
>> configCluster
```

You should see:

```
Must set AccountName before submitting jobs to TERREMOTO.  E.g.
```

```
    >> c = parcluster;  
    >> c.AdditionalProperties.AccountName = 'group-account-name';  
    >> c.saveProfile  
  
Complete.  Default cluster profile set to "Terremoto".
```

**Running MATLAB From Your Desktop/Laptop**

You can now also install MATLAB on your laptop/desktop and download it from [MathWorks Columbia page](https://www.mathworks.com/academia/tah-portal/columbia-university-650045.html), where students can download it for free, and currently only 2022b and 2020b are supported. You will need to [download a zip file](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140801/Parallel-Computing-Workshop.zip?version=1&modificationDate=1696436975000&cacheVersion=1&api=v2) which contains all the necessary integration scripts including the license. You will also need to be on the Columbia WiFi or VPN and copy the network.lic file into your device's MATLAB directory. On a Mac, you would use Finder, Applications, MATLAB, ctl-click the mouse, Show Package Contents, then licenses. Alternately you can run the `userpath` command. In MATLAB, navigate to the Coumbia-University.Desktop folder. In the Command Window type `configCluster`. You will be prompted for Ginsburg and Terremoto, select 2, for Terremoto. Enter your UNI (without @columbia.edu). You should see:

```
>> c = parcluster;  
    >> c.AdditionalProperties.AccountName = 'group-account-name';  
    >> c.saveProfile  
  
Complete.  Default cluster profile set to "Terremoto".
```

Inside the zip file is a Getting Started tutorial in a Word document. You can start with getting a handle to the cluster:

```
>> c = parcluster;
```

Submission to the remote cluster requires SSH credentials.  You will be prompted for your SSH username and password or identity file (private key).  The username and location of the private key will be stored in MATLAB for future sessions. Jobs will now default to the cluster rather than submit to the local machine.

**Configuring Jobs**

Prior to submitting the job, we can specify various parameters to pass to our jobs, such as queue, e-mail, walltime, etc. See AdditionalProperties for the complete list.  AccountName and MemPerCPU are the only fields that are mandatory.

```
>> % Specify the account  
>> c.AdditionalProperties.AccountName = 'group-account-name';  
  
>> % Specify memory to use, per core (default: 4gb)  
>> c.AdditionalProperties.MemPerCPU = '6gb';
```

## Python and JULIA

To use python you need to use:

```
$ module load anaconda
```

Here's a simple python program called "example.py" – it has just one line:

print ("Hello, World!")

To submit it on the Terremoto Cluster, use the submit script "example.sh"

(\*\*\* use "astro" if you are a member of "astro" group, otherwise use your group name):

```
#!/bin/sh
#
# Simple "Hello World" submit script for Slurm.
#
#SBATCH --account=astro # The account name for the job.
#SBATCH --job-name=HelloWorld # The job name.
#SBATCH -c 1 # The number of cpu cores to use.
#SBATCH --time=1:00 # The time the job will take to run.
#SBATCH --mem-per-cpu=1gb # The memory the job will use per cpu core.

module load anaconda

#Command to execute Python program
python example.py

#End of script
```

If you use "ls" command you should see 2 programs:

```
example.sh
example.py
```

To submit it - please use:

```
$ sbatch example.sh
```

To check the output use:

```
$ cat slurm-463023.out
Hello, World!
```

Similarly, here is the "julia\_example.jl" with just one line

```
$ cat julia_example.jl
println("hello world")
```

and

```
$ cat julia_example.sh
```

```
#!/bin/sh
#
# Simple "Hello World" submit script for Slurm.
#
#SBATCH --account=hblab # The account name for the job.
#SBATCH --job-name=HelloWorld # The job name.
#SBATCH -c 1 # The number of cpu cores to use.
#SBATCH --time=1:00 # The time the job will take to run.
#SBATCH --mem-per-cpu=1gb # The memory the job will use per cpu core.

module load julia

#Command to execute Python program
julia julia_example.jl

#End of script
```

After you finish creating those two files, if you use "ls"command you should see:

```
julia_example.jl
julia_example.sh
```

To submit it use:

```
$ sbatch julia_example.sh
Submitted batch job 463030
```

To check the output

```
$ cat slurm-463030.out
hello world
```

Julia Interactive Session Usage:

Step 1 >> start an interactive session (\*\*\* use "astro" if you are a member of "astro" group, otherwise use your group name):

```
$ srun --pty -t 0-04:00 -A astro /bin/bash
$ module load julia
$ julia julia_example.jl
hello world

$ julia
_
_ _ _(_)_ | A fresh approach to technical computing
() | () (_) | Documentation: http://docs.julialang.org&nbsp;
_ _ _| |_ __ _ | Type "?help" for help.
| | | | | | |/ _` | |
| | || | | | (| | | 
_/ |_'|||_'| | Official http://julialang.org/ release
|__/ | x86_64-pc-linux-gnu

julia>

To quit Julia use "CTRL +D"
```

Julia packages can be installed with this command (for example "DataFrames" package):

```
julia> using Pkg
julia> Pkg.add("DataFrames")
```

Please check this website:  
<https://pkg.julialang.org/docs/>  
to see the full list of the official packages available.

## Tensorflow

Tensorflow computations can use CPUs or GPUs. The default is to use CPUs which are more prevalent, but typically slower than GPUs.

### Tensorflow for CPUs

Tensorflow (optimized for Terremoto CPUs) and Keras are available by loading the **anaconda/3-2018.12** module:

```
$ module load anaconda/3-2018.12  
  
$ python  
Python 3.7.1 (default, Dec 14 2018, 19:28:38)  
>>> import tensorflow as tf  
>>> print(tf.__version__)  
1.13.1  
>>> import keras  
Using TensorFlow backend.  
>>> print(keras.__version__)  
2.2.4  
>>> exit()
```

### Tensorflow with GPU Support

The following describes how you to run tensorflow on a Terremoto GPU node. GPUs will typically run Tensorflow computations much faster than CPUs.

First, run an interactive job requesting one GPU on a GPU node

```
$ srun --pty -t 0-02:00:00 --gres=gpu:1 -A <group_name> /bin/bash
```

Then load the singularity environment module and run the tensorflow container, which was built from the Tensorflow docker image. You can start an interactive singularity shell and specify the **--nv** flag which instructs singularity to use the Nvidia GPU driver.

```
$ module load singularity

$ singularity shell --nv /moto/opt/singularity/tensorflow-1.13-gpu-py3-moto.simg

Singularity tensorflow-1.13-gpu-py3-moto.simg:~> python
Python 3.5.2 (default, Nov 12 2018, 13:43:14)
[GCC 5.4.0 20160609] on linux
>>> import tensorflow as tf
>>> hello = tf.constant('Hello, TensorFlow!')
>>> sess = tf.Session()
..
>>> exit()
```

You may type "**exit**" to exit when you're done with the Singularity shell.

```
Singularity tensorflow-1.13-gpu-py3-moto.simg:~> exit
```

```

```

Below is an example of job submission script named **submit.sh** that runs Tensorflow with GPU support using Singularity. 

```
#!/bin/bash
# Tensorflow with GPU support example submit script for Slurm.
#
# Replace <ACCOUNT> with your account name before submitting.
#
#SBATCH -A <ACCOUNT>           # Set Account name
#SBATCH --job-name=tensorflow  # The job name
#SBATCH -c 1                   # Number of cores
#SBATCH -t 0-0:30              # Runtime in D-HH:MM
#SBATCH --gres=gpu:1           # Request a gpu module

module load singularity
singularity exec --nv /moto/opt/singularity/tensorflow-1.13-gpu-py3-moto.simg python -c 'import tensorflow as tf; print(tf.__version__)'
```

Then submit the job to the scheduler. This example prints out the tensorflow version.

```
$ sbatch submit.sh
```

```

```

For additional details on how to use Singularity, please contact us, see our [Singularity documentation](https://columbiauniversity.atlassian.net/wiki/display/rcs/Terremoto+-+Job+Examples#Terremoto-JobExamples-Singularity), or refer to the [Singularity User Guide](https://www.sylabs.io/guides/2.6/user-guide/index.html).

Another option:

Please note that you should not work on our head node.

Since we have a limited number of GPU nodes, it is not unusual to wait in queue to get a GPU node.  
You should request an interactive job on GPU node (specify your groups name as accountName):

$ srun --pty -t 0-02:00:00 --gres=gpu:1 -A <accountNAME> /bin/bash

$ module load tensorflow/anaconda3-2019.10/gpu-2.0

Start python

$ python  
Python 3.7.4 (default, Aug 13 2019, 20:35:49)  
[GCC 7.3.0] :: Anaconda, Inc. on linux  
Type "help", "copyright", "credits" or "license" for more information.

To test it:

>>> import tensorflow as tf  
>>> print(tf.\_\_version\_\_)  
2.0.0

## Jupyter Notebooks

This is one way to set up and run a jupyter notebook on Terremoto. As your notebook will listen on a port that will be accessible to anyone logged in on the submit node, you should first create a password (as shown below).

### Creating a Password

The following steps can be run on the submit node or in an interactive job.

1. Load the anaconda python module.

```
$ module load anaconda/3-2019.10
```

2. If you haven’t already done so, initialize your jupyter environment.

```
$ jupyter notebook --generate-config
```

3. Start a python or ipython session.

```
$ ipython
```

4. Run the password hash generator. You will be prompted for a password, prompted again to verify, and then a hash of that password will be displayed.

```
In [1]: from notebook.auth import passwd; passwd()
Enter password:
Verify password:
Out[1]: 'sha1:60bdb1:306fe0101ca73be2429edbab0935c545'
```

5. Cut and paste the hash into ~/.jupyter/jupyter\_notebook\_config.py

(**Important**: the following line in the file is commented out by default so please uncomment it first)

```
c.NotebookApp.password = 'sha1:60bdb1:306fe0101ca73be2429edbab0935c545'
```

Setting the password will prevent other users from having access to your notebook and potentially causing confusion.

### Running a Jupyter Notebook

6. Log in to the submit node. Start an interactive job.

```
$ srun --pty -t 0-01:00 -A <ACCOUNT> /bin/bash

OR, if you want the notebook to run on a GPU node

$ srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

**Please note** that the example above specifies time limit of 1 hour only. That can be set to a much higher value, and in fact the default (i.e. if not specified at all) is as long as 5 days.

7. Get rid of XDG\_RUNTIME\_DIR environment variable

```
$ unset XDG_RUNTIME_DIR
```

8. Load the anaconda environment module.

```
$ module load anaconda/3-2019.10
```

9. Look up the IP of the node your interactive job is running on.

```
$ hostname -i
10.43.4.206
```

10. Start the jupyter notebook, specifying the node IP.

```
$ jupyter notebook --no-browser --ip=10.43.4.206
```

11. Look for the following line in the startup output to get the port number.

```
The Jupyter Notebook is running at: http://10.43.4.206:8888/
```

12. From your local system, open a second connection to Terremoto that forwards a local port to the remote node and port. Replace UNI below with your uni.

```
$ ssh -L 8080:10.43.4.206:8888 UNI@moto.rcs.columbia.edu
```

13. Open a browser session on your desktop and enter the URL 'localhost:8080' (i.e. the string within the single quotes) into its search field. You should now see the notebook.
