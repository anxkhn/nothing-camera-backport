# R12 device verification

Measured on 9 October 2026 on a Nothing Phone 3a, A059, AsteroidsIND, Android 16 API 36, Nothing OS `B4.1-260810-1153`.

The tested experimental APK was `Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk`, application ID `com.anx.camera.experimental`. Its SHA-256 is `00dd9b077e604fc1482f84085169661bd5849f8373d760672a2f683003ef83ac`, recorded in [inputs.json](../provenance/inputs.json).

Factory Camera was restored at `/system_ext/priv-app/NTCamera/NTCamera.apk`, version `16.0.01.27.00`. The operating-system build did not change.

This report adapts the original r12 device-verification record. Personal media filenames, pulled media and raw device logs are omitted. Numeric MediaStore IDs identify the measured rows only. They are not IDs to reuse in another installation.

## Instrumentation

```sh
adb shell am instrument -w \
  com.anx.camera.experimental/com.anx.camera.bridge.CodecInstrumentation
```

Recorded result:

```text
PASS: old reader request flags/metadata, null arrays,
HardwareBuffer/fence/crop, RPC remap, unsupported optional methods,
public metadata writer allocation/dequeue,
real native metadata set/pointer/entry-count,
owner MediaStore URI grant to factory UID,
invalid JPEG stays pending and valid JPEG publishes via owner provider
```

The implementation is [CodecInstrumentation.java](../src/java/com/anx/camera/bridge/CodecInstrumentation.java). Factory reader classes are generated from the pinned factory APK during [reconstruction](BUILD.md). A nonzero local metadata pointer is an access check, not a published native ABI specification.

## Photos

| Capture | MediaStore ID | Bytes | Width | Height | `is_pending` |
| --- | --- | --- | --- | --- | --- |
| Rear JPEG | `1000581840` | 1,546,438 | 3072 | 4080 | 0 |
| Front JPEG | `1000581841` | 3,572,540 | 4928 | 6560 | 0 |

The rear JPEG was pulled for inspection. The app survived repeat capture, camera switching and gallery return. No new application or Gallery crash appeared in the checked interval after r12 installation. That observation covers the checked interval, not every lifecycle transition or failure case.

The output provider checks nonzero file size and positive decoded bounds before clearing pending. These checks and the recorded photo rows establish completed output rather than a thumbnail placeholder. A bounds decode alone is not a full JPEG integrity test. See [PhotoOutputProvider.java](../src/java/com/anx/camera/bridge/PhotoOutputProvider.java).

## Dual-view video

| Measurement | Recorded value |
| --- | --- |
| MediaStore ID | `1000581843` |
| Bytes | 2,191,862 |
| Width × height | 1080 × 1920 |
| MediaStore duration | 5830 ms |
| `is_pending` | 0 |
| Video codec | H.264 High |
| Video frames | 173 |
| Video stream duration | 5.784533 seconds |
| Average video rate | About 29.91 fps |
| Audio codec | AAC LC |
| Audio channels and rate | Stereo, 48 kHz |
| Audio stream duration | 5.674667 seconds |
| Container duration | 5.829667 seconds |

The recording was pulled and inspected with FFprobe. FFmpeg decoded the frame at two seconds without an error. Inspection confirmed a front-camera picture-in-picture inset in the combined frame. Low-light test conditions explain the recorded dark output; the record does not establish a controlled image-quality comparison.

This verifies saved media and one short recording with audio. It does not establish long-duration thermal stability, exact audio/video synchronization, all compositions, stabilization, or every NOS 5 feature. UFS handles offline photo processing. The frontend's capture, composition and recording implementation produces dual-view video.

## Factory dependency

The port uses the restored factory app's exported UFS service. It does not directly access the protected native camera service from an untrusted process. [Nos41UfsBridge.java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java) translates the beta request format to the old service format. Owner-side output handling keeps photos pending until nonempty output with valid image bounds exists, then publishes them.

Keep the factory app enabled. Backend algorithm improvements requiring NOS 5 firmware remain outside this APK-only port's verified scope. [THIRD_PARTY_PROCESSING.md](THIRD_PARTY_PROCESSING.md) describes the connection and wire format. [TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md) records the blockers and fixes.

## Host reconstruction is a separate result

Source-kit preparation matched 54,736 decoded payload files and 3,503 non-`META-INF` uncompressed APK entries against r12. The rebuilt APK used a disposable local signer. It was not installed or capture-tested during that preparation. The ADB target-pull step and Linux execution were also not repeated. These limits are explicit in [validation.json](../provenance/validation.json) and [FILE_MAP.md](FILE_MAP.md).

Use [BUILD.md](BUILD.md) for reconstruction and your own signing setup. A payload-equivalent rebuild is not a new on-device verification result.
