set shell := ["fish", "-c"]

export MIRRORS_COUNTRY := "ES"
export OUT_FOLDER := "out"

build ARGS="":
  @sudo ./build_iso.fish {{ARGS}}

burn ARGS:
  @umount {{ARGS}}1
  @sudo wipefs --all {{ARGS}}
  @sudo cp out/Archrio-LATEST.iso {{ARGS}}

# todo fix old iso removal
clean:
  #!/usr/bin/env fish
  set -l isos (eza --absolute --no-symlinks --sort date -r $OUT_FOLDER)
  test (count $isos) -gt 1 && rm $isos[2..] 
  sudo rm -rf (pwd)/archrio-releng

test:
  @run_archiso -u -i $OUT_FOLDER/Archrio-LATEST.iso

update_mirrors:
  @curl -s https://archlinux.org/mirrorlist/?country=$MIRRORS_COUNTRY&protocol=https&ip_version=4 \
        | sed 's/^.//' >releng/archrio.mirrorlist
