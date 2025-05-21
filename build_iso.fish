#!/usr/bin/env fish

cp -r releng archrio-releng
set -f iso_folder archrio-releng
set -f etc $iso_folder/airootfs/etc

echo "Rendering templates..."
set -f render_values $argv[1]
for file in $iso_folder/packages.x86_64 $etc/hostname $etc/shadow $etc/passwd $etc/gshadow $etc/archinstall_config.json $etc/archinstall_creds.json
    cat base.yml $render_values | jinja2 --format yml -o $file $file.jinja
    rm $file.jinja
end

set -q MIRROR_LIST || set -f MIRROR_LIST ./releng/archrio.mirrorlist
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

echo "Copying network configuration"
sudo cp -r /etc/NetworkManager/system-connections "$etc/NetworkManager/"
sudo chown $USER:$USER "$etc/NetworkManager/system-connections/*"

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
rm -rf $iso_folder
