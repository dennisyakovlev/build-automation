#!/bin/sh

FILE=/usr/local/etc/build_files/project_dirs

while [ "$#" -ne 0 ]; do
    case "$1" in
        -d) d=1;;
        *) echo "invalid arg $1" >&2; exit 1;;
    esac

    shift
done

sudo -nv 2>> /dev/null
if [ "$?" -ne 0 ]; then
    >&2 echo "must be ran with root permissions"
    exit 1
fi

if [ "$(dirname $0)" != "." ]; then
    >&2 echo "must be ran in same directory as file"
    exit 1
fi

# assume only no extension and .sh extension files in dir
for comm in $(ls -I"*\.sh"); do
    case "$comm" in
        *.1)
            dir=/usr/share/man/man1/ ;;
        *)
            dir=/usr/local/bin ;;
    esac
    if [ "$d" = "" ] && [ -f "$dir""$comm" ]; then
        >&2 echo "$comm already exists in $dir, run with -d to delete"
        exit 1
    else
        rm -f "$dir""$comm" 2>> /dev/null # delete if exists
        cp $(dirname $0)/$comm "$dir" # move into bin
    fi
done

if [ -f "$FILE" ]; then
    echo "old artifacts found, there may be old build artifacts on your system"
fi
rm -f "$FILE"
touch "$FILE"
chmod 666 "$FILE"

echo "success"

exit 0