# fritz.box backup

Backup your fritz.box configuration.

## Usage

```sh
$ ./fritzbox-backup-export.sh --help

Usage: fritzbox-backup-export.sh [OPTION ...]

Export fritz.box configuration file.

Tested on a 7490 with OS 7.11

Options:
-h, --help              display this usage message and exit
    --host              host/ip of the fritz.box [fritz.box]
    --username          username to login, empty for admin [""]
    --password          password to login [""]
    --export-password   password for the config export file [""]
    --path              path to write the export file to, stdout if omitted
```

Please see the included example file. You can adjust the parameters and test it in place.
