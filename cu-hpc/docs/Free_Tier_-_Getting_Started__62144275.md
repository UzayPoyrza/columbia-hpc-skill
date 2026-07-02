# Free Tier - Getting Started

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62144275/Free+Tier+-+Getting+Started

---

- [Getting Access](#FreeTier-GettingStarted-GettingAccess)
- [Multifactor Authentication - DUO](#FreeTier-GettingStarted-MultifactorAuthentication-DUO)
- [Logging In](#FreeTier-GettingStarted-LoggingIn)
- [Submit Account](#FreeTier-GettingStarted-SubmitAccount)
- [Your First Cluster Job](#FreeTier-GettingStarted-YourFirstClusterJob)
  - [Submit Script](#FreeTier-GettingStarted-SubmitScript)
  - [Job Submission](#FreeTier-GettingStarted-JobSubmission)

## Getting Access

Access to the cluster is subject to formal approval by selected members of the participating research groups. See the [HPC service catalog](http://services.cuit.columbia.edu/high-performance-computing-hpc) for more information on access options.

## Multifactor Authentication - DUO

Multifactor authentication (MFA) adds an extra layer of security by requiring multiple proofs of identity before granting access to sensitive systems.

As part of our commitment to protecting research data and enhancing system security, we have enabled **Duo two-factor authentication (2FA)** on all public-facing Insomnia login and transfer nodes.

Before accessing the cluster, please ensure you have Duo set up on your account. This added step significantly reduces unauthorized access.

- For more information and how to set up DUO for the first time, follow the link below:

👉 [Duo 2FA Information](https://www.cuit.columbia.edu/mfa)

If you have any issues with it, please don’t hesitate to reach out to [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu).

## Logging In

You will need to use SSH (Secure Shell) in order to access the cluster.  Windows users can use [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or [Cygwin](http://www.cygwin.com/). MacOS users can use the built-in Terminal application.

Users log in to the cluster's submit node, located at insomnia.rcs.columbia.edu.  If logging in from a command line, type:

```
$ ssh <UNI>@insomnia.rcs.columbia.edu
```

where <UNI> is your Columbia [UNI](http://uni.columbia.edu/). Please make sure not to include the angle brackets ('<' and' >') in your command; they only represent UNI as a variable entity.

Once prompted, proceed with the Duo two-factor authentication process. You will see a menu similar to the one below:

```
Duo two-factor login for <uni> 

Enter a passcode or select one of the following options:  

1. Duo Push to XXX-XXX-####  
2. Phone call to XXX-XXX-####  
3. SMS passcodes to XXX-XXX-#### 

Passcode or option (1-3):
```

Select your preferred authentication method by entering the corresponding number (1–3) or choosing to enter a passcode.

After completing the DUO authentication, you will be prompted to enter your UNI password to finalize the login process.

For more information about CU DUO, please click [here](https://www.cuit.columbia.edu/mfa).

## Submit Account

When submitting a job to the cluster, you must specify your account. Free-tier users should use the designated `free` account.

## Your First Cluster Job

### Submit Script

This script will print "Hello World", sleep for 10 seconds, and then print the time and date. The output will be written to a file in your current directory.

```
#!/bin/sh
#
# Simple "Hello World" submit script for Slurm.
#
#
#SBATCH --account=free           # The account name for the job.
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

This job will create one output file named slurm-####.out, where the job ID assigned by Slurm will replace the #'s. If all goes well, the file will contain the words "Hello World" and the current date and time.

See the [**Slurm Quick Start Guide**](http://slurm.schedmd.com/quickstart.html) for a more in-depth introduction on using the Slurm scheduler.
