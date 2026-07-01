# Insomnia - Job Examples

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62145126/Insomnia+-+Job+Examples

---

- [Hello World](#Insomnia-JobExamples-HelloWorld)
- [Running Precompiled Binaries](#Insomnia-JobExamples-RunningPrecompiledBinaries)
- [C, C++, Fortran MPI](#Insomnia-JobExamples-C,C++,FortranMPI)
- [Intel oneAPI with Hyperthreading options.](#Insomnia-JobExamples-InteloneAPIwithHyperthreadingoptions.)
- [GPU (CUDA C/C++)](#Insomnia-JobExamples-GPU(CUDAC/C++))
- [Apptainer (formerly called SINGULARITY)](#Insomnia-JobExamples-Apptainer(formerlycalledSINGULARITY))
- [Using MAKER in an Apptainer container](#Insomnia-JobExamples-UsingMAKERinanApptainercontainer)
- [Using GATK in an Apptainer container](#Insomnia-JobExamples-UsingGATKinanApptainercontainer)
- [Using GeoChemFoam in an Apptainer container](#Insomnia-JobExamples-UsingGeoChemFoaminanApptainercontainer)
- [Using Couenne in an Apptainer container](#Insomnia-JobExamples-UsingCouenneinanApptainercontainer)
- [Running LAMMPS in an Apptainer Container with a GPU](#Insomnia-JobExamples-RunningLAMMPSinanApptainerContainerwithaGPU)
- [Installing R Packages locally on Insomnia](#Insomnia-JobExamples-InstallingRPackageslocallyonInsomnia)
- [MATLAB](#Insomnia-JobExamples-MATLAB)
- [Python and JULIA](#Insomnia-JobExamples-PythonandJULIA)
- [Snakemake](#Insomnia-JobExamples-Snakemake)
- [Tensorflow](#Insomnia-JobExamples-Tensorflow)
- [Jupyter Lab (formerly Jupyter Notebook)](#Insomnia-JobExamples-JupyterLab(formerlyJupyterNotebook))
- [Getting Python libraries JAX and JAXLIB to work with GPUs](#Insomnia-JobExamples-GettingPythonlibrariesJAXandJAXLIBtoworkwithGPUs)

In order for the scripts in these examples to work, you will need to replace **<ACCOUNT>** with your group's account name.

## Hello World

This script will print "Hello World", sleep for 10 seconds, and then print the time and date. The output will be written to a file in your current directory.

```
#!/bin/sh
# 
# Simple "Hello World" submit script for Slurm.
#
# Replace ACCOUNT with your account name before submitting.
#
#SBATCH --account=ACCOUNT        # Replace ACCOUNT with your group account name
#SBATCH --job-name=HelloWorld    # The job name
#SBATCH -c 1                     # The number of cpu cores to use (up to 160 cores per server as hyperthreading is enabled)
#SBATCH --time=0-0:30            # The time the job will take to run in D-HH:MM
#SBATCH --mem-per-cpu=5G         # The memory the job will use per cpu core

echo "Hello World"
sleep 10
date

# End of script
```

Provided you saved this script in your home directory as "helloworld.sh", you would make it executable and submit it to the cluster for processing using the following commands:

```
chmod +x helloworld.sh
sbatch helloworld.sh
```

"sbatch <your script>"  is the way you submit any script to the cluster for processing.

For more detailed information about SBATCH directives and submission scripts, see the section we have about [**submitting jobs**](https://columbiauniversity.atlassian.net/wiki/display/rcs/Insomnia+-+Submitting+Jobs)**.**

Examples of some more advanced scripts follow below.

## Running Precompiled Binaries

To submit a precompiled binary to run on Insomnia, the script will look just as it does in the Hello World example. The difference is that you will call your executable file instead of the shell commands "echo", "sleep", and "date".

## C, C++, Fortran MPI

#### OneAPI

Insomnia supports OneAPI which is a highly optimized compiler that builds software with the highest performance. It also supports MPI for applications that require communication between multiple nodes. All the nodes on the cluster have Infiniband transport and that is the fabric that MPI jobs avail themselves of - which is another reason for a substantial boost of efficiency on the cluster.

To use OneAPI, you must load the module first:

```
module load oneapi/hpctoolkit/hpctoolkit-2024.0.0
mpiexec -bootstrap slurm ./myprogram
```

In order to take advantage of Insomnia architecture, your program should be (re)compiled on the cluster even if you used Intel for compiling it on another cluster. It is important to compile with the compiler provided by the module mentioned above. Note that you may have to set additional environment variables in order to successfully compile your program.

These are the locations of the C and Fortran compilers for OneAPI:

```
$ module load oneapi/hpctoolkit/hpctoolkit-2024.0.0
$ which mpicc /insomnia001/shared/apps/anaconda/2023.09/bin/mpicc

For Fortran:

$ ml oneapi/hpctoolkit/ifort  
$ which ifort 
/insomnia001/shared/apps/oneapi/hpctoolkit/compiler/2024.0/bin/ifort
```

For programs written in C, use mpicc in order to compile them:

```
$ mpicc -o <MPI_OUTFILE> <MPI_INFILE.c>
```

The submit script below, named pi\_mpi.sh, assumes that you have compiled a simple MPI program used to compute pi, (see [mpi\_test.c](https://columbiauniversity.atlassian.net/wiki/download/attachments/62135732/mpi_test.c?version=1&modificationDate=1351290549000&cacheVersion=1&api=v2)), and created a binary called pi\_mpi:

```
#!/bin/sh

#SBATCH -A ACCOUNT               # Replace ACCOUNT with your group account name
#SBATCH -N 2                     # Number of nodes
#SBATCH --mem-per-cpu=5800       # Default is 5800
#SBATCH --time=0-0:30            # Runtime in D-HH:MM
#SBATCH --ntasks-per-node=80      # Max 80 since Insomnia has 80 cores per node

module load oneapi/hpctoolkit/hpctoolkit-2024.0.0

mpiexec -bootstrap slurm ./pi_mpi

# End of script
```

Job Submission (i.e. how you actually send it to the cluster)

```
$ sbatch pi_mpi.sh
```

#### OpenMPI5

Insomnia also supports OpenMPI5 from the GNU family.

To use OpenMPI, you must load the openmpi module instead:

```
#!/bin/sh

#SBATCH -A ACCOUNT               # Replace ACCOUNT with your account name
#SBATCH -N 2
#SBATCH --ntasks-per-node=80
#SBATCH --time=0-0:30            # Runtime in D-HH:MM

module purge
module load openmpi5

mpiexec --bind-to none ./myprogram
```

Your program must be compiled on the cluster. You can use the the module command as explained above to set your path so that the corresponding mpicc will be found. Note that you may have to set additional environment variables in order to successfully compile your program.

```
$ module load openmpi5
$ which mpicc 
/insomnia001/shared/apps/openmpi5/5.0.2/bin/mpicc
```

Compile your program using mpicc. For programs written in C:

```
$ mpicc -o <MPI_OUTFILE> <MPI_INFILE.c>
```

## Intel oneAPI with Hyperthreading options.

There are a few recommended ways to take advantage of hyper-threading while running an MPI application. Hyperthreading is enabled on all Insomnia compute/execute nodes.

1. To use all logical processors (including hyper-threaded cores) on a node, you can use the `` `all` `` option for `` `I_MPI_PIN_PROCESSOR_LIST` ``. For example:

```
$ mpirun -genv I_MPI_PIN_PROCESSOR_LIST=all -n <# total processes> ./app
```

This will allow MPI processes to be placed on both physical cores and their hyper-threaded siblings.

2. If you want to use hyper-threading but avoid sharing resources between adjacent MPI processes, you can use the `` `map=scatter` `` option along with `` `allcores` ``. This will scatter the processes across all physical cores first before utilizing the hyper-threaded siblings. For example:

```
$ mpirun -genv I_MPI_PIN_PROCESSOR_LIST=allcores:map=scatter -n <# total processes> ./app
```

This approach can potentially improve performance by reducing resource contention between processes that share the same physical core.

3. You can also specify a custom pinning granularity using the `` `grain` `` option. For example, if you want to pin two processes per physical core (one on the core and one on its hyper-threaded sibling), you can use:

```
$ mpirun -genv I_MPI_PIN_PROCESSOR_LIST=allcores:grain=2 -n <# total processes> ./app
```

This will create pinning cells with two logical processors each, allowing you to take advantage of hyper-threading while maintaining some level of resource isolation.

The optimal approach may depend on the specific characteristics of your MPI application, such as its resource usage patterns and sensitivity to resource contention. It's generally recommended to experiment with different pinning strategies and measure the performance to find the best configuration for your use case.

## GPU (CUDA C/C++)

Check out the [Technical Information](https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62145136/Insomnia+-+Technical+Information) page to see what GPUs are available on the Insomnia cluster.

To use a GPU server you must specify the **--gres=gpu** option in your submit request, followed by a colon and the number of GPU modules you require (with a maximum of 2 per server).

Request a gpu, specify this in your submit script. If the colon and number are omitted, as shown below, the scheduler will request 1 GPU module.

```
#SBATCH --gres=gpu
```

Not all applications have GPU support, but some, such as MATLAB, have built-in GPU support and can be configured to use GPUs.

To build your CUDA code and run it on the GPU modules you must first set your paths so that the Nvidia compiler can be found. Please note you must be logged into a GPU node to access these commands. To login interactively to a GPU node, run the following command, replacing <ACCOUNT> with your account.

```
$ srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

On Insomnia the CUDA module is automatically installed on the 3 GPU compute/execute nodes, **2402-gpu-node00[35-37].**

HOWEVER, certain aspects, such as nvcc, are not loaded unless the explicit module load statement is used.

If you are compiling cuda code directly and need to compile your program using [nvcc](http://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/), below is an exmaple.

```
$ /usr/local/cuda/bin/nvcc --cudart static -o <EXECUTABLE_NAME> <FILE_NAME.cu>
```

You can compile [hello\_world.cu](https://columbiauniversity.atlassian.net/wiki/download/attachments/62138761/hello_world.cu?version=1&modificationDate=1479195540000&cacheVersion=1&api=v2) sample code which can be built with the following command:

```
$ /usr/local/cuda/bin/nvcc --cudart static -o hello_world hello_world.cu
```

For non-trivial code samples, refer to Nvidia's [CUDA Toolkit Documentation](http://docs.nvidia.com/cuda/cuda-samples/#samples-reference).

A Slurm script template, gpu.sh, that can be used to submit this job is shown below:

```
#!/bin/sh
#
#SBATCH --account=ACCOUNT        # The account name for the job.
#SBATCH --job-name=HelloWorld    # The job name.
#SBATCH --gres=gpu:1             # Request 1 gpu (Up to 2 gpus per GPU node)
#SBATCH -c 1                     # The number of cpu cores to use.
#SBATCH --time=0-01:00           # The time the job will take to run in D-HH:MM
#SBATCH --mem-per-cpu=5gb        # The memory the job will use per cpu core.

module load cuda

./hello_world

# End of script
```

#### Job submission (i.e. how you actually send the script off to the cluster)

```
$ sbatch gpu.sh
```

This program will print out "Hello World!" when run on a gpu server or print "Hello Hello" when no gpu module is found.

## Apptainer (formerly called SINGULARITY)

Apptainer is a software tool that brings Docker-like containers and reproducibility to scientific computing and HPC. Apptainer has Docker container support and enables users to easily  run different flavors of Linux with different software stacks. These containers provide a single universal on-ramp from the laptop, to HPC, to cloud.

Users can run Apptainer containers just as they run any other program on our HPC clusters. Example usage of Apptainer is listed below. For additional details on how to use Singularity, please contact us or refer to the [Apptainer User Guide](https://www.sylabs.io/guides/2.6/user-guide/index.html).

### **Downloading Pre-Built Containers**

Apptainer makes it easy to quickly deploy and use software stacks or new versions of software. Since Singularity has Docker support, users can simply pull existing Docker images from [Docker Hub](https://hub.docker.com/) or download docker images directly from software repositories that increasingly support the Docker format. [Apptainer Container Library](https://cloud.sylabs.io/library) also provides a number of additional containers.

You can use the [pull](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#pull-command) command to download pre-built images from an external resource into your current working directory. The docker:// uri reference can be used to pull Docker images. Pulled Docker images will be automatically converted to the Apptainer container format. 

Apptainer is available on all compute nodes but must be loaded with `module load apptainer` first, so start an srun session to whichever type of node you want to work with:

```
srun --pty -t 0-02:00 -A <ACCOUNT> /bin/bash
    OR
srun --pty -t 0-02:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

This example pulls the default Ubuntu docker image from docker hub.

```
$ apptainer pull docker://ubuntu
```

### Running Apptainer Containers

Here's an example of pulling the latest stable release of the [Tensorflow Docker image](https://www.tensorflow.org/install/docker) and running it with Apptainer. (Note: these pre-built versions may not be optimized for use with our CPUs.)  
After starting an srun session, pull a docker image. This also converts the downloaded docker image to Apptainer format and saves it in your current working directory:

```
$ apptainer pull tensorflow.sif docker://tensorflow/tensorflow
```

The container tensorflow.sif in now your current directory.

Once you have download a container, you can run it interactively in a shell or in batch mode.

### Apptainer - Interactive Shell

The [shell](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#shell-command) command allows you to spawn a new shell within your container and interact with it as though it were a small virtual machine:

```
$ apptainer shell tensorflow.sif
Apptainer: Invoking an interactive shell within container...
```

From within the Apptainer shell, you will see the Apptainer prompt and can run the downloaded software. In this example, python is launched and tensorflow is loaded.

```
Apptainer > python
>>> import tensorflow as tf
>>> print(tf.__version__)
2.16.1
>>> exit()
```

When done, you may exit the Apptainer interactive shell with the "exit" command.

```
Apptainer> exit
```

### Apptainer: Executing Commands

The [exec](https://www.sylabs.io/guides/2.6/user-guide/appendix.html#exec-command) command allows you to execute a custom command within a container by specifying the image file. This is the way to invoke commands in your job submission script.

```
$ apptainer exec tensorflow.sif [command]
```

For example, to run python example above using the exec command:

```
$ apptainer exec tensorflow.sif python -c 'import tensorflow as tf; print(tf.__version__)'
2.16.1
```

### Apptainer: Running a Batch Job

Below is an example of job submission script named **submit.sh** that runs Apptainer. Note that you may need to specify the full path to the Apptainer image you wish to run.

```
#!/bin/bash
# Apptainer example submit script for Slurm.
#
# Replace <ACCOUNT> with your account name before submitting.
#
#SBATCH -A <ACCOUNT>           # Set Account name
#SBATCH --job-name=tensorflow  # The job name
#SBATCH -c 1                   # Number of cores
#SBATCH -t 0-0:30              # Runtime in D-HH:MM
#SBATCH --mem-per-cpu=5gb      # Memory per cpu core

module load apptainer

apptainer exec tensorflow.sif python -c 'import tensorflow as tf; print(tf.__version__)'
```

Then submit the job to the scheduler. This example prints out the tensorflow version. After saving the above code into a file, make it executable and submit it to the cluster.

```
$ chmod +x submit.sh

$ sbatch submit.sh
```

## Using MAKER in an Apptainer container

MAKER is an easy-to-use genome annotation pipeline designed to be usable by small research groups with little bioinformatics experience. It has many dependencies, especially for Perl and using a container is a convenient way to have all the requirements in one place. The [BioContainers website maintains a apptainer](https://biocontainers.pro/tools/maker) container as of Dec. 2023, version 3.01.03. Here is a sample tutorial.

First start an srun session to a compute node.

Note that the environment variable `LIBDIR` needs to be set and since `export` is a [Builtin command](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html) that needs to be called via the `bash` command:

```
apptainer run https://depot.galaxyproject.org/singularity/maker:3.01.03--pl5262h8f1cd36_2 bash -c 'export LIBDIR=/usr/local/share/RepeatMasker && maker --help'
```

You can ignore the warning:

Possible precedence issue with control flow operator at /usr/local/lib/site\_perl/5.26.2/Bio/DB/IndexedBase.pm line 805.

Using [example 03 legacy from the MAKER Tutorial for WGS Assembly and Annotation Winter School](https://weatherby.genetics.utah.edu/MAKER/wiki/index.php/MAKER_Tutorial_for_WGS_Assembly_and_Annotation_Winter_School_2018#Merge.2FResolve_Legacy_Annotations), you will be using the `model_gff` option to pass in legacy gene models. The full tutorial files can be [downloaded here](http://weatherby.genetics.utah.edu/data/maker_tutorial.tgz).

```
wget http://weatherby.genetics.utah.edu/data/maker_tutorial.tgz
tar -zxvf maker_tutorial.tgz
cd maker_tutorial/example_03_legacy
apptainer run https://depot.galaxyproject.org/singularity/maker:3.01.03--pl5262h8f1cd36_2 bash -c 'export LIBDIR=/usr/local/share/RepeatMasker && maker -CTL'
cp opts.txt maker_opts.ctl    (Type Y to overwrite the existing file)
nano maker_opts.ctl           (This is using the nano text editor to add the text in the next step).
```

Add a label:

```
est=pyu_est.fasta:hypoxia
```

Write the file back to disk and exit nano  
  
ctl-o   
ctl-x

```
apptainer run https://depot.galaxyproject.org/singularity/maker:3.01.03--pl5262h8f1cd36_2 bash -c "export LIBDIR=/usr/local/share/RepeatMasker && maker"

Possible precedence issue with control flow operator at /usr/local/lib/site_perl/5.26.2/Bio/DB/IndexedBase.pm line 805.
STATUS: Parsing control files...
STATUS: Processing and indexing input FASTA files...
STATUS: Setting up database for any GFF3 input...

Possible precedence issue with control flow operator at /usr/local/lib/site_perl/5.26.2/Bio/DB/IndexedBase.pm line 805.
STATUS: Parsing control files...
STATUS: Processing and indexing input FASTA files...
STATUS: Setting up database for any GFF3 input...
```

A data structure will be created for you at:  
`/burg/home/you/maker_tutorial/example_03_legacy/legacy_contig.maker.output/legacy_contig_datastore`  
To access files for individual sequences use the datastore index:  
`/burg/home/you/maker_tutorial/example_03_legacy/legacy_contig.maker.output/legacy_contig_master_datastore_index.log`

```
STATUS: Now running MAKER...
examining contents of the fasta file and run log
[...]

Maker is now finished!!!

Start_time: 1701293886
End_time:   1701293922
Elapsed:    36
```

To use Maker with OpenMPI, e.g., requesting 8 CPU [ntasks](https://slurm.schedmd.com/sbatch.html#OPT_ntasks) (which are [processes that a job executes in parallel in one or more nodes](https://stackoverflow.com/a/73828155/7606730)), you can use the following suggested options, which will help reduce warnings. Start with an interactive session using the `salloc` command and increase the requested memory as needed:

```
salloc --ntasks=8 --account=test --mem=50GB srun -n1 -N1 --mem-per-cpu=0 --gres=NONE --pty --preserve-env --mpi=none $SHELL

module load openmpi/gcc/64/4.1.5a1 apptainer
mpirun -np 2 --mca btl '^openib' --mca orte_base_help_aggregate 0 apptainer run https://depot.galaxyproject.org/singularity/maker:3.01.03--pl5262h8f1cd36_2 bash -c "export LIBDIR=/usr/local/share/RepeatMasker && maker"
```

Additionally [samtools](https://www.htslib.org/) (used for reading/writing/editing/indexing/viewing SAM/BAM/CRAM format) is available in the container:

```
apptainer> samtools --version
samtools 1.7
Using htslib 1.7-2
Copyright (C) 2018 Genome Research Ltd.
```

Note, if you are testing `maker` and kill jobs/processes look out for [.NFSLock files](https://groups.google.com/g/maker-devel/c/9Aw7CS5oep0), which you will likely need to delete for subsequent runs of `maker`. You will need to use the `-a` option with `ls` as files that start with a dot/period are hidden from the `ls` command by default.

## Using GATK in an Apptainer container

GATK, the Genome Analysis Toolkit has several dependencies and can run inside a container. Here is a sample tutorial:

```
module load apptainer
apptainer pull docker://broadinstitute/gatk
```

Using [Step 4](https://gatk.broadinstitute.org/hc/en-us/articles/360041320571--How-to-Install-all-software-packages-required-to-follow-the-GATK-Best-Practices) at the GATK Best Practices page, download the suggested .bam file:

```
wget https://raw.githubusercontent.com/broadinstitute/gatk/master/src/test/resources/org/broadinstitute/hellbender/tools/BQSR/NA12878.chr17_69k_70k.dictFix.bam
```

Then run:

```
apptainer shell gatk_latest.sif
```

In the container run:

```
gatk PrintReads -I NA12878.chr17_69k_70k.dictFix.bam -O output.bam
```

The output should end with (timestamp removed for clarity):

```
INFO PrintReads - Done initializing engine
WARN IntelDeflaterFactory - Intel Deflater not supported, using Java.util.zip.Deflater
INFO ProgressMeter - Starting traversal
INFO ProgressMeter - Current Locus Elapsed Minutes Reads Processed Reads/Minute
NFO PrintReads - 0 read(s) filtered by: WellformedReadFilter
NFO ProgressMeter - unmapped 0.0 493 896363.6
NFO ProgressMeter - Traversal complete. Processed 493 total reads in 0.0 minutes.
INFO PrintReads - Shutting down engine
org.broadinstitute.hellbender.tools.PrintReads done. Elapsed time: 0.00 minutes.
Runtime.totalMemory()=285212672
```

To quit the container press `ctl-D`.

These 2 files were created:

```
-rw-r--r-- 1 rk3199 user 128 Nov 28 16:48 output.bai
-rw-r--r-- 1 rk3199 user 62571 Nov 28 16:48 output.bam
```

## Using GeoChemFoam in an Apptainer container

[GeoChemFoam](https://github.com/GeoChemFoam) is open source code, based on the OpenFoam CFD toolbox [developed at the Institute of GeoEnergy Engineering, Heriot-Watt University](https://www.julienmaes.com/geochemfoam).

Some additional steps/tweaks are needed to get all of the features working. For this tutorial we assume [GeoChemFoam](https://github.com/GeoChemFoam) version 5.1 and use the [Test Case 01 Species transport in a Ketton Micro-CT image tutorial](https://github.com/GeoChemFoam/GeoChemFoam/wiki/Test-Case-01----Species-transport). You can choose your version of Anaconda Python. Note there are some changes in the tutorial from earlier versions of GeoChemFoam, e.g., 4.8. For this tutorial we assume the name of the Apptainer container is `geochemfoam-5.1.sif`. and we'll use an interactive job with `salloc`, to request  8 `--ntasks` for use with OpenMPI in the Ketton tutorial. Note that Apptainer is installed on all compute nodes so there is no need to load a module for it. Also note that copy/pasting these commands may not work, so it's best to type these commands out. Note that using multiple nodes with either with `-N`/`--nodes`= or adding `-c`/`--cpus-per-task`in your `SBATCH` script will not work and result in an error: "A`n ORTE daemon has unexpectedly failed after launch and before communicating back to mpirun.`" 

```
salloc -t 0-01:0:00 --ntasks=8 --mem=12gb <your-account> 
module load mpi/openmpi-x86_64
```

apptainer [offers a few ways](https://docs.sylabs.io/guides/3.7/user-guide/environment_and_metadata.html) to set/pass environment variables, we'll use APPTAINER`ENV_PREPEND_PATH` as the container needs to know where the `srun` command is.

```
export APPTAINERENV_PREPEND_PATH=$PATH
apptainer shell --bind /path/to/your-directory/runs:/home/gcfoam/works/GeoChemFoam-5.1/runs:rw geochemfoam-5.1_latest.sif
```

`--bind` connects whatever is to the left of the colon, in this case, a new directory called '`runs`'. The right side of the colon is a path that exists in the container. `rw` is read/write

All files written to the `/runs` directory will remain and that's the only directory that files can be written to when the container is bound.

Change the value of`$HOME`:

```
export HOME=/home/gcfoam
```

Copy the `multiSpeciesTransportFoam` directory from`/home/gcfoam/works/GeoChemFoam-5.1/tutorials/transport` to `/path/to/your-directory/runs/`,  e.g.,

`cp -a /home/gcfoam/works/GeoChemFoam-5.1/tutorials/transport /path/to/your-directory/runs/`

Install 5 Python libraries using Python from within the container. Specify where to install these (`-t` option as follows is one way).

```
/usr/bin/pip3 install -t /home/gcfoam/works/GeoChemFoam-5.1/runs matplotlib numpy scikit-image numpy-stl h5py
```

Note this will populate the `~/runs`directory where the results from the tutorial are so you may want to put these in a different directory.

Set 2 additional environment variables:

```
export PYTHONPATH=/home/gcfoam/works/GeoChemFoam-5.1/runs
export MPLCONFIGDIR=/home/gcfoam/works/GeoChemFoam-5.1/runs
```

Source the `.bashrc` file in the container:

```
source $HOME/works/GeoChemFoam-5.1/etc/bashrc
```

Run the scripts in the tutorial in your `~/runs` directory.

```
cd transport/multiSpeciesTransportFoam/Ketton/

./createMesh.sh
```

To avoid seeing a couple of warnings from OpenMPI, you can add the following options to the `mpirun` command in the scripts (using `vi`) that use them:  `--mca btl '^openib'  --mca orte_base_help_aggregate 0`

For the next script, `runSnappyHexMesh.sh,` that would change as follows:

```
mpirun -np $NP --mca btl '^openib' --mca orte_base_help_aggregate 0 snappyHexMesh -overwrite -parallel  > snappyHexMesh.out

./runSnappyHexMesh.sh
./initCaseFlow.sh
```

The next two scripts have `mpirun`, which you can add`--mca btl '^openib' --mca orte_base_help_aggregate 0`

```
./runCaseFlow.sh
```

Check the `simpleFoamFlow.out` file for '`SIMPLE solution converged in <X> iterations`'

```
./processFlow.sh

cat poroPerm.csv
time poro perm Lpore Re UD
0 0.133986 5.71129e-12 1.84664e-05 0.0220027 0.00239467

./initCaseTransport.sh
```

The next two scripts contain `mpirun`:

```
./runCaseTransport.sh
./processTransport.sh 

cat A_Conc.csv B_Conc.csv
time C
0 0
0.01 0.274137
0.02 0.432351
0.03 0.554637
0.04 0.652788
0.05 0.730438
0.06 0.791012
0.07 0.838068
0.08 0.87449
0.09 0.90264
0.1 0.924441
time C
0 0
0.01 0.126229
0.02 0.239035
0.03 0.345767
0.04 0.443858
0.05 0.533867
0.06 0.613993
0.07 0.681486
0.08 0.737184
0.09 0.782178
0.1 0.818111
```

To run the tutorial again make sure to run one of the delete scripts, e.g., `deleteAll.sh`

For additional details on how to use apptainer, please contact us or refer to the [apptainer User Guide](https://sylabs.io/docs/#doc-singularity-3.7).

## Using Couenne in an Apptainer container

[Couenne](https://github.com/coin-or/Couenne) (Convex Over and Under ENvelopes for Nonlinear Estimation) is a branch&bound algorithm to solve Mixed-Integer Nonlinear Programming (MINLP) problems. It includes a suite of programs with several dependencies. Fortunately there is a [Docker container](https://hub.docker.com/r/coinor/coin-or-optimization-suite) which can be used to access these programs, e.g., bonmin, couenne, Ipopt, Cgl, and Cbc, via apptainer. You can use [these sample .nl files](https://github.com/cvanaret/Uno/tree/main/examples) to test with Couenne.

```
apptainer pull docker://coinor/coin-or-optimization-suite 
apptainer shell coin-or-optimization-suite_latest.sif 
apptainer> couenne hs015.nl 
Couenne 0.5 -- an Open-Source solver for Mixed Integer Nonlinear Optimization
Mailing list: couenne@list.coin-or.org
Instructions: http://www.coin-or.org/Couenne

NLP0012I 
              Num      Status      Obj             It       time                 Location
NLP0014I             1         OPT 306.49998       22 0.004007
Couenne: new cutoff value 3.0649997900e+02 (0.009883 seconds)
Loaded instance "hs015.nl"
Constraints:            2
Variables:              2 (0 integer)
Auxiliaries:            8 (0 integer)

Coin0506I Presolve 29 (-1) rows, 9 (-1) columns and 64 (-2) elements
Clp0006I 0  Obj 0.25 Primal inf 473.75936 (14)
Clp0006I 13  Obj 0.31728151
Clp0000I Optimal - objective value 0.31728151
Clp0032I Optimal objective 0.3172815065 - 13 iterations time 0.002, Presolve 0.00
Clp0000I Optimal - objective value 0.31728151
Cbc0012I Integer solution of 306.49998 found by Couenne Rounding NLP after 0 iterations and 0 nodes (0.00 seconds)
NLP Heuristic: NLP0014I             2         OPT 306.49998        5 0.001228
solution found, obj. 306.5
Clp0000I Optimal - objective value 0.31728151
Optimality Based BT: 3 improved bounds
Probing: 2 improved bounds
Cbc0031I 1 added rows had average density of 2
Cbc0013I At root node, 4 cuts changed objective from 0.31728151 to 306.49998 in 1 passes
Cbc0014I Cut generator 0 (Couenne convexifier cuts) - 4 row cuts average 2.0 elements, 3 column cuts (3 active)
Cbc0001I Search completed - best objective 306.4999790004336, took 0 iterations and 0 nodes (0.00 seconds)
Cbc0035I Maximum depth 0, 0 variables fixed on reduced cost

couenne: Optimal

     "Finished"

Linearization cuts added at root node:         30
Linearization cuts added in total:             30  (separation time: 2.4e-05s)
Total solve time:                        0.003242s (0.003242s in branch-and-bound)
Lower bound:                                306.5
Upper bound:                                306.5  (gap: 0.00%)
Branch-and-bound nodes:                         0
Performance of                           FBBT:        2.8e-05s,        4 runs. fix:          0 shrnk: 0.000103838 ubd:       2.75 2ubd:        0.5 infeas:          0
Performance of                           OBBT:       0.000742s,        1 runs. fix:          0 shrnk:    6.70203 ubd:          0 2ubd:          0 infeas:          0
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
#
#SBATCH -A ACCOUNT               # Replace ACCOUNT with your group account name 
#SBATCH -J DeltaHedge            # The job name
#SBATCH -c 4                     # The number of cpu cores to use. Max 32.
#SBATCH -t 0-0:30                # Runtime in D-HH:MM
#SBATCH --mem-per-cpu 5gb        # The memory the job will use per cpu core

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

## Running LAMMPS in an Apptainer Container with a GPU

Nvidia provides prebuilt apptainer LAMMPS (Large-scale Atomic/Molecular Massively Parallel Simulator) GPU-enabled containers in its [New General Catalogue](https://catalog.ngc.nvidia.com/orgs/hpc/containers/lammps) (NGC). Using the tutorial provided you can use:

```
$ docker://nvcr.io/hpc/lammps:29Sep2021
```

Here is a modified tutorial for Insomnia, starting with an interactive session requesting one GPU, 10 GB of memory and note the extra option for the wget commands:

```
srun --pty --mem=10gb -t 0-2:00  --gres=gpu:1  -A <your-account> /bin/bash
module load apptainer/3.7.1
wget https://lammps.sandia.gov/inputs/in.lj.txt --no-check-certificate
export BENCHMARK_DIR=$PWD
cd $BENCHMARK_DIR
wget https://gitlab.com/NVHPC/ngc-examples/-/raw/master/lammps/single-node/run_lammps.sh --no-check-certificate 
chmod +x run_lammps.sh
cd $BENCHMARK_DIR
apptainer run --nv -B $PWD:/host_pwd --pwd /host_pwd docker://nvcr.io/hpc/lammps:29Sep2021 ./run_lammps.sh
```

You should start seeing this response:

```
Running Lennard Jones 8x4x8 example on 1 GPUS...
LAMMPS (29 Sep 2021)
KOKKOS mode is enabled (src/KOKKOS/kokkos.cpp:97)
  will use up to 1 GPU(s) per node
  using 1 OpenMP thread(s) per MPI task
Lattice spacing in x,y,z = 1.6795962 1.6795962 1.6795962
```

You can combine the commands for use with directly with a Slurm interactive session as suggested in the original tutorial

```
srun --pty --mem=10gb -t 0-4:00  --gres=gpu:1  -A <your-account> -v --mpi=pmi2 -c 4  apptainer run --nv -B $PWD:/host_pwd --pwd /host_pwd docker://nvcr.io/hpc/lammps:29Sep2021 ./run_lammps.sh
```

The same container can be used for non-GPU jobs but still requires requesting a GPU node. You can test with a tutorial that provides [polymer\_plus\_bridges.lam](https://cbrackley.github.io/simple_lammps_tutorial/). Download the .lam and initial configuration files. With srun, -v will show more verbose output.

```
wget https://cbrackley.github.io/simple_lammps_tutorial/lammps_tutorial/tutorial5/polymer_plus_bridges.lam
wget https://cbrackley.github.io/simple_lammps_tutorial/lammps_tutorial/tutorial5/initial_configuration.txt
srun --pty --mem=10gb -t 0-4:00  --gres=gpu:1  -A <your-account> -v --mpi=pmi2   apptainer exec --nv -B $PWD:/host_pwd --pwd /host_pwd docker://nvcr.io/hpc/lammps:29Sep2021 mpirun lmp -in polymer_plus_bridges.lam
[...]
Reading data file ...
  orthogonal box = (-25.000000 -25.000000 -25.000000) to (25.000000 25.000000 25.000000)
  1 by 1 by 1 MPI processor grid
  reading atoms ...
  220 atoms
  reading velocities ...
  220 velocities
  scanning bonds ...
  1 = max bonds/atom
  scanning angles ...
  1 = max angles/atom
  reading bonds ...
  199 bonds
  reading angles ...
  198 angles
Finding 1-2 1-3 1-4 neighbors ...
```

## Installing R Packages locally on Insomnia

HPC users can Install R packages locally in their home directory or group's scratch space. The below guide will use a User's group scratch space.

**LOCAL INSTALLATION**

After logging into Insomnia and using srun to get a **GPU** node, start R. It is automatically there on **GPU node**.

```
$ srun --pty -t 0-01:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash

$ R
```

You can see the default library paths (where R looks for packages) by calling .libPaths():

```
> .libPaths() 
[1] "/usr/lib64/R/library" "/usr/share/R/library"
```

These paths are all read-only, and so you cannot install packages to them. To fix this, we will tell R to look in additional places for packages.

Exit R and create a directory rpackages in /insomnia001/depts/<GROUP>/users/<UNI>/

```
$ mkdir -p /insomnia001/depts/<GROUP>/users/<UNI>/rpackages
```

Go back into R and add this path to .libPaths()

```
$ R
> .libPaths("/insomnia001/depts/<GROUP>/users/<UNI>/rpackages")
```

Call .libPaths() to make sure the path has been added

```
> .libPaths()
[1] "/insomnia001/depts/<GROUP>/users/<UNI>/rpackages"
[2] "/usr/lib64/R/library"                          
[3] "/usr/share/R/library"
```

To install a package, such as the "sm" package, tell R to put the package in your newly created local library:

```
> install.packages("sm", lib="/insomnia001/depts/<GROUP>/users/<UNI>/rpackages")
```

Select appropriate mirror and follow install instructions.

Test to see if package can be called:

```
> library(sm) 
Package 'sm', version 2.2-6.0: type help(sm) for summary information
```

In order to access this library from your programs, **make sure** you add the following line to the top of every program:

```
.libPaths("/insomnia001/depts/<GROUP>/users/<UNI>/rpackages/")
```

Since R will know where to look for libraries, a call to library(sm) will be successful (however, this line is not necessary per se for the install.packages(...) call, as the directory is already specified in it).

## MATLAB

### MATLAB atlab (single thread)

The file linked below is a MATLAB M-file containing a single function, simPoissGLM, that takes one argument (lambda).

[simPoissGLM.m](https://columbiauniversity.atlassian.net/wiki/download/attachments/62135832/simpoissglm.m.txt?version=1&modificationDate=1351290771000&cacheVersion=1&api=v2)

A Slurm script, simpoiss.sh, that can be used to submit this job is presented below.

```
#!/bin/sh
#
# Simple MATLAB submit script for Slurm.
#
#
#SBATCH -A ACCOUNT               # Replace ACCOUNT with your group account name 
#SBATCH -J SimpleMLJob           # The job name
#SBATCH -c 1                     # Number of cores to use (max 32)
#SBATCH -t 0-0:30                # Runtime in D-HH:MM
#SBATCH --mem-per-cpu=5G         # The memory the job will use per cpu core

module load MATLAB
echo "Launching a MATLAB run"
date

#define parameter lambda
LAMBDA=10

#Command to execute MATLAB code
matlab -nosplash -nodisplay -nodesktop -r "simPoissGLM($LAMBDA); exit" # > matoutfile

# End of script
```

#### Batch queue submission

```
$ sbatch simpoiss.sh
```

This program will leave several files in the output directory: slurm-<jobid>.out, out.mat, and matoutfile.

### MATLAB with Parallel Computing Toolbox

Parallel Computing Toolbox (PCT)™, [formerly known as Distributed Computing Engine](https://www.mathworks.com/matlabcentral/answers/217639-what-is-the-difference-between-the-distrib_comp_engine-and-distrib_computing_toolbox-licenses), is installed within MATLAB. It lets you solve computationally and data-intensive problems using multicore processors, but limited to one compute/execute node. The compute nodes on Insomnia have 32 CPUs, over 2 sockets, with 16 cores per socket. In order to use PCT you will have to incorporate MATLAB functions such as [distributed](https://www.mathworks.com/help/releases/R2020b/parallel-computing/distributed.distributed.html) or [parfor](https://www.mathworks.com/help/releases/R2020b/parallel-computing/parallel-for-loops-parfor.html?s_tid=CRUX_lftnav). Note in order to use all 32 CPUs the best practice is to use the `--exclusive` option to `srun` in order to assure no other users are running jobs on the requested node and it may take a while to get a free node, depending on how many users are running jobs. As in the previous section, the `-c` option option can be used to specify the number of cores, with 16 being the maximum

- To configure PCT, from the `Home` tab, under `Environment`, select the down arrow next to `Parallel` and select `Create and manage a cluster`.
- This opens up `Cluster Profile Manager`. Click `Add cluster profile` and choose `Local (use the cores on your machine)`.
- Click `Set as default`.
- Click `Edit`, which is within the `Manage Profile` section.
- Add a `Description`
- Set `Number of workers` to start on your local machine, with the maximum being 16.
- The rest of the fields can be left to their default value, unless you want to change them.
- Click `Validate,` it can take a minute to complete.

Once validation completes you can use the example for [Use Distributed Arrays to Solve Systems of Linear Equations with Direct Methods](https://www.mathworks.com/help/releases/R2020b/parallel-computing/Use-Distributed-Arrays-to-Solve-Systems-of-Linear-Equations-with-Direct-Methods.html), you can paste the following into MATLAB's `Editor` and click `Run`. A graph labeled `System of Linear Equations with Full Matrices` will pop up. In the bottom left corner under `ondemand (Folder)` you will see `Starting parallel pool` and in the Command Window you will see `Connected to the parallel pool (number of workers: ##)`. ## is the number of cores you configured earlier. Assuming you opened MATLAB in the background, you can also run the `top -i` command to see the number of CPUs being used during the calculation.

```
n = 1e3;
A = randi(100,n,n);
ADist = distributed(A);
b = sum(A,2);
bDist = sum(ADist,2);
xEx = ones(n,1);
xDistEx = ones(n,1,'distributed');
x = A\b;
err = abs(xEx-x);

xDist = ADist\bDist;
errDist = abs(xDistEx-xDist);

figure
subplot(2,1,1)
semilogy(err,'o');
title('System of Linear Equations with Full Matrices');
ylabel('Absolute Error');
xlabel('Element in x');
ylim([10e-17,10e-13])
subplot(2,1,2)
semilogy(errDist,'o');
title('System of Linear Equations with Distributed Full Matrices');
ylabel('Absolute Error');
xlabel('Element in x');
ylim([10e-17,10e-13])
```

### MATLAB with Parallel Server

**Running MATLAB via X11 Forwarding**

MATLAB Parallel Server is now configured on Insomnia for R2022b and R2023a. [X11 Forwarding](https://goteleport.com/blog/x11-forwarding/) is available and for Apple Mac computers, [XQuartz](https://www.xquartz.org/) is recommended and for Windows, [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html). The first time you run MATLAB via X11, it can take a few minutes to fully open, especially over WiFi.  You can run one simple command to enable the Toolbox:

```
>> configCluster
```

You should see:

```
Must set AccountName before submitting jobs to Insomnia.  E.g.

    >> c = parcluster;
    >> c.AdditionalProperties.AccountName = 'group-account-name';
    >> c.saveProfile

Complete.  Default cluster profile set to "Insomnia".
```

**Running MATLAB From Your Desktop/Laptop**

You can now also install MATLAB on your laptop/desktop and download it from [MathWorks Columbia page](https://www.mathworks.com/academia/tah-portal/columbia-university-650045.html), where students can download it for free. You will need to [download and install a zip file](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140801/Parallel-Computing-Workshop.zip?version=1&modificationDate=1696436975456&api=v2) which contains all the necessary integration scripts including the license. You will also need to be on the Columbia WiFi or VPN and copy the `network.lic` file into your device's MATLAB directory or running the `userpath` command. On a Mac, you would use Finder, Applications, MATLAB, ctl-click the mouse, Show Package Contents, then licenses. In MATLAB, navigate to the Coumbia-University.Desktop folder. In the Command Window type `configCluster`. You will be prompted for Insomnia and Terremoto, select 1, for Insomnia. Enter your UNI (without @columbia.edu). You should see:

```
>> c = parcluster;
    >> c.AdditionalProperties.AccountName = 'group-account-name';
    >> c.saveProfile

Complete.  Default cluster profile set to "Insomnia".
```

Inside the zip file is a Getting Started tutorial in a Word document. An example interactive pool job follows:

`>> c = parcluster;`  
  
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

```
print ("Hello, World!")
```

Save as example.py.

To submit it on the Insomnia Cluster, use the submit script "example.sh"

```
#!/bin/sh
#
# Simple "Hello World" submit script for Slurm.
#
#SBATCH --account=ACCOUNT         # Replace ACCOUNT with your group account name
#SBATCH --job-name=HelloWorld     # The job name.
#SBATCH -c 1                      # The number of cpu cores to use
#SBATCH -t 0-0:30                 # Runtime in D-HH:MM
#SBATCH --mem-per-cpu=5gb         # The memory the job will use per cpu core

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
#SBATCH --account=ACCOUNT             # Replace ACCOUNT with your group account name 
#SBATCH --job-name=HelloWorld         # The job name
#SBATCH -c 1                          # The number of cpu cores to use
#SBATCH --time=1:00                   # The time the job will take to run
#SBATCH --mem-per-cpu=5gb             # The memory the job will use per cpu core

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

Step 1 >> start an interactive session (\*\*\* replace ACCOUNT with your slurm group account name below):

```
$ srun --pty -t 0-04:00 -A ACCOUNT /bin/bash
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
<https://julialang.org/packages/>

to see the full list of the official packages available.

## Snakemake

The Snakemake workflow `management` system is a tool to create reproducible and scalable data analyses. Workflows are described via a human readable, Python based language. They can be seamlessly scaled to server, cluster, grid and cloud environments, without the need to modify the workflow definition.

To use it, follow the below steps:

```
ml anaconda
conda init
source ~/.bashrc
conda activate snakemake
```

## Tensorflow

Tensorflow computations can use CPUs or GPUs. The default is to use CPUs which are more prevalent, but typically slower than GPUs.

### Tensorflow

FIRST, start an srun session to a compute node, specifying a GPU if you want to use a GPU.

```
$  srun --pty -t 0-02:00 -A <ACCOUNT> /bin/bash

           OR
$ srun --pty -t 0-02:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash
```

Then use PIP to install Tensorflow.  Note that there no longer  a separate "Tensorflow-GPU" Just install the one version and if you're on a GPU node, you can use the GPU.

```
$ pip install tensorflow
```

Test tensorflow

```
$ python
Python 3.7.1 (default, Dec 14 2018, 19:28:38)
>>> import tensorflow as tf
>>> print(tf.__version__)
2.15.0
```

**OR** if on a  GPU node -

```
$ python
>>> import tensorflow as tf
>>> print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))
```

## Jupyter Lab (formerly Jupyter Notebook)

This is one way to set up and run a Jupyter Lab notebook on Insomnia. As your notebook will listen on a port that will be accessible to anyone logged in on a submit node you should first create a password.

**NOTE:** at step 5 you will be editing your jupyter configuration file on Insomnia. You will first need to understand how to use a command line text editor. Advanced users may use "vi". Those less advanced should use "nano". One tutorial about nano is [at this link](https://linuxize.com/post/how-to-use-nano-text-editor/), but you can google for others.

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
II.  In the "Session" category on the left side, enter the hostname or IP address of the remote server in the "Host Name (or IP address)" field. (In this case - som.rcs.columbia.edu).  
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

## Getting Python libraries JAX and JAXLIB to work with GPUs

[JAX](https://github.com/google/jax), a Just-In-Time (JIT) compiler focused on harnessing the maximum number of FLOPs to generate optimized code while using the simplicity of pure Python. It is frequently updated with [strict version requirements](https://github.com/google/jax#instructions) for minimum versions of CUDA and CUDNN. The following combination of modules and libraries will work and remember to request a GPU node. Note to use

```
module load cuda
conda deactivate        (If you have the conda environment initialized from previous work, it will interfere)
python

Python 3.9.18 (main, Jan 4 2024, 00:00:00) 
[GCC 11.4.1 20230605 (Red Hat 11.4.1-2)] on linux
Type "help", "copyright", "credits" or "license" for more information.

>>> from jax.lib import xla_bridge
>>> print(xla_bridge.get_backend().platform)
gpu
```

If you'd like to install the correct versions for your user run:

```
pip install jaxlib==0.4.7+cuda11.cudnn86 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
```

[https://storage.googleapis.com/jax-releases/cuda11/jaxlib-0.4.7+cuda11.cudnn86-cp39-cp39-manylinux2014\_x86\_64.whl](https://storage.googleapis.com/jax-releases/cuda11/jaxlib-0.4.7+cuda11.cudnn86-cp39-cp39-manylinux2014_x86_64.whlpython)
