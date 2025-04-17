#!/usr/bin/fish

set -f iso_folder releng
set -f etc $iso_folder/airootfs/etc

if contains -- --generate-user $argv
    read -l -P "Username: " -l username
    set -l pass (openssl passwd -6)
    echo "$username:$pass:14871::::::" >>$etc/shadow
    echo "$username:x:1000:1000::/home/$username:/usr/bin/fish" >>$etc/passwd
    echo "$username:!*::" >>$etc/gshadow
end

set -q MIRROR_LIST; or set -f MIRROR_LIST $iso_folder/archrio.mirrorlist
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

echo "Generating new BUILD_ID"
set -l today (date +"%Y-%m-%d")
cat $etc/os-release | rg "^BUILD_ID" | sed 's/BUILD_ID=//' | read -d "." -l build_date build_v
test $today = $build_date; and set -l build_v (math $build_v + 1); or set -l build_v 0
sed -i "s/^BUILD_ID=.\+\$/BUILD_ID=$today.$build_v/" $etc/os-release
cat $etc/os-release

set -q WORK_FOLDER || set -f WORK_FOLDER /tmp/work
set -q OUT_FOLDER || set -f OUT_FOLDER (pwd)/out

echo "Updating pacman repos"
pacman -Syy
echo "Starting mkarchiso script"
mkarchiso -v -w $WORK_FOLDER -o $OUT_FOLDER $iso_folder

set -l new_iso (eza --absolute --no-symlinks -r --sort date $OUT_FOLDER | head -1 )
set -l last_iso $OUT_FOLDER/Archrio-LATEST.iso
echo "Updating $last_iso symlink"
ln -sf $new_iso $last_iso

echo "Tearing up script artifacts"
rm -rf $WORK_FOLDER

if contains -- --generate-user $argv
    echo "Restoring user files"
    cat $etc/passwd | head -n -1 | sponge $etc/passwd
    cat $etc/gshadow | head -n -1 | sponge $etc/gshadow
    cat $etc/shadow | head -n -1 | sponge $etc/shadow
end
