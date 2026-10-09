# Release r12

Backport of stock Nothing Camera 17.0.00.71.00 for Nothing Phone 3a on Nothing OS 4.1.

## Download and installation

Download `Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk` below.

It installs as **Nothing Camera Beta Port** (`com.anx.camera.experimental`) alongside your stock camera.

- Leave your stock Nothing Camera app installed and enabled.
- Grant camera, microphone, and photos/videos permissions.
- No root access, unlocked bootloader, or OS update required.

Direct download link:
https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk

## What works

- Dual-view video: simultaneous front and rear camera recording (1080 × 1920 MP4 at ~30 fps with stereo AAC audio).
- Draggable picture-in-picture window with tap-to-swap main camera and 50/50 split-screen.
- Full-resolution photos: saves 3072 × 4080 (rear) and 4928 × 6560 (front) JPEGs through the factory backend.
- Gallery integration: opens Google Photos or Nothing Gallery normally after capture.
- Compatible Binder bridge for factory photo processing.

## Tested setup

- Device: Nothing Phone 3a (A059, AsteroidsIND)
- OS: Nothing OS 4.1 (Android 16, B4.1-260810-1153)
- Factory Camera: 16.0.01.27.00

Other phone models and OS builds are untested. Lower-level image tuning still comes from your NOS 4.1 firmware, so firmware-level improvements from NOS 5 are not included. Avoid running the stock camera and this port at the same time, as the background processing service only connects to one app at a time.

APK SHA-256:
```text
00dd9b077e604fc1482f84085169661bd5849f8373d760672a2f683003ef83ac
```
