# Social post drafts

Ready-to-use posts for sharing the project across different communities.

- GitHub repository: https://github.com/anxkhn/nothing-camera-backport
- Direct APK download: https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk
- Release notes: https://github.com/anxkhn/nothing-camera-backport/releases/tag/r12
- Banners and graphics: `assets/ui-banners/` (`landscape.png`, `portrait.png`, `options.png`)

## Telegram

Got Nothing OS 5's Dual-view Camera running on Phone 3a with NOS 4.1.

Front and rear cameras record together into a 1080p video with audio. You can drag the floating preview window anywhere on screen, swap the main camera, or switch to split-screen mode.

It installs as a separate app (Nothing Camera Beta Port) without overwriting your stock camera. No root or custom recovery needed. Just leave your original Nothing Camera installed, as this port connects to its background service to process photos.

Direct APK download:
https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk

GitHub repo (source kit and technical docs):
https://github.com/anxkhn/nothing-camera-backport

Tested on Phone 3a (A059, NOS B4.1-260810-1153). If you try it on another build, let me know how it goes.

Attach `assets/ui-banners/landscape.png` or `assets/ui-banners/options.png`.

## Nothing Community

### I backported NOS 5's Dual-view Camera to Phone 3a on NOS 4.1

I really wanted dual-view video recording on my Phone 3a without waiting months for the full Nothing OS 5 update, so I adapted the beta Camera app (17.0.00.71.00) to run on NOS 4.1.

It installs as a separate application named Nothing Camera Beta Port. Your stock camera stays untouched.

How it works:
The port handles the camera sessions and UI, and bridges photo processing to your stock camera's background service via an IPC adapter. Because of that architecture, no root or bootloader unlocking is required.

Verified on Phone 3a:
- Dual-view video recording with audio (1080p MP4 at 30 fps)
- Draggable picture-in-picture window and camera flip
- 50/50 split-screen layout
- Full-resolution rear and front photos saved cleanly to gallery

Tested configuration:
- Phone 3a (A059, AsteroidsIND)
- Nothing OS 4.1 (Android 16, B4.1-260810-1153)
- Stock Camera 16.0.01.27.00

APK download:
https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk

Source kit and technical details:
https://github.com/anxkhn/nothing-camera-backport

Keep in mind that the low-level camera backend remains NOS 4.1, so firmware-level tuning from NOS 5 is not included. Also avoid running both camera apps at the same time.

If you give it a try, please share whether dual-view recordings and photos save properly to your gallery.

Attach `assets/ui-banners/landscape.png`.

## Reddit

### Title
Backported Nothing OS 5 Dual-view Camera to Phone 3a on NOS 4.1 (APK + source build kit on GitHub)

### Body
Wanted dual-view recording on my Phone 3a without waiting for the official NOS 5 rollout, so I built a backport of the new stock Camera (17.0.00.71.00).

It installs as a separate app alongside your existing camera. No root, Magisk, or unlocked bootloader needed.

What works:
- Simultaneous front and rear video recording (1080p MP4 with audio)
- Draggable picture-in-picture window
- One-tap main camera swap and 50/50 split-screen
- Regular rear and front photos saved directly to gallery

How it works technically:
The beta camera UI runs under its own package name (`com.anx.camera.experimental`) and connects to the factory camera's processing service via an IPC parcel adapter. This allows the third-party port to process photos through the vendor pipeline without requiring elevated system permissions.

Direct APK download:
https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk

GitHub repo (patches, build scripts, Binder protocol write-up):
https://github.com/anxkhn/nothing-camera-backport

Tested on Phone 3a (A059, NOS B4.1-260810-1153, Android 16). Make sure your stock camera remains installed and enabled. Don't open both camera apps at the same moment, as the background processing service only accepts one client at a time.

Attach `assets/ui-banners/landscape.png` or `assets/ui-banners/options.png`.

## X

### Main tweet (fits 280 characters)
Backported Nothing OS 5 Dual-view Camera to Phone 3a on NOS 4.1.

Front + rear video with draggable PiP, full-res photos, and zero root required.

APK and reproducible source kit on GitHub:
https://github.com/anxkhn/nothing-camera-backport

### Thread reply
Direct APK download:
https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk

Tested on Phone 3a (A059, NOS 4.1). Leave the factory camera installed, as the port uses its background service to process photos.

Attach `assets/ui-banners/landscape.png` to the main tweet.

## XDA Forums

### Title
[APP][PORT][Phone 3a] Nothing Camera NOS 5 backport for NOS 4.1 (Dual-view video, draggable PiP)

### Body
Here is a backport of Nothing Camera 17.0.00.71.00 (from Asteroids-C5.0-260915-2123) adapted for the Nothing Phone 3a running NOS 4.1 / Android 16.

It installs as a separate package (`com.anx.camera.experimental`), named Nothing Camera Beta Port. No root access or system modifications are needed on the tested setup. The factory Nothing Camera must remain installed and enabled.

Working features:
- Dual-view video: simultaneous front and rear video recording (1080 × 1920 MP4 at ~30 fps with stereo AAC audio).
- Draggable picture-in-picture: move the inset window anywhere, tap to swap the main camera, or switch to 50/50 split-screen.
- Photo capture: full-resolution rear (3072 × 4080) and front (4928 × 6560) JPEGs.
- Clean return to Google Photos or Nothing Gallery after capture.

Tested environment:
- Nothing Phone 3a (A059, AsteroidsIND)
- Android 16 / Nothing OS B4.1-260810-1153
- Factory Camera 16.0.01.27.00

Downloads:
- Direct APK: https://github.com/anxkhn/nothing-camera-backport/releases/download/r12/Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk
- Release page: https://github.com/anxkhn/nothing-camera-backport/releases/tag/r12
- GitHub repo: https://github.com/anxkhn/nothing-camera-backport

Technical overview:
The port preserves JNI class names, bundles required beta dependencies, and bridges new UFS Binder parcel structures to the factory NOS 4.1 protocol. Pending MediaStore photos use an owner-side content provider. This design delegates photo processing to the existing factory service rather than trying to access protected native HAL services from a third-party UID.

Notes and limitations:
The native camera HAL remains NOS 4.1. Avoid running both the factory Camera and this port simultaneously, since the background processing service only accepts one client at a time. Other phone models and OS builds are untested.

Attach `assets/ui-banners/header.png` and `assets/ui-banners/options.png`.
