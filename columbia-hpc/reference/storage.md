# Columbia University HPC — Storage Reference

> **Source of truth:** offline snapshot of Columbia CUIT HPC wiki, **captured 2026-06-30**
> from the RCS Confluence wiki (columbiauniversity.atlassian.net/wiki/spaces/rcs). Facts below are taken from the per-cluster
> **Storage**, **New Scratch Space**, and **Working on …** pages. Per-group TB allocations
> change over time — confirm against the live `Source:` URLs in each page before relying on a
> specific number. Two items (node-local `/tmp` behavior, apptainer/singularity cache path)
> are general HPC/tool behavior, not spelled out in the snapshot — they are marked as such.

Covers three cluster generations: **Insomnia** (`/insomnia001`), **Ginsburg** (`/burg`, plus
newer `/ginsburg` mount), **Terremoto** (`/moto`). The **Free Tier** lives on Insomnia hardware
under the `free` group.

---

## 1. Per-cluster paths (home + scratch/group)

Placeholders: `<uni>` = your Columbia UNI (login), `<group>` = your group/account name,
`<project>` = a shared project dir name.

| Cluster | Storage server | Home path ( = `$HOME`) | Home quota | Home inode quota | Group/scratch path pattern | Min scratch |
| --- | --- | --- | --- | --- | --- | --- |
| **Insomnia** | `/insomnia001` | `/insomnia001/home/<uni>` | 50 GB | 150,000 † | `/insomnia001/depts/<group>` | ≥ 1 TB |
| **Ginsburg** (current) | `/burg` | `/burg/home/<uni>` | 50 GB | 150,000 | `/burg/<group>` | ≥ 1 TB |
| **Ginsburg** (new mount) | `/ginsburg` | (home stays on `/burg`) | — | — | `/ginsburg/<group>` | per New Scratch table |
| **Terremoto** | `/moto` (a.k.a. "Moto") | `/moto/home/<uni>` | 30 GB | 102,400 | `/moto/<group>` | ≥ 1 TB |
| **Free Tier** (on Insomnia) | `/insomnia001` | `/insomnia001/home/<uni>` | 30 GB | 102,400 | `/insomnia001/depts/free` | 32 GB/user quota in `free` scratch |

† Insomnia's **Storage** page states 150,000 for home inodes; the **Free Tier - Storage** page
states 102,400. Treat 150,000 as the standard Insomnia home figure and 102,400 as the Free Tier one.

Every storage page notes: **the home directory begins as `$HOME` after login** and is meant for
small files (documents, source code, scripts); it **fills up quickly** if used for datasets.

### Per-user and per-project subdirectories (same pattern on all clusters)

Group scratch is subdivided by UNI or project. Naming (UNI for your dir) is **not enforced but
strongly recommended**.

```
# Personal working dir:
cd /insomnia001/depts/<group>/users/     &&  mkdir <uni>   # Insomnia
cd /burg/<group>/users/                  &&  mkdir <uni>   # Ginsburg
cd /moto/<group>/users/                  &&  mkdir <uni>   # Terremoto

# Shared project dir:
cd /insomnia001/depts/<group>/projects/  &&  mkdir <project>
cd /burg/<group>/projects/               &&  mkdir <project>
cd /moto/<group>/projects/               &&  mkdir <project>
```

So a personal scratch working directory is, e.g.:
`/insomnia001/depts/<group>/users/<uni>/`, `/burg/<group>/users/<uni>/`, `/moto/<group>/users/<uni>/`.

---

## 2. Quotas & allocations

- **Home**: 50 GB on Insomnia and Ginsburg; 30 GB on Terremoto and Free Tier. `$HOME` inode
  quotas: 150,000 (Insomnia/Ginsburg) / 102,400 (Terremoto/Free Tier).
- **Group scratch**: "at least 1 TB" per group; actual size is per-group and listed in each
  cluster's Storage page. Group inode limits scale with purchased TB (Terremoto/Free Tier pages).
- **Example group allocations** (illustrative — see source pages for the full tables):

  | Insomnia (`/insomnia001/depts/…`) | Ginsburg current (`/burg/…`) | Ginsburg new (`/ginsburg/…`) | Terremoto (`/moto/…`) |
  | --- | --- | --- | --- |
  | `pas_lab` 100 TB, `friesner` 60 TB | `palab` 120 TB, `ocp` 100 TB* | `ocp` 62 TB, `palab` 60 TB | `palab` 90 TB, `sscc` 50 TB |
  | `morpheus` 30 TB, `sscc` 30 TB | `sscc` 90 TB, `thea` 88 TB | `ccce` 50 TB, `sscc` 45 TB | `astro` 48 TB, `trl` 40 TB |
  | `asenjo`/`free`/`xulab` 1 TB | `emlab`/`kellylab` 1 TB | `asenjo`/`emlab` 0.5 TB | many groups 1 TB |

  \* Ginsburg `/burg/ocp` is a 100 TB shared volume with a **per-user 10 TB** quota. On Terremoto
  most groups show a "None" default per-user quota (whole group scratch shared).
