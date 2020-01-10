#!/bin/bash
set -eu -o pipefail

PROGNAME=$(basename $0)

die() {
    echo "$PROGNAME: $*" >&2
    exit 1
}

usage() {
    if [ "$*" != "" ] ; then
        echo "Error: $*"
    fi

    cat << EOF

Usage: $PROGNAME [OPTION ...]

Export fritz.box configuration file.

Tested on a 7490 with OS 7.11

Options:
-h, --help              display this usage message and exit
    --host              host/ip of the fritz.box [fritz.box]
    --username          username to login, empty for admin [""]
    --password          password to login [""]
    --export-password   password for the config export file [""]
    --path              path to write the export file to, stdout if omitted
EOF

    exit 1
}

host="fritz.box"
username=""
password=""
export_password=""
path="-"
while [ $# -gt 0 ] ; do
    case "$1" in
    -h|--help)
        usage
        ;;
    --username)
        username="$2"
        shift
        ;;
    --password)
        password="$2"
        shift
        ;;
    --export-password)
        export_password="$2"
        shift
        ;;
    --path)
        path="$2"
        shift
        ;;
    -*)
        usage "Unknown option '$1'"
        ;;
    *)
    esac
    shift
done

challenge=$(curl -s http://${host}/login_sid.lua |  grep -o "<Challenge>[a-z0-9]\{8\}" | cut -d'>' -f 2)

if [ -z "${challenge}" ] ; then
    echo "[ERROR] login failed"
    exit 1
fi

hash=$(echo -n "${challenge}-${password}" |sed -e 's,.,&\n,g' | tr '\n' '\0' | md5sum | grep -o "[0-9a-z]\{32\}")
avmsid=$(curl -s "http://${host}/login_sid.lua" -d "response=${challenge}-${hash}" -d 'username='${username} | grep -o "<SID>[a-z0-9]\{16\}" |  cut -d'>' -f 2)

if [ -z "${avmsid}" ] || [ "${avmsid}" = "0000000000000000" ]; then
    echo "[ERROR] login failed"
    exit 1
fi

curl -s -k \
    --output ${path} \
    --form 'sid='${avmsid} \
    --form 'ImportExportPassword='${export_password} \
    --form 'ConfigExport=' \
    http://${host}/cgi-bin/firmwarecfg
