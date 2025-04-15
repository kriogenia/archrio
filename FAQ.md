# FAQ

Frequently Asked Questions that nobody even Asked, much less Frequently, but they are Questions nonetheless. Somehow.

## Why are the scripts in fish?

Because that's what I use and it's way more pleasant to write than bash. Maybe in the future I translate them to POSIX, maybe not.

## Why does the build script update the mirrorlist?

Manjaro mirrors doesn't have `archinstall` and `reflector`, that's why. Until I get rid of those, if I ever do, adding arch mirrors is a must to be able to build the image. At least I implemented it in a conditional way tho.
