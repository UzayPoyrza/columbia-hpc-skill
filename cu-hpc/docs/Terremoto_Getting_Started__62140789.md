# Terremoto: Getting Started

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62140789/Terremoto+Getting+Started

---

- [Getting Access](#Terremoto:GettingStarted-GettingAccess)
- [Logging In](#Terremoto:GettingStarted-LoggingIn)
- [Submit Account](#Terremoto:GettingStarted-SubmitAccount)
- [Your First Cluster Job](#Terremoto:GettingStarted-YourFirstClusterJob)
  - [Submit Script](#Terremoto:GettingStarted-SubmitScript)
  - [Job Submission](#Terremoto:GettingStarted-JobSubmission)

## Getting Access

Access to the cluster is subject to formal approval by selected members of the participating research groups. See the [HPC service catalog](http://services.cuit.columbia.edu/high-performance-computing-hpc) for more information on access options.  
Training Series Recordings

## Logging In

You will need to use SSH (Secure Shell) in order to access the cluster.  Windows users can use [PuTTY](http://www.columbia.edu/acis/software/putty/) or [Cygwin](http://www.cygwin.com/). MacOS users can use the built-in Terminal application.

Users log in to the cluster's submit node, located at [terremoto.rcs.columbia.edu](http://terremoto.rcs.columbia.edu) or use the shorter form [moto.rcs.columbia.edu](http://moto.rcs.columbia.edu).  If logging in from a command line, type:

```
$ ssh <UNI>@terremoto.rcs.columbia.edu
OR
$ ssh <UNI>@moto.rcs.columbia.edu
```

where <UNI> is your Columbia [UNI](http://uni.columbia.edu/). Please make sure not to include the angle brackets ('<' and' >') in your command; they only represent UNI as a variable entity.

Once prompted,  you need to provide your usual Columbia password.

## Submit Account

You must specify your account whenever you submit a job to the cluster. You can use the following table to identify the account name to use.

Note that at this time not all groups names have been finalized.

| Account | Full Name |
| --- | --- |
| apam | Applied Physics and Applied Mathematics |
| asenjo | Asenjo Lab |
| astro | Astronomy and Astrophysics |
| atmchm | Atmospheric Chemistry |
| axs | Axel Lab |
| berkelbach | Berkelbach Group |
| cboyce | Boyce |
| cheme | Chemical Engineering |
| cs | Computer Science (Yang, Jana, Wing) |
| eaton | Eaton |
| edu | Education Users |
| fortin | Fortin Lab |
| febio | Ateshian / Morrison |
| gsb | Graduate School of Business |
| hblab | Harmen Bussemaker Lab |
| hill | Hill |
| iicd | Irving Institute for Cancer Dynamics |
| katt2 | Hirschberg |
| gsb | Graduate School of Business |
| mauel | Michael Mauel |
| nklab | Kriegeskorte Lab |
| palab | Przeworski / Andolfatto Lab |
| pdlab | Dutrieux |
| qmech | Quantum Mechanics |
| roam | Ciocarlie |
| slab | Sharma Lab |
| sscc | Social Science Computing Committee |
| stats | Statistics |
| trl | Turbulence Research Lab |
| urban | Urban Lab |
| yoon | Yoon |
| zi | Zuckerman Institute |
| rent<UNI> | Renters |

## Your First Cluster Job

When you first login to Terremoto, you are on a login node. Login nodes are not places where users should do actual work aside from simple tasks like editing a file or creating new folders.

Instead, it is important to move from the initial login node to a compute node before doing most work. Example:

```
srun --pty -t 0-2:00 -A <ACCOUNT> /bin/bash
```

Now you have moved from the login node to one of the compute nodes on the cluster.  The simple tasks mentioned above can also be done here, but from here is where it is especially important to submit scripts for processing.

If the HPC group notices jobs being run on a login node, such jobs will be terminated and the user notified.

### Submit Script

This script will print "Hello World", sleep for 10 seconds, and then print the time and date. The output will be written to a file in your current directory.

In order for this example to work you need to replace <ACCOUNT> with your account name. If you don't know your account name the table in the previous section might help.

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
#SBATCH --time=1:00              # The time the job will take to run (here, 1 min)
#SBATCH --mem-per-cpu=1gb        # The memory the job will use per cpu core.

echo "Hello World"
sleep 10
date

# End of script
```

### Job Submission

If this script is saved as helloworld.sh you can submit it to the cluster with:

```
$ sbatch helloworld.sh
```

This job will create one output file name slurm-####.out, where the #'s will be replaced by the job ID assigned by Slurm. If all goes well the file will contain the words "Hello World" and the current date and time.

See the [**Slurm Quick Start Guide**](http://slurm.schedmd.com/quickstart.html) for a more in-depth introduction on using the Slurm scheduler.
