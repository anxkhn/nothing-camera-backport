# Reconstruct the r12 APK

This kit reconstructs Nothing Camera `17.0.00.71.00` as `com.anx.camera.experimental` for the tested Phone 3a NOS 4.1 environment. It applies the complete original-to-r12 delta in one pass. Intermediate r1 through r11 APKs are unnecessary.

Run commands from the repository root containing `scripts/`, `patches/`, `src/`, `licenses/` and `provenance/`. In the preparation workspace, that root is `publication/`.

## Toolchain

Install these versions and put `java`, `javac`, `jar`, `keytool`, `apktool`, `jadx` and `patch` on `PATH`:

| Tool | Version or requirement |
| --- | --- |
| uv | Python runner with Python 3.11 or newer |
| Java JDK | OpenJDK 21, helper compilation uses `--release 8` |
| Apktool | 3.0.3 |
| JADX | 1.5.6 |
| Android SDK platform | `platforms/android-36/android.jar` |
| Android SDK Build Tools | 36.0.0, including D8, zipalign and apksigner |
| patch | BSD or GNU, with `--batch` and `-p1` |

Set `ANDROID_SDK_ROOT` to your actual SDK directory. The scripts take `--sdk` explicitly and do not assume a Homebrew or Linux path. `prepare` refuses different Apktool and JADX versions because decoder and decompiler output affects hash equivalence. It downloads the hash-pinned AndroidHiddenApiBypass 6.1 AAR from Maven Central. Python scripts use only the standard library.

Allow several minutes for ten selective JADX invocations. Give automation at least a five-minute timeout for `prepare`. Keep enough disk space for the decoded OEM APK, generated models, DEX, and multiple roughly 311 MB APKs. Firmware extraction needs additional space as described in [EXTRACTION.md](EXTRACTION.md).

Before building, install the contents of `scripts/publication.gitignore` as the repository's `.gitignore`. `.work/` contains proprietary inputs, generated code and private local build outputs.

## Inputs

Use [EXTRACTION.md](EXTRACTION.md) to produce:

```text
.work/inputs/NTCamera.apk
.work/inputs/factory-camera.apk
.work/inputs/native/                         exactly the 11 added .so files
```

The original APK SHA-256 is `89fb2557710f5f858870d4af84e33ffd56c9ffe62127a59962541e8f81ebab59`. The factory Camera `16.0.01.27.00` APK SHA-256 is `8793db86987f9736f5ce1f9a2e6287693ee259f50490416bd478e50c436cb620`. The exact native hashes are in `provenance/native-libraries.json`.

If you already have the ten extracted firmware libraries and the tested target's libc++, stage them without a connected phone:

```sh
uv run scripts/local_inputs.py \
  --firmware-native /path/to/extracted/arm64-v8a \
  --target-libcxx /path/to/target/libc++.so \
  --output .work/inputs/native
```

All input hashes must match. An APK with the same displayed version but different content is not interchangeable with these pinned inputs.

## Prepare, build and verify

Choose a fresh work directory. The script will not erase or overwrite an existing one.

```sh
uv run scripts/reconstruct.py prepare \
  --original .work/inputs/NTCamera.apk \
  --factory .work/inputs/factory-camera.apk \
  --native .work/inputs/native \
  --sdk "$ANDROID_SDK_ROOT" \
  --work .work/r12

uv run scripts/reconstruct.py build \
  --sdk "$ANDROID_SDK_ROOT" \
  --work .work/r12

uv run scripts/verify_apk.py \
  --original .work/inputs/NTCamera.apk \
  --apk .work/r12/aligned.apk

uv run python -m unittest discover -s tests -v
```

`prepare` performs the following operations:

1. Verify the beta APK, factory APK and eleven native files.
2. Decode the original APK using Apktool 3.0.3. Check the before-hash of every changed file.
3. Apply `patches/r12.patch`. Check every after-hash.
4. Add the eleven unchanged arm64 libraries. Preserve all 87 original native libraries.
5. Extract six modern parcel models with JADX for compile-time stubs. These are not added to the APK because the original app already defines them.
6. Extract four old parcel models from the factory APK and relocate their Java package to `com.anx.camera.bridge.old`. Remove the decompiler's AudioStats import and replace its zero constant with `0.0`.
7. Compile the five authored Java helpers and the old models with `javac --release 8`. D8 converts these classes and the upstream library into DEX, using Android API 36 and minimum API 34.
8. Disassemble that DEX with Apktool. Verify that all seven authored smali classes match the published r12 representation exactly. Install the old models, helpers and upstream classes into `smali_classes9`.
9. Copy upstream license assets and compare all 54,736 decoded payload files against `provenance/r12-decoded.json`.

