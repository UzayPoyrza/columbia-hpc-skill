# Ginsburg - Working on Ginsburg

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62141890/Ginsburg+-+Working+on+Ginsburg

---

- [Transferring Files](#Ginsburg-WorkingonGinsburg-TransferringFiles)
- [Globus Connect](#Ginsburg-WorkingonGinsburg-GlobusConnect)
- [Copying files from Insomnia or Terremoto](#Ginsburg-WorkingonGinsburg-CopyingfilesfromInsomniaorTerremoto)
- [Managing Jobs](#Ginsburg-WorkingonGinsburg-ManagingJobs)
- [Other useful commands](#Ginsburg-WorkingonGinsburg-Otherusefulcommands)

## Transferring Files

You must use SCP (secure copy protocol) to transfer data and other program files between your local machine and Ginsburg. Unix/Linux and Cygwin users can use the scp command, Windows users can use [WinSCP](https://cuit.columbia.edu/winscp), and Mac users can use [Fugu](http://www.columbia.edu/acis/software/fugu/). For large file transfers we recommend the use of Globus, documented below.

Please use the server **motion.rcs.columbia.edu** when transferring files.

For example, this is how you would transfer "MyDataFile" to the cluster using scp from the command line.

```
$ scp MyDataFile <UNI>@motion.rcs.columbia.edu:<DESTINATION_PATH>
```

If you specify no path after the colon, the file will end up in your home directory (no check for the existence of its older version is performed in this case).

## [Globus Connect](https://www.cuit.columbia.edu/research-data-transfer)

Globus is a utility (technically, SaaS, or Software as a Service) which among others allows file transfer between personal computers and HPC clusters. It is particularly useful for fast and reliable transfer of very large files, as well as a large number of small files.

To transfer data to/from the HPC clusters, [request a Globus account](https://www.cuit.columbia.edu/globus/request-account). Email [globus@columbia.edu](mailto:globus@columbia.edu) with any questions.

Globus moves data between "endpoints". An endpoint is a unique name representing a Globus resource like a computer or a cluster, typically in the following format: <globus-username>#<machine name>. The endpoints for the resources you'll be using for transferring data need to be added to your account.

**Ginsburg's Globus endpoint name: "Columbia Ginsburg"**

Before connecting, you will need to create your own endpoint on the machine from which or to which you will be transferring data to and from Ginsburg. To do this, you'll need to download and run 'Globus Connect Personal' as described in:

<https://www.globus.org/globus-connect-personal>

Choose between Mac, Linux, or Windows, and follow the instructions for the download.

Once you run the downloaded software, you will be able to, via the online interface, enter the two endpoints of your transfer, specify the paths of the files/directories on the source and destination systems, and launch the transfer. Once it starts, it will take place in the background and you do not need to supervise it or even be logged in.

Globus is a fairly sophisticated system that also allows you to work via Command Line Interface and programming API, and has other useful features. For details, please visit the [globusonline.org](http://globusonline.org) site.

### Globus Guest Collection

Globus allows you to securely share folders through guest collections, letting collaborators access data without needing direct access to your storage system. You control permissions (read/write) and roles, but sharing is only available on subscription-enabled endpoints. Only folders (not individual files) can be shared, and you may need to enable sharing or adjust settings if the Share option is unavailable.

You can find instructions on Globus' documentation:

<https://docs.globus.org/guides/tutorials/manage-files/share-files/>

## Copying files from Insomnia or Terremoto

Users who have an account on the Insomnia cluster may access Insomnia’s storage system (/insomnia001) by navigating to the /insomnia001 directory on the Insomnia login nodes.

Terremoto users can access their storage system (/moto) by navigating to /moto on the Insomnia login nodes.

Note that neither /insomnia nor /moto are accessible on Ginsburg compute nodes.

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

To view fair share information, use share.

```
$ sshare
```

## Other useful commands

Here's a partial list of useful Slurm commands.

```
sbatch                             # submit a job
sinfo                              # list of partitions/queues on the cluster
scontrol show job <jobID>          # see status of running job
sacct -j <jobID>                   # see status of completed job
scontrol show node <nodeName>      # information about a node
sshare                             # information about fair share
```

Each command on both systems is naturally replete with flags and optional arguments which customize its functionality. For reference on Slurm. please refer to:

[**Slurm reference**](https://slurm.schedmd.com/overview.html)
