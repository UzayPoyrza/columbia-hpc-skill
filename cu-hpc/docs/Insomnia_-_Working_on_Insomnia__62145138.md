# Insomnia - Working on Insomnia

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62145138/Insomnia+-+Working+on+Insomnia

---

- [Transferring Files](#Insomnia-WorkingonInsomnia-TransferringFiles)
- [Globus Connect](#Insomnia-WorkingonInsomnia-GlobusConnect)
  - [Globus Guest Collection](#Insomnia-WorkingonInsomnia-GlobusGuestCollection)
- [Copying files from Ginsburg](#Insomnia-WorkingonInsomnia-CopyingfilesfromGinsburg)
- [Managing Jobs](#Insomnia-WorkingonInsomnia-ManagingJobs)
- [Other useful commands](#Insomnia-WorkingonInsomnia-Otherusefulcommands)

## Transferring Files

Insomnia will no longer support Direct File Transfers using SCP/SFTP protocols - Do not use File Transfer Clients such as FileZilla, CyberDuck, WinSCP, scp, sftp, etc... Instead, please use Globus. Globus offers a lot of features that direct file transfer does not such as auto recovery if your transfer was interrupted. This is particular useful when transferring huge amount of files. Also, Globus handles large amount of data transfer much better and faster. See Globus documentation below.

## [Globus Connect](https://www.cuit.columbia.edu/research-data-transfer)

Globus is a utility (technically, SaaS, or Software as a Service) which among others allows file transfer between personal computers and HPC clusters. It is particularly useful for fast and reliable transfer of very large files, as well as a large number of small files.

To transfer data to/from the HPC clusters, [request a Globus account](https://www.cuit.columbia.edu/globus/request-account). Email [globus@columbia.edu](mailto:globus@columbia.edu) with any questions.

Globus moves data between "endpoints". An endpoint is a unique name representing a Globus resource like a computer or a cluster, typically in the following format: <globus-username>#<machine name>. The endpoints for the resources you'll be using for transferring data need to be added to your account.

**Insomnia's Globus endpoint name: "Insomnia-CUIT"**

Before connecting, you will need to create your own endpoint on the machine from which or to which you will be transferring data to and from Insomnia. In order to to this, you'll need to download and run 'Globus Connect Personal' as described in:

<https://www.globus.org/globus-connect-personal>

Choose between Mac, Linux, or Windows, and follow the instructions for the download.

Once you run the downloaded software, you will be able to, via the online interface, enter the two endpoints of your transfer, specify the paths of the files/directories on the source and destination systems, and launch the transfer. Once it starts, it will take place in the background and you do not need to supervise it or even be logged in.

Globus is a fairly sophisticated system which allows you also to work via Command Line Interface and programming API, and has other useful features. For details, please visit the [globusonline.org](http://globusonline.org) site.

### Globus Guest Collection

Globus allows you to securely share folders through guest collections, letting collaborators access data without needing direct access to your storage system. You control permissions (read/write) and roles, but sharing is only available on subscription-enabled endpoints. Only folders (not individual files) can be shared, and you may need to enable sharing or adjust settings if the Share option is unavailable.

You can find instructions on Globus' documentation:

<https://docs.globus.org/guides/tutorials/manage-files/share-files/>

## Copying files from Ginsburg

Users that have an account on the Ginsburg cluster may access Ginsburg's storage system (/burg) by navigating to the **/burg** directory on the Insomnia login nodes.

Note that /burg are accessible on Insomnia's compute nodes.

## Managing Jobs

To view all jobs on the system, use the squeue command.

```
$ squeue

$ squeue -u <uni> # Shows jobs you submitted on the system
```

To view information about a particular job, use scontrol.

```
$ scontrol show job [job ID]
```

To cancel a job, use scancel.

```
$ scancel [job ID]

$ scancel -u <uni> # Cancels all job(s) you submitted
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
