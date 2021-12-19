## Backup Programs
* * *
### rdiff-backup
```bash
rdiff-backup --print-statistics /src /dst
```

### restic
```bash
restic init --repo /dst
restic -r /dst --verbose backup /src
```