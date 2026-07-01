# Columbia HPC Clusters — Reference

**How to use this file:** look up per-cluster login/transfer hostnames, node specs, partitions/QoS, walltime and job limits, and how account names work; where the source docs disagree, a ⚠ note flags the conflict — verify against the live wiki before relying on it.

**Source:** offline snapshot of Columbia CUIT HPC wiki (`/Users/uzaypoyraz/cuit-hpc-docs/`, captured 2026-06-30). All specs below are drawn only from those pages (HPC overview + each cluster's Technical Information, Getting Started, Submitting Jobs, User Documentation, plus Terremoto New Queue System / Working pages). Node counts and policies are time-sensitive — confirm against the source `Source:` URLs.

## Summary

| Cluster | Login (short) | Transfer | Nodes | Cores/node | Std RAM | High-mem | GPUs | OS / interconnect |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Insomnia | insomnia / som .rcs.columbia.edu | Globus only | 90 | 80 phys / 160 logical | 512 GB | 1 TB (mem1024) | A600, H100, L40, L40s | RHEL 9.3 / HDR IB |
| Ginsburg | ginsburg / burg .rcs.columbia.edu | motion.rcs.columbia.edu | 286 | 32 | 192 GB | 768 GB (mem768) | RTX 8000, V100S, A40, A100 | RHEL 8 / HDR IB |
| Terremoto | terremoto / moto .rcs.columbia.edu | quake.rcs.columbia.edu | 137 | 24 | 192 GB | 768 GB (mem768) | V100 | EDR IB |

All three use the **Slurm** scheduler with fair-share priority (no preemption in the legacy model; see Terremoto queue system for the preemptible `burst` QoS). Accounts on every cluster are **group (lab/department) names**, not your UNI, passed via `-A`/`--account`.

> **Verified on-cluster (2026-07-01) — Insomnia:** nodes are dual 40-core Intel Xeon Platinum 8460Y = **80 physical cores/node (160 logical with hyperthreading)**. The Submitting-Jobs page's "**32 cores**" (and its directives table's "max 24 cores") is **STALE** — do not trust it. A GPU node observed was an **NVIDIA RTX A6000 (48 GB)** (the docs' "A600" == RTX A6000).

---

## Insomnia

**Access.** Login/submit: `insomnia.rcs.columbia.edu` or short form `som.rcs.columbia.edu`. **Duo 2FA** is enabled on all public login and transfer nodes; after Duo you enter your UNI password.
**Transfer.** Insomnia **no longer supports direct SCP/SFTP** (no FileZilla/CyberDuck/WinSCP/scp/sftp) — use **Globus** only. (`som.rcs.columbia.edu` still appears in SSH port-forward examples for interactive web apps.)

**Nodes (90 total).** Dual **Intel Xeon Platinum 8460Y @ 2 GHz**, 2 CPUs × 40 cores = **80 physical cores/node, 160 usable (hyperthreading enabled)**.

| Type | Count | RAM | Notes |
| --- | --- | --- | --- |
| Standard | 41 | 512 GB (~510 GB usable) | `-C mem400` requests a standard node w/ 400 GB |
| High-memory | 19 | 1 TB (1024 GB) | `-C mem1024` / `--constraint=mem1024` |
| GPU | 30 | same as standard | 13×(8 A600), 2×(4 A600), 3×(2 H100), 3×(2 L40), 9×(2 L40s) |

**Cluster totals:** 7,144 physical / 14,288 logical cores; ~58.3 TiB RAM; **2.283 PB GPFS** (scratch + home); HDR Infiniband (100 Gb/s between nodes, 10 Gb/s ethernet uplink); **RHEL 9.3**.
**Memory default:** 5,800 MB per core if unspecified.
**Walltime:** max **5 days (120 h)** but only on nodes your group owns; on all other/shared nodes the limit is **12 h**.
**Job limits:** **500** max running jobs/user; **5,000** max submitted/user; job array ≤ **1,001** elements.
**Accounts:** group names from the submit-account table (e.g. `berkelbach`, `astro`, `iicd`, `sscc`, `free`, `friesner`, `qmech`, …); `free` = Free-Tier users with limited run times.
⚠ **Stale/conflict:** Submitting-Jobs page says "max cores per node is 32", its directives table says "max 24 cores", and memory examples assume 32 cores → 160 GB — all wrong per the on-cluster verification above (80 physical / 160 logical).

---

## Ginsburg

**Access.** Login/submit: `ginsburg.rcs.columbia.edu` or short form `burg.rcs.columbia.edu`. Duo 2FA + UNI password. (The Getting-Started text mistakenly says "Insomnia login and transfer nodes.")
**Transfer.** Use `motion.rcs.columbia.edu` for SCP file transfer; Globus supported for large transfers.

**Nodes (286 total).** Dual **Intel Xeon Gold 6226R @ 2.9 GHz** (Tech-Info table writes "6226"), 2 CPUs × 16 cores = **32 cores/node**.

| Type | Count | RAM | Notes |
| --- | --- | --- | --- |
| Standard | 191 | 192 GB (~187 GB usable) | `-C mem192` |
| High-memory | 56 | 768 GB | `-C mem768` / `--constraint=mem768` |
| GPU | 39 | same as standard | 18×(2 RTX 8000), 4×(2 V100S), 9×(2 A40), 8×(2 A100) |

**Cluster totals:** 4,576 physical / 9,152 logical cores; ~77.10 TB RAM; **Lustre** parallel FS (scratch + home); HDR Infiniband (100 Gb/s; 10 Gb/s uplink); **RHEL 8**.
**Memory default:** 5,800 MB per core. GPU interactive job: `srun --pty --gres=gpu:1 -A <ACCOUNT> /bin/bash`.
**Walltime:** max **5 days (120 h)** on group-owned nodes; **12 h** on all other nodes.
**Job limits:** **50** max running jobs/user; **5,000** max submitted/user; job array ≤ **1,001** elements.
**Accounts:** group names table (e.g. `apam`, `astro`, `stats`, `dsi`, `iicd`, `gsb`, `zi`, ocean-climate groups `abernathey`/`camargo`/`fiore`/… etc.).
**Retirement (tentative):** Phase 1 Feb 2026, Phase 2 Mar 2027, Phase 3 Dec 2027.
⚠ **Conflicts:** CPU model listed as "6226R" (overview) vs "6226" (Tech-Info table); storage listed as "1 PB DDN ES7790 Lustre" (overview) vs "1.1 PB Lustre" (Tech-Info). Tech-Info header's "9,152 cores (32 cores per node)" counts logical CPUs (286×32=9,152); physical cores = 4,576.

---

## Terremoto

**Access.** Login/submit: `terremoto.rcs.columbia.edu` or short form `moto.rcs.columbia.edu`. Docs say only "provide your usual Columbia password" (no Duo mentioned for Terremoto).
**Transfer.** Use `quake.rcs.columbia.edu` for SCP; Globus endpoint "Columbia Terremoto". Named transfer nodes: **shake, bake, quake** (also expose Habanero `/rigel` storage on login/transfer nodes, not compute nodes).

**Nodes (137 total).** Dual **Intel Xeon Gold 6126 @ 2.6 GHz**, 2 CPUs × 12 cores = **24 cores/node**.

| Type | Count | RAM | Notes |
| --- | --- | --- | --- |
| Standard | 111 | 192 GB | `-C mem192` |
| High-memory | 14 | 768 GB | `-C mem768` / `--constraint=mem768` |
| GPU | 12 | same as standard | 2× Nvidia V100 each |

**Cluster totals:** 3,288 cores (24/node); **500 TB GPFS** (scratch + home); EDR Infiniband (100 Gb/s; 10 Gb/s uplink); Slurm.
**Memory default:** **4 GB per CPU** (note: differs from Insomnia/Ginsburg's 5,800 MB).

**Queue system (New Queue — 4 QoS/partitions).** Request `hpc_test`/`burst` via `--qos`; `short`/`long` are assigned by partition. Time syntax `[days-][hours:]minutes[:seconds]`.

| QoS | Purpose | Max walltime | Priority | Preemptible | Max running / submitted per user |
| --- | --- | --- | --- | --- | --- |
| `hpc_test` | quick testing/validation (`--qos=hpc_test`) | 6 h | 600 (highest) | no | 5 / 20 |
| `short` | shared partition, day-to-day (`--partition=short`) | 12 h | 200 | no | 500 / 5000 |
| `long` | group-owned partition, extended (`--partition=<group>`, default) | 7 days | 400 | no | 500 / 5000 |
| `burst` | opportunistic/high-throughput (`--qos=burst`, use `--requeue`) | 14 days | 10 (lowest) | **yes** (30-min grace, requeued) | 500 / 5000 |

Only `burst` is preemptible (by `hpc_test` and `long`/group-owner jobs). If no partition is given, it defaults to your group's partition.
**Legacy walltime model (Submitting-Jobs page):** max **5 days (120 h)**; group-owned nodes give priority; other groups' nodes capped at **12 h**; public nodes open to all for up to 5 days.
**Job limits (Submitting-Jobs page):** **1,005** max running jobs/user; **5,000** max submitted/user; job array ≤ **1,001** elements. (New-Queue per-QoS caps above are stricter: 500 running per QoS, 5/20 for `hpc_test`.)
**Accounts:** group names table (e.g. `apam`, `astro`, `stats`, `gsb`, `qmech`, `zi`, `sscc`, `cs`, …); "not all group names finalized" per docs.
⚠ **Conflicts:** Tech-Info says **111 standard + 14 high-mem**, but the Submitting-Jobs "Memory Requests" section says **92 standard + 10 high-mem**. Tech-Info's High-Memory-Nodes paragraph says "114 high memory nodes" — a typo for **14** (matches its own header and the 137 total).

---

## Cross-cluster note on the queue system

The general **New Queue System** wiki page states the QoS model (`hpc_test` / `short` / group-partition / `burst`, with the same 6 h / 12 h / 7-day / 14-day walltimes and preemption rules) **applies to all clusters**. Only Terremoto has a dedicated queue-system page in this snapshot; the Insomnia and Ginsburg Submitting-Jobs pages still document the older "owned-node = 5 days, other nodes = 12 h" model and do not mention named partitions. Confirm the effective policy per cluster against the live wiki.
