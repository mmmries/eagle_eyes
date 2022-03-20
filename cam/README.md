# Cam

Cam is a raspberry pi computer + camera that will act as a sensor.
We provision them with names like `cam1.local`, `cam2.local`, etc.

## Provisioning a Camera Node

* use RaspiOS (32-bit) Lite
* configure SSH keys, WiFi, etc using the imager and then burn the SD card
  * make sure you modify the hostname to be something like `cam4.local`
* after powering on the device you can try to find it using `ping cam4.local`
* now connect using `ssh pi@cam4.local` and install some dependencies:

```
sudo apt-get install git python3-picamera ffmpeg elixir erlang-src erlang-dev
mix local.rebar
mix local.hex
```

* Now you'll need to enable the legacy camera interface
* Run `sudo raspi-config`
* Select "3 - Interface Options" => "I1 Legacy Camera" => "Yes" => "ok" => "reboot"

## Optional DNS

The multicast DNS that we used to find the raspberry pi is really convenient, but
not super reliable. You may want to log into your WiFi router and setup a DHCP
IP reservation to give your pi a consistent IP address.

You can then set a public DNS record for this IP address as something like `cam4.riesd.com`.
This will make the DNS lookup very fast in the future if you need to access the device.

## Current Versions

As of this writing, the current versions are:

```
pi@cam1:~ $ uname -a
Linux cam1 5.10.92-v7+ #1514 SMP Mon Jan 17 17:36:39 GMT 2022 armv7l GNU/Linux

pi@cam1:~ $ elixir --version
Erlang/OTP 23 [erts-11.1.8] [source] [smp:4:4] [ds:4:4:10] [async-threads:1]

Elixir 1.10.3 (compiled with Erlang/OTP 22)
pi@cam1:~ $ ffmpeg -version
ffmpeg version 4.3.3-0+rpt2+deb11u1 Copyright (c) 2000-2021 the FFmpeg developers
built with gcc 10 (Raspbian 10.2.1-6+rpi1)
```

## Installing Cam

Login to the device with ssh (your home directory should be `/home/pi`) and then
git clone this repository into `/home/pi/eagle_eyes`.
Then cd to `eagle_eyes/cam` and setup the systemd job by running this:

```
mix do deps.get compile
sudo cp watchr.service /etc/systemd/system/watchr.service
sudo systemctl daemon-reload
sudo systemctl enable --now watchr.service
```

## Updating

There's a helper script at `./bin/update.sh` for updating this project and safely restarting
the watchr service.

## Checking Logs

If you want to see whether things have been crashing or other log messages you
ssh into a device and run this:

```
journalctl -f -u watchr.service
```

