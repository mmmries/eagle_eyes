# Vcr

A firmware project for running the `screen` application on a rasberry pi

## Targets

For now this is designed specifically for the Raspberry Pi Zero 2W.
Please set `MIX_TAGET=rpi3a` and `MIX_ENV=prod` when building firmwares.

## Deploying

> Keep in mind that this project is only available within the local wifi network

```
MIX_TARGET=rpi3a mix firmware
./upload.sh
open http://screen.riesd.com/
```