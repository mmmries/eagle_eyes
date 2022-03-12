# Eagle Eye

This is a little DIY home security project.
My main goal is provide video clips for any neighbors that experience
some type of vandalism or robbery, and to get video of the naughty
foxes that knock over my garbage bins.

The project is split up into cameras and a central UI.
The `cam` project handles the code that runs on each camera unit.
This code is provisioned onto a set of [Raspberry Pi Zero 2W](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/)
boards that have a connected camera each.
Each of these boards monitor their own video feed and capture clips
whenever they see motion.
Clips are then sent back to the central hub.

The central hub is another Raspberry Pi Zero 2W, but without a camera.
This device runs the `screen` project which manages the various clips and
provides a Phoenix LiveView app.
The `vcr` project is a nerves app which embeds the `screen` project and 
gets everything pulled together and ready to run as a firmware project.