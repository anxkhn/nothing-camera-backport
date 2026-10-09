# Reference files and reproducible inspection inventory

The original `THIRD_PARTY_PROCESSING_GUIDE.md` contained 77 local-link occurrences pointing to 65 distinct targets. This inventory accounts for every target by original basename or decoded class path. It maps authored files to published source, OEM references to selective extraction from pinned APKs, and historical reports/scripts to current documentation and reconstruction equivalents. Equivalent documentation does not reproduce a historical report's raw evidence or an incremental script byte-for-byte.

All commands run from the repository root containing `scripts/`, `src/`, `patches/` and `provenance/`. In the preparation workspace this is `publication/`. Generated `.work/` paths are local inspection/build outputs, not links to unpublished files and not files to commit. Original date-stamped workspace prefixes are unnecessary.

## Start with locked inputs

Follow [EXTRACTION.md](EXTRACTION.md), using [extract.py](../scripts/extract.py) to verify the three logical archive volumes, extract `system_ext.img` and `vendor.img`, select the beta APK and ten vendor libraries, and pull the matching factory APK plus target runtime. The target pull is a separate hardware step, not a firmware-archive extraction.

| Origin | Public lock | Local staged input |
| --- | --- | --- |
| Beta NOS 5 `system_ext:/priv-app/NTCamera/NTCamera.apk` | [inputs.json](../provenance/inputs.json), [firmware.json](../provenance/firmware.json) | `.work/inputs/NTCamera.apk` |
| NOS 4.1 factory APK from `pm path com.nothing.camera` | [inputs.json](../provenance/inputs.json) | `.work/inputs/factory-camera.apk` |
| Ten beta `vendor:/lib64/` additions | [native-libraries.json](../provenance/native-libraries.json) | `.work/inputs/native/` |
| Target `/system/lib64/libc++.so` | [native-libraries.json](../provenance/native-libraries.json) | `.work/inputs/native/libc++.so` |

Factory APK SHA-256 is `8793db86987f9736f5ce1f9a2e6287693ee259f50490416bd478e50c436cb620`; beta APK SHA-256 is `89fb2557710f5f858870d4af84e33ffd56c9ffe62127a59962541e8f81ebab59`. Same displayed version is insufficient if hashes differ.

## Selectively extract a Java reference

Use JADX 1.5.6, the version pinned by [BUILD.md](BUILD.md). Create an inspection directory, choose the APK origin from the tables, then use the qualified class name and original output basename:

```sh
mkdir -p .work/references

jadx --single-class com.nothing.algolib.cameraufs.INtCamUfsSession \
  --single-class-output .work/references/nos41-INtCamUfsSession.java \
  --no-res .work/inputs/factory-camera.apk

jadx --single-class com.nothing.algolib.cameraufs.INtCamUfsSession \
  --single-class-output .work/references/nos5-INtCamUfsSession.java \
  --no-res .work/inputs/NTCamera.apk
```

Repeat this command for each row needed, substituting the class, output basename and matching input APK. This regenerates inspection references without publishing complete extracted OEM interfaces. JADX output may differ if options change or contain methods it cannot reconstruct. It is not a claim of byte-identical historical Java output.

