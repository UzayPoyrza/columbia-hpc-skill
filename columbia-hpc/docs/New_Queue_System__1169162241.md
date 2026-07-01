# New Queue System

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/1169162241/New+Queue+System

---

We've introduced a new queue structure to optimize resource allocation and improve job scheduling across the cluster. Each queue is designed for specific use cases and priority levels.

The core of our scheduling is based on QoS Priority, which determines job start order and whether a job can be interrupted by a higher-priority request. All time syntax uses the format `[days-][hours:]minutes[:seconds]`.

**NOTE:** The new queue system applies to all clusters.

- [1. The Four Queue Types](#NewQueueSystem-1.TheFourQueueTypes)
- [2. Understanding Preemption](#NewQueueSystem-2.UnderstandingPreemption)
  - [Preemption Policy](#NewQueueSystem-PreemptionPolicy)
  - [Preemption Grace Period](#NewQueueSystem-PreemptionGracePeriod)
- [3. How to Submit Your Jobs](#NewQueueSystem-3.HowtoSubmitYourJobs)
  - [A. hpc\_test — Testing & Trial Runs for node owners](#NewQueueSystem-A.hpc_test—Testing&TrialRunsfornodeowners)
  - [Standard Jobs](#NewQueueSystem-StandardJobs)
    - [B. short — Access any node in the cluster](#NewQueueSystem-B.short—Accessanynodeinthecluster)
    - [C. Group partition — Extended Jobs on Owner Nodes](#NewQueueSystem-C.Grouppartition—ExtendedJobsonOwnerNodes)
  - [D. burst — High-Throughput with Preemption](#NewQueueSystem-D.burst—High-ThroughputwithPreemption)
- [4. Important Per-User Limits](#NewQueueSystem-4.ImportantPer-UserLimits)
- [5. Queue Spotlight: burst — High-Throughput with Preemption](#NewQueueSystem-5.QueueSpotlight:burst—High-ThroughputwithPreemption)
  - [Important Considerations](#NewQueueSystem-ImportantConsiderations)
  - [Best Practices](#NewQueueSystem-BestPractices)

## 1. The Four Queue Types

All jobs are automatically assigned a Quality of Service (QoS) based on your submission details, or you can explicitly request the special `hpc_test` or `burst` QoS using the `--qos` flag.

|  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| **Queue Name** | **Purpose** | **Max Wall Time** | **Priority** | **Preemption Risk** | **How to Use** |
| `hpc_test` | For quick testing and validation. **Node owners** get immediate, high-priority access on the nodes their group has purchased. | **6 hours** | **Highest (600)** | **None** | Explicitly request with `#SBATCH --qos=hpc_test`. *(free and edu users **do not** have access to this queue)* |
| Group partition  *(not necessary to* *specify)* | **Long-running** jobs for group-owned resources (7 days). | **7 days** | **High (400)** | **None** | **Default behavior.** Assigned automatically based on your account (e.g., `--account=ntar_lab` defaults to `--partition=ntar_lab1`). |
| `short` | **Shared queue** A way to access any node in the cluster outside of the ones your group owns, but only for a short time. | **12 hours** | **Medium (200)** | **None** | Explicitly request with `#SBATCH --partition=short`. This allows you to access specialized hardware (like GPU or High-Memory nodes) that your group does not own for up to 12 hours. |
| `burst` | **Opportunistic** computing for high-throughput, interruptible workloads. | **14 days** | **Lowest (10)** | **High** (Preemptible by `hpc_test` and a group owner’s account). | Explicitly request with `#SBATCH --partition=burst`. |

## 2. Understanding Preemption

Preemption is the process where a lower-priority job is interrupted (`REQUEUED`) to immediately make room for a higher-priority job.

### Preemption Policy

Only jobs running with the `burst`queue are subject to preemption. The other standard queues (`hpc_test`, Group partition, and `short`) guarantee uninterrupted execution.

- **Who Preempts** `burst`**?**

  - `hpc_test` (Priority 600)
  - Group partition (Priority 400)

### Preemption Grace Period

A preempted `burst` job is given a **30-minute grace period**. The job will have a reason `BeginTime` indicating that the job has been preempted and the job is automatically **requeued** for rescheduling on available node(s).

## 3. How to Submit Your Jobs

All submissions use the batch job method (`sbatch`). The system will automatically assign the QoS for `short` and group partition jobs based on the partition used.

### A. `hpc_test` — Testing & Trial Runs for node owners

Use this queue for quick tests and trial runs before submitting larger jobs.

```
#!/bin/bash
#SBATCH --account=<account>
#SBATCH --time=06:00:00     
#SBATCH --qos=hpc_test      # Explicitly requests the hpc_test queue
#SBATCH --job-name=hpc-test-run

# Your commands here
```

free and edu users **do not** have access to hpc\_test queue.

### Standard Jobs

The system will automatically assign the appropriate QoS based on the requested partition - short & group partition.

#### B. `short` — Access any node in the cluster

This job will run on any free node in the cluster, but only for 12 hours or less.

```
#!/bin/bash
#SBATCH --account=<account>
#SBATCH --partition=short    # Requesting short partition
#SBATCH --time=12:00:00
#SBATCH --job-name=my_short_job

# Your commands here
-----------------------------------------------
A common example use. If your group does not own a GPU node, you can use another group's, but only for a limited time.

#!/bin/bash
#SBATCH --account=<account>
#SBATCH --partition=short    # Requesting short partition
#SBATCH --gres=gpu:1         # Request 1 GPU
#SBATCH --time=12:00:00
#SBATCH --job-name=my_short_job
```

#### C. Group partition — Extended Jobs on Owner Nodes

Used by node-owning groups for longer-duration workloads on their own nodes. Your partition is implicit with your account and does not have to be specified.

```
#!/bin/bash
#SBATCH --account=<my_group_account>
#SBATCH --partition=<my_group_account1>    # Group partition. Again, this is optional. SLURM will invisibly supply this when using "--account=<my_group_account>"
#SBATCH --time=7-00:00:00
#SBATCH --job-name=my_long_job

# Your commands here
```

Please note that if partition is not defined it will default to your group’s partition.

### D. `burst` — High-Throughput with Preemption

Ideal for workloads that can tolerate interruptions. Use the `--requeue` flag to ensure the job automatically restarts if preempted.

```
#!/bin/bash
#SBATCH --account=<account>
#SBATCH --partition=burst          # Explicitly requests the burst queue
#SBATCH --time=14-00:00:00
#SBATCH --requeue                  # Highly Recommended for automatic restart
#SBATCH --job-name=my_burst_job

# Your commands here
```

## 4. Important Per-User Limits

To ensure fair resource sharing, the following user limits are strictly enforced by the QoS settings:

|  |  |  |  |
| --- | --- | --- | --- |
| **QoS Name** | **Max Running Jobs Per User** | **Max Submissions Per User** | **Max Wall Time** |
| `hpc_test` | 5 | 20 | 6 hours |
| Group partition | 500 | 5000 | 7 days |
| `short` | 500 | 5000 | 12 hours |
| `burst` | 500 | 5000 | 14 days |

## 5. Queue Spotlight: `burst` — High-Throughput with Preemption

The `burst` queue maximizes cluster utilization by providing opportunistic access to all available nodes. It is implemented with the lowest priority.

### **Important Considerations**

Jobs in the burst queue are **not guaranteed to complete** without interruption. If a node owner launches a job on their hardware, any burst queue job running on that node will be:

1. Automatically canceled
2. Re-queued by SLURM
3. Rescheduled on another available node when possible
4. **Interactive sessions** on the burst partition receive the same 14-day walltime as other burst jobs, remain subject to burst preemption, and are limited to 2 interactive jobs per user.

### Best Practices

Jobs submitted to the `burst` queue **must** be designed to handle interruptions:

- **Checkpointing** — Save progress at regular intervals so work can resume from the last checkpoint after preemption.
- **Stateless execution** — Design jobs that can restart cleanly without requiring saved state from previous runs.
