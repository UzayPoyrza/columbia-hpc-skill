# Free Tier - Job Examples

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62144297/Free+Tier+-+Job+Examples

---

- [Hello World](#FreeTier-JobExamples-HelloWorld)
- [C/C++/Fortran](#FreeTier-JobExamples-C/C++/Fortran)
- [C/C++/Fortran MPI](#FreeTier-JobExamples-C/C++/FortranMPI)
- [GPU (CUDA C/C++)](#FreeTier-JobExamples-GPU(CUDAC/C++))
- [Singularity](#FreeTier-JobExamples-Singularity)
- [Example of R run](#FreeTier-JobExamples-ExampleofRrun)
- [Installing R Packages on Insomnia](#FreeTier-JobExamples-InstallingRPackagesonInsomnia)
- [Local Installation](#FreeTier-JobExamples-LocalInstallation)
- [Matlab](#FreeTier-JobExamples-Matlab)
- [Python and JULIA](#FreeTier-JobExamples-PythonandJULIA)
- [Tensorflow](#FreeTier-JobExamples-Tensorflow)
- [Jupyter Lab (formerly Jupyter Notebook)](#FreeTier-JobExamples-JupyterLab(formerlyJupyterNotebook))
- [Spark](#FreeTier-JobExamples-Spark)

In order for the scripts in these examples to work, you will need to replace <ACCOUNT> with `free`.

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

To submit a precompiled binary to run on Insomnia, the script will look just as it does in the Hello World example. The difference is that you will call your executable file instead of the shell commands "echo", "sleep", and "date".

## C/C++/Fortran MPI

#### Intel Parallel Studio

Free Tiersupports Intel Parallel Studio which provides a version of MPI derived from MPICH2. We encourage users to avail themselves of Intel MPI because it is faster and more modern than other versions. Also, all nodes on the cluster have Infiniband transport and that is the fabric that MPI jobs avail themselves of - which is another reason for a substantial boost of efficiency on the cluster.

To use Intel MPI, you must load the Intel module first:

```
module load intel-parallel-studio/2020
mpiexec ./myprogram
```

To take advantage of Free Tierarchitecture, your program should be (re)compiled on the cluster even if you used Intel for compiling it on another cluster (like Yeti). It is important to compile with the compiler provided by the module mentioned above. Note that you may have to set additional environment variables in order to successfully compile your program.

These are the locations of the C and Fortran compilers for Intel Studio:

```
$ module load intel-parallel-studio/2020
(...)

$ which mpiicc
/rigel/opt/parallel_studio_xe_2020/compilers_and_libraries_2020.4.304/linux/mpi/intel64/bin/mpiicc

$ which ifort
/rigel/opt/parallel_studio_xe_2020/compilers_and_libraries_2020.4.304/linux/bin/intel64/ifort
```

For programs written in C, use mpiicc in order to compile them:

```
$ mpiicc -o <MPI_OUTFILE> <MPI_INFILE.c>
```

The submit script below, named pi\_mpi.sh, assumes that you have compiled a simple MPI program used to compute pi, (see [mpi\_test.c](https://columbiauniversity.atlassian.net/wiki/download/attachments/62135732/mpi_test.c?version=1&modificationDate=1351290549000&cacheVersion=1&api=v2)), and created a binary called pi\_mpi:

```
#!/bin/sh

#SBATCH -A <ACCOUNT>

#SBATCH --time=30
#SBATCH -N 2
#SBATCH --exclusive

module load intel-parallel-studio/2020

mpiexec -bootstrap slurm ./pi_mpi

# End of script
```

The --exclusive flag will ensure that full nodes are being used in the runs (that's the reason why no memory specification is given). Each available core will give rise to another MPI thread. Without the flag, you can specify the number of tasks, or tasks per node, in order to limit the number of threads that will be created. For example, you can replace the directive containing the flag by:

```
#SBATCH -N 2
#SBATCH --ntasks-per-node=4
```

- Your MPI code will run on 8 threads, with 4 on each of the 2 nodes requested.

Job Submission

```
$ sbatch pi_mpi.sh
```

#### OpenMPI

Free Tiersupports also OpenMPI from the GNU family.

To use OpenMPI, you must load the following module instead:

```
module load openmpi/gcc/64
mpiexec myprogram
```

Your program must be compiled on the cluster. You can use the the module command as explained above to set your path so that the corresponding mpicc will be found. Note that you may have to set additional environment variables in order to successfully compile your program.

```
$ module load openmpi/gcc/64
$ which mpicc
/rigel/opt/openmpi-3.1.1/bin/mpicc
```

Compile your program using mpicc. For programs written in C:

```
$ mpicc -o <MPI_OUTFILE> <MPI_INFILE.c>
```

## GPU (CUDA C/C++)

The cluster includes two types of GPU servers: Nvidia K80s and Nvidia P100s.

- There are 14 K80 GPU servers, each with two dual K80 Tesla GPU accelerators, for a total of 4 GPU modules per server.

  - Note that the Kepler K80’s have [compute capability 3.7](https://docs.nvidia.com/deploy/cuda-compatibility/index.html#faq), i.e. sm\_37 architecture, so you will need to use CUDA/toolkit lower than 11.2.
- There are 13 P100 servers, each with two P100 accelerators, for a total of 2 GPU modules per P100 server.

To use a GPU server you must specify the **--gres=gpu** option in your submit request, followed by a colon and the number of GPU modules you require.

Use the **--constraint=<gpu type>** along with the **--gres=gpu** directive if you'd like to request a specific type of GPU (A6000, h100, l40, or l40S).

Request a **specific** gpu, specify this in your submit script.

```
#SBATCH --gres=gpu 
#SBATCH --constraint=<gpu type>
```

Not all applications have GPU support, but some, such as MATLAB and Tensorflow, have built-in GPU support and can be configured to use GPUs.

To build your CUDA code and run it on the GPU modules you must first set your paths so that the Nvidia compiler can be found. Please note you must be logged into a GPU node to access these commands. To login interactively to a GPU node, run the following command, replacing <ACCOUNT> with your account.

```
$ srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

Load the cuda environment module which will add cuda to your PATH and set related environment variables.

```
$ module load cuda/12.3
```

If you are building custom CUDA code, then you may have to compile your program using [nvcc](http://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/). If your application already has CUDA support built-in, you may skip this step.

```
$ nvcc -o <EXECUTABLE_NAME> <FILE_NAME.cu>
```

For example, you can compile [hello\_world.cu](https://columbiauniversity.atlassian.net/wiki/download/attachments/62144297/hello_world.cu?version=1&modificationDate=1689107214000&cacheVersion=1&api=v2) sample code which can be built with the following command:

```
$ nvcc -o hello_world hello_world.cu
```

For non-trivial code samples, refer to Nvidia's [CUDA Toolkit Documentation](http://docs.nvidia.com/cuda/cuda-samples/#samples-reference).

A Slurm script template, gpu.sh, that can be used to submit this job is shown below:

```
#!/bin/sh
#
#SBATCH --account=<ACCOUNT>      # The account name for the job.
#SBATCH --job-name=HelloWorld    # The job name.
#SBATCH --gres=gpu:1             # Request 1 gpu (Up to 4 on K80s, or up to 2 on P100s are valid).
#SBATCH -c 1                     # The number of cpu cores to use.
#SBATCH --time=1:00              # The time the job will take to run.
#SBATCH --mem-per-cpu=1gb        # The memory the job will use per cpu core.

module load cuda/12.3
./hello_world

# End of script
```

#### Job submission

```
$ sbatch gpu.sh
```

This program will print out "Hello World!" when run on a gpu server or print "Hello Hello" when no gpu module is found.

<https://columbiauniversity.atlassian.net/wiki/display/rcs/Terremoto+-+Job+Examples#Terremoto-JobExamples-Singularity>

## Singularity

[Singularity](https://www.sylabs.io/singularity/) is a software tool that brings Docker-like containers and reproducibility to scientific computing and HPC. Singularity has Docker container support and enables users to easily  run different flavors of Linux with different software stacks. These containers provide a single universal on-ramp from the laptop, to HPC, to cloud.

Users can run Singularity containers just as they run any other program on our HPC clusters. Example usage of Singularity is listed below. For additional details on how to use Singularity, please contact us or refer to the [Singularity User Guide](https://www.sylabs.io/guides/2.6/user-guide/index.html).

### **Downloading Pre-Built Containers**

Singularity makes it easy to quickly deploy and use software stacks or new versions of software. Since Singularity has Docker support, users can simply pull existing Docker images from [Docker Hub](https://hub.docker.com/) or download docker images directly from software repositories that increasingly support the Docker format. [Singularity Container Library](https://cloud.sylabs.io/library) also provides a number of additional containers.

You can use the [pull](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#pull-command) command to download pre-built images from an external resource into your current working directory. The docker:// uri reference can be used to pull Docker images. Pulled Docker images will be automatically converted to the Singularity container format. 

This example pulls the default Ubuntu docker image from docker hub.

$ singularity pull docker://ubuntu

### Running Singularity Containers

Here's an example of pulling the latest stable release of the [Tensorflow Docker image](https://www.tensorflow.org/install/docker) and running it with Singularity. (Note: these pre-built versions may not be optimized for use with our CPUs.)

First, load the Singularity software into your environment with:

$ module load singularity

Then pull the docker image. This also converts the downloaded docker image to Singularity format and save it in your current working directory:

$ singularity pull docker://tensorflow/tensorflow

Done. Container is at: ./tensorflow.simg

Once you have download a container, you can run it interactively in a shell or in batch mode.

### Singularity - Interactive Shell

The [shell](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#shell-command) command allows you to spawn a new shell within your container and interact with it as though it were a small virtual machine:

$ singularity shell tensorflow.simg

Singularity: Invoking an interactive shell within container...

From within the Singularity shell, you will see the Singularity prompt and can run the downloaded software. In this example, python is launched and tensorflow is loaded.

```
Singularity tensorflow.simg:~> python
>>> import tensorflow as tf
>>> print(tf.__version__)
1.13.1
>>> exit()
```

When done, you may exit the Singularity interactive shell with the "exit" command.

Singularity tensorflow.simg:~> exit

### Singularity: Executing Commands

The [exec](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#exec-command) command allows you to execute a custom command within a container by specifying the image file. This is the way to invoke commands in your job submission script.

```
$ module load singularity

$ singularity exec tensorflow.simg [command]
```

For example, to run python example above using the exec command:

```
$ singularity exec tensorflow.simg python -c 'import tensorflow as tf; print(tf.__version__)'
```

### Singularity: Running a Batch Job

Below is an example of job submission script named **submit.sh** that runs Singularity. Note that you may need to specify the full path to the Singularity image you wish to run.

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

### How To use GeoChemFoam in a Singularity Container

GeoChemFoam is an [Open Source code based](https://github.com/GeoChemFoam) on the OpenFoam CFD toolbox developed at the Institute of GeoEnergy Engineering, Heriot-Watt University. The overarching goal of the code is to simulate reactive transport in porous media applications at the pore-scale. The Department of Earth and Environmental Engineering and the [Kelly Lab](https://www.eee.columbia.edu/faculty/shaina-kelly) are the main users. The following uses version 4.8 of the [Ketton Multi Species Transport Foam tutorial](https://github.com/GeoChemFoam/GeoChemFoam/wiki/Test-Case-01----Species-transport). You can request access to the already-built geochemfoamnew-4-8.sif container file.

```
mkdir ~/runs
module load singularity/3.2.0
singularity shell --bind /rigel/home/<your-directory>/runs:/home/gcfoam/works/GeoChemFoam-4.8/runs:rw geochemfoamnew-4-8.sif
```

- - --bind connects whatever is to the left of the colon, to a newly created directory called 'runs'.
- the right side of the colon is a path that exists in the container
- rw is read/write
- therefore all files written to the /runs directory will remain  and that's the only directory that files can be written to when the  container is bound.

Copy the Ketton tutorial files from the container to your runs directory:

```
cp -a /home/gcfoam/works/GeoChemFoam-4.8/tutorials/transport /rigel/home/<your-directory>/runs/
```

Verify the environment variables:

```
echo $HOME
/home/gcfoam
Singularity geochemfoamnew-4-8.sif:/rigel/home/rk3199/runs

echo $PYTHONPATH
/home/gcfoam/works/GeoChemFoam-4.8/runs
Singularity geochemfoamnew-4-8.sif:/rigel/home/rk3199/runs

echo $MPLCONFIGDIR
/home/gcfoam/works/GeoChemFoam-4.8/runs
```

Source the .bashrc file in the container to activate the environment variables:

```
source $HOME/works/GeoChemFoam-4.8/etc/bashrc
```

Change into YOUR ~/run directory and descend into the Ketton directory:

```
cd /rigel/home/<your-directory>/runs/transport/multiSpeciesTransportFoam/Ketton
```

Now run these 3 commands from the tutorial:

```
./initCase.sh
./runCaseFlow.sh
./runCaseTransport.sh
```

You output should look like this:

```
make stl
Value of the pores is:255
Unique values in the padded image are:[ 0 255]
Coordinates at center of a pore = (129,135,224)
Create background mesh
Decompose background mesh
Run snappyHexMesh in parallel
reconstruct parallel mesh
transformPoints
[..]
```

Note for subsequent runs you should run deleteTransport.sh as you will run into errors such as:

```
FOAM FATAL IO ERROR:  size 253063 is not equal to the given value of 421875
```

For additional details on how to use Singularity, please contact us or refer to the [Singularity User Guide](https://www.sylabs.io/guides/2.6/user-guide/index.html).

## Example of R run

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

## Installing R Packages on Insomnia

HPC users can Install R packages locally in their home directory or group's scratch space (see below).

## Local Installation

After logging in to Insomnia, start R:

```
$ module load R

$ R
```

You can see the default library paths (where R looks for packages) by calling .libPaths():

```
> .libPaths()
[1] "/usr/lib64/R/library"   "/usr/share/R/library"
[3] "/usr/lib64/R/site-library"
```

These paths are all read-only, and so you cannot install packages to them. To fix this, we will tell R to look in additional places for packages.

Exit R and create a directory rpackages in /rigel/<GROUP>/users/<UNI>/.

```
$ mkdir /rigel/<GROUP>/users/<UNI>/rpackages
```

Go back into R and add this path to .libPaths()

```
$ R
> .libPaths("/rigel/<GROUP>/users/<UNI>/rpackages/")
```

Call .libPaths() to make sure the path has been added

```
> .libPaths()
[1] "/rigel/<GROUP>/users/<UNI>/rpackages/"
[2] "/usr/lib64/R/site-library"
[3] "/usr/lib64/R/library"
```

To install a package, such as the "sm" package, tell R to put the package in your newly created local library:

```
> install.packages("sm", lib="/rigel/<GROUP>/users/<UNI>/rpackages")
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
.libPaths("/rigel/<GROUP>/users/<UNI>/rpackages/")
```

Since R will know where to look for libraries, a call to library(sm) will be successful (however, this line is not necessary per se for the install.packages(...) call, as the directory is already specified in it).

**Note**: we found that the solution to the following error that occasionally comes up in R installations:

```
ERROR: 'configure' exists but is not executable
```

is setting the following environment variable before the invocation of R:

```
export TMPDIR=/local
```

## [Matlab](https://columbiauniversity.atlassian.net/wiki/pages/createpage.action?spaceKey=rcs&title=Habanero%20-%20Matlab%20Examples&linkCreation=true&fromPageId=62144297)

### Matlab (single thread)

We created a new Matlab example called "simpleML" (ML = MatLab).  
  
The sample matlab code was used from this page:  
<https://www.mathworks.com/help/matlab/ref/magic.html>  
  
M = magic(5) returns an 5-by-5 matrix constructed from the integers 1 through 25  
sum(M) will print the sum of the elements in each column  
  
To run this Matlab example on Free Tiercluster, you will need to create 2 files in your directory (square5.m and simpleML.sh)

```
$ nano square5.m

**********copy and paste this without " any stars **** "

% Creates a 5x5 Magic square
M = magic(5);
M
sum(M)
exit
```

\*\*\*\*\*\*\*\*\*

And to submit it you would use this file (you also need to create it or copy +paste it in your directory), simpleML.sh

```
$ nano simpleML.sh
```

```
#!/bin/sh
#
# Simple Matlab submit script for Slurm.
#
#
#SBATCH -A astro # The account name for the job.
#SBATCH -J simpleML # The job name.
#SBATCH -t 2:00:00 # The time the job will take to run.
#SBATCH --mem-per-cpu=10gb # The memory the job will use per cpu core.
#SBATCH --job-name=simpleML
#SBATCH -o slurm.%N.%j.out # STD OUT
#SBATCH -e slurm.%N.%j.err # STD ERR
#SBATCH --nodes=1
#SBATCH --ntasks=1

module load matlab

matlab -nodisplay < square5.m

#End of script
```

#### Batch queue submission

```
$ sbatch simpleML.sh
```

You will get a job number that you submitted the job and that job is in the queue.  
Once your job is finished, you will get an output with slurm Job ID in the same directory.  
If you use:

```
$ ls
```

You will see `slurm.t108.1498555.out`

If you want to check it you can use:

```
$cat slurm.t108.1498555.out
```

You should see a 5 x 5 matrix and an answer that represents the sum of the elements in each column

```
>> >> >>
M =

17 24 1 8 15
23 5 7 14 16
4 6 13 20 22
10 12 19 21 3
11 18 25 2 9

>>
ans =

65 65 65 65 65
```

### Matlab (multi-threading)

Matlab has built-in implicit multi-threading (even without applying its Parallel Computing Toolbox, PCT), which causes it to use several cores on the node it is running on. It consumes the number of cores assigned by Slurm.The user can activate explicit (PCT) multi-threading by specifying the number of cores desired also in the Matlab program.

The Torque submit script  should contain the following line:

```
#SBATCH -c 6
```

The -c flag determines the number of cores (up to 24 are allowed).

For explicit multi-threading, the users must include the following corresponding statement within their Matlab program:

```
parpool('local', 6)
```

The second argument passed to parpool must equal the number specified with the ppn directive. Users who are acquainted with the use of commands like parfor need to specify explicit multi-threading with the help of parpool command above.

Note: `maxNumCompThreads()` is being deprecated by Mathworks. It is being replaced by parpool:

The command to execute Matlab code remains unchanged from the single thread example above.

**Important note**: On Yeti, where Matlab was single thread by default, it appeared that the more recent versions of Matlab took liberties to grab all the cores within a node even when fewer (or even only one) cores were specified as above. On Terremoto, we believe this has been addressed by implementing a system mechanism which enforces the proper usage of the number of specified cores.

## Python and JULIA

To use python you need to use:

```
$ module load anaconda
```

Here's a simple python program called "example.py" – it has just one line:

print ("Hello, World!")

To submit it on the Free TierCluster, use the submit script "example.sh"

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
$ module load julia/0.5.1
$ julia julia_example.jl
hello world

$ julia
_
_ _ _(_)_ | A fresh approach to technical computing
() | () (_) | Documentation: http://docs.julialang.org&nbsp;
_ _ _| |_ __ _ | Type "?help" for help.
| | | | | | |/ _` | |
| | || | | | (| | | Version 0.5.1 (2017-03-05 13:25 UTC)
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

The following describes is how you can import tensorflow on a CPU node.

First, run an interactive job.

```
$ srun --pty -t 0-02:00:00 -A <group_name> /bin/bash
```

Then load cuda and anaconda modules.

```
$ module load cuda11.2/toolkit cuda11.2/blas cudnn8.1-cuda11.2
$ module load anaconda
```

If you never installed tensorflow please use this command once:

```
$ pip install tensorflow --user
```

Start python and test tensorflow:

```
$ python
Python 2.7.13 |Anaconda custom (64-bit)| (default, Dec 20 2016, 23:09:15) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux2

>>> import tensorflow as tf
```

### Tensorflow with GPU Support

The following describes is how you can import tensorflow on a GPU node.

First, run an interactive job requesting a GPU node

```
$ srun --pty -t 0-02:00:00 --gres=gpu:1 -A <group_name> /bin/bash
```

Then load cuda and anaconda modules.

```
$ module load cuda11.2/toolkit cuda11.2/blas cudnn8.1-cuda11.2
$ module load anaconda
```

If you never installed tensorflow-gpu package please use this command once:

```
$ pip install tensorflow-gpu --user
```

Start python and test tensorflow:

```
$ python
Python 2.7.13 |Anaconda custom (64-bit)| (default, Dec 20 2016, 23:09:15) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux2

>>> import tensorflow as tf
>>> print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))
```

The following describes is how you can import tensorflow on GPU P100 node.

First, run an interactive job requesting a **P100 gpu node**

```
$ srun --pty -t 0-02:00:00 --constraint=p100 --gres=gpu -A <group_name> /bin/bash
```

Load modules:

```
$ module load cuda11.2/toolkit 
$ module load cuda11.2/blas 
$ module load cudnn/8.1-cuda11.2 

Load a recent version of Anaconda
$ module load anaconda

If you never installed tensorflow-gpu package please use this command once:
$ pip install tensorflow-gpu --user
```

Start python and test tensorflow:

```
$ python 

Python 3.5.2 |Anaconda 4.2.0 (64-bit)| (default, Jul 2 2016, 17:53:06) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux 
Type "help", "copyright", "credits" or "license" for more information. 

>>> import tensorflow as tf 
>>> print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))
```

## Jupyter Lab (formerly Jupyter Notebook)

This is one way to set up and run a Jupyter Lab notebook on Insomnia. As your notebook will listen on a port that will be accessible to anyone logged in on a submit node you should first create a password.

**NOTE:** at step 5 you will be editing your jupyter configuration file on Insomnia. You will first need to understand how to use a command line text editor. Advanced users may use "vi". Those less advanced should use "nano". One tutorial about nano is [at this link](https://linuxize.com/post/how-to-use-nano-text-editor/), but you can Google for others.

### Creating a Password

1. First, from the initial login node, you will open a shell on a compute node (the below example is for a CPU node)

```
$ srun --pty -t 0-02:00 -A <ACCOUNT> /bin/bash
```

Please note that the example above specifies time limit of two hours only. That can be set to a much higher value, and in fact the default (i.e. if not specified at all) is as long as 5 days.

1B. Alternatively, if you want to do the same thing, but you want to use a **GPU node** with your notebook, you'll start an srun session to a GPU node like below:

```
$ srun --pty -t 0-02:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

**NOTE:** On Insomnia, this loads the CUDA module for you automatically.

(For more about using GPUs, see the [GPU section of the documentation](https://columbiauniversity.atlassian.net/wiki/display/rcs/Insomnia+-+Job+Examples#InsomniaJobExamples-GPU(CUDAC/C++)))

2. On the compute node, you will next load the anaconda module and initialize the jupyter server. A LOT of installation messages will fly by. That is normal.

```
$ ml anaconda; pip install jupyter
```

3. Get rid of the XDG\_RUNTIME\_DIR variable and initialize your jupyter environment.

```
$ unset XDG_RUNTIME_DIR; jupyter lab --generate-config
```

2. Start an ipython session.

```
$ ipython
```

3. Run the password hash generator. You will be prompted for a password, prompted again to verify, and then a hash of that password will be displayed.

DO NOT USE YOUR UNI PASSWORD (or something from your bank, social media, etc.) Create a new one just for this.

```
In [1]: from jupyter_server.auth import passwd; passwd()
Enter password:
Verify password:
Out[1]: 'sha1:60bdb1:306fe0101ca73be2429edbab0935c545'
In [2]: exit
```

4. Copy the hash line and then type "exit" to exit iPython. You may want to open a local Notepad or Textedit window on your computer to paste that line in so it won't get lost. We'll need it in a moment.

5. Use a text editor to place the line at the right spot in your  ~/.jupyter/jupyter\_lab\_config.py file (i.e. "nano ~/.jupyter/jupyter\_lab\_config.py")

(**Important**: the following line in the file is commented out by default so please uncomment it first)

```
CHANGE  # c.ServerApp.password = ''    INTO     c.ServerApp.password = 'sha1:60bdb1:306fe0101ca73be2429edbab0935c545'
(Remember, your hash will look different. Do not use this example one.)
```

Setting the password will prevent other users from having access to your notebook and potentially causing confusion.

### Running the Jupyter Notebook

6. Look up the IP of the node your interactive job is running on.

```
$ hostname -i
10.197.80.51
```

7. Start the Jupyter Lab notebook, specifying the node IP.

```
$ jupyter lab --no-browser --ip=10.197.80.51
```

8. Look for the following 2 lines in the startup output to get the port number.

```
Jupyter Server 2.15.0 is running at:
http://10.197.80.51:8888/lab
```

9. From your local system, open a second connection window to Insomnia that forwards a local port to the remote node and port. Replace UNI below with your uni.

```
$ ssh -L 8080:10.197.80.51:8888 UNI@som.rcs.columbia.edu  (This is not for Windows users. Windows users, see step 9B).
```

 9B. Windows users generally are using PuTTY and not a native command line, so step 9 instructions, which use Port Forwarding, may be particularly hard to replicate. To accomplish Step 9 while using PuTTY, you should do this -

I.   Open PuTTY.  
II.  In the "Session" category on the left side, enter the hostname or IP address of the remote server in the "Host Name (or IP address)" field. (In this case - [som.rcs.columbia.edu](http://som.rcs.columbia.edu)).  
III.  Make sure the connection type is set to SSH.  
IV.  In the "Connection" category, expand the "SSH" tab and select "Tunnels".  
V.  In the "Source port" field, enter 8080.  
VI. In the "Destination" field, enter `10.197.80.51:8888`(Remember, this is only an example IP. the one you use will be different)  
VII. Make sure the "Local" radio button is selected.  
VIII. Click the "Add" button to add the port forwarding rule to the list.  
IX.  Now, return to the "Session" category on the left side.  
X.  Optionally, enter a name for this configuration in the "Saved Sessions" field, then  
XI.  Click "Save" to save these settings for future use.  
XII. Click "Open" to start the SSH connection with the port forwarding configured.

10. LAST STEP - Open a browser session on your desktop and enter the URL 'localhost:8080' (i.e. the string within the single quotes) into its search field.

IF YOU DO NOT HAVE A PREVIOUS NOTEBOOK, you will see a main window in front of you with several options: Notebook, Console, and Other. Choose the Python kernel under the Notebook button on the top. This will open a brand new Jupyter Lab notebook for you.

IF YOU DO HAVE AN EXISTING NOTEBOOK FROM BEFORE, that notebook will likely open directly

NOTE: if the browser window does not work the first time, you should try quitting your browser entirely and restarting with a new window, opening a new Private or Incognito window, or also trying another browser. Some popular browsers are Safari, Chrome, and Firefox. Sometimes one may work where another does not.

## Spark

[Spark](http://spark.apache.org/) is a fast and general-purpose cluster computing framework for large-scale data processing. It provides high-level APIs in Java, Scala, Python and R, and an optimized engine that supports cyclic data flow and in-memory computing.

For a short overview of how Spark runs on clusters, refer to the [Spark Cluster Mode Overview](http://spark.apache.org/docs/latest/cluster-overview.html) .

The **spark-slurm** script launches Spark in [standalone cluster mode](http://spark.apache.org/docs/latest/spark-standalone.html) and is integrated with the cluster scheduler to automatically set up a spark mini-cluster using the nodes allocated to your job.

To use the script, you must first launch a job that allocates at least 2 nodes.

The script performs the following steps:

- Launches a spark master process.
- Launches a spark worker process on each allocated node, pointing each one to the master process.
- Sets various default environment variables some of which can be overridden.

The **spark-slurm** script on Free Tieris slightly modified version of the github [spark-slurm](https://github.com/alexander-matz/spark-slurm) script.

**Set your environment:**

Before running spark-slurm, JAVA\_HOME and the spark environment must be set:

```
$ export JAVA_HOME=/usr
$ module load spark
```

To run spark within an interactive job allocation of 3 nodes (replacing *<account>* with your account):

```
$ salloc -N 3 -A <account> --cpus-per-task 24 --mem=120G
```

Run spark-slurm to launch the spark cluster

```
$ spark-slurm
```

Or, if you'd like to save the console output to a log file:

```
$ spark-slurm > ~/.spark/spark-${SLURM_JOB_ID}.log &
```

To view the log file:

```
$ less ~/.spark/spark-${SLURM_JOB_ID}.log
```

After spark-slurm successfully started a spark cluster, look for the line starting with starting master: .... and use that URL for your spark-shell or spark-submit scripts.

So to get the spark master URL from a log file:

```
$ awk '/master:/ {print $NF}' ${SLURM_JOB_ID}.log
spark://10.43.4.220:7077
```

You can then submit spark jobs to using this information.

**Running spark as a non-interactive batch job**

Example submit script spark-submit.sh:

```
#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --account=<your_account>
#SBATCH --nodes=3
#SBATCH --mem=120G
#SBATCH --cpus-per-task=24
#SBATCH --mail-user=<your_email>
#SBATCH --mail-type=ALL
module load spark
export JAVA_HOME=/usr
SPARK_LOG=~/.spark/spark-${SLURM_JOB_ID}.log
spark-slurm > $SPARK_LOG &
sleep 20
sparkmaster=`awk '/master:/ {print $NF}' $SPARK_LOG`
echo sparkmaster="$sparkmaster"
spark-submit --master $sparkmaster $SPARK_HOME/examples/src/main/python/wordcount.py $SPARK_HOME/README.md
```

Submit

```
$ sbatch spark-submit.sh
```

The console/log will also indicate the master WebUI port. To determine which port it was started on:

```
$ grep UI spark-9463479.log | grep Success 
2018-10-20 09:42:53 INFO  Utils:54 - Successfully started service 'MasterUI' on port 8082.
```

To connect to the spark master WebUI, you can launch google-chrome from a login node. You will need to use Xwindows. If using Windows operating system, install and run [Xming](https://sourceforge.net/projects/xming/) and then use Putty and enable SSH Xwindows forward before connecting.

Run chrome in the Xwindows session.

```
$ google-chrome &
```

This should bring up a new browser window which is running on the login node. This is necessary since you cannot directly connect to the compute node's internal network from your personal computer. In that browser, load the URL for the master WebUI, for example:

Example URL only, replace with actual master node and actual port as shown in log file:

**node220:8082**

Use **spark-submit** to submit spark programs to the spark cluster.

You can then submit spark jobs to using this information.

Submit spark wordcount program to spark cluster.

```
$ sparkmaster=spark://10.43.4.220:7077
$ spark-submit --master ${sparkmaster} $SPARK_HOME/examples/src/main/python/wordcount.py $SPARK_HOME/README.md
```

View help

```
$ spark-submit -h
```

If needed, you may optionally set the number of spark executor cores or executor memory available by supplying flags to spark-submit. Here's a submit spark program example, specifying total executor cores and memory:

```
 $ spark-submit --total-executor-cores 48 --executor-memory 5G --master ${sparkmaster} $SPARK_HOME/examples/src/main/python/wordcount.py $SPARK_HOME/README.md
```

When you exit the job allocation or when your job ends, your spark master and slave processes will be killed.
