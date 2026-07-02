# Terremoto - Working on Terremoto

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62140835/Terremoto+-+Working+on+Terremoto

---

- [Transferring Files](#Terremoto-WorkingonTerremoto-TransferringFiles)
- [Globus Connect](#Terremoto-WorkingonTerremoto-GlobusConnect)
- [Copying files from Habanero](#Terremoto-WorkingonTerremoto-CopyingfilesfromHabanero)
- [Managing Jobs](#Terremoto-WorkingonTerremoto-ManagingJobs)
- [Other useful commands](#Terremoto-WorkingonTerremoto-Otherusefulcommands)
- [Using Groups for Collaborative Research](#Terremoto-WorkingonTerremoto-UsingGroupsforCollaborativeResearch)
- [Open OnDemand Web Portal Access](#Terremoto-WorkingonTerremoto-OpenOnDemandWebPortalAccess)

## Transferring Files

You must use SCP (secure copy protocol) to transfer data and other program files between your local machine and Terremoto. Unix/Linux and Cygwin users can use the scp command, Windows users can use [WinSCP](https://cuit.columbia.edu/winscp), and Mac users can use [Fugu](http://www.columbia.edu/acis/software/fugu/). For large file transfers we recommend the use of Globus, documented below.

Please use the interface [quake.rcs.columbia.edu](http://quake.rcs.columbia.edu) when transferring files.

For example, this is how you would transfer "MyDataFile" to the cluster using scp from the command line.

```
$ scp MyDataFile <UNI>@quake.rcs.columbia.edu:<DESTINATION_PATH>
```

If you specify no path after the colon, the file will end up in your home directory (no check for the existence of its older version is performed in this case).

## Globus Connect

Globus is a utility (technically, SaaS, or Software as a Service) which among others allows file transfer between personal computers and HPC clusters. It is particularly useful for fast and reliable transfer of very large files, as well as a large number of small files.

To transfer data to/from the HPC clusters, [request a Globus account](https://www.cuit.columbia.edu/globus/request-account). Email [globus@columbia.edu](mailto:globus@columbia.edu) with any questions.

Globus moves data between "endpoints". An endpoint is a unique name representing a Globus resource like a computer or a cluster, typically in the following format: <globus-username>#<machine name>. The endpoints for the resources you'll be using for transferring data need to be added to your account.

To use Terremoto's Globus endpoint, input "**Columbia**" as the Collection and then select "**Columbia Terremoto**".

Before connecting, you will need to create your own endpoint on the machine from which or to which you will be transferring data to and from Terremoto. In order to to this, you'll need to download and run 'Globus Connect Personal' as described in:

<https://www.globus.org/globus-connect-personal>

Choose between Mac, Linux, or Windows, and follow the instructions for the download.

Once you run the downloaded software, you will be able to, via the online interface, enter the two endpoints of your transfer, specify the paths of the files/directories on the source and destination systems, and launch the transfer. Once it starts, it will take place in the background and you do not need to supervise it or even be logged in.

Globus is a fairly sophisticated system which allows you also to work via Command Line Interface and programming API, and has other useful features. For details, please visit the [globusonline.org](http://globusonline.org) site.

## Copying files from Habanero

Users that have an account on the Habanero cluster may access Habanero's storage system (/rigel) by navigating to the **/rigel** directory on Terremoto login nodes and transfer nodes (shake, bake, and quake). Habanero's storage system is not accessible on the compute nodes.

## Managing Jobs

To view all jobs on the system, use the squeue command.

```
$ squeue
```

To view information about a particular job, use scontrol.

```
$ scontrol show job [job ID]
```

To cancel a job, use scancel.

```
$ scancel [job ID]
```

To view fair share information, use sshare.

```
$ sshare
```

## Other useful commands

Here's a partial list of useful Slurm commands.

```
sbatch       # submit a job
```

```
sinfo       # list of partitions/queues on the cluster
```

```
scontrol show job <jobID>      # see status of running job
```

```
sacct -j <jobID>      # see status of completed job
```

```
scontrol show node <nodeName>      # information about a node
```

```
sshare      # information about fair share
```

Each command on both systems is naturally replete with flags and optional arguments which customize its functionality. For reference on Slurm. please refer to:

[**Slurm reference**](https://slurm.schedmd.com/overview.html)

## Using Groups for Collaborative Research

Researchers will often wish to share access to a set of directories and files with a group of users. One mechanism that can be used to accomplish this is Unix groups. Terremoto users can create and modify groups without assistance from HPC support by using the group command on Cunix.

To use the group command log in to [cunix.columbia.edu](http://cunix.columbia.edu). **The group command is not available on Terremoto itself.**

To create a new group:

```
$ group -c <GROUP_NAME>
```

To view group members and owners:

```
$ group -i <GROUP_NAME>
```

To add a user to a group:

```
$ group -m <GROUP_NAME> <UNI>
```

To remove a user from a group:

```
$ group -M <GROUP_NAME> <UNI>
```

Group owners can add and remove owners and users. To add a group owner:

```
$ group -o <GROUP_NAME> <UNI>
```

To remove an owner:

```
$ group -O <GROUP_NAME>
```

Note that existing user sessions will not be affected by changes in group membership. If a user is added or removed from a group they will have to log out and log back in to Terremoto. Note also that in some cases group changes can take up to an hour to propagate to Terremoto.

There are many ways to view your group membership. One way is to use the groups command.

```
$ groups
user yetiapam apam
```

Once a group has been created and users have been added, group members can use the chgrp and chmod commands to set group ownership and permissions on files and directories to values appropriate for sharing. For more information see the manual pages for the two commands.

```
$ man chgrp
$ man chmod
```

## Open OnDemand Web Portal Access

Terremoto users may also access the cluster and submit jobs via the Open OnDemand web portal.

[Open OnDemand](http://openondemand.org/) is a web portal service developed by the Ohio Supercomputer Center that provides users with access to the Terremoto cluster and its underly file system. It allows to view, edit, upload and download files, create, edit, submit and monitor jobs, and connect via SSH, all via a web browser and with a minimal knowledge of Linux and scheduler commands.

### Connecting to Open OnDemand

To connect, point your web browser to <https://quake.rcs.columbia.edu> and authenticate with your Columbia UNI and UNI password. After successfully logging in you will come to a dashboard page that looks like this:

![](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140835/image2020-4-3_14-9-15.png?api=v2)

From this menu you can access your home directory files as well as submit and monitor jobs.

**PLEASE NOTE:** a known existing issue with Open OnDemand is that **Open OnDemand will not log you out until you have fully shutdown your browser**. Because of this we discourage the user of Open OnDemand from public computers and encourage you to shut down your browser upon completing your work. Another option may be to use Open OnDemand from a "private" browsing window or "Incognito" window. We plan on implementing a fix for this once it has been released by the Open OnDemand developers.

### File Management

The Files menu allows one to view and operate on files in user's home directory. This page will show your available files and folders and provide tools to view and download current files, create new files, and upload files to your home directory.

![](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140835/image2020-4-3_14-12-40.png?api=v2)

### Job Composer

Jobs can be created, edited and submitted with the job management tools under the Jobs menu with the Job Composer. The Job Composer serves as a GUI alternative to Slurm scheduler commands and allows to write Slurm batch scripts and create script templates.

Users can create a new job either from the default job template - a mostly empty Slurm batch script file - or providing the path to an existing slurm batch script.

![](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140835/image2020-4-3_14-29-42.png?api=v2)

Users may have to open the Job Options menu and enter their Account membership, like shown below.

![](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140835/image2020-4-3_14-31-40.png?api=v2)

The Account can also be included in the Slurm job script, which can be edited either from the command line or directly in the GUI interface:

![](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140835/image2020-4-3_14-34-2.png?api=v2)

### Job Monitoring

Users may monitor their jobs that are currently running via the Jobs menu by selecting Active Jobs

![](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140835/image2020-4-3_14-36-48.png?api=v2)

### Shell Access

Users can open a command line interface by selecting the Clusters menu and then the "terremoto Shell Access" option. This will open a command line interface directly in your browser, rather than needing to connect via the terminal or PuTTY program.

![](https://columbiauniversity.atlassian.net/wiki/download/attachments/62140835/image2020-4-3_14-26-4.png?api=v2)
