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

