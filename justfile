set shell := ["fish", "-c"]

export MIRRORS_COUNTRY := "ES"
export OUT_FOLDER := "out"

build ARGS="":
  @sudo ./build_iso.fish {{ARGS}}

clean:
  @sudo rm (eza --absolute --no-symlinks --sort date -r $OUT_FOLDER | tail +2)

test:
  @run_archiso -u -i $OUT_FOLDER/Archrio-LATEST.iso

update_mirrors:
  @curl -s https://archlinux.org/mirrorlist/?country=$MIRRORS_COUNTRY&protocol=https&ip_version=4 \
        | sed 's/^.//' >releng/mirrorlist
