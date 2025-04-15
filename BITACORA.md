# Bitacora

Journal reflecting all the work from starting this ISO to its completion.

## Day 01

* Copied the releng configuration from the archiso repo as I started doing this from Windows, bad idea.
* Removed packages that I know I want use because I use the superior versions: `fish` instead of `zsh`, `tmux` instead of `screen` and `nvim` instead of `nano`.
* Edited the `os-release` and `profiledef` with the custom information.
* Modified some `/etc` files:
  * Edited `hostname` to just use the SO name.
  * Added a new non-root username to `passwd`. In the future the creation script will do this.
  * Added encrypted passwords for the root and non-root users to `shadow`. This will also be part of the creation script.

## Day 02

* Added my most used packages available in Pacman to the `packages.x86_64` so they are all available from the get go.
* **Compilation Attempt 01**: _FAILURE_. I don't know why but `archinstall` and `reflector` are not available. I didn't even add those, they are from the recipe. Let's just remove them for now to see other errors.
* **Compilation Attempt 02**: _FAILURE_. Conflict with `os-release`. I created it in the wrong place. Moved it.
* **Compilation Attempt 03**: _SUCCESS!_. First compilation of the ISO: _Archrio-2025.04.14.iso_.
* **Launch Attempt 01** (_Archrio-2025.04.14.iso_), using VirtualBox for these.
  * Loads the ArchLinux boot page.
  * Install option doesn't start, probably related to missing `archinstall` or Calamares.
  * Booting image gets stuck in a very funny _"seems reasonable"_ message.

## Day 03

* Found the problem behind packages unavailability: they are not in Manjaro mirrors
  * Fixed adding one of base arch mirrors to `pacman.conf`
  * I don't want to prioritize these mirrors while on Manjaro, so time to start the ISO build script.
* Added a FAQ just of questions I ask myself, so I can talk with my past self and have that beautiful. _Why? WHHHYYYY? Oh, that's why_.
* Created the first version of the building script to handle the temporary need for additional mirrors. What a beautiful pipe did I craft there.
* **Compilation Attempt 04**: _FAILURE_. A lot of signature verifications failed. The addition of these mirrors requires a bit more work.
* Added back `archinstall` and `reflector` packages.
* **Compilation Attempt 05**: _SUCCESS!_. I just ran the script again and it worked? Probably first mirror fails and following work. I should had `-Syy` before, probably. Anyway, we have _Archrio-2025.04.15.iso_. Yay!
* While attempting to make a `clean` recipe I removed some non-staged files. I'm such an idiot. Thankfully nothing important was lost.
