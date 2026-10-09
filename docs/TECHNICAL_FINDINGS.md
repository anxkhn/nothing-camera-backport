# Nothing Camera NOS 5 port and dual-camera findings

## Target and scope

Measured on 9 October 2026 with a USB-connected Nothing Phone 3a, model A059, product AsteroidsIND. The phone runs Android 16, API 36, Nothing OS `B4.1-260810-1153`. The source firmware is `Asteroids-C5.0-260915-2123`, Android 17, NOS 5.0 beta. This project ports the stock Camera APK. The independent concurrent-camera test is a capability probe.

Current tested revision is r12. It saves rear and front full JPEGs and a short combined dual-view video with audio on the target OS. The processing backend remains NOS 4.1. See [DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md) for measurements and [THIRD_PARTY_PROCESSING.md](THIRD_PARTY_PROCESSING.md) for the full Binder protocol and integration tutorial.

## Verified firmware source

- [Archive release](https://github.com/spike0en/nothing_archive/releases/tag/Asteroids_C5.0-260915-2123).
- [Changelog](https://nothingarchive.tech/docs/changelogs/asteroids/Asteroids-C5.0-260915-2123).
- [Official NOS information](https://nothing.tech/nothing-os).
- [OTA URL](https://android.googleapis.com/packages/ota-api/package/ae787dc1f1ff5bde0fa556eb6a5c69beedd5c29d.zip). The reconstruction kit uses the logical archive, not this OTA URL as its input.
- The logical archive has three parts totalling 4,891,142,002 bytes. [firmware.json](../provenance/firmware.json) records volume hashes and published image checksums.
- Beta APK partition location is `system_ext:/priv-app/NTCamera/NTCamera.apk`. [EXTRACTION.md](EXTRACTION.md) stages it at `.work/inputs/NTCamera.apk`.
- APK SHA-256 is `89fb2557710f5f858870d4af84e33ffd56c9ffe62127a59962541e8f81ebab59`.
- Original package is `com.nothing.camera`, version `17.0.00.71.00`, code `170007100`, minSDK 34, targetSDK 36, compileSDK 37, arm64-v8a. There is no `sharedUserId`; `extractNativeLibs=false`.
- Inspected Nothing platform certificate SHA-256 is `2c4e1f8eb95d96f760336f03b92bc3858111e987c59703f9873c8dc7faa4119d`. This is the source certificate fingerprint, not a signing key supplied by the kit.

The original APK's Android floor permits Android 16. That alone does not prove native, framework, HAL or service compatibility. Re-signing removes platform-signature privileges.

## Live concurrent-camera result

The independent probe used application ID `com.anx.camera.probe`, component `.ProbeActivity`. Its original source and APK are not part of this kit. [REFERENCE_FILES.md](REFERENCE_FILES.md#independent-probes) records that gap and the configuration needed to repeat the experiment.

The probe opens cameras 0 and 1 before configuring either session. Each session targets one `ImageReader` using `YUV_420_888`, 640 × 480, `maxImages=2`. It drains frames and checks overlapping arrival intervals and recent frames on both cameras.

Recorded result:

```text
camera=0 onOpened
camera=1 onOpened
OPEN BARRIER PASSED: cameras 0 and 1 both open BEFORE any createCaptureSession.
camera=0 onConfigured
camera=1 onConfigured
SAMPLE START: both repeating requests active; counting drained frames for 5000 ms.
Observed frame arrival intervals overlap=true
camera=0 sampleFrames=140 captureFailures=0 frameWithinLast1000Ms=true
camera=1 sampleFrames=140 captureFailures=0 frameWithinLast1000Ms=true
TOTAL sample frames=280
RESULT: PASS, simultaneous dual YUV streaming observed for this configuration.
```

The session-capability query threw even though actual streaming worked:

```text
CameraAccessException: CAMERA_ERROR (3)
isConcurrentSessionConfigurationSupported:3551:
Unable to query session configuration support Function not implemented (-38)
```

Do not infer unsupported hardware solely from that exception on this build. Attempt a bounded real session and handle failures. This low-resolution YUV result does not prove recording resolution, encoder throughput, audio, stabilization, timestamps, sustained capture or proprietary dual-video session settings.

If independently recreating the original probe package and report convention, its launch and retrieval commands were:

```sh
adb shell am start -n com.anx.camera.probe/.ProbeActivity --ez run true
adb shell run-as com.anx.camera.probe cat files/report.txt
```

Those commands require the separately built debug probe; they do not run against the r12 port. The original probe released sessions, readers and camera devices at completion and on pause.

## Android API contracts for another implementation

- Camera2 concurrency APIs are available since API 30. They do not require Android 17.
- Query `CameraManager.getConcurrentCameraIds()` and each camera's `SCALER_MANDATORY_CONCURRENT_STREAM_COMBINATIONS`.
- Open every intended concurrent camera before configuring any session. Configuring the first camera immediately can reserve resources needed by the second camera.
- Public API guarantees apply to advertised combinations and supported stream sizes. They do not promise full zoom range or concurrent access from separate apps.
- A combined single-file recording requires both images to reach a compositor that feeds an encoder. Opening two cameras or displaying two previews does not produce a combined recording.
- Validate rotation, front mirroring, crop/aspect ratio, EGL recordable configuration, encoder presentation timestamps, audio synchronization, pending-file cleanup and lifecycle release using actual output videos.

References: [CameraManager concurrency](https://developer.android.com/reference/android/hardware/camera2/CameraManager#getConcurrentCameraIds()) and [AOSP concurrent streaming](https://source.android.com/docs/core/camera/concurrent-streaming).

## Stock app dual-video implementation

The OEM inspection sources can be recreated from the pinned APK using the [selective extraction inventory](REFERENCE_FILES.md#device-and-feature-routing).

- `ConfigMapAsteroids.java` sets `FEATURE_DUAL_CAMERA=true`.
- `ProductConfig` assigns that flag to `isSupportDualVideo`.
- A059 maps to P24111/Asteroids. No arbitrary feature-enable patch is needed.
- `DualVideoMode.java` checks camera combinations and session support. Its existing exception handling proceeds to a real session attempt after a query failure. Do not replace this with unconditional success.
- P24111 uses front EIS session type `0xf004` and vendor key `com.nothing.camera.sessionParameters.isDualVideoMode`.
- The public YUV probe did not exercise those settings.
- The app contains XML feature readers but does not call them during normal feature initialization. Compiled product configuration is active. `/system/etc/camera_feature.xml` is not an established override for this build.

The historical `UFS-DUALVIEW-REPORT.md` is represented by these findings and the reproducible class inventory. Its complete local report is not published.

## Native libraries and services

The original extraction audit inventoried 107 libraries, 87 inside the APK and 20 additional OEM files, around 386 MiB. It excluded Android platform `libc`, `libdl`, `libm` and `libc++`. Sixty requested or transitive names were absent from the inspected firmware trees and APK. This is an inventory observation, not proof that every file should be packaged or every dependency is satisfied.

The selected port adds ten beta vendor libraries and the tested target's `libc++.so`. Final r12 has 98 native entries, with all 87 original entries unchanged. [native-libraries.json](../provenance/native-libraries.json) records all eleven additions, exact hashes, origins and `DT_NEEDED` names. [REFERENCE_FILES.md](REFERENCE_FILES.md#native-and-firmware-audits) explains how to repeat the wider audit; the historical full ELF graph is not included.

First observed main-process crash:

```text
CameraDecisionNative.<clinit>
UnsatisfiedLinkError: dlopen failed: library "libcameradecision.so" not found
```

The file exists in the beta's `/vendor/lib64/` and is loaded unconditionally by `CameraDecisionNative`. Its SHA-256 is `6361c10a35058e433e54487f130c4759228ad588a0da5b5f7340ceabacdbfa98`.

Its `DT_NEEDED` entries are `liblog.so`, `libc++.so`, `libc.so`, `libm.so` and `libdl.so`. The APK's bundled `libc++_shared.so` does not satisfy the same ABI. The historical static audit found 31 required `std::__1` symbols missing from that shared runtime. Do not rename `DT_NEEDED` blindly or package an arbitrary C++ runtime. The portable lock specifies the actual target runtime used.

On the target phone, `/system/lib64/libc++.so` exists. `/vendor/lib64/libcameradecision.so` and `/vendor/lib64/libofflineproc_jni.so` were absent at those exact paths. This was not an exhaustive device search.

The target native service was present:

```text
adb shell service check vendor.noth.hardware.camera.INtCamService/default
Service vendor.noth.hardware.camera.INtCamService/default: found
```

Presence does not establish AIDL version, authorization or SELinux access for the renamed app. The enabled NCF photo path needs this service. A null guard cannot recreate its processing.

Second observed startup problem:

```text
UFSManager.connectNtCameraServiceLocked
NullPointerException: Method.setAccessible(boolean) on a null reference
```

The reflective lookup of hidden `ServiceManager.waitForDeclaredService(String)` returned null. The patch preserves the original call when available and falls back to `getService(String)`. Hidden-API access is a likely cause of the reflective failure; the original investigation did not establish a definitive distinction from this OEM framework. The patch does not bypass Binder authorization. The final patch also retains the factory native-service identity. See [r12.patch](../patches/r12.patch).

Direct lookup from the separately signed client produced a service-manager SELinux denial for `vendor_hal_noth_camera_service`. The working path binds to the exported factory Android service, which accesses the native service under the factory process's identity.

## APK identity and rebuild notes

Experimental ID is `com.anx.camera.experimental`. Launcher class remains `com.nothing.camera.activity.CameraActivity`. Preserve Java/smali and JNI package names when changing application ID. App-owned authorities, dynamic receiver permission, process checks, self-directed intents and task affinity change; external service identities and OEM configuration keys retain their original meaning.

The port's private UFS manifest process is `:ufs`. The attempted `com.anx.camera.experimental:ufs` declaration is invalid manifest syntax despite resembling the expanded runtime process name. It triggered a misleading `ParsedServiceImpl`-to-`String` parser exception. The final manifest delta corrects it.

Original native files remain uncompressed and correctly ZIP-aligned because `extractNativeLibs=false`. ZIP 16 KiB alignment and ELF `PT_LOAD` alignment are separate checks. Some unchanged OEM ELF files have lower alignment; host ZIP checks do not establish operation on a 16 KiB-page phone.

[BUILD.md](BUILD.md) replaces the historical staged scripts with one original-to-r12 reconstruction. It uses JDK 21, Apktool 3.0.3, JADX 1.5.6, Android API 36 and Build Tools 36.0.0. The publication toolchain is pinned separately from the earlier manual work, which used Build Tools 37 for some steps. The SDK path is supplied through `--sdk`. Signing uses your own local identity.

## Stock-port progression

The untouched official beta installed with its valid platform signature and dual-view opened. Switching to Photo crashed on the missing decision library. The update was removed and the factory Camera restored. No OS update was installed.

Ordinary explicit binding to the NOS 4.1 exported `com.nothing.camera/com.nothing.algolib.cameraufs.UFSService` succeeded from a normal app. Descriptor and old transaction 12 returned correctly. The r12 port uses this service through [Nos41UfsBridge.java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java).

The old/new interfaces share a descriptor but differ in transaction numbering and parcel layouts. The adapter maps processing-count RPC 13 to old 12 and translates request/image fields. Unrepresented document, direct-processing, tuning and newer watermark semantics remain unverified. It rejects nonzero border offsets, accepts only the observed JPEG sizing Bundle hint without applying it, and returns unknown total count `-1` for exit analytics.

| Revision | Confirmed blocker or change | Current public reference |
| --- | --- | --- |
| Initial | Separate identity while preserving JNI names | [r12.patch](../patches/r12.patch) |
| r2 | Invalid private service-process declaration | [r12.patch](../patches/r12.patch) |
| r3 | Missing OEM libraries and defensive service lookup | [native lock](../provenance/native-libraries.json), [r12.patch](../patches/r12.patch) |
| r4 | ABI-matched target `libc++.so` | [EXTRACTION.md](EXTRACTION.md) |
| r5 | Factory binding and explicit old-wire adapter | [Nos41UfsBridge.java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java) |
| r6 | Private gesture constructor unavailable | [r12.patch](../patches/r12.patch) |
| r7 | Request, buffer and metadata diagnostics | [Nos41UfsBridge.java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java) |
| r8 | Private ImageWriter factory denied | [PublicImageWriter.java](../src/java/com/anx/camera/bridge/PublicImageWriter.java) |
| r9 | Private metadata set/pointer access denied | [MetadataCompatibility.java](../src/java/com/anx/camera/bridge/MetadataCompatibility.java), [upstream provenance](../provenance/hiddenapibypass.json) |
| r10 | Raw pending MediaStore URI grant still insufficient | [Output ownership](THIRD_PARTY_PROCESSING.md#6-keep-output-ownership-in-your-app) |
| r11 | Owner-side provider and callback URI mapping | [PhotoOutputProvider.java](../src/java/com/anx/camera/bridge/PhotoOutputProvider.java) |
| r12 | Gallery requires numeric proxy-ID suffix | [PhotoOutputProvider.java](../src/java/com/anx/camera/bridge/PhotoOutputProvider.java), [DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md) |

The public ImageWriter builder preserves allocation dimensions and CPU-write usage. Pinned AndroidHiddenApiBypass 6.1 supplies narrow app-process exemptions for `CameraMetadataNative`, `CaptureResult` and `CaptureRequest`. Real metadata set, nonzero pointer and entry-count regression passed on the device. It does not grant native-service access or stabilize private APIs. [License](../licenses/AndroidHiddenApiBypass-LICENSE) and [attribution](../licenses/AndroidHiddenApiBypass-ATTRIBUTION.txt) accompany the upstream provenance.

Factory processing generated a JPEG but initially could not write the port's pending MediaStore row. A simple URI grant removed the permission denial yet still failed pending-owner enforcement. The owner provider now forwards the granted proxy URI under the port's identity, checks size and decoded bounds before publishing, and maps callbacks back to the original URI. Gallery requires the original numeric ID at the end of the proxy path. Token and ID must match. Persistent mapping/grant cleanup remains deferred in r12.

## Verified result and remaining gaps

Latest tested APK is `Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk`. [DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md) records the exact rear/front JPEG and dual-view MP4 measurements. Low-light conditions explain the dark test output; there was no controlled image-quality comparison.

All seven tuning effects and every beta feature are not verified. Portrait, high-resolution paths, Live Photo, QR/Lens, widgets, every lens, prolonged recording, stabilization and exhaustive filter/tuning comparisons need separate tests. Firmware-only NOS 5 processing improvements are not established by these results.

The source kit can reproduce the r12 decoded and packaged payload from hash-locked inputs. [validation.json](../provenance/validation.json) records successful host checks. The disposable-signed rebuild was not retested on a device, the target-pull command was not executed during kit preparation, and Linux execution was not repeated.

Full OEM decompilations, historical revision APKs/reports, independent probe projects and the broad native audit are not published as source. [REFERENCE_FILES.md](REFERENCE_FILES.md) maps every local link in the original processing guide to published files, reproducible extraction outputs or an explicit historical gap.
