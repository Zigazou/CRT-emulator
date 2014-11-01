CRT-emulator
============

Script for The Gimp 2.8 which tries to emulate the look and feel of a picture rendered on a CRT

The best results are obtained by using images (from emulators) in the natural resolution.
For example, images from an Amstrad CPC should be 320×200 pixels in RGB format.

Beware that the result will be 8 times larger than the original (320×200 → 2560 × 1600). Therefore
you should not use images too large that they could not fit into your computer’s memory.

Installation
------------

The `crt.scm` file should be placed in your Gimp directory (on Linux, it is `~/.gimp-2.8/scripts`).

Usage
-----

The script is accessible via the `Filters/Distort/CRT emulator` menu.

It requires no parameter.

Example
-------

Here’s a screenshot from the game Cybernoid on Amstrad CPC

![](https://github.com/Zigazou/CRT-emulator/blob/master/cybernoid.crt.png)

after CRT-Emulator

![](https://github.com/Zigazou/CRT-emulator/blob/master/cybernoid.emulator.png)

Notes
-----

What the script does :

- upscale (×2)
- remove even rows
- upscale (×4)
- flatten
- spread pixels (2×2)
- gaussian blur (8×4)
- curves (brighten)
- lens distortion (main distortion=10, luminosity=20)
- create a layer `Noise` with black background in lighten-only mode
- generate RGB noise (0.3)
- blur the noise (24×24)