- **Ginsburg `/ginsburg` (new scratch space)**: newer mount provisioned to stress-test new
  storage. Phase 1 retirement groups sized to specific requested requirements; Phase 2 & 3 groups
  provisioned at **50% of their `/burg-archive` quota**. All new paths route through the
  `/ginsburg/` mount point; per-group TB values are in the New Scratch Space table.

### Purge / retention

- **No scratch purge or auto-deletion policy is documented in this snapshot.** The only stated
  data-safety policy is **No Backups**, present on every cluster's Storage page:
  *"Storage is not backed up. User files may be lost due to hardware failure, user error, or other
  unanticipated events. It is the responsibility of users to ensure that important files are copied
  from the system to other more robust storage locations."* This applies to **both home and
  scratch**. Keep your own copies of anything important; do not treat scratch as archival.

### Checking usage

```
df -h  <dir>      # Size = your quota, Avail = remaining (Insomnia/Ginsburg Storage pages)
du -sh <dir>      # actual space used by a dir + subdirs (may be slow with many files)
df -hi <dir>      # inode usage vs. limit, e.g. df -hi /moto/<group>
```

---

## 3. Shared-filesystem model

Each cluster's home and scratch live on a **single network-mounted "shared storage server"**
(`/insomnia001`, `/burg`, `/moto`). That filesystem is mounted **identically on the login/submit
node and on the compute nodes**, so:

- A file or folder you create on a **compute node persists** and is visible on the login node and
  every other compute node — and vice-versa. (Insomnia Getting Started notes that editing files and
  making folders works on both login and compute nodes; work should move to a compute node.)
- Paths are **absolute and stable** across nodes — a job started from
  `/burg/<group>/users/<uni>/run1` sees the same files on whatever node Slurm assigns.

**Cross-cluster storage visibility on compute nodes** (from the "Working on …" pages):

| From cluster | Other storage reachable | Reachable on **compute** nodes? |
| --- | --- | --- |
| Insomnia | `/burg` (Ginsburg) | **Yes** — `/burg` mounted on Insomnia login *and* compute nodes |
| Ginsburg | `/insomnia001`, `/moto` | **No** — visible on Insomnia login nodes only; **not** on Ginsburg compute nodes |
| Terremoto | `/rigel` (Habanero) | **No** — login/transfer nodes (shake, bake, quake) only, **not** compute nodes |

**Exception — node-local `/tmp`:** each compute node has its own local `/tmp` that is *not* shared
across nodes and is wiped when the job ends. Use shared scratch (not `/tmp`) for anything you need
to keep or read from another node. *(General HPC behavior — not documented in this snapshot; see
the verified note below.)*

---

## 4. Guidance / best practices

- **Run jobs from scratch/group space, not home.** Home is only 30–50 GB and is for scripts and
  source, not datasets or job I/O. Put working dirs under `…/depts/<group>/users/<uni>/` (Insomnia),
  `/burg/<group>/users/<uni>/` (Ginsburg), or `/moto/<group>/users/<uni>/` (Terremoto).
- **Mind quotas and inodes.** Check with `df -h`, `df -hi`, and `du -sh`. Home inode quotas
  (150,000 / 102,400) are hit by many small files, not just large ones — conda/pip trees and
  container layers are common offenders. Group inodes scale with purchased TB.
- **Clean large caches** that silently fill home:
  - **Conda** keeps package tarballs/index caches: `conda clean --all --dry-run` then
    `conda clean --all` (documented on every Storage page).
  - **Apptainer/Singularity** image cache: clear `~/.apptainer/cache` (or `~/.singularity/cache`),
    e.g. `apptainer cache clean`, and pull `.sif` images into **scratch**, not home. *(Cache path
    is standard apptainer behavior, not spelled out in this snapshot; the snapshot only notes that
    `apptainer pull` writes the image to your current working directory.)*
- **Nothing is backed up.** Copy results off-cluster (e.g. via Globus, the recommended transfer
  tool) — treat all cluster storage as loss-prone.

---

## 5. Verified on-cluster (2026-07-01)

- On **Insomnia**, a personal scratch folder at `/insomnia001/depts/<group>/users/<uni>/` is the
  right place for job working directories. **Confirmed.**
- The **login node and compute nodes share this filesystem**: a directory created there from the
  login node was present and writable from a compute node inside a job, and files written by the
  job were visible back on the login node after it finished. **Confirmed.**
- **Caveat:** node-local `/tmp` is per-node and cleared at job end — do not rely on it for
  persistence or for sharing data between nodes. Keep job I/O and outputs in shared scratch.
