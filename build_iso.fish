#!/usr/bin/fish

function _get_os_id
    cat /etc/os-release | rg "^ID=" | sed --quiet 's/ID=//'
end

if _get_os_id = Manjaro
    echo "Detected Manjaro OS, adding arch mirrors to pull all packages"
    set -q MIRRORS_COUNTRY || set -l MIRRORS_COUNTRY ES
    set -f mirror_file /etc/pacman.d/mirrorlist
    test -e $mirror_file; or return
    set -f mirror_backup /tmp/mirrorlist.bak
    echo "Creating mirrorlist backup in $mirror_backup"
    cp $mirror_file $mirror_backup
    curl -s https://archlinux.org/mirrorlist/?country=$MIRRORS_COUNTRY&protocol=https&ip_version=4 \
        | tail -3 | sed 's/^.//' | cat - $mirror_file | sponge $mirror_file
    echo "Mirrorlist to use in the script:"
    echo -e
    cat $mirror_file
end

set -q WORK_FOLDER || set -l WORK_FOLDER /tmp/work

echo "Starting mkarchiso script"
mkarchiso -v -w $WORK_FOLDER releng

echo "Tearing up script artifacts"
rm -rf $WORK_FOLDER
echo "Restoring original mirrorlist"
cp $mirror_backup $mirror_file

functions -e _get_os_id
