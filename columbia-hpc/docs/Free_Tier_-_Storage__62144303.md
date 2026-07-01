# Free Tier - Storage

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62144303/Free+Tier+-+Storage

---

- [Storage Overview](#FreeTier-Storage-StorageOverview)
- [Inodes](#FreeTier-Storage-Inodes)
- [User and Project Scratch Directories](#FreeTier-Storage-UserandProjectScratchDirectories)
- [No Backups](#FreeTier-Storage-NoBackups)

## Storage Overview

After logging in to the Free Tier, you will be in your home directory. This storage space (30 GB) is appropriate for smaller files, such as documents, source code, and scripts, but will fill up quickly if used for data sets or other large files.

Insomnia’s shared storage server is named "**insomnia001**", and consequently, the path to all home and scratch directories begins with "**/insomnia001**". Your home directory is located at `/insomnia001/home/<UNI>`. This is also the value of the environment variable $HOME.

Each group account on Insomnia has an associated scratch storage space that is at least 1 terabyte (TB) in size. The free group account's scratch storage is located under `/insomnia001/depts/free/`.

For **"Free Tier"**, the account name is "free" and each individual user has a 32GB quota in the "free" scratch space.

Note the important "**No backups**" warning regarding this storage at the bottom of this page.

The storage for each account is as follows:

|  |  |  |
| --- | --- | --- |
| **scratch space directory path** | **size** | **user home directory size** |
| /insomnia001/depts/5sigma | 2 TB | 50 GB |
| /insomnia001/depts/asenjo | 1 TB | 50 GB |
| /insomnia001/depts/astro | 11 TB | 50 GB |
| /insomnia001/depts/berkelbach | 4 TB | 50 GB |
| /insomnia001/depts/cboyce | 20 TB | 50 GB |
| /insomnia001/depts/cklab | 3 TB | 50 GB |
| /insomnia001/depts/crislab/ | 1TB | 50GB |
| /insomnia001/depts/db | 2 TB | 50 GB |
| /insomnia001/depts/delmore\_lab | 3 TB | 50 GB |
| /insomnia001/depts/dr\_beast | 3 TB | 50 GB |
| /insomnia001/depts/e3b | 10 TB | 50 GB |
| /insomnia001/depts/esma | 3 TB | 50 GB |
| /insomnia001/depts/exposomics/ | 5 TB | 50 GB |
| **/insomnia001/depts/free** | **1 TB** | **50 GB** |
| /insomnia001/depts/friesner | 60 TB | 50 GB |
| /insomnia001/depts/hill | 12 TB | 50 GB |
| /insomnia001/depts/hilsha | 2 TB | 50 GB |
| /insomnia001/depts/houlab | 20 TB | 50 GB |
| /insomnia001/depts/ieor\_lam | 1 TB | 50 GB |
| /insomnia001/depts/ieortag | 1 TB | 50 GB |
| /insomnia001/depts/iicd | 10 TB | 50 GB |
| /insomnia001/depts/javitchlab | 2 TB | 50 GB |
| /insomnia001/depts/kumar\_group | 5 TB | 50 GB |
| /insomnia001/depts/mcilvain | 1 TB | 50 GB |
| /insomnia001/depts/mmsci | 10 TB | 50 GB |
| /insomnia001/depts/morpheus | 30 TB | 50 GB |
| /insomnia001/depts/msph | 2 TB | 50 GB |
| /insomnia001/depts/neuralctrl | 15 TB | 50 GB |
| /insomnia001/depts/ntar\_lab | 1 TB | 50 GB |
| /insomnia001/depts/pas\_lab | 100 TB | 50 GB |
| /insomnia001/depts/qmech | 3 TB | 50 GB |
| /insomnia001/depts/sscc | 30 TB | 50 GB |
| /insomnia001/depts/schwabelab | 1 TB | 50 GB |
| /insomnia001/depts/tekle\_smith | 1 TB | 50 GB |
| /insomnia001/depts/ueil | 2 TB | 50 GB |
| /insomnia001/depts/xulab | 1 TB | 50 GB |

The amount of data stored in any directory, along with its subdirectories, can be found with:

```
cd <directoryName>
du -sh .
```

If you have many files in the directory, please allow some time for the 'du' command to return with its output.

## Inodes

Inodes are used to store information about files and directories, and an inode is used up for every file and directory that's created. Each group has a limited number of inodes based on how many TB of storage purchased. To check your groups inode usage and limit, run:

```
$ df -hi /insomnia001/depts/free
```

Should your group run out of inodes and there are free inodes available, we may be able to increase your inode allocation. Please contact us for more details about this if your group is running out of inodes.

The inode quota for home directories is 102,400.

Anaconda keeps a cache of the package files, tarballs etc. of the packages you've installed. This is great when you need to reinstall the same packages. But, over time, the space can add up.

You can use the 'conda clean' command and run the command in dry-run mode to see what would get cleaned up,

```
$ conda clean --all --dry-run
```

Once you're satisfied with what might be deleted, you can run the clean up,

```
$ conda clean --all
```

This will clean the index cache, lock files, tarballs, unused cache packages, and the source cache.

## User and Project Scratch Directories

Free Tier users can create directories in their account's scratch storage using their UNI or a project name.

```
$ cd /insomnia/deptrs/free/users/
$ mkdir <UNI>
```

Alternatively, for a project shared with other free users:

```
$ cd /insomnia001/depts/free/projects/
$ mkdir <PROJECT_NAME>
```

Naming conventions (such as using your UNI for your user's directory) are not enforced, but following them is highly recommended as they have worked well as organizational mechanisms on previous clusters.

## **No Backups**

Storage is not backed up. User files may be lost due to hardware failure, user error, or other unanticipated events.

**It is the responsibility of users to ensure that important files are copied from the system to other, more robust storage locations.**
