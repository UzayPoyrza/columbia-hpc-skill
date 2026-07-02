# Ginsburg - Storage

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62141884/Ginsburg+-+Storage

---

- [Storage Overview](#Ginsburg-Storage-StorageOverview)
- [Inodes](#Ginsburg-Storage-Inodes)
- [User and Project Scratch Directories](#Ginsburg-Storage-UserandProjectScratchDirectories)
- [No Backups](#Ginsburg-Storage-NoBackups)

## Storage Overview

After logging in to Ginsburg you will be in your home directory. **This home directory storage space (50 GB)** is appropriate for smaller files, such as documents, source code, and scripts but will fill up quickly if used for data sets or other large files.

Ginsburg's shared storage server is named "burg", and consequently the path to all home and scratch directories begins with "**/burg**". Your home directory is located at **/burg/home/<UNI>**. This is also the value of the environment variable $HOME.

**Each group account on Ginsburg has an associated scratch storage space that is at least 1 terabyte (TB) in size**.

Note the important "**No backups**" warning regarding this storage at the bottom of this page.

Your group account's scratch storage is located under **/burg/<ACCOUNT>**. The storage area for each account is as following:

| Location | Size | Default User Quota |
| --- | --- | --- |
| $HOME |  | 50 GB |
| /burg/abernathey | 20 TB | 50 GB |
| /burg/anastassiou | 5 TB | 50 GB |
| /burg/apam | 7 TB | 50 GB |
| /burg/asenjo | 1 TB | 50GB |
| /burg/astro | 65 TB | 50 GB |
| /burg/berkelbach | 16 TB | 50 GB |
| /burg/biostats | 10 TB | 50 GB |
| /burg/camargo | 6 TB | 50 GB |
| /burg/ccce | 22 TB | 50 GB |
| /burg/cgl | 30 TB | 50 GB |
| /burg/crew | 11 TB | 50 GB |
| /burg/dsi | 52 TB | 50 GB |
| /burg/dslab | 7 TB | 50 GB |
| /burg/e3b | 2 TB | 50 GB |
| /burg/edru | 2 TB | 50 GB |
| /burg/emlab | 1 TB | 50 GB |
| /burg/fiore | 21 TB | 50 GB |
| /burg/glab | 30 TB | 50 GB |
| /burg/gsb | 2 TB | 50 GB |
| /burg/hblab | 20 TB | 50 GB |
| /burg/iicd | 21 TB | 50 GB |
| /burg/jalab | 8 TB | 50 GB |
| /burg/katt3 | 2 TB | 50 GB |
| /burg/kellylab | 1 TB | 50 GB |
| /burg/mckinley | 21 TB | 50 GB |
| /burg/millis | 10 TB | 50 GB |
| /burg/mjlab | 8 TB | 50 GB |
| /burg/morphogenomics-lab | 50 TB | 50 GB |
| /burg/myers | 2 TB | 50 GB |
| /burg/ntar\_lab | 2 TB | 50 GB |
| /burg/ocp | 100 TB | OCP shared volume with per user 10 TB quota. |
| /burg/oshaughnessy | 2TB | 50 GB |
| /burg/palab | 120 TB | 50 GB |
| /burg/psych | 15 TB | 50 GB |
| /burg/qmech | 2 TB | 50 GB |
| /burg/rqlab | 10 TB | 50 GB |
| /burg/sail | 3 TB | 50 GB |
| /burg/seager | 10 TB | 50 GB |
| /burg/seasdean | 16 TB | 50 GB |
| /burg/sobel | 10 TB | 50 GB |
| /burg/sscc | 90 TB | 50 GB |
| /burg/stats | 20 TB | 50 GB |
| /burg/stock | 11 TB | 50 GB |
| /burg/subram | 4 TB | 50 GB |
| /burg/thea | 88 TB | 50 GB |
| /burg/theory | 11 TB | 50 GB |
| /burg/ting | 5 TB | 50 GB |
| /burg/tosches | 5 TB | 50 GB |
| /burg/urban | 5 TB | 50 GB |
| /burg/vedula | 21 TB | 50 GB |
| /burg/wu | 6 TB | 50 GB |
| /burg/zi | 10 TB | 50 GB |

The amount of data stored in any directory along with its subdirectories can be found with:

```
cd ~
df -h .
Filesystem      Size  Used Avail Use% Mounted on
xxx:xxx:/burg   50G   20K   50G   1% /burg
```

`Size` shows your quota and `Avail` shows what is used.

## Inodes

Inodes are used to store information about files and directories and an inode is used up for every file and directory that's created. The inode quota for home directories is 150,000.

```
$ df -hi /burg/<ACCOUNT>
```

Should your group run out of inodes and there are free inodes available, we may be able to increase your inode allocation. Please contact us for more details about this if your group is running out of inodes.

Anaconda keeps a cache of the package files, tarballs etc. of the packages you've installed. This is great when you need to reinstall the same packages. But, over time, the space can add up.

You can use the 'conda clean' command and run the command in dry-run mode to see what would get cleaned up,

```
conda clean --all --dry-run
```

Once you're satisfied with what might be deleted, you can run the clean up,

```
conda clean --all
```

This will clean the index cache, lock files, tarballs, unused cache packages, and the source cache.

## User and Project Scratch Directories

Ginsburg users can create directories in their account's scratch storage using their UNI or a project name.

```
$ cd /burg/<ACCOUNT>/users/
$ mkdir <UNI>
```

For example, an astro member may create the following directory:

```
$ cd /burg/astro/users/
$ mkdir <UNI>
```

Alternatively, for a project shared with other users:

```
$ cd /burg/astro/projects/
$ mkdir <PROJECT_NAME>
```

Naming conventions (such as using your UNI for your users directory) are not enforced, but following them is highly recommended as they have worked well as organization mechanisms on previous clusters.

## No Backups

***Storage is not backed up.** User files may be lost due to hardware failure, user error, or other unanticipated events.*

***It is the responsibility of users to ensure that important files are copied from the system to other more robust storage locations.***
