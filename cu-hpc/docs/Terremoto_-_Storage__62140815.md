# Terremoto - Storage

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62140815/Terremoto+-+Storage

---

- [Storage Overview](#Terremoto-Storage-StorageOverview)
- [Inodes](#Terremoto-Storage-Inodes)
- [User and Project Scratch Directories](#Terremoto-Storage-UserandProjectScratchDirectories)
- [No Backups](#Terremoto-Storage-NoBackups)

## Storage Overview

After logging in to Terremoto you will be in your home directory. This home directory storage space (30 GB) is appropriate for smaller files, such as documents, source code, and scripts but will fill up quickly if used for data sets or other large files.

Terremoto's shared storage server is named "Moto", and consequently the path to all home and scratch directories begins with "**/moto**". Your home directory is located at **/moto/home/<UNI>**. This is also the value of the environment variable $HOME.

Each group account on Terremoto has an associated scratch storage space that is at least 1 terabyte (TB) in size. Note the important "**No backups**" warning regarding this storage at the bottom of this page. Your group account's scratch storage is located under /moto/<ACCOUNT>. The storage for each account is as following:

| Location | Size | Default User Quota |
| --- | --- | --- |
| $HOME | n/a | 30 GB (102,400 inodes) |
| /moto/apam | 9 TB | None |
| /moto/asenjo | 1 TB | None |
| /moto/astro | 48 TB | None |
| /moto/atmchm | 12 TB | None |
| /moto/axs | 5 TB | None |
| /moto/berkelbach | 8 TB | None |
| /moto/buck | 1 TB | None |
| /moto/buddy | 4 TB | None |
| /moto/cboyce | 20 TB | None |
| /moto/cheme | 2 TB | None |
| /moto/cs | 2 TB | None |
| /moto/cury | 3TB | None |
| /moto/eaton | 6 TB | None |
| /moto/edu | 3 TB | None |
| /moto/edu/e4880 | 3 TB | None |
| /moto/edu/emlab | 3 TB | None |
| /moto/fortin | 4 TB | None |
| /moto/free | 1 TB | 32 GB |
| /moto/febio | 2 TB | None |
| /moto/gsb | 10 TB | None |
| /moto/hblab | 20 TB | None |
| /moto/hill | 8 TB | None |
| /moto/iicd | 20 TB | None |
| /moto/katt2 | 1 TB | None |
| /moto/kohwi | 2 TB | None |
| /moto/kumar | 3 TB | None |
| /moto/mauel | 10 TB | None |
| /moto/nklab | 2 TB | None |
| /moto/palab | 90 TB | None |
| /moto/pdlab | 15 TB | None |
| /moto/qmech | 3 TB | None |
| /moto/rent | 1 TB | 100 GB |
| /moto/roam | 1 TB | None |
| /moto/slab | 1 TB | None |
| /moto/sscc | 50 TB | None |
| /moto/stats | 6 TB | None |
| /moto/trl | 40 TB | None |
| /moto/urban | 10 TB | None |
| /moto/yoon | 3 TB | None |
| /moto/zi | 5 TB | None |
| /moto/ziab | 8 TB | None |
| /moto/zims | 2 TB | None |
| /moto/zidw | 3 TB | None |

The amount of data stored in any directory along with its subdirectories can be found with:

```
cd <directoryName>
du -sh .
```

If you have lots of files in the directory, please allow some time for the 'du' command to return with its output.

## Inodes

Inodes are used to store information about files and directories and an inode is used up for every file and directory that's created. Each group has a limited number of inodes based on how many TB of storage purchased. To check your groups inode usage and limit, run:

```
$ df -hi /moto/<ACCOUNT>
```

Should your group run out of inodes and there are free inodes available, we may be able to increase your inode allocation. Please contact us for more details about this if your group is running out of inodes.

The inode quota for home directories is 102,400.

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

Terremoto users can create directories in their account's scratch storage using their UNI or a project name.

```
$ cd /moto/<ACCOUNT>/users/
$ mkdir <UNI>
```

For example, an astro member may create the following directory:

```
$ cd /moto/astro/users/
$ mkdir <UNI>
```

Alternatively, for a project shared with other users:

```
$ cd /moto/astro/projects/
$ mkdir <PROJECT_NAME>
```

Naming conventions (such as using your UNI for your users directory) are not enforced, but following them is highly recommended as they have worked well as organization mechanisms on previous clusters.

## No Backups

Storage is not backed up. User files may be lost due to hardware failure, user error, or other unanticipated events.

**It is the responsibility of users to ensure that important files are copied from the system to other more robust storage locations.**
