# Insomnia - Technical Information

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62145136/Insomnia+-+Technical+Information

---

- [Hardware](#Insomnia-TechnicalInformation-Hardware)
  - [Standard Nodes](#Insomnia-TechnicalInformation-StandardNodes)
  - [High Memory Nodes](#Insomnia-TechnicalInformation-HighMemoryNodes)
  - [GPU Nodes](#Insomnia-TechnicalInformation-GPUNodes)
  - [Storage](#Insomnia-TechnicalInformation-Storage)
  - [Network](#Insomnia-TechnicalInformation-Network)
- [Scheduler](#Insomnia-TechnicalInformation-Scheduler)
- [Fair share](#Insomnia-TechnicalInformation-Fairshare)

Insomnia is currently running **Red Hat Enterprise Linux release 9.3**

# Hardware

Insomnia has 90 nodes with a cluster total of 14,288 cores (80 physical cores per node, doubled via hyperthreading) running Red Hat Enterprise Linux 9.3

- 41 Standard Nodes (512 GB ram)
- 19 High Memory Nodes (1 TB ram)
- 13 GPU Nodes with eight NVIDIA RTX A6000 GPU modules
- 2 GPU Nodes with four NVIDIA RTX A6000 GPU modules
- 3 GPU Nodes with two NVIDIA H100 GPU modules
- 3 GPU Nodes with two NVIDIA L40 GPU modules
- 9 GPU Nodes with two NVIDIA L40s GPU modules

## Standard Nodes

Insomnia has 41 Standard Nodes with the following specifications:

|  |  |
| --- | --- |
| **Model** | Dell |
| **CPU** | Intel Xeon Platinum 8460Y 2 Ghz |
| **Number of CPUs** | 2 |
| **Cores per CPU** | 40 |
| **Total PHYSICAL Cores per node** | 80 |
| **Total USABLE Cores per node** | 160 (hyperthreading is enabled on Insomnia) |
| **Memory** | 512 GB |
| **Network** | HDR Infiniband |

## High Memory Nodes

Insomnia's 19 high memory nodes have 1 TB of memory each. They are otherwise identical to the standard nodes.

## GPU Nodes

See the Hardware section above for a breakdown by GPU model. All GPU nodes are otherwise identical to the standard nodes.

## Storage

Insomnia has 2.283PB on a GPFS filesystem  used for scratch space and home directories.

## Network

10 Gb/s ethernet connections to the Internet from login nodes. 100 Gb/s HDR Infiniband connection between compute nodes.

# Scheduler

Insomnia uses the [Slurm](https://slurm.schedmd.com/)scheduler to manage jobs.

# Fair share

Resource allocation on our cluster is based on each group's contribution to computing cores. The Slurm scheduler uses fair share targets and historical resource utilization to determine when jobs are scheduled to run. Also, within-group priority is based on historical usage such that heavier users will have a lower priority than light users. Slurm uses all of a job's attributes - such as wall time, resource constraints, and group membership - to determine the order in which jobs are run.

Using job data such as walltime and resources requested, the scheduler can start other, lower-priority jobs so long as they do not delay the highest priority jobs. Because it works by essentially filling in holes in node space, backfill tends to favor smaller and shorter running jobs more than larger and longer running ones.

There is no preemption in the current system; a job in the queue will never interrupt or stop a job in run state.
