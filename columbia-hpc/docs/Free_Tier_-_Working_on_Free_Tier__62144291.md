# Free Tier - Working on Free Tier

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62144291/Free+Tier+-+Working+on+Free+Tier

---

- [Transferring Files](#FreeTier-WorkingonFreeTier-TransferringFiles)
- [Globus Connect](#FreeTier-WorkingonFreeTier-GlobusConnect)
- [Copying files from Ginsburg](#FreeTier-WorkingonFreeTier-CopyingfilesfromGinsburg)
- [Managing Jobs](#FreeTier-WorkingonFreeTier-ManagingJobs)
- [Using Groups for Collaborative Research](#FreeTier-WorkingonFreeTier-UsingGroupsforCollaborativeResearch)

## Transferring Files

You can  use [SCP](https://www.ssh.com/academy/ssh/scp) (secure copy protocol) to transfer data and other program files between your local machine and Insomnia. Unix/Linux and Cygwin users can use the scp command, Windows users can use [WinSCP](https://cuit.columbia.edu/winscp), and Mac users can use SCP from the built-in [Terminal](https://macpaw.com/how-to/use-terminal-on-mac) just like Linux, or the free (for Education) program, [Fetch](https://fetchsoftworks.com/fetch/download/).

[Rsync](https://www.geeksforgeeks.org/rsync-command-in-linux-with-examples/) is available too, though here we will cover scp.

For large file transfers we recommend the use of Globus, documented below.

This is how you would transfer "MyDataFile" to your home directory on the cluster using scp from a Mac or Linux command line.

```
$ scp MyDataFile <UNI>@insomnia.rcs.columbia.edu:~/
```

Please keep in mind that if MyDataFile already exists in the destination directory, it will be overwritten. If you specify no path after the colon, the file will be copied to your home directory.

## Globus Connect

Globus is a utility (technically, SaaS, or Software as a Service) which among others allows file transfer between personal computers and HPC clusters. It is particularly useful for fast and reliable transfer of very large files, as well as a large number of small files.

To transfer data to/from the HPC clusters, [request a Globus account](https://www.cuit.columbia.edu/globus/request-account). Email [globus@columbia.edu](mailto:globus@columbia.edu) with any questions.

Globus moves data between "endpoints". An endpoint is a unique name representing a Globus resource like a computer or a cluster, typically in the following format: `<globus-username>#<machine name>`. The endpoints for the resources you'll be using for transferring data need to be added to your account.

NOTE:

**Insomnia's Globus endpoint name: "Insomnia-CUIT"**

Before connecting, you will need to create your own endpoint on the machine from which or to which you will be transferring data to and from Insomnia. In order to to this, you'll need to download and run 'Globus Connect Personal' as described in:

<https://www.globus.org/globus-connect-personal>

Choose between Mac, Linux, or Windows, and follow the instructions for the download.

Once you run the downloaded software, you will be able to, via the online interface, enter the two endpoints of your transfer, specify the paths of the files/directories on the source and destination systems, and launch the transfer. Once it starts, it will take place in the background and you do not need to supervise it or even be logged in.

Globus is a fairly sophisticated system which allows you also to work via Command Line Interface and programming API, and has other useful features. For details, please visit the [globusonline.org](http://globusonline.org) site.

## Copying files from Ginsburg

Users that have an account on the Ginsburg cluster may access Ginsburg's storage system (/burg) by navigating to the **/burg** directory on the Insomnia login nodes.

Note that /burg is not accessible on Insomnia's compute nodes.

## Managing Jobs

To view all jobs on the system, use the squeue command.

```
$ squeue
```

To view jobs specific to you:

```
$ squeue -u <uni>
```

To view information about a particular job, use scontrol.

```
$ scontrol show job [job ID]
```

To cancel a job, use scancel.

```
$ scancel [job ID]
```

To cancel all job(s) submitted by you,

```
$ scancel -u <uni>
```

To view fair share information, use sshare.

```
$ sshare
```

Each command on both systems is naturally replete with flags and optional arguments which customize its functionality. For reference on Slurm. please refer to:

- [Slurm reference](https://slurm.schedmd.com/overview.html)

## Using Groups for Collaborative Research

Researchers will often wish to share access to a set of directories and files with a group of users. One mechanism that can be used to accomplish this is Unix groups. Free Tier users can create and modify groups without assistance from HPC support by using the group command on Cunix.

To use the group command log in to cunix.columbia.edu. **The group command is not available on Free Tier itself.**

To view group members and owners:

```
$ group -i <GROUP_NAME>
```

To add a user ("member") to a group:

```
$ group -m <GROUP_NAME> <UNI>
```

To remove a user from a group:

```
$ group -M <GROUP_NAME> <UNI>
```

Note that existing user sessions will not be affected by changes in group membership. If a user is added or removed from a group they will have to log out and log back in to Free Tier. Note also that in some cases group changes can take up to an hour to propagate to Free Tier.

There are many ways to view your group membership. One way is to use the groups command.

```
$ groups
user habaapam apam
```

Once a group has been created and users have been added, group members can use the chgrp and chmod commands to set group ownership and permissions on files and directories to values appropriate for sharing. For more information see the manual pages for the two commands.

```
$ man chgrp
$ man chmod
```
