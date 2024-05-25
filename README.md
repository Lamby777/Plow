Plow

Gimme my `Pl`ugins, n`ow`!

Plow is a package manager for your Minecraft server plugins.

Inspired by the [Installer](https://dev.bukkit.org/projects/plugin-installer)
plugin.

## Contributions

The code is probably trash. If you're willing to put up with it, go ahead. <3

## Usage

The project is nowhere near complete, but ideally, this is how it'd work:

```bash
plow i plugin@pluginver!mcver
```

```bash
$ plow search minigame
Found plugins:
86051 - Imposters Minigame @ !latest(1.19.4) | Updated Apr 21, 2023
12345 - Some Other Plugin  @ !latest(1.12.2) | Updated Sep 29, 2017

$ plow info 86051
Author:           nktfh100
Total Downloads:  7,500
First Release:    Nov 23, 2020
Last Update:      Apr 21, 2023
Category:         Game Mode
All-Time Rating:  4.5⭐️ (39 ratings)

# the `@` version specifies plugin version
# the `!` version specifies MC version
# in this example, both can be omitted since
# installing latest is the default behavior...
$ plow install 86051@latest!1.19.4
Downloading... [=========================] 100%
Done! Plugin JAR acquired via Spiget API


# if we were to run...
$ plow install 86051!1.18.2
# then it would search for the latest version
# of the plugin compatible with 1.18.2


# now for an example of "external site" plugins
$ plow search essentials

Found plugins:
9089  - EssentialsX        @ !latest(1.19.4) | Updated Aug 22, 2022
12345 - Some Other Plugin  @ !latest(1.12.2) | Updated Sep 29, 2017

$ plow releases 9089
EssentialsX only lists external site releases.
Maybe check for a GitHub Releases page, or install it manually?

$ plow install EssentialsX/Essentials@latest
(installing from GitHub Releases)
Downloading... [=========================] 100%
Done! EssentialsX-v2.20.0.jar installed to plugins folder!
```
