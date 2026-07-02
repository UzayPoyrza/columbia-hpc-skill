# Interactive Job Policy

Source: https://columbiauniversity.atlassian.net/wiki/spaces/rcs/pages/1156546561/Interactive+Job+Policy

---

## Interactive Job

An Interactive Job is a resource allocation requested through Slurm commands that grant the user a shell session on a compute node, allowing for real-time engagement and immediate feedback.

NOTE: This policy applies to all clusters.

**An interactive job is typically launched using:**

- `salloc`: Requesting a resource allocation and then manually launching processes within the reserved environment.
- `srun` (without a script): Directly launching a command that requires terminal input or graphical output without using a formal batch script (`/bin/bash`).

Interactive sessions are **not** intended for long-running production workloads

## Interactive job policy

To ensure fair access and resource availability for all users, the following limits are enforced for interactive jobs submitted:

| **Policy Parameter** | **Limit** | **Details** |
| --- | --- | --- |
| Max Concurrent Sessions | 2 per user | A user may have a maximum of two running or pending interactive sessions simultaneously. |
| Max Walltime | 48 hours | The maximum execution time allowed for any single interactive session is 48 hours. Sessions reaching this limit will be automatically cancelled by the scheduler. |

## **Policy Enforcement**

The limits detailed above are enforced by the Slurm workload manager at the time of job submission. Attempts to submit more than the maximum number of sessions will result in a submission error with a message explaining the restriction.

If you have any questions or concerns about our interactive job policy or need assistance with job submission, please email us at [**hpc-suppport@columbia.edu**](mailto:hpc-suppport@columbia.edu).
