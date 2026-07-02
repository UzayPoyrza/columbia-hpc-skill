# Terremoto - Technical Information

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62140825/Terremoto+-+Technical+Information

---

- [Hardware](#Terremoto-TechnicalInformation-Hardware)
  - [Standard Nodes](#Terremoto-TechnicalInformation-StandardNodes)
  - [High Memory Nodes](#Terremoto-TechnicalInformation-HighMemoryNodes)
  - [GPU Nodes](#Terremoto-TechnicalInformation-GPUNodes)
  - [Storage](#Terremoto-TechnicalInformation-Storage)
  - [Network](#Terremoto-TechnicalInformation-Network)
- [Scheduler](#Terremoto-TechnicalInformation-Scheduler)
- [Fair share](#Terremoto-TechnicalInformation-Fairshare)

# Hardware

Terremoto has 137 nodes with a total of 3288 cores (24 cores per node)

- 111 Standard Nodes (192 GB)
- 14 High Memory Nodes (768 GB)
- 12 GPU Nodes with two Nvidia V100 GPU modules

## Standard Nodes

Terremoto has 111 Standard Nodes with the following specifications:

|  |  |
| --- | --- |
| Model | Dell C6420 |
| CPU | Intel Xeon Gold 6126 2.6 Ghz |
| Number of CPUs | 2 |
| Cores per CPU | 12 |
| Total Cores | 24 |
| Memory | 192 GB |
| Network | EDR Infiniband |

## High Memory Nodes

Terremoto's 14 high memory nodes have 768 GB of memory each. They are otherwise identical to the standard nodes.

## GPU Nodes

Terremoto has 12 GPU nodes, each with two Nvidia V100 GPU modules. They are otherwise identical to the standard nodes.

## Storage

500 TB of GPFS parallel file system storage is used for scratch space and home directories.

## Network

10 Gb/s ethernet connections to the Internet from login nodes and transfer node. 100 Gb/s EDR Infiniband connection between compute nodes.

# Scheduler

Terremoto uses the [Slurm](https://slurm.schedmd.com/)scheduler to manage jobs.

# Fair share

Resource allocation on our cluster is based on each group's contribution to computing cores. The Slurm scheduler uses fair share targets and historical resource utilization to determine when jobs are scheduled to run. Also, within-group priority is based on historical usage such that heavier users will have a lower priority than light users. Slurm uses all of a job's attributes - such as wall time, resource constraints, and group membership - to determine the order in which jobs are run. 

Using job data such as walltime and resources requested, the scheduler can start other, lower-priority jobs so long as they do not delay the highest priority jobs. Because it works by essentially filling in holes in node space, backfill tends to favor smaller and shorter running jobs more than larger and longer running ones.

There is no preemption in the current system; a job in the queue will never interrupt or stop a job in run state.
