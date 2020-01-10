#!/bin/bash
set -eu -o pipefail

PROGNAME=$(basename $0)

fb_backup_path=$(pwd)
fb_pass='xxx'
fb_backup_count='1'
fb_backup_name="fritzbox-$(date +"%Y%m%d_%H%M%S").cfg"

../fritzbox-backup-export.sh \
  --password "${fb_pass}" \
  --path "${fb_backup_path}/${fb_backup_name}"

ls -tr \
  | grep -v ${PROGNAME} \
  | grep -v '/$' \
  | head -n -${fb_backup_count} \
  | xargs --no-run-if-empty rm

exit 0
