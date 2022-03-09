# Cam

Cam is a raspberry pi computer + camera that will act as a sensor.
We provision them with names like `cam1.local`, `cam2.local`, etc.

## Provisioning a Camera Node

* use RaspiOS (32-bit) Lite
* configure SSH keys, WiFi, etc using the imager
* after booting install some dependencies:

```
sudo apt-get install git python3-picamera ffmpeg
```

* Now you'll need to enable the legacy camera interface
* Run `sudo raspi-config`
* Select "3 - Interface Options" => "I1 Legacy Camera" => "Yes" => "ok" => "reboot"
* Run `mkdir clips` in the home directory of the `pi` user

## Installing

Just copy this `cam` directory onto your provisioned device at `/home/pi/cam` then
jump into the console inside the `cam` directory and run this:

```
sudo cp watchr.service /etc/systemd/system/watchr.service
sudo systemctl daemon-reload
sudo systemctl start watchr.service
```

## Converting Clip Files

You can easily convert the clip files from h264 to mp4 like this:

```
ffmpeg -framerate 24 -i 1646826659.h264 -c copy 1646826659.mp4
```

## Checking Logs

If you want to see whether things have been crashing or other log messages you
ssh into a device and run this:

```
journalctl -f -u watchr.service
```