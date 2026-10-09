# Extract the reconstruction inputs

The source APK comes from Nothing OS 5 beta firmware `Asteroids_C5.0-260915-2123`. The backend models and bundled libc++ come from the tested NOS 4.1 Phone 3a. Both input sets are required for exact reconstruction.

Run these commands from the repository root. All paths are examples except partition-internal paths and the locked filenames. Use [BUILD.md](BUILD.md) after extraction.

## Obtain the three firmware parts

Nothing Archive provides the logical partition archive. Start at [spike0en/nothing_archive](https://github.com/spike0en/nothing_archive) or [nothingarchive.tech](https://nothingarchive.tech) and locate build `Asteroids_C5.0-260915-2123`. Download all three parts into one local directory:

```text
Asteroids_C5.0-260915-2123-image-logical.7z.001
Asteroids_C5.0-260915-2123-image-logical.7z.002
Asteroids_C5.0-260915-2123-image-logical.7z.003
```

The archive is 4,891,142,002 bytes across three volumes. `provenance/firmware.json` records the SHA-256 of each locally verified volume and the archive's published image checksums. Downloads are manual because a live release URL is not part of the pinned reconstruction contract. A missing or altered part fails before extraction.

Install 7-Zip with a `7zz` executable, or pass your executable with `--sevenzip`. EROFS extraction uses erofs-utils 1.9.4 or a compatible version with `--path`, `--extract` and `--no-preserve-owner`. A Linux distribution package or macOS-built erofs-utils works if it supports the firmware's compression. Pass `--fsck` explicitly if `fsck.erofs` is not on `PATH`. No filesystem mount or root privilege is required.

```sh
uv run scripts/extract.py archive \
  --parts /path/to/downloads \
  --output .work/images

uv run scripts/extract.py images \
  --images .work/images \
  --output .work/inputs \
  --fsck /path/to/fsck.erofs
```

7-Zip reads the first volume and finds the other two automatically. The script selects only `system_ext.img`, `vendor.img` and an optional `hash.sha256` archive member. This solid archive still requires scanning its compressed data. Some 7-Zip versions count traversed archive members in the output even though only the selected images appear in the destination. Use a fresh output directory. The two extracted images require roughly 6.7 GB together, in addition to the archive and decoded build workspace.

`images` verifies both full image hashes before extracting individual files. It extracts the beta APK from `system_ext.img` at `/priv-app/NTCamera/NTCamera.apk`. A host extraction tree may name that path `system_ext/priv-app/NTCamera/NTCamera.apk`; the partition-internal path does not include `system_ext`.

The ten additional firmware libraries come from `vendor.img`, each at `/lib64/<name>`:

```text
libcameradecision.so
libQnnHtp.so
libQnnSystem.so
libarcsoft_aiscenedetection.so
libarcsoft_beautyshot.so
libarcsoft_dualcam_refocus_preview.so
libarcsoft_lensstaindetection.so
libarcsoft_panorama.so
libarcsoft_portrait_distortion_correction.so
libnoteengine.so
```

Every extracted file is checked against the publication lock. These files are unmodified. Do not copy the entire vendor dependency bundle into the APK. Many other libraries are device-provided or incompatible with the target platform. The eleven-file selection is the exact final r12 addition set, not a general native dependency resolver.

If the two partition images already exist locally, start with `images`. You do not need to extract them again. The script does not modify or mount the supplied images.

## Obtain the tested factory backend inputs

Use a Phone 3a running NOS 4.1 with factory Camera `16.0.01.27.00` restored and enabled. Enable USB debugging and connect it to an authorized ADB host. The original beta update under `com.nothing.camera` is not the factory backend input.

```sh
uv run scripts/extract.py target \
  --factory .work/inputs/factory-camera.apk \
  --native .work/inputs/native
```

For multiple connected devices add `--serial YOUR_ADB_SERIAL`. The script asks `pm path com.nothing.camera`, requires one monolithic APK, and pulls that APK and `/system/lib64/libc++.so`. It verifies both hashes. It neither installs nor removes an app and does not change the phone's filesystem.

The target libc++ SHA-256 is `2267f93b8b3c9d1967f1833d5f71c7312213c43bb291250cf772800763037fb9`. Do not substitute the beta firmware's libc++ or rename `libc++_shared.so`. They have different ABI/runtime roles. The original APK's `libc++_shared.so` remains untouched.

The factory APK supplies four parcel models for the compatibility DEX. `prepare` extracts only those classes into local build staging, relocates their Java package, and compiles them. The published source kit does not contain the factory APK or its complete decompilation.

If your own extracted inputs already exist, use `scripts/local_inputs.py` to stage native files, and supply the two APK paths directly to `reconstruct.py`. Hash checks still apply.

## Input provenance and publication boundary

`provenance/firmware.json` retains Nothing Archive credit and image ownership information. Its image checksums come from the archive's checksum listing. The volume hashes identify the exact local copies used for this reconstruction. `inputs.json` locks the two APKs. `native-libraries.json` identifies each selected library's partition or target path, hash and native dependencies.

Keep archives, partition images, proprietary APK inputs, native binaries and generated model sources in ignored local storage. The source publication consists of the targeted delta, authored helper source/smali, scripts, tests, licenses, technical documentation and hash inventories. See [licenses/SCOPE.md](../licenses/SCOPE.md) for the authorship boundary.

## Validation performed during kit preparation

The three local archive volumes passed their recorded SHA-256 checks. `extract.py archive` successfully extracted the selected images and validated both image hashes. `extract.py images` extracted the original APK and all ten vendor libraries using erofs-utils 1.9.4, then validated every file hash.

The original APK extracted by this script was used in a fresh `reconstruct.py prepare` run. All 54,736 decoded r12 payload hashes matched, including regenerated old parcel models and HiddenApiBypass classes. The target-pull command was checked through its CLI and reviewed against the existing source extraction procedure. It was not executed against a device during this preparation.