`build` repeats the decoded payload verification, assembles all nine DEX files and resources, then aligns uncompressed native ZIP entries with `zipalign -P 16`. It produces `unsigned.apk` and `aligned.apk`. It does not patch ELF load segments. Many unchanged OEM libraries have 4 KiB ELF alignment, so ZIP alignment alone is not a claim of full 16 KiB-page support.

## Sign with your own key

Keep your key outside the published source tree. To create a new local key, run the following command and answer its password prompts:

```sh
keytool -genkeypair -storetype PKCS12 \
  -keystore /private/path/camera.p12 -alias camera \
  -keyalg RSA -keysize 3072 -validity 10000 \
  -dname "CN=Local Camera Build"
```

Set `CAMERA_KS_PASS` and `CAMERA_KEY_PASS` in your environment. For PKCS12, use the same password for both. Then run:

```sh
uv run scripts/reconstruct.py build \
  --sdk "$ANDROID_SDK_ROOT" --work .work/r12 \
  --keystore /private/path/camera.p12 --alias camera \
  --output .work/r12/camera-signed.apk
```

The script passes passwords to apksigner via environment variable names, verifies the signature and rechecks ZIP alignment. Signing happens after alignment. A key you create will have a different certificate and signed APK hash from the released r12 APK. Android will not install it as an update over a build signed by another certificate. Removing only the experimental package discards its app data and permits a fresh installation.

The reference signed APK SHA-256 is `00dd9b077e604fc1482f84085169661bd5849f8373d760672a2f683003ef83ac`. If you have that release asset locally, compare payloads with:

```sh
uv run scripts/verify_apk.py \
  --original .work/inputs/NTCamera.apk \
  --apk .work/r12/camera-signed.apk \
  --reference /path/to/r12-galleryid-signed.apk
```

The comparison ignores `META-INF/` entries and APK signing blocks. It verifies the reference's full APK hash first, then requires every other uncompressed entry to match, including DEX, compiled resources, manifest, native libraries and assets. This is stronger than checking only class names or a subset of patched methods.

## Runtime contract

Keep the factory Camera installed and enabled. The frontend preserves `com.nothing.*` Java/JNI names while its application ID, provider authorities, task affinities, shortcuts and app label change. A new package ID grants no native-service privilege.

The beta UFS client binds explicitly to the factory `com.nothing.camera` package, then wraps the returned Binder with the version-specific adapter. The factory provides the NOS 4.1 processing backend. The device's HAL and native services remain NOS 4.1. Avoid simultaneous use of factory Camera and this port because the service has a single callback slot.

`Nos41UfsBridge` translates request/image parcel layouts. It removes the NOS 5-only border offsets after rejecting nonzero offsets, omits the extra save-on-pause argument, and maps modern transaction 13 to old transaction 12. Modern transaction 12 accepts only the JPEG sizing hint and logs that the factory chooses its own size. Modern transaction 14 returns unknown count `-1`. New document, direct-processing and watermark fields have no old wire representation. Their presence is logged, not treated as verified backported behavior.

Photo processing grants the factory access to an owner-controlled proxy URI. Its opaque token is followed by the original numeric MediaStore ID so gallery parsing still works. `PhotoOutputProvider` forwards file access under the port's identity and validates dimensions and file size before clearing `is_pending`. The owner callback translates the proxy back to the original URI. Persistent mappings and grants remain for asynchronous work. Cleanup is deferred in r12.

`PublicImageWriter` replaces the inaccessible OEM writer overload with the public builder and CPU write usage. `MetadataCompatibility` installs narrowly scoped camera metadata exemptions through HiddenApiBypass. The gesture initializer degrades when the device's gesture service is unavailable. Neither helper changes JNI class names or ports the native camera HAL.

### Binder wire map

The session descriptor is `com.nothing.algolib.cameraufs.INtCamUfsSession`. Requests write that interface token and use synchronous request/reply parcels. The wrapper validates the descriptor before accepting the factory Binder. It reads the factory exception header before forwarding the complete reply. Buffer-bearing requests close locally acquired HardwareBuffers, fences and parcel file descriptors after the synchronous transaction returns.

| Modern transaction | Old transaction | Translation |
| --- | --- | --- |
| 1 | 1 | Register callback, wrap it to restore owner photo URI |
| 2 | 2 | Scalar/string parameters, unchanged |
| 3 | 3 | Border watermark PFD, width, height and request number; reject nonzero left/top offsets |
| 4 | 4 | Metadata buffers and request number, unchanged |
| 5 | 5 | Save image with old image layout; omit modern processing-on-pause argument |
| 6 | 6 | Translate capture request and input/output image arrays; delegate output URI |
| 7 through 11 | Same number | Existing scalar/session/buffer layouts, unchanged |
| 12 | No call | Accept only `ncf_jpeg_max_size`; factory size selection remains authoritative |
| 13 | 12 | Return the factory tracked-request count |
| 14 | No call | Return unknown total count `-1` for exit analytics |

