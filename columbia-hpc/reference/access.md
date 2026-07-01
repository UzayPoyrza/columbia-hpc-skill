# Access: login, Duo, SSH config, accounts

## Logging in

SSH to the cluster's login/submit node with your Columbia **UNI**, then complete
**Duo two-factor** (a push/passcode is required on *every* login). Hostnames per
cluster are in `reference/clusters.md` (e.g. Insomnia `insomnia.rcs.columbia.edu`
/ `som.rcs.columbia.edu`).

```
ssh <uni>@insomnia.rcs.columbia.edu     # then approve Duo
```

First-time access needs an approved account/allocation on that cluster — direct new
users to Columbia's HPC service page.

## SSH config tips (do this once, locally)

On the user's **own machine**, add to `~/.ssh/config` so they type less and idle
sessions stop dropping:

```
Host *.columbia.edu
    User <uni>
    ServerAliveInterval 30
```
- `User <uni>` sets a default username, so `ssh insomnia.rcs.columbia.edu` works
  without `<uni>@`. Use the user's **own** UNI — a common mistake is pasting a
  colleague's config with *their* username.
- `ServerAliveInterval 30` sends a keepalive every 30 s so idle connections don't
  freeze/drop.
- Scope to `*.columbia.edu` (with the leading dot) rather than `Host *` so it only
  affects Columbia hosts. Then `chmod 600 ~/.ssh/config` — SSH ignores a config that
  others can write.

Add short aliases if useful:
```
Host insomnia
    HostName insomnia.rcs.columbia.edu
    User <uni>
```

### For agents/automation: reuse one authenticated connection

Because Duo fires on every new connection, running many `ssh`/`scp` commands would
prompt many times. Use SSH connection multiplexing so the user authenticates
**once** and subsequent commands reuse the live connection:

```
Host *.columbia.edu
    User <uni>
    ServerAliveInterval 30
    ControlMaster auto
    ControlPath ~/.ssh/cm-%r@%h:%p
    ControlPersist 8h
```
The user opens one connection (`ssh -fN insomnia.rcs.columbia.edu`, approves Duo);
all later commands ride on it for 8 h. Kill it with `ssh -O exit <host>`.

## Accounts (`-A`)

Every job must specify a SLURM account: `#SBATCH -A <account>` (or `-A` on the
`srun`/`sbatch` command line). The account is your **research group's** short name,
not your UNI. Find it in the cluster's "Submit Account" table (see
`reference/clusters.md`) or ask your PI. Free-tier users typically use the `free`
account with limited run times.

## Moving files

Home and scratch are shared across the cluster (see `reference/storage.md`), so copy
data once to the login/transfer node and it's visible on all compute nodes.

```
scp -r ./localdir <uni>@insomnia.rcs.columbia.edu:                 # to home
scp -r ./localdir <uni>@insomnia.rcs.columbia.edu:/insomnia001/depts/<group>/users/<uni>/
```
For large transfers prefer `rsync` or Globus; some clusters have a dedicated
transfer hostname (see `reference/clusters.md`). A trailing `:` after the host means
"my home directory."
