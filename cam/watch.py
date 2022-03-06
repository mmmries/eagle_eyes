# This file is lifted from https://picamera.readthedocs.io/en/release-1.13/recipes2.html?highlight=Motion#custom-outputs
import numpy as np
import picamera
import picamera.array

class DetectMotion(picamera.array.PiMotionAnalysis):
    def analyze(self, a):
        print('.', end='')
        a = np.sqrt(
            np.square(a['x'].astype(np.float)) +
            np.square(a['y'].astype(np.float))
            ).clip(0, 255).astype(np.uint8)
        # If there're more than 10 vectors with a magnitude greater
        # than 60, then say we've detected motion
        if (a > 60).sum() > 10:
            print('\nMotion detected!')

with picamera.PiCamera() as camera:
    with DetectMotion(camera) as output:
        camera.resolution = (640, 480)
        camera.start_recording(
              '/dev/null', format='h264', motion_output=output)
        camera.wait_recording(30)
        camera.stop_recording()