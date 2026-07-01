# Terremoto - New Queue System

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/1221951489/Terremoto+-+New+Queue+System

---

We've introduced a new queue structure to optimize resource allocation and improve job scheduling across the cluster. Each queue is designed for specific use cases and priority levels.

The core of our scheduling is based on QoS Priority, which determines job start order and whether a job can be interrupted by a higher-priority request. All time syntax uses the format `[days-][hours:]minutes[:seconds]`.

- [1. The Four Queue Types](#Terremoto-NewQueueSystem-1.TheFourQueueTypes)
- [2. Understanding Preemption](#Terremoto-NewQueueSystem-2.UnderstandingPreemption)
  - [Preemption Policy](#Terremoto-NewQueueSystem-PreemptionPolicy)
  - [Preemption Grace Period](#Terremoto-NewQueueSystem-PreemptionGracePeriod)
- [3. How to Submit Your Jobs](#Terremoto-NewQueueSystem-3.HowtoSubmitYourJobs)
  - [A. hpc\_test — Testing & Trial Runs](#Terremoto-NewQueueSystem-A.hpc_test—Testing&TrialRuns)
  - [Standard Jobs](#Terremoto-NewQueueSystem-StandardJobs)
    - [B. short — Standard Daily Workloads](#Terremoto-NewQueueSystem-B.short—StandardDailyWorkloads)
    - [C. long — Extended Jobs on Owner Nodes](#Terremoto-NewQueueSystem-C.long—ExtendedJobsonOwnerNodes)
  - [D. burst — High-Throughput with Preemption](#Terremoto-NewQueueSystem-D.burst—High-ThroughputwithPreemption)
- [4. Important Per-User Limits](#Terremoto-NewQueueSystem-4.ImportantPer-UserLimits)
- [5. Queue Spotlight: burst — High-Throughput with Preemption](#Terremoto-NewQueueSystem-5.QueueSpotlight:burst—High-ThroughputwithPreemption)
  - [Important Considerations](#Terremoto-NewQueueSystem-ImportantConsiderations)
  - [Best Practices](#Terremoto-NewQueueSystem-BestPractices)

## 1. The Four Queue Types

All jobs are automatically assigned a Quality of Service (QoS) based on your submission details, or you can explicitly request the special `hpc_test` or `burst` QoS using the `--qos` flag.

|  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- |
| **QoS Name** | **Purpose** | **Max Wall Time** | **Priority** | **Preemption Risk** | **How to Use** |
| `hpc_test` | **Quick testing** and validation. Gets immediate, high-priority access. | **6 hours** | **Highest (600)** | **None** | Explicitly request with `#SBATCH --qos=hpc_test`. |
| `long` | **Long-running** jobs for group-owned resources (7 days). | **7 days** | **High (400)** | **None** | Assigned automatically when submitting to a **group-owned partition**:  `--partition=<group_partition>` |
| `short` | **Standard** day-to-day computational work on shared resources. | **12 hours** | **Medium (200)** | **None** | Assigned automatically when submitting to the **shared partition**: `--partition=short` |
| `burst` | **Opportunistic** computing for high-throughput, interruptible workloads. | **14 days** | **Lowest (10)** | **High** (Preemptible by `hpc_test` and `long`). | Explicitly request with `#SBATCH --qos=burst`. |

## 2. Understanding Preemption

Preemption is the process where a lower-priority job is interrupted (`REQUEUED`) to immediately make room for a higher-priority job.

### Preemption Policy

Only jobs running with the `burst`queue are subject to preemption. The other standard queues (`hpc_test`, `long`, and `short`) guarantee uninterrupted execution.

- **Who Preempts** `burst`**?**

  - `hpc_test` (Priority 600)
  - `long` (Priority 400)

### Preemption Grace Period

A preempted `burst` job is given a **30-minute grace period**. The job will have a reason `BeginTime` indicating that the job has been preempted and the job is automatically **requeued** for rescheduling on available node(s).

## 3. How to Submit Your Jobs

All submissions use the batch job method (`sbatch`). The system will automatically assign the QoS for `short` and `long` jobs based on the partition used.

### A. `hpc_test` — Testing & Trial Runs

Use this queue for quick tests and trial runs before submitting larger jobs.

```
#!/bin/bash
#SBATCH --account=<account>
#SBATCH --time=06:00:00     
#SBATCH --qos=hpc_test      # Explicitly requests the hpc_test queue
#SBATCH --job-name=hpc-test-run

# Your commands here
```

### Standard Jobs

The system will automatically assign the appropriate QoS based on the requested partition - short & long (group-owned partition).

#### B. `short` — Standard Daily Workloads

The recommended queue for standard day-to-day computational work on shared resources.

```
#!/bin/bash
#SBATCH --account=<account>
#SBATCH --partition=short    # Requesting short partition
#SBATCH --time=12:00:00
#SBATCH --job-name=my_short_job

# Your commands here
```

#### C. `long` — Extended Jobs on Owner Nodes

Used by node-owning groups for long-duration workloads on their dedicated resources. Substitute `<group_partition>` with your group's partition name.

```
#!/bin/bash
#SBATCH --account=<account>
#SBATCH --partition=<group_partition>    # Requesting group partition
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
#SBATCH --qos=burst          # Explicitly requests the burst queue
#SBATCH --time=14-00:00:00
#SBATCH --requeue            # Highly Recommended for automatic restart
#SBATCH --job-name=my_burst_job

# Your commands here
```

## 4. Important Per-User Limits

To ensure fair resource sharing, the following user limits are strictly enforced by the QoS settings:

|  |  |  |  |
| --- | --- | --- | --- |
| **QoS Name** | **Max Running Jobs Per User** | **Max Submissions Per User** | **Max Wall Time** |
| `hpc_test` | 5 | 20 | 6 hours |
| `long` | 500 | 5000 | 7 days |
| `short` | 500 | 5000 | 12 hours |
| `burst` | 500 | 5000 | 14 days |

## 5. Queue Spotlight: `burst` — High-Throughput with Preemption

The `burst` queue maximizes cluster utilization by providing opportunistic access to all available nodes. It is implemented as a **QoS** with a **Priority of 10**.

### **Important Considerations**

Jobs in the burst queue are **not guaranteed to complete** without interruption. If a node owner launches a job on their hardware, any burst queue job running on that node will be:

1. Automatically canceled
2. Re-queued by SLURM
3. Rescheduled on another available node when possible

### Best Practices

Jobs submitted to the `burst` queue **must** be designed to handle interruptions:

- **Checkpointing** — Save progress at regular intervals so work can resume from the last checkpoint after preemption.
- **Stateless execution** — Design jobs that can restart cleanly without requiring saved state from previous runs.
