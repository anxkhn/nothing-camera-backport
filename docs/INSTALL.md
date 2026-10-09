# Installation guide

Download the APK directly:
- [Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk](https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk)
- Or view the [r12 GitHub release](https://github.com/anxkhn/nothing-camera-backport/releases/tag/r12)

Tested on Nothing Phone 3a (A059, Android 16, NOS B4.1-260810-1153, factory Camera 16.0.01.27.00).

## Step-by-step setup

1. Download the APK file onto your phone.
2. Tap the downloaded file to install it. If prompted, allow your browser or file manager to install unknown apps.
3. Open **Nothing Camera Beta Port**.
4. Grant the requested permissions: camera, microphone, and photos/videos. Full media access is needed so captured photos can open in your gallery.
5. Take a quick test photo, then switch to Dual-view Video and record a short clip to verify everything saves to your gallery.

No root access, ADB commands, or firmware modifications are needed.

Important: keep your stock Nothing Camera app installed and enabled. This port delegates photo processing to the stock camera's background service. Do not run both camera apps at the same time.

Package name: `com.anx.camera.experimental`

SHA-256 checksum:
```text
00dd9b077e604fc1482f84085169661bd5849f8373d760672a2f683003ef83ac
```

## How to use dual-view

Swipe over to **More** in the bottom mode carousel, then select **Dual-view Video**.

- Tap the layout button to switch between floating picture-in-picture and split-screen.
- Drag the small inset window to move it around your screen.
- Tap the switch button to swap which camera appears in the main view versus the inset.
- Press record to capture a combined 1080p video with audio.

## Troubleshooting

- **App not installed or signature conflict:** If you installed an earlier test build, uninstall that test build first. Never uninstall or disable your stock Nothing Camera.
- **Photos hang during processing:** Check that your factory Camera app is enabled and running. The port connects to its background service to finalize shots.
- **Preview shows up, but nothing saves:** Check that you granted storage/media permissions. Also verify that you are not running the stock camera simultaneously, since the processing service only talks to one app at a time.
- **Untouched NOS 5 APK was previously installed as an update:** If you previously updated your stock Camera with the raw NOS 5 APK, uninstall updates for Nothing Camera in Android Settings first to restore the factory 4.1 version. This port requires the factory 4.1 backend.

To uninstall this port, simply uninstall **Nothing Camera Beta Port** like any normal app. Your original Camera app is completely unaffected.
