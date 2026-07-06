# Ginsburg - Getting Started

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62141892/Ginsburg+-+Getting+Started

---

- [Getting Access](#Ginsburg-GettingStarted-GettingAccess)
- [Multifactor Authentication - DUO](#Ginsburg-GettingStarted-MultifactorAuthentication-DUO)
- [Logging In](#Ginsburg-GettingStarted-LoggingIn)
- [Submit Account](#Ginsburg-GettingStarted-SubmitAccount)
- [Your First Cluster Job](#Ginsburg-GettingStarted-YourFirstClusterJob)
  - [Submit Scripts](#Ginsburg-GettingStarted-SubmitScripts)
  - [Job Submission](#Ginsburg-GettingStarted-JobSubmission)

## Getting Access

Access to the cluster is subject to formal approval by selected members of the participating research groups. See the [HPC Service Webpage](http://services.cuit.columbia.edu/high-performance-computing-hpc) for more information on access options.

## Multifactor Authentication - DUO

Multifactor authentication (MFA) adds an extra layer of security by requiring multiple proofs of identity before granting access to sensitive systems.

As part of our commitment to protecting research data and enhancing system security, we have enabled **Duo two-factor authentication (2FA)** on all public-facing Insomnia login and transfer nodes.

Before accessing the cluster, please ensure you have Duo set up on your account. This added step significantly reduces unauthorized access.

- For more information and how to set up DUO for the first time, follow the link below:

👉 [Duo 2FA Information](https://www.cuit.columbia.edu/mfa)

If you have any issues with it, please don’t hesitate to reach out to [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu).

## Logging In

You will need to use SSH (Secure Shell) in order to access the cluster. **Note: as of July 2026, connecting from off campus requires the [CUIT VPN](https://www.cuit.columbia.edu/vpn); no VPN is needed from the campus network.**  Windows users can use [PuTTY](http://www.columbia.edu/acis/software/putty/) or [Cygwin](http://www.cygwin.com/). MacOS users can use the built-in Terminal application.

Users log in to the cluster's submit node, located at [ginsburg.rcs.columbia.edu](http://ginsburg.rcs.columbia.edu) or use the shorter form [burg.rcs.columbia.edu](http://burg.rcs.columbia.edu).  If logging in from a command line, type:

```
$ ssh <UNI>@ginsburg.rcs.columbia.edu

OR

$ ssh <UNI>@burg.rcs.columbia.edu
```

where <UNI> is your Columbia [UNI](http://uni.columbia.edu/). Please make sure not to include the angle brackets ('<' and' >') in your command; they only represent UNI as a variable entity.

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

You must specify your account whenever you submit a job to the cluster. You can use the following table to identify the account name to use.

| Account | Full Name |
| --- | --- |
| anastassiou | Anastassiou Lab |
| apam | Applied Physics and Applied Math |
| asenjo | Asenjo-Garcia Lab |
| astro | Astronomy and Astrophysics |
| berkelbach | Berkelbach Group |
| biostats | Biostats |
| ccce | Columbia Center for Computational Electrochemistry |
| cgl | Biomedical Engineering |
| dslab | Shohamy Lab |
| dsi | Data Science Institute |
| edru | Karin Foerde |
| e3b | Department of E3B |
| ehsmsph | Environmental Health Sciences Mailman School of Public Health |
| emlab | Electromagnetic Geophysics Laboratory |
| gsb | Business School |
| hblab | Harmen Bussemaker Lab |
| iicd | Irving Institute for Cancer Dynamics |
| jalab | Austermann Lab |
| jhucbsr | Jianhua Hu Biostatistics |
| kellylab | Shaina Kelly Lab |
| katt3 | Computer Science |
| millis | Physics |
| myers | Myers Lab |
| mjlab | Biological Sciences |
| morphogenomics-lab | Bianca M. Dumitrascu |
| ntar\_lab | Neurotrauma and Repair Lab (Morrison) |
| abernathey | Ocean Climate Physics: Abernathey |
| camargo | Ocean Climate Physics: Camargo |
| fiore | Ocean Climate Physics: Fiore |
| glab | Ocean Climate Physics: Gentine |
| mckinley | Ocean Climate Physics: McKinley |
| oshaughnessy | Ben O'Shaughnessy, Dept. Chemical Engineering |
| seager | Ocean Climate Physics: Seager |
| sobel | Ocean Climate Physics: Sobel |
| ting | Ocean Climate Physics: Ting |
| wu | Ocean Climate Physics: Wu |
| qmech | Quantum Mechanics: Marianetti |
| rent | Rent |
| sail | Schiminovich Astronomy & Instrumentation Lab |
| seasdean | School of Engineering and Applied Science |
| sscc | Social Science Computing Committee |
| stats | Statistics |
| stock | Stockwell Lab |
| thea | Sironi / Beloborodov |
| theory | Theoretical Neuroscience: Abbott Lab |
| tosches | Tosches Lab |
| urbangroup | Urban Group |
| vedula | Vijay Vedula |
| zi | Zuckerman Institute |

## Your First Cluster Job

When you first login to Ginsburg, you are on a login node. Login nodes are not places where users should do actual work aside from simple tasks like editing a file or creating new folders.

Instead, it is important to move from the initial login node to a compute node before doing most work. Example:

```
srun --pty -t 0-2:00 -A <ACCOUNT> /bin/bash
```

Now you have moved from the login node to one of the compute nodes on the cluster.  The simple tasks mentioned above can also be done here, but from here is where it is especially important to submit scripts for processing.

If the HPC group notices jobs being run on a login node, such jobs will be terminated and the user notified.

### Submit Scripts

This script will print "Hello World", sleep for 10 seconds, and then print the time and date. The output will be written to a file in your current directory.

In order for this example to work you need to replace ACCOUNT with your group account name. If you don't know your account name the table in the previous section might help.

```
#!/bin/sh
#
# Simple "Hello World" submit script for Slurm.
#
# Replace ACCOUNT with your account name before submitting.
#
#SBATCH --account=ACCOUNT        # Replace ACCOUNT with your group account name 
#SBATCH --job-name=HelloWorld    # The job name
#SBATCH -N 1                     # The number of nodes to request
#SBATCH -c 1                     # The number of cpu cores to use (up to 32 cores per server)
#SBATCH --time=0-0:30            # The time the job will take to run in D-HH:MM
#SBATCH --mem-per-cpu=5G         # The memory the job will use per cpu core

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
