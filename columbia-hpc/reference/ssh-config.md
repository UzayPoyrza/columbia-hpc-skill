# SSH config tip (client-side)

Login, Duo, and account details live in each cluster's **Getting Started** page (see
`../docs/INDEX.md`). This file covers the one thing those pages don't: a client-side SSH
setup that makes cluster access smoother.

On the user's **own machine**, add to `~/.ssh/config`:

```
Host *.columbia.edu
    User <uni>
    ServerAliveInterval 30
```
- `User <uni>` → default username, so `ssh insomnia.rcs.columbia.edu` works without `<uni>@`.
  Use the user's own UNI.
- `ServerAliveInterval 30` → keepalive so idle sessions don't freeze/drop.
- Scope to `*.columbia.edu` (with the leading dot) so it only affects Columbia hosts, then
  `chmod 600 ~/.ssh/config` (SSH ignores a config others can write).

## For agents / automation: reuse one authenticated connection

Duo fires on every new connection, so running many `ssh`/`scp` commands would prompt many
times. Add connection multiplexing so the user authenticates **once** and later commands
reuse the live connection:

```
Host *.columbia.edu
    User <uni>
    ServerAliveInterval 30
    ControlMaster auto
    ControlPath ~/.ssh/cm-%r@%h:%p
    ControlPersist 8h
```
Open it once with `ssh -fN insomnia.rcs.columbia.edu` (approve Duo); all later commands ride
on it for 8 h. Close with `ssh -O exit <host>`.
