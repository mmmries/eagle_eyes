# This file is lifted from https://picamera.readthedocs.io/en/release-1.13/recipes2.html?highlight=Motion#custom-outputs
import numpy as np
import picamera
import picamera.array
import time

class DetectMotion(picamera.array.PiMotionAnalysis):
  def __init__(self, camera):
    super().__init__(camera)
    self.motion_detected = False

  def analyze(self, a):
    a = np.sqrt(
      np.square(a['x'].astype(np.float)) +
      np.square(a['y'].astype(np.float))
      ).clip(0, 255).astype(np.uint8)
    # If there're more than 20 vectors with a magnitude greater
    # than 60, then say we've detected motion
    if (a > 60).sum() > 20:
      self.motion_detected = True

class Watchr:
  @classmethod
  def wait_for_motion(_class, camera):
    with DetectMotion(camera) as detector:
      camera.start_recording('/dev/null', format='h264', motion_output=detector)
      while detector.motion_detected == False:
        camera.wait_recording(0.5)
      camera.stop_recording()

  @classmethod
  def record_clip(_class, camera):
    filename = "clips/{timestamp:.0f}.h264".format(timestamp = time.time())
    camera.start_recording(filename, format='h264')
    camera.wait_recording(30)
    camera.stop_recording()
    print('CAPTURED CLIP!')

with picamera.PiCamera() as camera:
  print('Starting Camera')
  camera.resolution = (640, 480)
  camera.rotation = 180
  # This allows the camera to wakeup and white balance before we check for motion
  camera.start_recording('/dev/null', format='h264')
  camera.wait_recording(5)
  camera.stop_recording()
  print("I'm Watching...")
  while True:
    Watchr.wait_for_motion(camera)
    Watchr.record_clip(camera)
      