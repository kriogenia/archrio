# Bitacora

Journal reflecting all the work from starting this ISO to its completion.

* Copied the releng configuration from the archiso repo as I started doing this from Windows, bad idea.
* Removed packages that I know I want use because I use the superior versions: `fish` instead of `zsh`, `tmux` instead of `screen` and `nvim` instead of `nano`.
* Edited the `os-release` and `profiledef` with the custom information.
* Modified some `/etc` files:
  * Edited `hostname` to just use the SO name.
  * Added a new non-root username to `passwd`. In the future the creation script will do this.
  * Added encrypted passwords for the root and non-root users to `shadow`. This will also be part of the creation script.
* Added my most used packages available in Pacman to the `packages.x86_64` so they are all available from the get go.
* **Compilation Attempt 01**: _FAILURE_. I don't know why but `archinstall` and `reflector` are not available. I didn't even add those, they are from the recipe. Let's just remove them for now to see other errors.
* **Compilation Attempt 02**: _FAILURE_. Conflict with `os-release`. I created it in the wrong place. Moved it.
* **Compilation Attempt 03**: _SUCCESS!_. First complete compilation of the ISO. _ISO-01_.
* **Launch Attempt 01** (_ISO-01_), using VirtualBox for these.
  * Loads the ArchLinux boot page.
  * Install option doesn't start, probably related to missing `archinstall` or Calamares.
  * Booting image gets stuck in a very funny _"seems reasonable"_ message.