For an executable r12 reference, run `reconstruct.py prepare` exactly as shown in [BUILD.md](BUILD.md#prepare-build-and-verify). `.work/r12/decoded/` then contains the final patched Apktool tree. For original beta smali or a factory manifest/service inspection, decode locally into fresh paths:

```sh
apktool d .work/inputs/NTCamera.apk -o .work/references/beta-decoded
apktool d .work/inputs/factory-camera.apk -o .work/references/factory-decoded
```

Do not overwrite an existing decode. Factory DEX partitions must be located in that extraction rather than assumed to match beta partitions. The factory manifest is `.work/references/factory-decoded/AndroidManifest.xml`.

## Factory and beta protocol sources

Each row has two origins. `nos41-` means the factory APK; `nos5-` means the original beta APK. Their qualified Java names are the same; their wire contracts are not.

| Original source basenames | Qualified class |
| --- | --- |
| `nos41-INtCamUfsSession.java`, `nos5-INtCamUfsSession.java` | `com.nothing.algolib.cameraufs.INtCamUfsSession` |
| `nos41-INtCamUfsCallback.java`, `nos5-INtCamUfsCallback.java` | `com.nothing.algolib.cameraufs.INtCamUfsCallback` |
| `nos41-NtCamUfsRequest.java`, `nos5-NtCamUfsRequest.java` | `com.nothing.algolib.cameraufs.NtCamUfsRequest` |
| `nos41-NtCamUfsImage.java`, `nos5-NtCamUfsImage.java` | `com.nothing.algolib.cameraufs.NtCamUfsImage` |
| `nos41-NtCamUfsBuffer.java`, `nos5-NtCamUfsBuffer.java` | `com.nothing.algolib.cameraufs.NtCamUfsBuffer` |
| `nos41-NtCamUfsHandle.java`, `nos5-NtCamUfsHandle.java` | `com.nothing.algolib.cameraufs.NtCamUfsHandle` |
| `nos41-NtCamUfsResult.java`, `nos5-NtCamUfsResult.java` | `com.nothing.algolib.cameraufs.NtCamUfsResult` |
| `nos41-INtCamJpeg.java`, `nos5-INtCamJpeg.java` | `com.nothing.algolib.cameraufs.INtCamJpeg` |

`prepare` generates only six beta compile models under `.work/r12/stubs/`: request, image, buffer, handle, result and JPEG. It generates only four factory test readers under `.work/r12/old/`: request, image, buffer and handle. The generated factory readers relocate their package to `com.anx.camera.bridge.old`; modern stubs retain the OEM package. `prepare` removes the JADX AudioStats import and substitutes `0.0` for its zero constant before compilation. Generated filenames omit the `nos41-`/`nos5-` prefixes. Session/callback interfaces and full result/JPEG factory references require the selective commands above.

Old readers compile into the compatibility DEX for instrumentation. Modern stubs supply compile-time types and are not added as duplicate runtime classes. Original OEM models remain in the app. See [reconstruct.py](../scripts/reconstruct.py) for the exact model lists and transformations.

## Capture and service implementation

| Original source basename | Qualified class | Origin |
| --- | --- | --- |
| `nos41-NtCameraManager.java` | `com.nothing.algolib.offlineproc.NtCameraManager` | Factory |
| `nos41-UFSManager.java` | `com.nothing.algolib.cameraufs.UFSManager` | Factory |
| `nos41-UFSService.java` | `com.nothing.algolib.cameraufs.UFSService` | Factory |
| `nos41-UfsManagerTool.java` | `com.nothing.algolib.cameraufs.tool.UfsManagerTool` | Factory |
| `NtCameraManager.java` | `com.nothing.algolib.offlineproc.NtCameraManager` | Beta |
| `UFSManager.java` | `com.nothing.algolib.cameraufs.UFSManager` | Beta |
| `nos5-UfsManagerTool.java` | `com.nothing.algolib.cameraufs.tool.UfsManagerTool` | Beta |
| `nos5-NcfQcomNightNode.java` | `com.nothing.camera.pipeline.ncf.qcom.NcfQcomNightNode` | Beta |

Use factory `UFSService` plus its manifest for binding/lifecycle declarations. Factory `UFSManager` and `UfsManagerTool` explain request-map counts, callbacks and output work. `NtCameraManager` and the beta pipeline references explain capture inputs and metadata serialization. If Java decompilation is incomplete, inspect corresponding decoded smali instead.

Additional classes needed to trace the findings are `com.nothing.algolib.offlineproc.OfflineProcServer` for native metadata serialization and `com.nothing.algolib.decision.CameraDecisionNative` for unconditional native library loading. Extract them from the beta APK with the same selective command. This does not independently specify the native metadata ABI.

## Custom metadata serializer

All six original references are beta executable smali in `smali_classes4/com/nothing/algolib/offlineproc/`. Reconstruction preserves them under `.work/r12/decoded/`. For Java inspection, selectively extract the outer class; JADX may include nested definitions within that output.

| Original smali basename | Qualified class |
| --- | --- |
| `NtCamCustomMetadata.smali` | `com.nothing.algolib.offlineproc.NtCamCustomMetadata` |
| `NtCamCustomMetadata$Type.smali` | `com.nothing.algolib.offlineproc.NtCamCustomMetadata$Type` |
| `NtCamCustomMetadata$MetadataTags.smali` | `com.nothing.algolib.offlineproc.NtCamCustomMetadata$MetadataTags` |
| `NtCamCustomMetadata$NtCamMetadataHeader.smali` | `com.nothing.algolib.offlineproc.NtCamCustomMetadata$NtCamMetadataHeader` |
| `NtCamCustomMetadata$NtCamMetadataEntry.smali` | `com.nothing.algolib.offlineproc.NtCamCustomMetadata$NtCamMetadataEntry` |
| `NtCamCustomMetadata$Rational.smali` | `com.nothing.algolib.offlineproc.NtCamCustomMetadata$Rational` |

```sh
jadx --single-class com.nothing.algolib.offlineproc.NtCamCustomMetadata \
  --single-class-output .work/references/NtCamCustomMetadata.java \
  --no-res .work/inputs/NTCamera.apk
```

Quote class names and paths containing `$` in shell commands. The [processing reference](THIRD_PARTY_PROCESSING.md#custom-settings-byte-array-structure) retains the little-endian header, entry and enum layouts. Native metadata stored in shared buffers is a different format.

## Device and feature routing

These inspection outputs derive from the original beta APK. Selectively extract by the qualified names below.

| Original source basename | Qualified class |
| --- | --- |
| `ConfigMapAsteroids.java` | `com.nothing.common.utils.config.ConfigMapAsteroids` |
| `ConfigMapAsteroidsPlus.java` | `com.nothing.common.utils.config.ConfigMapAsteroidsPlus` |
| `FeatureConfig.java` | `com.nothing.common.utils.FeatureConfig` |
| `DualVideoMode.java` | `com.nothing.camera.mode.DualVideoMode` |
| `LaunchIntentParser.java` | `com.nothing.common.setting.LaunchIntentParser` |
| `nos5-SettingContext.java` | `com.nothing.common.setting.SettingContext` |
| `nos5-CameraScheduler.java` | `com.nothing.camera.scheduler.CameraScheduler` |

Also extract `com.nothing.common.utils.ProductConfig` to trace `FEATURE_DUAL_CAMERA` into `isSupportDualVideo`. Its beta smali is `smali_classes5/com/nothing/common/utils/ProductConfig.smali`. See [TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md#stock-app-dual-video-implementation) for the verified interpretation. Configuration references are evidence for this device/version, not a feature override API.

## Patched smali integration points

The original guide linked to final decoded files. These are recreated by `prepare` under `.work/r12/decoded/`. [r12.patch](../patches/r12.patch) publishes the relevant OEM changes; [patch-files.json](../provenance/patch-files.json) locks their before/after hashes. [r12-decoded.json](../provenance/r12-decoded.json) locks the entire final tree.

| Original decoded relative path | Qualified class | Role |
| --- | --- | --- |
| `smali_classes4/com/nothing/algolib/cameraufs/UFSClient.smali` | `com.nothing.algolib.cameraufs.UFSClient` | Factory binding and adapter insertion |
| `smali_classes3/com/nothing/camera/app/CameraApp.smali` | `com.nothing.camera.app.CameraApp` | Process identity and metadata initialization |
| `smali_classes4/com/nothing/camera/gesture/GestureRecognizer.smali` | `com.nothing.camera.gesture.GestureRecognizer` | Public gesture fallback |
| `smali_classes4/com/nothing/algolib/offlineproc/NtCameraManager.smali` | `com.nothing.algolib.offlineproc.NtCameraManager` | Retained executable capture/metadata implementation |
| `smali_classes4/com/nothing/algolib/offlineproc/NtCameraManager$NtCamImageProvider.smali` | `com.nothing.algolib.offlineproc.NtCameraManager$NtCamImageProvider` | Patched public ImageWriter construction |

The manager outer class is an executable reference, while the writer delta is in its nested provider. A reference to the whole original `decoded/` directory maps to [BUILD.md](BUILD.md) and `.work/r12/decoded/`, not a downloadable full extracted source tree.

## Authored sources and build staging

| Original source basename | Published source | Qualified class |
| --- | --- | --- |
| `Nos41UfsBridge.java` | [Java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java) | `com.anx.camera.bridge.Nos41UfsBridge` |
| `PhotoOutputProvider.java` | [Java](../src/java/com/anx/camera/bridge/PhotoOutputProvider.java) | `com.anx.camera.bridge.PhotoOutputProvider` |
| `PublicImageWriter.java` | [Java](../src/java/com/anx/camera/bridge/PublicImageWriter.java) | `com.anx.camera.bridge.PublicImageWriter` |
| `MetadataCompatibility.java` | [Java](../src/java/com/anx/camera/bridge/MetadataCompatibility.java) | `com.anx.camera.bridge.MetadataCompatibility` |
| `CodecInstrumentation.java` | [Java](../src/java/com/anx/camera/bridge/CodecInstrumentation.java) | `com.anx.camera.bridge.CodecInstrumentation` |

Exact authored r12 disassembly is also published in [src/smali/com/anx/camera/bridge](../src/smali/com/anx/camera/bridge/), including `Nos41UfsBridge$OwnerCallback` and `CodecInstrumentation$1`. The historical helper staging directories map to `.work/r12/stubs`, `old`, `stub-classes`, `helper-classes`, `helper-dex` and `helper-disassembled`. [reconstruct.py](../scripts/reconstruct.py) generates these paths under the selected `--work` directory.

The historical `vendor/hiddenapibypass-6.1/provenance.json` maps to [hiddenapibypass.json](../provenance/hiddenapibypass.json). `prepare` downloads the pinned AAR, verifies its hash, extracts `classes.jar` as `.work/r12/hiddenapi.jar`, and regenerates `org/lsposed` smali. The historical complete library vendor folder is replaced by this download plus [license](../licenses/AndroidHiddenApiBypass-LICENSE) and [attribution](../licenses/AndroidHiddenApiBypass-ATTRIBUTION.txt).

## Native and firmware audits

| Original reference | Published replacement or reproduction |
| --- | --- |
| `NATIVE_DEPENDENCY_REPORT.md` | [Technical native findings](TECHNICAL_FINDINGS.md#native-libraries-and-services), [native lock](../provenance/native-libraries.json) |
| `r4-added-libraries.json` | [native-libraries.json](../provenance/native-libraries.json), exact final eleven additions |
| `r4-runtime-abi-audit.json` | Historical 31-symbol mismatch retained in [findings](TECHNICAL_FINDINGS.md#native-libraries-and-services); repeat symbol comparison locally |
| `elf-graph.json` | Recreate a graph from local ELF `DT_NEEDED` inspection; full historical graph is not published |
| `unresolved-needed-edges.json` | Recompute against the chosen inspection inventory; historical absent-name count is retained in [findings](TECHNICAL_FINDINGS.md#native-libraries-and-services) |

Other original findings references, `CAMERA_REPORT.md` and `dependency-graph.txt`, map to [TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md), [EXTRACTION.md](EXTRACTION.md) and the same audit procedure. The broad `native_bundle/lib/arm64-v8a/` inventory is not the final package selection. The original APK's native files can be obtained through a local Apktool decode. The ten selected vendor files and target runtime regenerate through `extract.py`; the full 107-library audit needs a wider local firmware inspection.

For a selected dependency/symbol check with an available LLVM `llvm-readelf` executable:

```sh
llvm-readelf --dynamic .work/inputs/native/libcameradecision.so
llvm-readelf --dyn-syms --wide .work/inputs/native/libcameradecision.so
llvm-readelf --dyn-syms --wide \
  .work/references/beta-decoded/lib/arm64-v8a/libc++_shared.so
llvm-readelf --dyn-syms --wide .work/inputs/native/libc++.so
```

Record every `NEEDED` edge, recursively inspect candidates from the matching inventory, and compare exact required undefined symbol names against runtime exports. This includes symbol versions and ABI, not merely demangled similarities. Record missing names against a stated search inventory. Do not equate a library's existence with availability inside an app linker namespace. These commands expose the inputs for an audit; the kit does not supply a replacement full-graph generator or the exact historical ABI report.

Target linker allowlists originally named `*-public-libraries.txt` can be inspected locally from `/system/etc/public.libraries.txt` and `/vendor/etc/public.libraries.txt` when present. Those target-dependent text snapshots are not bundled or needed for the hash-locked eleven-file selection.

## Historical patches, scripts and revision reports

Each original target below maps to the final delta, authored implementation or public explanation. The complete [r12.patch](../patches/r12.patch) supersedes intermediate patch application, and [reconstruct.py](../scripts/reconstruct.py) supersedes staged build edits. Intermediate files themselves are not published.

| Original target | Current public reference |
| --- | --- |
| `identity.patch` | [r12.patch](../patches/r12.patch), [identity findings](TECHNICAL_FINDINGS.md#apk-identity-and-rebuild-notes) |
| `patch_identity.py` | [reconstruct.py](../scripts/reconstruct.py), [BUILD.md](BUILD.md) |
| `r2-process-fix.patch` | [r12.patch](../patches/r12.patch), final `:ufs` declaration |
| `R2-DEBUG-REPORT.md` | [Identity/process findings](TECHNICAL_FINDINGS.md#apk-identity-and-rebuild-notes) |
| `integrate_r3_native.py` | [extract.py](../scripts/extract.py), [reconstruct.py](../scripts/reconstruct.py), [native lock](../provenance/native-libraries.json) |
| `ufs-service-lookup.patch` | [r12.patch](../patches/r12.patch), [service findings](TECHNICAL_FINDINGS.md#native-libraries-and-services) |
| `R4-PORT-REPORT.md` | [Native findings](TECHNICAL_FINDINGS.md#native-libraries-and-services), [EXTRACTION.md](EXTRACTION.md) |
| `r5-ufs-client.patch` | [r12.patch](../patches/r12.patch), final Context-and-Binder wrapper signature |
| `R5-STOCK-BRIDGE-REPORT.md` | [Full protocol reference](THIRD_PARTY_PROCESSING.md#reference-old-factory-session-protocol), [wire map](BUILD.md#binder-wire-map) |
| `r6-gesture-fallback.patch` | [r12.patch](../patches/r12.patch), `GestureRecognizer` delta |
| `r8-public-imagewriter.patch` | [r12.patch](../patches/r12.patch), [PublicImageWriter.java](../src/java/com/anx/camera/bridge/PublicImageWriter.java) |
| `R9-METADATA-REPORT.md` | [Metadata integration](THIRD_PARTY_PROCESSING.md#4-serialize-metadata-into-buffers), [MetadataCompatibility.java](../src/java/com/anx/camera/bridge/MetadataCompatibility.java), [upstream lock](../provenance/hiddenapibypass.json) |
| `R10-URI-REPORT.md` | [Output ownership](THIRD_PARTY_PROCESSING.md#6-keep-output-ownership-in-your-app), original grant still failed pending-owner enforcement |
| `R11-OWNER-OUTPUT-REPORT.md` | [Output ownership](THIRD_PARTY_PROCESSING.md#6-keep-output-ownership-in-your-app), [PhotoOutputProvider.java](../src/java/com/anx/camera/bridge/PhotoOutputProvider.java) |
| `R12-GALLERY-ID-REPORT.md` | [Output ownership](THIRD_PARTY_PROCESSING.md#6-keep-output-ownership-in-your-app), numeric suffix fix |
| `DEVICE-VERIFICATION.md` | [DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md), sanitized measured record |
| `TECHNICAL_FINDINGS.md` | [TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md), public adaptation |
| `README.md` | [FILE_MAP.md](FILE_MAP.md) for kit navigation, [findings](TECHNICAL_FINDINGS.md) for technical history |

Original reconstruction text also named these unlinked utilities:

| Original utility | Current reproduction |
| --- | --- |
| `prepare_bridge_sources.py` | `reconstruct.py` selective decompile, package relocation and compiler steps |
| `install_hiddenapi_smali.py` | `reconstruct.py` hash-pinned AAR regeneration and installation |
| `verify_apk.py` | Published [verify_apk.py](../scripts/verify_apk.py) has explicit input flags and a narrower documented scope |
| `verify_bridge_layout.py` | [CodecInstrumentation.java](../src/java/com/anx/camera/bridge/CodecInstrumentation.java) for real Android readers, decoded-tree checks for exact reconstruction |
| `verify_gesture_fallback.py` | Final patch before/after hashes and complete decoded-tree verification |
| `verify_r12_delta.py` | Complete delta/tree checks and optional packaged r12 payload comparison, not an r11-to-r12 comparison |

Historical verification scripts and local revision APK sets are not needed by the clean pipeline. Do not assume a renamed historical script has the same CLI as its published replacement. Use [BUILD.md](BUILD.md) for actual commands.

## Independent probes

The two linked status-probe targets, `ProbeActivity.java` in the UFS access-probe project and `Stock-UFS-Access-Probe-r1-signed.apk`, are not published. The [inline StatusActivity tutorial](THIRD_PARTY_PROCESSING.md#tutorial-prove-that-your-app-can-connect) reproduces binding and the old read RPC with public APIs. It does not recreate the exact probe's timeout/persisted-report code or original signed APK.

The separate concurrent-camera `probe/` project referenced in the original findings is also absent. [TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md#live-concurrent-camera-result) retains its camera IDs, open-before-configure barrier, stream configuration, timing/sample checks and observed result. An independent probe can repeat that experiment. No kit command currently rebuilds the original probe artifacts.

The r12 [CodecInstrumentation.java](../src/java/com/anx/camera/bridge/CodecInstrumentation.java) is published and rebuilt as part of the port. It tests parcel/metadata/output behavior, not the original standalone access or concurrent-stream probe programs.

## Release artifact and evidence boundary

The original guide's signed r12 filename is `Nothing-Camera-Beta-Port-17.0.00.71.00-r12-galleryid-signed.apk`. [inputs.json](../provenance/inputs.json) records its SHA-256 `00dd9b077e604fc1482f84085169661bd5849f8373d760672a2f683003ef83ac`. A release asset obtained separately can be supplied to `verify_apk.py --reference`. These docs do not assert that an asset has already been uploaded or that a public repository/release URL exists.

[DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md) retains measured media IDs, sizes, dimensions and durations. It omits personal media names, files, location values and raw device logs. The measurements cannot recreate original image/video content. Host reconstruction evidence is [validation.json](../provenance/validation.json); it does not constitute new device testing.

## Coverage and remaining technical gaps

The 65 distinct linked targets are covered by two independent-probe entries, 23 explicitly linked OEM Java references, six custom-metadata smali references, four integration smali references, five authored helpers, one decoded-tree reference, five native-audit references, one upstream provenance reference, sixteen historical patch/script/report entries and two root-document entries. Additional unlinked old/new classes and utility names are listed above so inspection does not depend on unpublished workspace paths.

Full OEM interfaces/models are generated locally, not published wholesale as code. Native metadata ABI and independent capture-decision/frontend implementation remain incomplete specifications. Historical raw reports, full dependency graph and probe binaries cannot be reproduced byte-for-byte by this kit. Request/grant cleanup and unrepresented NOS 5 semantics need further work. Host payload equality is verified; regenerated-APK device tests, target-pull execution during preparation and Linux execution remain unperformed. See [FILE_MAP.md](FILE_MAP.md#remaining-checks).
