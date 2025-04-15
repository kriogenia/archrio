set shell := ["fish", "-c"]

export OUT_FOLDER := "out"

clean:
  @sudo rm (eza --absolute --no-symlinks --sort date -r $OUT_FOLDER | tail +2)
