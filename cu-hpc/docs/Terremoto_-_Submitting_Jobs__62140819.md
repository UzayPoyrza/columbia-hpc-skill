# Terremoto - Submitting Jobs

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62140819/Terremoto+-+Submitting+Jobs

---

- [Processes and Jobs](#Terremoto-SubmittingJobs-ProcessesandJobs)
- [Restrictions on Login Node Usage](#Terremoto-SubmittingJobs-RestrictionsonLoginNodeUsage)
- [Core-Based Jobs](#Terremoto-SubmittingJobs-Core-BasedJobs)
- [Node-Based Jobs](#Terremoto-SubmittingJobs-Node-BasedJobs)
- [Interactive Jobs](#Terremoto-SubmittingJobs-InteractiveJobs)
- [Basic Job Directives](#Terremoto-SubmittingJobs-BasicJobDirectives)
- [Walltime](#Terremoto-SubmittingJobs-Walltime)
- [Memory Requests](#Terremoto-SubmittingJobs-MemoryRequests)
- [Job Arrays](#Terremoto-SubmittingJobs-JobArrays)
- [Job scheduling basics](#Terremoto-SubmittingJobs-Jobschedulingbasics)
- [Job limits](#Terremoto-SubmittingJobs-Joblimits)
- [Slurm Quick Start Guide](#Terremoto-SubmittingJobs-SlurmQuickStartGuide)

## Processes and Jobs

In computing, a process is an instance of a computer program that is being executed. It contains the program code and its current activity. A process is normally launched by invoking it by the name of the executable (compiled code) associated with it, either directly at the Unix shell prompt, or within a shell script.

A job in Slurm (the scheduler on Terremoto) is an allocation of resources assigned to a user for a specified amount of time. Within a job, process or processes can be launched: for batch jobs that is done in the submit script used for running the job, and for interactive jobs at the shell prompt that appears on running one. All such processes execute on the compute (aka "execute") nodes, which are dedicated precisely to that purpose.

## Restrictions on Login Node Usage

After logging in, you land on a login (aka "head") node, from which users normally launch their jobs. The login node has some restrictions on the scope of processes that can be run on it. In order to allow for special projects and activities, these restrictions are still quite lenient at this time, and we strongly rely on our users to severely limit launching processes on the head node.

When a user ignores that recommendation and executes processes that are compute-intensive, longer than momentary, and especially requiring multiple cores, the login node becomes overloaded, preventing other users from doing their regular work. In such cases, we typically terminate the processes and inform the user about it with a request to run the processes within jobs instead. Please be aware that the cluster is a shared resource and cooperate with us on trying to limit the computing activity on the head node to minimum.

If you need to run a CPU intensive process, please start an interactive job as described bellow:

<https://columbiauniversity.atlassian.net/wiki/display/rcs/Terremoto+-+Submitting+Jobs#Terremoto-SubmittingJobs-InteractiveJobs>

Jobs can request compute resources on a per-core basis or a per-node basis.

## Core-Based Jobs

Jobs wishing to use less than a full node should specify the number of cores required. If you're not sure how many cores to request then 1 is most likely to be the correct number to use. The maximum number of cores available on a node is 24, but if that really is the number of cores you need you should probably request an entire node instead (see the Node-Based Jobs section below).

Cores can be requested using either -c or --cpus-per-task (in this and the following examples, "or" indicates an exactly equivalent alternative syntax).

```
#SBATCH -c 1
```

or

```
#SBATCH --cpus-per-task=1
```

It is important to also specify your memory requirement when using less than a full node as this will allow the scheduler to ensure that there will be enough memory available on the node where your job runs.

## Node-Based Jobs

Jobs can also request entire nodes. This is often the most efficient way to run parallel distributed jobs, such as those using MPI. To request an entire node or nodes, specify the --exclusive flag in your submit file.

```
#SBATCH --exclusive
```

To specify the number of nodes, use -N or --nodes.

```
#SBATCH -N 1
```

or

```
#SBATCH --nodes=1
```

You should also specify a memory requirement when requesting exclusive use of a node.

```
#SBATCH --mem=4G
```

To explictly request a "standard node" with 192 GB RAM, you may specify the mem192 feature.

```
#SBATCH -C mem192
```

If your job requires more than the standard 192 GB then you may optionally add a constraint to request one of the cluster's high memory nodes, each of which has 768 GB of memory. The feature to request is "mem768".

```
#SBATCH -C mem768
```

or

```
#SBATCH --constraint=mem768
```

## Interactive Jobs

Interactive jobs allow user interaction during their execution. They deliver to the user a new shell from which applications can be launched.

To submit an interactive job, run the following, where "<ACCOUNT>" is your group's account name.

```
srun --pty -t 0-01:00 -A <ACCOUNT> /bin/bash
```

```

```

The Slurm directives noted below that begin with #BATCH are available on the command line as well for interactive jobs.

For example, to run an interactive job on a large node, use:

```
srun --pty -t 0-01:00 -C mem768 -A <ACCOUNT> /bin/bash
```

```

```

If a node is available, it will be picked for you automatically, and you will see a command line prompt on a shell running on it. If no nodes are available, your current shell will wait.

```

```

## Basic Job Directives

The following table lists the most common (in our estimation) directives used in Slurm submit scripts. Each should be preceded by #SBATCH when used in a submit script. Many directives have a short alternate name and these are listed where available. The examples sometimes use the long version of a given directive and sometimes the short version; in either case no preference is implied.

| Directive | Short Version | Description | Example | Notes |
| --- | --- | --- | --- | --- |
| --account=<account> | -A <account> | Account. | #SBATCH --account=stats |  |
| --job-name=<job name> | -J <job name> | Job name. | #SBATCH -J DiscoProject |  |
| --time=<time> | -t <time> | Time required. | #SBATCH --time=10:00:00 | The maximum time allowed is five days. |
| --mem=<memory> |  | Memory required per node. | #SBATCH --mem=16gb |  |
| --constraint=mem768 |  | Specifying a large (768 GB RAM) node. | #SBATCH -C mem768 |  |
| --cpus-per-task=<cpus> | -c <cpus> | CPU cores per task. | #SBATCH -c 1 | Nodes have a maximum of 24 cores. |
| --nodes=<nodes> | -N <nodes> | Nodes required for the job. | #SBATCH -N 4 |  |
| --array=<indexes> | -a <indexes> | Submit a job array. | #SBATCH -a 1-4 | See below for discussion of job arrays. |
| --mail-type=<ALL,BEGIN,END,FAIL,NONE> |  | Send email job notifications | #SBATCH --mail-type=ALL |  |
| --mail-user=<email\_address> |  | Email address | #SBATCH --mail-user=me@[email.com](http://email.com) |  |

## Walltime

The walltime is specified with "-t" flag. For example:

#SBATCH -t 10:00:00  
  
That is walltime format that translates to 10 hours (00 minutes and 00 seconds).  
If you want to request just 1 hour walltime,  you should request 1:00:00  
  
Acceptable time formats in Slurm scheduler are: "minutes", "minutes:seconds", "hours:minutes:seconds",   
"days-hours", "days-hours:minutes" and "days-hours:minutes:seconds".

The maximum time allowed is five days.

## Memory Requests

There are two ways to ask for memory and they are are mutually exclusive. You can ask either for   
1) memory per cpu   
or   
2) memory per node   
  
If you do not specify the memory requirement, by default you get 4 gb per CPU. 

Terremoto has 111 Standard Nodes with 192 GB of memory.

Terremoto's 14 high memory nodes have 768 GB of memory each. They are otherwise identical to the standard nodes.

For example,   
--mem-per-cpu=5gb   
Minimum memory required per allocated CPU. If you request 24 cores (one node) you will get 120gb of memory on both standard node and on high-memory node.   
  
If you specify the real memory required per node:   
--mem = 120gb   
  
You will get the same.   
  
However, if you specify   
#SBATCH --exclusive   
#SBATCH -C mem768   
#SBATCH --mem = 700gb  
  
You will get 700 gb on high memory node. 

## Job Arrays

Multiple copies of a job can be submitted by using a job array. The --array option can be used to specify the job indexes Slurm should apply.

An existing submit file can be used to submit a job array by adding the flag to the sbatch command line.

```
$ sbatch -a 1-5 helloworld.sh
Submitted batch job 629249
```

In this example the job IDs will be the number 629249 followed by \_1, \_2, etc. so the first job in the array can be accessed using the job ID 629249\_1 and the last 629249\_5.

```
$ scontrol show job 629249_1
```

Note: There is a **limit of 1,001 max job elements in an job array**. If you try to submit more than 1,001 elements, the scheduler issues the following:

"Batch job submission failed: Invalid job array specification".

The environment variable $SLURM\_ARRAY\_TASK\_ID indicates the index of the array element (i.e. job) in the job array, and is accessible from within that job.

## Job scheduling basics

The walltime limit on the cluster is 5 days (120 hours).

You have priority access to the nodes owned by your group. That implies that the maximum time a job from your group will need to wait for one of those nodes is 12 hours (and that occurs only in one of those rare case when a job by someone from another group starts running on such a node just before you or someone else in your group launch yours).

In order to guarantee that, users are allowed to run on other groups' nodes only for maximum of 12 hours.

Obviously, public nodes are not subject to such restrictions and everyone competes for those with the walltime limit of 5 days.

## Job limits

Note: There is a **limit of 1,005 max jobs running per user**. Any jobs that exceed this limit will remain in queue until (some of) the user's other running jobs complete.

Additionally, there is a **limit of 5,000 max submitted jobs** per user simultaneously.  If you try to submit more than 5,000 jobs  simultaneously, the schedule spits out the following:

sbatch: error: Batch job submission failed: Job violates accounting/QOS policy (job submit limit, user's size and/or time limits

## Slurm Quick Start Guide

See the [Slurm Quick Start Guide](http://slurm.schedmd.com/quickstart.html) for a more in-depth introduction on using the Slurm scheduler.
