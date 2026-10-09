# Camera UI screenshots

These screenshots show the r12 port running on a Nothing Phone 3a with NOS 4.1.

For privacy, the Android status bar and bottom gesture bar have been cropped out, and gallery thumbnails in the bottom corner are obscured. All camera controls and viewfinder contents are otherwise untouched.

![Real Camera UI overview](overview.png)

## Dual-view video controls

Dual-view lets you record video from both cameras simultaneously:

- **Move the inset window:** Drag the small floating camera preview to any corner of the screen.
- **Swap primary camera:** Tap the flip button to swap which camera takes up the full screen versus the floating window.
- **Switch layout:** Tap the layout button to toggle between floating picture-in-picture and a 50/50 split-screen. The floating window size is fixed at one-third width and height.

| Draggable inset | Front camera main | Dual-view controls |
| --- | --- | --- |
| ![Moved inset](dual-view-pip-moved.png) | ![Front main view](dual-view-front-main.png) | ![Dual-view controls](dual-view-controls.png) |

| Floating picture-in-picture | 50/50 split-screen | More modes menu |
| --- | --- | --- |
| ![Dual-view PiP](dual-view-pip.png) | ![Dual-view split](dual-view-split.png) | ![More modes](more-modes.png) |

## Camera modes

| Photo | Video | Expert |
| --- | --- | --- |
| ![Photo](photo.png) | ![Video](video.png) | ![Expert](expert.png) |

| Night | Time-lapse | Slow motion |
| --- | --- | --- |
| ![Night](night.png) | ![Time-lapse](time-lapse.png) | ![Slow motion](slow-motion.png) |

Note: Just because a mode appears in the menu does not mean its output has been verified. Testing for this release focused on Dual-view Video and standard photo capture. Modes like portrait and specialized burst capture remain untested.

## Tuning, filters, and presets

| Photo controls | Filters | Tuning controls |
| --- | --- | --- |
| ![Photo controls](photo-controls.png) | ![Filters](filters.png) | ![Tuning controls](tuning-controls.png) |

| Exposure slider | Tuning guide | Preset library |
| --- | --- | --- |
| ![Exposure](exposure.png) | ![Tuning introduction](tuning.png) | ![Preset library](preset-library.png) |

| Preset introduction | Video controls | Video frame rate |
| --- | --- | --- |
| ![Preset introduction](presets.png) | ![Video controls](video-controls.png) | ![Video frame rate](video-fps.png) |

## Settings

| Video resolution and fps | Main settings | Advanced settings |
| --- | --- | --- |
| ![Video quality](video-quality.png) | ![Settings](settings.png) | ![Lower settings](settings-lower.png) |

Redaction and cropping coordinates are documented in [manifest.json](manifest.json). Camera UI design and sample tutorial assets are the property of Nothing.
