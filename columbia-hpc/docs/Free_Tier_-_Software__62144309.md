# Free Tier - Software

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62144309/Free+Tier+-+Software

---

- [Table of installed Software](#FreeTier-Software-TableofinstalledSoftware)
  - [Mathematica](#FreeTier-Software-Mathematica)
  - [OpenMPI Settings](#FreeTier-Software-OpenMPISettings)
  - [RStudio in an Apptainer container](#FreeTier-Software-RStudioinanApptainercontainer)
  - [Visual Studio Code Server](#FreeTier-Software-VisualStudioCodeServer)

When you login to Insomnia, you land on one of the **two** **login** nodes. As a general rule, you should do your actual work on a **compute** node. Meaning when you login, you should first execute a line like this:

```
srun --pty -t 0-02:00 -A <ACCOUNT> /bin/bash.              (CPU compute node)
srun --pty -t 0-02:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash. (GPU compute node)

(The above lines will open a session on a random compute node for a maximum of 2 hours. You can lengthen or shorten the time as you please. The absolute upper limit is 5 days on a node your group owns. 12 hours on another group's node.)
```

This is important because all of the software noted in the table below that is loaded automatically is only seen on a compute node. It will not be seen on a login node.

Use the following command to verify whether software/packages can be found on Insomnia:

```
$ module avail

NOTE: For a good guide on how to use environment modules to easily load your software environment, please see:

https://lmod.readthedocs.io/en/latest/010_user.html
```

## Table of installed Software

The table below shows software already installed  on the cluster as a module. **NOTE:** On the Insomnia cluster, some software is automatically available and need not be manually loaded. Such software is noted.

The list may be partial and not totally up-to-date at any given time. Requests for software can be submitted for consideration through an emailed request to [hpc-support@columbia.edu](mailto:hpc-support@columbia.edu)

| **Name** | **Version** | **Location / Module** | **Category** |
| --- | --- | --- | --- |
| Apptainer | 1.2.5-1.el9 | (installed directly on all **compute** nodes) | Run Docker-like containers |
| cmake | 3.20.2 | (installed directly on all **compute** nodes) |  |
| cuda | 12.3 | (installed directly on GPU nodes) | GPU Computing |
| gcc | 11.4.1 | (installed directly on all **compute** nodes) | Compiler - C / C++ |
| gdal, gdal-devel libraries | 3.4.3 | (installed directly on all **compute** nodes) |  |
| gsl/gsl-devel libraries | 2.6-7 | (installed directly on all **compute** nodes) | GNU Scientific Library |
| gurobi | 10.0.3 | module load gurobi/10/0/3 | Prescriptive analytics platform and a decision-making technology |
| hdf5/hdf5-devel | 1.12.1-7 | (installed directly on all **compute** nodes) | Hierarchical Data Format version 5 |
| hdf5p | 1.10.7 and 1.14.3 | module load hdf5p | Hierarchical Data Format version 5, PARALLEL version |
| Intel oneAPI toolkit | various | ml load oneapi/hpctoolkit/hpctoolkit-2024.0.0 | Core set of tools and libraries for developing high-performance, data-centric applications across diverse architectures (includes, mpi, fortran compiler, etc) |
| julia | 1.5.3 | module load julia/1.5.3 | Programming Language |
| knitro | 13.2.0 | module load knitro/13.2.0 | Software package for solving large scale nonlinear mathematical optimization problems; short for "Nonlinear Interior point Trust Region Optimization" |
| make | 4.3 | (installed directly on all **compute** nodes) |  |
| Mathematica | 14.0 | (installed directly on all **compute** nodes) | Numerical Computing |
| MATLAB | R2023b | module load MATLAB/2023b | Numerical Computing |
| openmpi | 5.0.2 | module load openmpi/gcc/64/4.1.5a1 | OpenMPI Compiler (provided by Nvidia/Mellanox) |
| Python  (Incl many libraries such as  numpy, torch, Tensorflow, scipy, and more) | 3.9.18 | (installed directly on all **compute** nodes) | Python for Scientific Computing |
| Qt 5 | 5.15.9-1 | (installed directly on all **compute** nodes) |  |
| R | 4.3.2 | (installed directly on all **compute** nodes) | Programming Language |
| Schrodinger | 2024-1 | module load schrodinger | A collection of software for chemical and biochemical use. It offers various tools that facilitate the investigation of the structures, reactivity and properties of chemical systems. |
| Singularity (now called Apptainer. see above) |  | installed directly on compute nodes |  |
| stata | 18 | module load stata | a statistical software package used for data analysis, management, and graphing |
| Visual Studio Code Server |  | Not a module | A server side Integrated Development Environment hosted on Insomnia compute nodes |

### **Mathematica**

The first time you launch Mathematica you will need to provide the host details of the MathLM (license) server. Using the [Activating Mathematica guide](https://reference.wolfram.com/language/tutorial/ActivatingMathematica.html), click 'Other ways to activate' then choose 'Connect to a Network License Server' and enter the IP address, 128.59.30.140

### **OpenMPI Settings**

Insomnia has a few MPI options loadable as modules in addition to Intel oneAPI/hpctoolkit/mpi/2021.11:

- `openmpi5/5.0.2`
- `mpi/mpich-x86_64/4.1.1`
- `mpi/openmpi-x86_64/4.1.1`

If you find that a mpirun hangs or does not complete, try adding the following option:

`-mca coll ^hcoll`

### RStudio in an Apptainer container

On Insomnia, rstudio can be loaded by leveraging an interactive session, i.e., `srun`, and using a Apptainer container via the [Rocker Project which provides containers](https://rocker-project.org/use/singularity.html) from where this tutorial comes . First you will need to download the Apptainer image. This will require two terminal sessions. One session will be used to connect to a compute host and run `rstudio`. The other terminal session will be used to initiate [SSH Port Forwarding/Tunneling](https://www.ssh.com/academy/ssh/tunneling-example#what-is-ssh-port-forwarding,-aka-ssh-tunneling?) to access the resource. The first step is to request an interactive session so you can run `rstudio` server from a compute node as follows. Please be sure to change your group as noted by "`-A`".

```
srun -X -A <GROUP> --pty -t 0-01:00 -X /bin/bash
```

Apptainer is loaded automatically and no longer a separate module the way Singularity was on previous clusters. We can go ahead and use it to pull the container. This will take a few minutes.

On subsequent sessions you skip this step as the container will remain.

```
apptainer pull --name rstudio.simg docker://rocker/rstudio:4.3.1
```

In order for RStudio to start in a browser via an interactive session you will need the IP address of the compute node. Note that the IP below will likely be different for you:

```
$ hostname -i 
10.197.16.39           (REMEMBER, this is only an example IP. Yours will likely be different)
```

From RStudio 4.2 and later, some added [security features](https://docs.posit.co/ide/server-pro/rstudio_pro_sessions/directory_management.html) require binding of a locally created database file to the database in the container. Don't forget to change the password.

```
mkdir -p run var-lib-rstudio-server

printf 'provider=sqlite\ndirectory=/var/lib/rstudio-server\n' > database.conf

PASSWORD='CHANGEME' singularity exec \
   --bind run:/run,var-lib-rstudio-server:/var/lib/rstudio-server,database.conf:/etc/rstudio/database.conf \
   rstudio.simg \
   /usr/lib/rstudio-server/bin/rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user=$USER
```

This will run `rserver` in an Apptainer/Singularity container.

Alternatively, if you want to use scratch space in `/insomnia001/depts`click the 3 dots in the far right:

![RStudio Option for changing directory](https://columbiauniversity.atlassian.net/wiki/download/attachments/62144309/RStudio-folder.png?api=v2)

`PASSWORD='CHANGEME' singularity exec --bind run:/run,var-lib-rstudio-server:/var/lib/rstudio-server,database.conf:/etc/rstudio/database.conf --bind=/insomnia001/depts/rcs/projects/rstudio-test rstudio.simg /usr/lib/rstudio-server/bin/rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user=$USER`

Now open another Terminal and start the RStudio `rserver` session using Port Forwarding to connect a local port on your computer to a remote one on Insomnia.

```
ssh -Nf -L 8787:10.197.16.39:8787 myUNI@som.rcs.columbia.edu           (NOTE: THIS IS NOT FOR WINDOWS. On a PC, see below)
```

The above Port Forwarding line works on Linux/Unix/MacOS, or any virtual machine running Linux. For Windows, we are assuming you are using PuTTY and the above line would be accomplished using the alternative steps below:

I.    Launch PuTTY

II.   In the "Session" category (the default screen when you open PuTTY), enter som`.rcs.columbia.edu` in the "Host Name (or IP address)" field.

III.   Ensure the "Port" field is set to `22`, which is the default SSH port.       Optionally, you can enter a name in the "Saved Sessions" field and click "Save" to save these settings for future re-use

IV.   In the "Category" pane on the left, expand the "SSH" category by clicking the `+` sign next to it.

V.    Click on "Tunnels" under the "SSH" category.

VI.   In the "Source port" field, enter `8787`.

VII.   In the "Destination" field, enter `10.197.16.39:8787`.    (Remember,  1`0.197.16.39` is only an example IP, your actual one may be different)

VIII.   Click the "Add" button. You should see the forwarded port appear in the list box as `L8787 10.197.16.39:8787`.

IX.     Optional but recommended,   To save this configuration for future use, go back to the "Session" category, and enter a name for the session in the "Saved Sessions" field (e.g., `<myuni>@som.rcs.columbia.edu`) and click the "Save" button.

X.      Click the "Open" button at the bottom of the PuTTY window and connect to [som.rcs.columbia.edu](http://som.rcs.columbia.edu)

**Next, use a web browser to connect to to your locally forwarded port.**

In any browser, e.g., Google Chrome, Firefox, Edge, etc. etc., enter `localhost:8787 in the web address field`. The login screen for RStudio will appear and you enter your UNI (without the @columbia.edu) and whatever password you put from the above example (where it says `CHANGME`). If you need a session that last longer than an hour, you can add `--auth-timeout-minutes=0 --auth-stay-signed-in-days=30` to the end of the above `singularity`. command. A sample Slurm bash script is available at [Rocker Project's Singularity page](https://rocker-project.org/use/singularity.html#slurm-job-script). If you run into an error such as `[rserver] ERROR system error 98 (Address already in use),` you can specify the port number as an additional option, e.g.,  `--www-port 8788`. The new command could look like this:

```
mkdir -p run var-lib-rstudio-server

printf 'provider=sqlite\ndirectory=/var/lib/rstudio-server\n' > database.conf

PASSWORD='CHANGEME' singularity exec \
   --bind run:/run,var-lib-rstudio-server:/var/lib/rstudio-server,database.conf:/etc/rstudio/database.conf \
   rstudio.simg \
   /usr/lib/rstudio-server/bin/rserver --www-port 8788 --auth-none=0 --auth-pam-helper-path=pam-helper --server-user=$USER
```

\*\*\*IMPORTANT NOTE\*\*\*

When you are finished with RStudio remember to stop the Singularity session via ctl-c, and you can kill the SSH forwarding session by finding the process ID (PID) with the following command, noting that the PID is the second column:

```
ps -ef | grep 8787
  503 82438     1   0 10:56AM ??         0:00.31 ssh -Nf -L 8787:10.197.16.39:8787 myUNI@som.rcs.columbia.edu
kill -9 82438
```

### Visual Studio Code Server

A pre-existing Github account is now required to use the instructions below.

Visual Studio Code is an Integrated Development Environment that some like to use on their laptops. If you are familiar with that, the HPC has a server-side version hosted on the compute nodes (NOT the login nodes) for users to connect their local VS Code application on their laptop to Insomnia and open files from their Insomnia folder directly.  To use it, do the following:

After logging into Insomnia, start an srun session to a CPU or GPU node of your choice:

|  |
| --- |
| ``` srun --pty -t 0-02:00  -A <ACCOUNT> /bin/bash        OR, if you need a GPU   srun --pty -t 0-02:00 --gres=gpu:1 -A <ACCOUNT> /bin/bash ``` |

Then type

```
$ code tunnel
```

You will get a message like the one below:

|  |
| --- |
| ``` * Visual Studio Code Server   *   * By using the software, you agree to   * the Visual Studio Code Server License Terms (https://aka.ms/vscode-server-license) and   * the Microsoft Privacy Statement (https://privacy.microsoft.com/en-US/privacystatement).   *   [2024-04-05 16:12:16] info Using Github for authentication, run `code tunnel user login --provider <provider>` option to change this.   To grant access to the server, please log into https://github.com/login/device and use code <###-###> ``` |

When you use the device login URL, you will first get a page asking you to use your GitHub credentials to log in.

After using your GitHub login, you will get a page asking you to input the device code given to you above (represented as <###-###> here)

Next, you will see a page requesting you to authorize VS Code Studio's access permissions.

After that, when you use your local VS Code application on your computer, you will see a running SSH tunnel listed. Double click to connect to it. This can take a moment to finish.

Once done, you will be able to open files in your Insomnia folder the same as you do on your local computer.

It's possible that the next time you try to use the tunnel you've just made, you may not be able to reconnect. The connection may keep trying endlessly, or finally fail with an error. This is because the srun session in the first step has placed you on another node, different from the one where you created the tunnel.

**IF** that happens, follow the steps below:

1. In your local VSCode app (if you use a local copy of VS Code and not the browser-based window version), unregister/delete all of your existing tunnels. We’ll be making a new one.

2. Login to Insomnia. Do not start a srun session yet.

3. Delete your invisible VScode settings folders in your home directory  (" `rm -r .vscode*`")

4. Start an srun session as described above, type "code tunnel", and follow all of the directions as normal. Open VScode in the web browser first. It will take a moment as the new tunnel is created.

If you only use VS Code in the browser, you are now done.

5. If you prefer to use a local copy of VS Code on your computer, you can now connect to this tunnel in it. WINDOWS USERS, additionally, you may need to downgrade your local copy of Visual Studio Code to version 1.8.1 due to a bug existing as of this writing (8/28/2024).
