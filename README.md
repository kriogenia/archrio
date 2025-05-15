# Archrio

Archrio is an intended ArchLinux based distro with my environment set-up, so it can be easily moved around without the need to continously reconfigure everything. This is based on the [archiso](https://wiki.archlinux.org/title/Archiso) package.

At this point in time the compiled ISOs are only useful as LiveUSB/LiveCD. It can install an ArchLinux into a system, but it will be the default ArchLinux without any of the Live packages or configurations. There's plans to add Calamares so it can be installed like any other distro.

> [!NOTE]
> Take into account that this is a distro tailored to my own needings and likings as it's only for my own use. The repository is public to provide public knowledge and help you if you intent to build one yourself. You can use this Live distro, but take into account that you'll find an alien environment if you do so.

## Pre-generating values

You can pre-generate some values for the LiveUSB and archinstall like the hostname or user passing certain values with a YAML file. For example:

```yml
hostname: myhostname
users:
- user: mysudouser
  password: my-encrypted-password
  sudo: true
- user: otheruser
  password: their-encrypted-password
```

## Compiling the ISO

You need to have `archiso` installed on your system to do this, but once you do so, just run:

```sh
just build
```

Or, in case of having a values file:

```sh
just build my_values.yml
```

This will set everything up, pull all the packages and generate the ISO in the `/out` folder. A symbolic link named `Archrio-LATEST.iso` will also be created in the same folder pointed to the most recently compiled image. This can help to mount the ISO or burn it without having to pick a new one each time.

If you have `qemu-desktop` and `edk2-ovmf` installed on your system, and once you have built one ISO you can test it with a new VM just running:

```sh
just test
```

The build script behavior can also vary depending on different environment variables like `MIRRORS_COUNTRY`, `WORK_FOLDER` and `OUT_FOLDER`. You can also clean old ISOs with `just clean`.
