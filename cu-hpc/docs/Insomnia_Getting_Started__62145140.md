# Insomnia: Getting Started

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62145140/Insomnia+Getting+Started

---

- [Getting Access](#Insomnia:GettingStarted-GettingAccess)
- [Multifactor Authentication - DUO](#Insomnia:GettingStarted-MultifactorAuthentication-DUO)
- [Logging In](#Insomnia:GettingStarted-LoggingIn)
- [Submit Account](#Insomnia:GettingStarted-SubmitAccount)
- [Your First Cluster Job](#Insomnia:GettingStarted-YourFirstClusterJob)
  - [An example Submit Script](#Insomnia:GettingStarted-AnexampleSubmitScript)
  - [Job Submission](#Insomnia:GettingStarted-JobSubmission)

## Getting Access

Access to the cluster is subject to formal approval by selected members of the participating research groups. See the [HPC Service Webpage](http://services.cuit.columbia.edu/high-performance-computing-hpc) for more information on access options.

## Multifactor Authentication - DUO

Multifactor authentication (MFA) adds an extra layer of security by requiring multiple proofs of identity before granting access to sensitive systems.

As part of our commitment to protecting research data and enhancing system security, we have enabled **Duo two-factor authentication (2FA)** on all public-facing Insomnia login and transfer nodes.

Before accessing the cluster, please ensure you have Duo set up on your account. This added step significantly reduces unauthorized access.

- For more information and how to set up DUO for the first time, follow the link below:

👉 [Duo 2FA Information](https://www.cuit.columbia.edu/mfa)

If you have any issues with it, please don’t hesitate to reach out to hpc-support@columbia.edu.

## Logging In

You will need to use SSH (Secure Shell) in order to access the cluster.  Windows users can use [PuTTY](http://www.columbia.edu/acis/software/putty/) or [Cygwin](http://www.cygwin.com/). MacOS users can use the built-in Terminal application.

Users log in to the cluster's submit node, located at **insomnia.rcs.columbia.edu** or use the shorter form **som.rcs.columbia.edu**.  If logging in from a command line, type:

```
$ ssh <UNI>@insomnia.rcs.columbia.edu
OR
$ ssh <UNI>@som.rcs.columbia.edu
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

| **Account** | **Full Name** |
| --- | --- |
| **5sigma** | Biostatistics |
| **asenjo** | lab of Ana Asenjo Garcia, Dept of Physics |
| **astro** | Columbia Astrophysics Lab |
| **berkelbach** | Chemistry |
| **cboyce** | Chemical Engineering (Christopher Boyce) |
| **ciesin** | Climate School |
| **cklab** | IEOR |
| **crislab** | Chemical Engineering (Venkat Venkatasubramanian) |
| **db** | Computer Science |
| **delmore\_lab** | Ecology, Evolution and Environmental Biology |
| **dr\_beast** | lab of Dr. Nikhil Sharma, Molecular Pharmacology |
| **e3b** | Ecology, Evolution and Environmental Biology |
| **esma** | SIPA-CGEP |
| **exposomics** | MSPH Exposomics |
| **free** | special group for Free Tier users with limited run times on the cluster |
| **friesner** | Dept of Chemistry |
| **hill** | Physics (Columbia Astrophysics Laboratory) |
| **hilsha** | Lamont Climate School - Steckler lab |
| **houlab** | Laboratory of Wenpin Hou |
| **ieortang** | Industrial Engineering and Operations Research (IEOR) |
| **iicd** | Irving Institute for Cancer Dynamics |
| **jalab** | Department of Earth and Environmental Sciences |
| **javitchlab** | Psychiatry |
| **kumar\_group** | Lab of Prof Sanat Kumar, Chemical Engineering |
| **loulab** | Rheumatology and Clinical Immunology, Department of Medicine |
| **mathemalab** | Epidemiology |
| **mcilvain** | Grace McIlvain Lab |
| **mmsci** | Multimessenger Science |
| **morpheus** | Bianca Dumitrascu Lab |
| **msph** | MSPH IT |
| **neuralctrl** | Laboratory for Neural Engineering and Control |
| **ntar\_lab** | Biomedical Engineering  (Morrison) |
| **pas\_lab** | Biological Sciences |
| **ueil** | Biomedical Engineering  (Konofagou) |
| **qmech** | Quantum Mechanics/Applied Physics and Applied Math: Marianetti |
| **sscc** | Social Science Computing Committee (ISERP, Econ, and CPRC) |
| **schwabelab** | Department of Medicine |
| **tekle\_smith** | Chemistry Dept - Tekle Smith group |
| **tepolelab** | Mechanical Engineering |
| **urbangroup** | Chemical Engineering |
| **xulab** | Earth and Environmental Engineering |

## Your First Cluster Job

While best practice on all Columbia HPC group clusters, it is particularly important on Insomnia to move from the initial login node to a compute node before doing most work. Example:

```
srun --pty -t 0-2:00 -A <ACCOUNT> /bin/bash
```

Now you have moved from the login node to one of the compute nodes on the cluster. While simple things like editing a file or making new folders can be done on a login node, they can also be done on a compute node, and as you run more complicated jobs on Insomnia, some things simply will not work unless you are first on a compute node.

### An example Submit Script

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
#SBATCH -c 1                     # The number of cpu cores to use (up to 80 cores per server)
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

See further documentation we have about [**submitting jobs**](https://columbiauniversity.atlassian.net/wiki/display/rcs/Insomnia+-+Submitting+Jobs).  For much more in-depth information, there is a [**Slurm Quick Start Guide**](http://slurm.schedmd.com/quickstart.html) on the web.
