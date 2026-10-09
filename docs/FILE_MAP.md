# File map and verification record

This is the reconstruction kit prepared for `anxkhn/nothing-camera-backport`. Paths below are relative to the kit root.

| Path | Purpose |
| --- | --- |
| `scripts/reconstruct.py` | Hash-checked preparation, Java/D8 regeneration, assembly, alignment and optional signing |
| `scripts/extract.py` | Verify local archive volumes, selectively extract partitions and camera inputs, pull factory inputs with ADB |
| `scripts/local_inputs.py` | Stage exactly eleven already-extracted native libraries |
| `scripts/verify_apk.py` | Verify preserved assets/native libraries and compare reconstructed ZIP payloads with r12 |
| `scripts/export_patch.py` | Generate the reviewed original-to-final delta, authored sources and hash inventories |
| `scripts/record_firmware.py` | Record local archive hashes and published partition checksums |
| `scripts/audit_publication.py` | Check the publication allowlist, reject proprietary binaries/private paths, and write the file manifest |
| `scripts/publication.gitignore` | Ignore rules to install as the repository root `.gitignore` |
| `patches/r12.patch` | Complete unified delta against Apktool 3.0.3's original decode, 70 changed files |
| `src/java/com/anx/camera/bridge/` | Five readable authored Java helpers |
| `src/smali/com/anx/camera/bridge/` | Seven exact r12 authored smali classes, including inner classes |
| `tests/test_pipeline.py` | Standard-library checks for input rejection, tree mismatch rejection, patch inventory and CLI availability |
| `licenses/AndroidHiddenApiBypass-LICENSE` | Full upstream Apache-2.0 license |
| `licenses/AndroidHiddenApiBypass-ATTRIBUTION.txt` | Upstream attribution copied into the APK |
| `licenses/SCOPE.md` | Authored work, upstream library and proprietary input boundaries |
| `provenance/inputs.json` | Original, factory and released r12 APK hashes; pinned tool versions |
| `provenance/firmware.json` | Three firmware-volume hashes, published image hashes and Nothing Archive credit |
| `provenance/native-libraries.json` | Eleven added native hashes, dependency names and portable source locations |
| `provenance/hiddenapibypass.json` | Maven artifact hashes, coordinate and upstream commit |
| `provenance/patch-files.json` | Before/after hashes for every modified OEM text file |
| `provenance/r12-decoded.json` | Filename/hash inventory for all 54,736 reconstructed decoded payload files |
| `provenance/validation.json` | Sanitized host verification results and explicit untested steps |
| `provenance/files.json` | Size/hash inventory of the publishable kit, excluding itself and local work |
| `docs/BUILD.md` | Build, signing, validation, runtime contract and maintenance instructions |
| `docs/EXTRACTION.md` | Firmware and target extraction how-to |
| `docs/FILE_MAP.md` | This inventory and validation summary |

## Authored helper responsibilities

`Nos41UfsBridge.java` wraps the factory Binder. It translates request/image parcels, remaps incompatible transactions, grants proxy-URI access to the factory, restores owner URIs in callbacks and closes acquired buffers/descriptors.

`PhotoOutputProvider.java` persists token-to-owner-URI mappings. Proxy paths retain numeric media IDs for gallery parsing. The provider validates a completed image's dimensions and file size before publishing its MediaStore row under the owner's identity.

`PublicImageWriter.java` creates a metadata ImageWriter using the public builder and CPU write usage. `MetadataCompatibility.java` enables exact camera metadata class exemptions and checks real native metadata access. `CodecInstrumentation.java` runs the device-side parcel, metadata and publication checks.

The smali directory contains these five classes plus `Nos41UfsBridge$OwnerCallback` and `CodecInstrumentation$1`. Four relocated factory model classes and their generated inner classes come from the supplied factory APK during preparation. They are not published here. Upstream `org/lsposed` classes also regenerate from the downloaded, hash-checked AAR.

## Patch map

The 70 changed OEM files comprise one manifest, 55 resource files and 14 smali files. Resource changes cover localized provider-authority strings and shortcut target packages. The app label changes in the manifest.

The smali delta covers:

- `BuildConfig` and component/provider/widget callers whose runtime package identity must become `com.anx.camera.experimental`.
- `CameraApp` process-name initialization and metadata compatibility setup.
- `UFSClient` factory service binding, explicit backend package selection and Binder adapter insertion.
- `UFSManager` defensive service-method lookup. `ExtensionsInterfaceProxyWrapper` targets the experimental app's own proxy service.
- `NtCameraManager$NtCamImageProvider` public ImageWriter construction.
- `GestureRecognizer` unavailable-service fallback.

The manifest changes application ID, authorities, signature permission, affinities, label and private UFS process name. It adds factory package visibility, bridge instrumentation and the owner output provider. OEM Java and JNI package names remain intact. Native libraries are copied unchanged; there is no binary patch section.

## Host verification completed

On 2026-10-09 the kit passed:

- Complete local firmware volume hashing and selective 7-Zip extraction with image hash validation.
- Selective EROFS extraction of the beta APK and ten vendor libraries with exact hash checks.
- A clean preparation run from that extracted beta APK and the pinned factory APK.
- Java regeneration of all seven authored helper smali classes, byte-for-byte.
- Comparison of all 54,736 decoded payload files with the final r12 tree.
- Apktool assembly of all nine DEX files and resources.
- `zipalign -P 16` checks on aligned and signed APKs.
- Signing and successful apksigner verification using a newly generated disposable local test key.
- Exact match of 3,503 non-`META-INF` uncompressed ZIP payload entries against the released r12 APK.
- Preservation of all 199 original assets and 87 original native libraries, with exactly eleven native additions and 98 uncompressed native entries total.
- Standard-library script tests and Python lint/format checks.

The disposable key and all rebuilt APKs remain in local `.work/` storage. The user's release key was not used. APK payload equality does not imply equality of the signed APK hash or certificate.

## Remaining checks

The regenerated APK was not installed or exercised on a phone during kit preparation. The ADB target-pull command was not run against hardware. Linux execution was not repeated; commands are portable, but exact helper output was validated on macOS with the pinned toolchain.

Earlier device results for released r12 are described in `docs/BUILD.md`. They establish the existing tested behavior, not a new device result for the disposable-signed rebuild. The factory backend remains version-specific. No standalone NOS 5 native processing service or HAL is supplied.

Repository creation, license selection for authored work, release asset upload and public release notes are outside this kit preparation. The APK release asset should be the existing verified signed r12 artifact, with its public SHA-256, rather than the disposable-signed test rebuild.
