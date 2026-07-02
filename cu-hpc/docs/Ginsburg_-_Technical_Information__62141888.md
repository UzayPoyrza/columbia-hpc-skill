# Ginsburg - Technical Information

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62141888/Ginsburg+-+Technical+Information

---

# Hardware

Ginsburg has 286 nodes with a total of 9,152 cores (32 cores per node)

- 191 Standard Nodes (192 GB)
- 56 High Memory Nodes (768 GB)
- 18 GPU Nodes with two Nvidia RTX 8000 GPU modules
- 4 GPU Nodes with two Nvidia V100S GPU modules
- 9 GPU Nodes with two Nvidia A40 GPU modules
- 8 GPU nodes with two Nvidia A100 GPU modules

## Standard Nodes

Ginsburg has 191 Standard Nodes with the following specifications:

|  |  |
| --- | --- |
| Model | Dell |
| CPU | Intel Xeon Gold 6226R 2.9 Ghz |
| Number of CPUs | 2 |
| Cores per CPU | 16 |
| Total Cores | 32 |
| Memory | 192 GB |
| Network | HDR Infiniband |

## High Memory Nodes

Ginsburg's 56 high memory nodes have 768 GB of memory each. They are otherwise identical to the standard nodes.

## GPU Nodes

See the [Hardware section above](https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/62141888/Ginsburg+-+Technical+Information#Hardware) for a breakdown by GPU model. All GPU nodes are otherwise identical to the standard nodes.

## Storage

1.1 PB of Lustre parallel file system storage is used for scratch space and home directories.

## Network

10 Gb/s ethernet connections to the Internet from login nodes and transfer node. 100 Gb/s HDR Infiniband connection between compute nodes.

# Scheduler

Ginsburg uses the [Slurm](https://slurm.schedmd.com/)scheduler to manage jobs.

# Fair share

Resource allocation on our cluster is based on each group's contribution to computing cores. The Slurm scheduler uses fair share targets and historical resource utilization to determine when jobs are scheduled to run. Also, within-group priority is based on historical usage such that heavier users will have a lower priority than light users. Slurm uses all of a job's attributes - such as wall time, resource constraints, and group membership - to determine the order in which jobs are run.

Using job data such as walltime and resources requested, the scheduler can start other, lower-priority jobs so long as they do not delay the highest priority jobs. Because it works by essentially filling in holes in node space, backfill tends to favor smaller and shorter running jobs more than larger and longer running ones.

There is no preemption in the current system; a job in the queue will never interrupt or stop a job in run state.