Callback descriptor is `com.nothing.algolib.cameraufs.INtCamUfsCallback`. Callback transaction 1 contains `NtCamUfsResult` and `INtCamJpeg`. Their layouts match the tested old backend. The callback wrapper resolves `photoUri` back to the owner's MediaStore URI, forwards the two typed objects, then closes its acquired JPEG shared memory. Other callback transactions forward unchanged.

Old image parcels contain a typed-object presence marker followed by a sized object. Fields inside the sized object, in order, are format, width, height, transform, scaling mode, timestamp, plane count, slave-image flag, crop Rect, HardwareBuffer and fence PFD. The modern tuning-image flag is omitted, with a diagnostic message. Null typed arrays use length `-1`; non-null arrays write their length followed by each typed old image.

Old request parcels also use a presence marker and sized object. Their field order is request number, operation mode, logical camera ID, settings byte array, input buffers, output buffers, URI, description, latitude, longitude, camera ID, flash mode, focal length, AWB mode, exposure time, aperture, sensitivity boost, ISO, EV, step denominator, step numerator, focus, 35 mm equivalent focal length, override EV, override ISO, maker note, click timestamp, then burst, pre-capture, Ultra HDR, border watermark, Live Photo, support-UFS and UFS-save flags. The serializer patches the leading size after writing these fields. The original modern buffer/handle models supply nested buffer serialization because those layouts match the tested backend. The old models generated from the factory APK are independent readers used by instrumentation to check this order.

The output authority is `com.anx.camera.experimental.bridgeoutput`. A delegated path has the form `/<opaque-token>/<numeric-media-id>`. The provider rejects a token with a different media ID and rejects query/fragment additions. It remains non-exported, with per-URI grants to `com.nothing.camera`. Publication under the port's identity matters because a delegated write grant alone does not make the factory the owner of the pending MediaStore row.

## Device check

Install a signed build and grant camera, microphone and media permissions in the Android UI. Stop any active factory capture before testing:

```sh
adb install .work/r12/camera-signed.apk
adb shell am instrument -w \
  com.anx.camera.experimental/com.anx.camera.bridge.CodecInstrumentation
```

Instrumentation uses temporary MediaStore rows and deletes those rows afterwards. It checks old/new parcel translation, RPC remapping, metadata writer allocation, native metadata access, factory URI grants, numeric gallery IDs, and invalid/valid JPEG publication. Run it only on the intended test device with the pinned factory Camera. Host reconstruction checks do not replace camera-device testing.

Earlier r12 device testing on A059, AsteroidsIND, Android 16, build `B4.1-260810-1153` verified rear/front full JPEG capture and a 5.83-second 1080 by 1920 H.264/AAC dual-view recording. This publication preparation did not reinstall the rebuilt APK or repeat capture tests. Portrait, high-resolution modes, Live Photo, QR/Lens, widgets, every lens, prolonged recording, stabilization and exhaustive filter/tuning comparisons remain unverified.

## Troubleshooting and maintenance

- Hash mismatch before decoding means the input is different. Restore or obtain the pinned input. Do not loosen the lock to make a different firmware pass.
- A before-hash mismatch after decoding usually means a different Apktool version or framework resource cache. Use the pinned tool and an unmodified Android framework. Inspect the differing file before regenerating provenance.
- Helper smali mismatch means the compiler/decompiler/D8 output differs. Use the pinned JADX, JDK 21 and Build Tools 36.0.0. The exact-match check is deliberate.
- Interrupted preparation leaves its work directory for inspection. Start again with another fresh path.
- Signature conflict means the installed experimental app uses a different signer. Preserve the key for your own future updates.
- Missing factory service or incompatible Binder means the device is outside the tested backend contract. Changing an application ID cannot repair it.

For a future reviewed revision, decode its matching original and final APKs with the same toolchain, use `export_patch.py --help` to regenerate the targeted delta and source inventory, then run a fresh reconstruction and APK comparison. `record_firmware.py` records the local three-part archive hashes and published image hashes. Neither export tool contacts GitHub or signs an APK.

Tool references: [Apktool](https://apktool.org/), [zipalign](https://developer.android.com/tools/zipalign), [apksigner](https://developer.android.com/tools/apksigner), [AndroidHiddenApiBypass](https://github.com/LSPosed/AndroidHiddenApiBypass).
