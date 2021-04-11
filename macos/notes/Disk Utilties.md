## Useful Disk Utilities Commands
* * *
### List Available Disks

```bash
diskutil list
```

### Mount An Image

```bash
hdiutil attach image.dmg
```

### Detach An Image

```bash
hdiutil detach /Volumes/image
```

### Format USB as ExFAT

```bash
diskutil eraseDisk ExFAT NEW_DISK_NAME GPT /dev/usb
```