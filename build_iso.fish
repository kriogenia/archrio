#!/usr/bin/fish

set -q MIRROR_LIST; or set -f MIRROR_LIST releng/archrio.mirrorlist
if contains -- --update-mirrors $argv
    echo "Updating mirrors..."
    set -q MIRRORS_COUNTRY || set -l MIRRORS_COUNTRY ES
    curl -s https://archlinux.org/mirrorlist/?country=$MIRRORS_COUNTRY&protocol=https&ip_version=4 \
        | sed 's/^.//' >$MIRROR_LIST
end

set -f pacman_mirror_path /tmp/archrio.mirrorlist
cp $MIRROR_LIST $pacman_mirror_path
echo "Mirrorlist to use in the script:"
echo -e
cat $pacman_mirror_path


echo "Updating pacman repos"
pacman -Syy
echo "Starting mkarchiso script"
mkarchiso -v -w $WORK_FOLDER -o OUT_FOLDER releng

set -l new_iso (eza -r --sort date | head -1 $OUT_FOLDER)
set -l last_iso $OUT_FOLDER/Archrio-LATEST.iso
echo "Updating $last_iso symlink"
ln -sf $OUT_FOLDER/$new_iso $last_iso

echo "Tearing up script artifacts"
rm -rf $WORK_FOLDER
