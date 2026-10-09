# How to use Nothing Camera processing from a third-party Android app

This guide describes the factory Camera processing service successfully used from a separately signed application on a Nothing Phone 3a. It includes a connection tutorial, the extracted Binder protocol, the working photo-processing flow and reproducible inspection references.

The connection works on the tested firmware without root or a platform signing key. Full processing requires more than binding. The working r12 port preserves Nothing's capture frontend, metadata serializer, JNI code and device configuration. An arbitrary JPEG or CameraX image cannot be assumed to satisfy those requirements.

Run repository commands from the root containing `scripts/`, `src/`, `patches/` and `provenance/`. In the preparation workspace, that root is `publication/`. [BUILD.md](BUILD.md) and [EXTRACTION.md](EXTRACTION.md) describe the current source-kit pipeline. [REFERENCE_FILES.md](REFERENCE_FILES.md) maps all 77 local-link occurrences in the original guide, including references to OEM code recreated locally rather than published as full source.

## Verified scope

| Component | Verified value |
| --- | --- |
| Device | Nothing Phone 3a, A059, AsteroidsIND |
| OS | Nothing OS B4.1-260810-1153, Android 16, API 36 |
| Factory Camera | `com.nothing.camera`, 16.0.01.27.00 |
| Factory APK path | `/system_ext/priv-app/NTCamera/NTCamera.apk` |
| Port frontend | Nothing Camera 17.0.00.71.00 from NOS 5 beta |
| Separate client package | `com.anx.camera.experimental` |
| Factory service class | `com.nothing.algolib.cameraufs.UFSService` |
| Session descriptor | `com.nothing.algolib.cameraufs.INtCamUfsSession` |

Two results were independently verified:

1. A small ordinary app bound to the factory service and executed the status RPC without camera permissions, callback registration or native libraries.
2. The stock-derived port submitted real capture buffers and metadata through an adapter, received processing results and published full rear and front JPEGs.

These results establish an integration path on this specific build. They do not establish a supported public Nothing SDK or compatibility with other models and updates. Version-gate the integration and rerun tests after a factory Camera or OS update. [DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md) records the r12 device measurements. [inputs.json](../provenance/inputs.json) locks the beta, factory and tested release APK hashes.

## What service does the app connect to?

```text
Third-party app
  |
  | explicit Android bindService
  v
Factory com.nothing.camera / UFSService
  |
  | factory app's Binder and SELinux identity
  v
vendor.noth.hardware.camera.INtCamService/default
  |
  v
Firmware-native camera processing
```

The exported Android service is the entry point. The factory process owns its native camera session and calls the protected firmware service.

Direct lookup from the renamed port failed with this diagnostic excerpt:

```text
avc: denied { find }
name=vendor.noth.hardware.camera.INtCamService/default
scontext=u:r:untrusted_app:...
tcontext=u:object_r:vendor_hal_noth_camera_service:s0
tclass=service_manager
```

Changing an application ID, declaring `SYSTEM_CAMERA` or bundling another native library does not grant this SELinux access. The working integration uses normal Android binding to the exported factory service.

The inspected factory service is enabled and exported, with no binding permission declared on it or its application. Its inspected `onBind`, session Stub and manager contain no caller UID/signature check. That observation applies to the extracted version. Recreate those sources and the factory manifest using the [reference inventory](REFERENCE_FILES.md#factory-and-beta-protocol-sources).

The old manifest names the service process `com.camera.ufs.service`. Let Android start it through `bindService`. A client does not need to reproduce that process name or declare a copy of the factory service.

## Tutorial: prove that your app can connect

This tutorial executes one read RPC. It does not acquire a camera or process a photo. Use an Android app project compiling against API 36 and a phone with the verified factory version. The status example requires no OEM classes or native libraries.

### Step 1: declare package visibility and the test activity

The `queries` element belongs directly inside `manifest`; the activity belongs inside `application`.

```xml
<queries>
    <package android:name="com.nothing.camera" />
</queries>

<application>
    <activity
        android:name="com.example.nothingbridge.StatusActivity"
        android:exported="true" />
</application>
```

Merge these into the existing elements. The example does not need `CAMERA` permission. An eventual capture UI needs normal camera permission and permissions required by its own capture functions.

### Step 2: add the connection activity

This example targets the old protocol below using public Android APIs for binding and the status query. It assumes factory Camera `16.0.01.27.00` has already been established as the installed version.

```java
package com.example.nothingbridge;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import android.widget.TextView;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class StatusActivity extends Activity {
    private static final String DESCRIPTOR =
            "com.nothing.algolib.cameraufs.INtCamUfsSession";
    private final ExecutorService worker = Executors.newSingleThreadExecutor();
    private TextView output;
    private boolean bindingAccepted;
    private volatile boolean destroyed;

    private final ServiceConnection connection = new ServiceConnection() {
        @Override public void onServiceConnected(ComponentName name, IBinder service) {
            worker.execute(() -> {
                try {
                    show("Connected. Tracked requests: " + queryTrackedRequests(service));
                } catch (Exception error) {
                    show("Query failed: " + error);
                }
            });
        }
        @Override public void onServiceDisconnected(ComponentName name) {
            show("Service disconnected");
        }
        @Override public void onNullBinding(ComponentName name) {
            show("Service returned a null Binder");
        }
        @Override public void onBindingDied(ComponentName name) {
            show("Binding died. Close this activity and retry.");
        }
    };

    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        output = new TextView(this);
        output.setText("Connecting to factory Camera...");
        setContentView(output);
        Intent intent = new Intent().setComponent(new ComponentName(
                "com.nothing.camera", "com.nothing.algolib.cameraufs.UFSService"));
        try {
            bindingAccepted = bindService(intent, connection, Context.BIND_AUTO_CREATE);
            if (!bindingAccepted) show("bindService returned false");
        } catch (RuntimeException error) {
            show("Binding failed: " + error);
        }
    }

    private static int queryTrackedRequests(IBinder service) throws RemoteException {
        if (!DESCRIPTOR.equals(service.getInterfaceDescriptor())) {
            throw new RemoteException("Unexpected session descriptor");
        }
        Parcel request = Parcel.obtain();
        Parcel response = Parcel.obtain();
        try {
            request.writeInterfaceToken(DESCRIPTOR);
            if (!service.transact(12, request, response, 0)) {
                throw new RemoteException("Old status transaction was not handled");
            }
            response.readException();
            int count = response.readInt();
            if (response.dataAvail() != 0) {
                throw new RemoteException("Unexpected status response payload");
            }
            return count;
        } finally {
            response.recycle();
            request.recycle();
        }
    }

    private void show(String message) {
        runOnUiThread(() -> {
            if (!destroyed) output.setText(message);
        });
    }

    @Override public void onDestroy() {
        destroyed = true;
        if (bindingAccepted) unbindService(connection);
        worker.shutdownNow();
        super.onDestroy();
    }
}
```

Binder is Android's cross-process message mechanism. The returned object is a remote `IBinder`, not an instance of your app's service class. Do not cast it to a `LocalBinder`.

The example keeps its binding until destruction, matching the historical access probe. Factory `onUnbind` calls `onClientDied`, so ending even a read-only binding has lifecycle effects. Test with no competing photo-processing client. Shutting down the executor does not cancel a blocking Binder transaction.

### Step 3: launch and check the result

Build and install the app, then launch:

```sh
adb shell am start -W -n com.example.nothingbridge/.StatusActivity
```

Replace the component package with the actual application ID if it differs from the Java package. On the tested idle phone, the equivalent historical probe returned:

```text
BIND_RESULT: true
DESCRIPTOR: com.nothing.algolib.cameraufs.INtCamUfsSession
TRANSACTION_12_HANDLED: true
PROCESSING_NUMBER: 0
PASS: normal app binding and stock UFS read RPC succeeded
```

The historical probe had a ten-second UI timeout and persisted results. Its exact source/APK are not published in this kit; the [probe inventory](REFERENCE_FILES.md#independent-probes) distinguishes that artifact from this inline example.

### What you built

You built a service-access check. A successful status query is not a photo-processing test. Continue with the protocol reference and capture integration below only after matching the backend version.

## Reference: old factory session protocol

The source of truth is the factory `INtCamUfsSession` extracted from the hash-locked NOS 4.1 APK. [REFERENCE_FILES.md](REFERENCE_FILES.md#factory-and-beta-protocol-sources) gives its qualified class name and a selective JADX command. Every request starts with the exact interface token. These session calls use synchronous transact flags `0`; replies begin with the exception marker read by `Parcel.readException`.

| Old transaction | Method | Arguments after interface token | Result after exception marker |
| --- | --- | --- | --- |
| 1 | registerCallback | Callback Binder | No payload |
| 2 | setParameters | String params | No payload |
| 3 | addBorderWatermark | Typed ParcelFileDescriptor, int width, int height, long reqNumber | No payload |
| 4 | addMetaData | Typed NtCamUfsBuffer array, long reqNumber | No payload |
| 5 | saveImage | long reqNumber, typed NtCamUfsImage | int boolean |
| 6 | processImgRequest | Typed NtCamUfsRequest, typed input-image array, typed output-image array | No payload |
| 7 | deleteCancelData | long requestNum | No payload |
| 8 | closeSession | None | No payload |
| 9 | canDoCapture | int mode | int boolean |
| 10 | updateRequestPriority | long requestNum | No payload |
| 11 | setCameraAppStatus | String status | No payload |
| 12 | getProcessingNumber | None | int count |

Old `getProcessingNumber` returns tracked request-map size. A count of one does not prove native processing is active. The tracked bin may still be collecting frames or waiting for metadata.

In the successful r12 flow, `saveImage` returned false for RAW frames and the frontend retained them for the subsequent direct processing request. A false return therefore does not necessarily mean capture failed. A true return can mean asynchronous save work was queued, not that a final JPEG exists.

### Callback protocol

Descriptor is `com.nothing.algolib.cameraufs.INtCamUfsCallback`.

| Transaction | Arguments | Flags |
| --- | --- | --- |
| 1, processResult | Typed NtCamUfsResult, typed INtCamJpeg | IBinder.FLAG_ONEWAY, no reply |
| 2, onNCFBinderDied | None | IBinder.FLAG_ONEWAY, no reply |

Keep callback work short. Move result handling to a worker and retain received handles that worker requires. Do not close shared memory or file handles while another task reads them.

Factory `INtCamUfsCallback`, `NtCamUfsResult`, `INtCamJpeg`, `UFSManager` and `UfsManagerTool` define the wire format and message handling. The tested capture returned message 3 before message 1. Do not label every message as final output. Extract those classes using the [inventory](REFERENCE_FILES.md#factory-and-beta-protocol-sources).

Both payloads carry an AIDL-style size prefix. Field order is:

```text
NtCamUfsResult:
    long reqNumber
    int message
    int status
    String photoUri

INtCamJpeg:
    typed android.os.SharedMemory jpegMemory
    long timestamp
    int width
    int height
```

`INtCamJpeg` is a Parcelable despite its interface-like name. Its `SharedMemory` is a transferable resource, not a byte array automatically copied into the callback. Its `describeContents` propagates the contained resource flag.

### Parcel serialization rules

Objects use an AIDL-style size prefix including the prefix's own four bytes. Typed objects have a separate presence marker. Arrays preserve length, element presence and null-array markers.

Emit presence `0` for null or `1` for non-null. For a non-null object, record its start, write a placeholder size and fields, then seek back to store the size and restore the end position. The tested encoders are `writeOldImage` and `writeOldRequest` in [Nos41UfsBridge.java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java).

Old image fields, in order:

```text
int format
int width
int height
int transform
int scalingMode
long timestamp
int planeCount
int boolean slaverImage
typed Rect crop
typed HardwareBuffer buffer
typed ParcelFileDescriptor fence
```

Old request fields, in order:

```text
long reqNumber
int operationMode
int logicalCameraId
byte[] settings
NtCamUfsBuffer[] inputBuffers
NtCamUfsBuffer[] outputBuffers
Uri uri
String desc
double latitude
double longitude
String cameraId
int flashMode
float focalLength
int awbMode
long exposureTimeUs
float lensAperture
int postRawSensitivityBoost
int iso
int ev
int stepDenominator
int stepNumerator
float focus
int efl35
float overrideEv
int overrideIso
String makerNote
long clickTimestamps
int boolean isBrust
int boolean isPreCapture
int boolean isUltraHdrOn
int boolean isBorderWatermarkOn
int boolean isLivePhoto
int boolean isSupportUfs
int boolean isUfsSave
```

The old spelling is `isBrust`. The modern class uses `isBurst`; the adapter writes it into the old field's position. Do not change JNI-facing names to correct spelling. Latitude and longitude above are protocol field names, not captured location values.

`NtCamUfsBuffer` fields, in order:

```text
int format, width, height, phyCameraId, tuningSize
long yBufAddr, uBufAddr, vBufAddr
int[] strides
typed NtCamUfsHandle buffer
```

`NtCamUfsHandle` contains a typed `ParcelFileDescriptor` array, then an int array. Factory readers define size validation and descriptor handling. Four relocated readers regenerate under `.work/r12/old/` for device instrumentation, as described in [BUILD.md](BUILD.md).

Process-local native addresses are not remotely usable pointers. The client uses local metadata access to serialize metadata into shared storage before sending buffer handles. Do not send a `CaptureResult` pointer instead of serialized metadata. No meaning is inferred here from raw pointer bytes.

### Custom settings byte-array structure

Request `settings` is a separate binary format, not a Parcel, JSON object or dump of a `CaptureResult`. The beta `NtCamCustomMetadata` constructor sets `entrySize=16`; `calculateHeaderSize` returns 28; `serializeCustomMetadata` explicitly uses little-endian byte order. Recreate its executable smali at `.work/r12/decoded/smali_classes4/com/nothing/algolib/offlineproc/` through [reconstruction](BUILD.md). The [metadata inventory](REFERENCE_FILES.md#custom-metadata-serializer) lists every associated class.

| Byte offset | int32 field | Meaning in the serializer |
| --- | --- | --- |
| 0 | size | Total serialized length |
| 4 | entryCount | Number of entries |
| 8 | entrySize | 16 |
| 12 | entriesStart | 28 |
| 16 | dataCount | Number of used data bytes |
| 20 | dataCapacity | Internal data-buffer capacity, which can exceed dataCount |
| 24 | dataStart | 28 + entryCount × 16 |

Each 16-byte entry contains four little-endian int32 values:

```text
offset +0: type ordinal
offset +4: tagId
offset +8: dataCount, byte count for this entry
offset +12: dataOffset, relative to the start of the data region
```

The serialized tail contains only used bytes. Total length is `28 + 16 * entryCount + dataCount`, excluding unused `dataCapacity` bytes.

| Type enum | Ordinal | Scalar width |
| --- | --- | --- |
| BYTE | 0 | 1 byte |
| INT32 | 1 | 4 bytes |
| INT64 | 2 | 8 bytes |
| FLOAT | 3 | 4 bytes |
| DOUBLE | 4 | 8 bytes |
| RATIONAL | 5 | 8 bytes, numerator/denominator pair |
| STRING | 6 | Inspect serializer encoding |
| UNKNOWN | 7 | Inspect serializer handling |

Array count is represented through serialized payload length. Check `putDataIntoBuffer` and `getSizeForType` for supported Java value classes and string encoding. `CaptureRequest` keys map to numeric tag IDs and types in the static initializer. Reconstruct that version's map; do not assign arbitrary tag IDs. `MetadataTags`, `NtCamMetadataHeader`, `NtCamMetadataEntry` and `Rational` define associated structures.

This format differs from native metadata bytes stored in the shared metadata image by `OfflineProcServer.nativeSetHWBufferMetadata`. OEM JNI serialization remains the reference for that second format. This project does not provide a complete independent specification of its native buffer ABI.

### NOS 5 is a different protocol

The beta retains the descriptor while changing the wire contract:

- Transaction 12 becomes `setParameters2` with a Bundle. Old transaction 12 is `getProcessingNumber`.
- Processing count moves to 13; transaction 14 adds `getAllUfsNumber`.
- Border watermark adds left/top coordinates.
- `saveImage` adds `processingOnPause`.
- The image inserts `tuningImage` before crop and buffers.
- Requests add document, direct-processing and newer watermark fields.

A descriptor match is not version negotiation. A modern generated proxy called directly on the old Binder can misread flags, handles or arguments.

The adapter accepts only the observed `ncf_jpeg_max_size` Bundle hint, logs that old sizing remains active and rejects other keys. Unknown total-UFS count returns `-1` for exit analytics. Nonzero border offsets raise `RemoteException`. Other modern-only request/image semantics have no old representation and remain unverified. [BUILD.md](BUILD.md#binder-wire-map) records the modern-to-old transaction map.

## How to integrate full photo processing

### 1. Choose the client protocol deliberately

A new app specific to this factory version can encode the old protocol directly. An app retaining beta client classes needs [Nos41UfsBridge.java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java).

This adapter imports beta `com.nothing.algolib.cameraufs` Parcelables and requires the output provider. Copying only the Java file into an unrelated app will not compile. Adapt its hardcoded authority and package assumptions too.

[r12.patch](../patches/r12.patch) shows `UFSClient` targeting the factory service, keeping `linkToDeath` on the real Binder and wrapping it before constructing the modern proxy. The photo-processing signature is `Nos41UfsBridge.wrap(Context, IBinder)`. An older Binder-only historical patch does not include the final owner-output behavior.

### 2. Register a real callback and track lifecycle

After version and descriptor validation, register a callback and establish the matched client's lifecycle state. The observed port sent:

```text
setCameraAppStatus("create")
setCameraAppStatus("resume")
setParameters("camera_pid=<actual-pid>;camera_close=0;screen_off=0;first_preview=0;camera_pause=0")
setParameters("first_preview=1")
```

These are observed/extracted messages, not a documented list of every parameter. Preserve the matched pause, resume, screen-off and close sequence. Do not invent parameters or claim another app's PID.

The factory manager has one callback slot. Factory Camera, the port and another client can replace each other's callbacks. Avoid concurrent photo processing through this service from multiple clients. A UI timeout does not cancel a blocking Binder call.

### 3. Produce matching capture inputs

Implement or retain:

- Compatible camera session and stream configuration.
- Capture decision, frame count, exposure choices and algorithm settings.
- Image buffers and capture results matched by timestamp.
- Dimensions, format, strides, physical-camera IDs, fences and native handles.
- Serialized custom settings and native camera metadata.

The successful rear capture used operation mode `0x900a`, logical camera ID 0, eight `RAW_SENSOR` frames of 4080 × 3072 and eight metadata entries. RAW row stride was 8160. These values describe one capture; they are not defaults for all cameras or algorithms.

The service does not open both cameras, construct decisions from an arbitrary bitmap or turn a finished JPEG into a stock night-mode capture. The app supplies the expected capture data.

### 4. Serialize metadata into buffers

[PublicImageWriter.java](../src/java/com/anx/camera/bridge/PublicImageWriter.java) uses `ImageWriter.Builder` with explicit dimensions, `maxImages`, format and CPU-write usage. The public builder is available from API 33.

Nothing's metadata buffer uses JPEG-format allocation as byte storage, not as a displayable JPEG. One capture's writer allocation was 8388608 × 1, while the reader's logical allocation differed. Preserve actual allocation calculations rather than photo dimensions.

The client obtains native metadata from capture results, applies request settings and calls the OEM serializer. Inspect factory `NtCameraManager.doImgRequest`, especially `nativeSetHWBufferMetadata` and `addMetaData`. If JADX reports an incomplete beta method, use executable `.work/r12/decoded/smali_classes4/com/nothing/algolib/offlineproc/NtCameraManager.smali`. See [capture/server references](REFERENCE_FILES.md#capture-and-service-implementation).

Private `CameraMetadataNative.set` and `getMetadataPtr` access was denied in the separately signed app. [MetadataCompatibility.java](../src/java/com/anx/camera/bridge/MetadataCompatibility.java) uses AndroidHiddenApiBypass 6.1 for narrow app-process exemptions covering `CameraMetadataNative`, `CaptureResult` and `CaptureRequest`. [hiddenapibypass.json](../provenance/hiddenapibypass.json) and the [license](../licenses/AndroidHiddenApiBypass-LICENSE) record provenance and attribution.

This does not grant native-service access or make private APIs stable. The status test needs no such library. Native metadata access is a separate device-tested dependency.

### 5. Submit metadata and the final request

Successful sequence:

```text
saveImage for each captured RAW frame -> false, frontend retains direct inputs
addMetaData, count 8, matching request ID
processImgRequest with request, input images and output images
closeSession
asynchronous processResult message 3
asynchronous processResult message 1
owner-side JPEG validation and publication
```

The final input-image array held eight image descriptors plus the shared metadata image. Input buffers were separate request fields. The metadata image is not an additional captured exposure.

`closeSession` belongs to the matched sequence; it does not prove asynchronous processing is finished. Retain the connection, callback and buffer ownership needed for completion. The adapter closes locally acquired translation handles after the synchronous transaction; that is distinct from the frontend's remaining ownership and the remote process's transferred resources.

### 6. Keep output ownership in your app

Your app creates a pending MediaStore photo row. Factory Camera is a different owner. Direct factory writing first failed with `RecoverableSecurityException`. Granting the original URI still failed with:

```text
Only owner is able to interact with pending/trashed item
```

The working solution keeps the row pending and delegates an app-owned proxy URI:

```text
content://<your-app>.bridgeoutput/<random-token>/<numeric-media-id>
```

[PhotoOutputProvider.java](../src/java/com/anx/camera/bridge/PhotoOutputProvider.java) persists a token-to-original-URI mapping. Declare it private with explicit URI grants:

```xml
<provider
    android:name="com.anx.camera.bridge.PhotoOutputProvider"
    android:authorities="${applicationId}.bridgeoutput"
    android:exported="false"
    android:grantUriPermissions="true" />
```

For reuse, change the hardcoded `AUTHORITY` to match the declaration. Changing the manifest alone leaves delegation and resolution inconsistent.

The owner grants the exact proxy URI to `com.nothing.camera` for read and write. The provider validates the mapping, calls `Binder.clearCallingIdentity` before its own `ContentResolver` operations and restores identity in `finally`. The MediaStore operation therefore runs as the row owner.

The r12 mapping checks `content` scheme, `media` authority and numeric ID at creation. Resolution checks the token, numeric suffix, path-segment count and absence of query/fragment. It does not independently validate the original collection or ownership at mapping creation, and it forwards supplied query/update arguments. A reused implementation should constrain those operations and validate expected owner collections. The grant-protected provider must not become an arbitrary URI-forwarding facility.

Before clearing pending, r12 requires nonzero file size and positive dimensions from `BitmapFactory` bounds decoding. It writes final size/dimensions and notifies the original row. A bounds check is not a full file-integrity test; decode actual output during validation too.

Factory Camera also notifies Nothing Gallery. Gallery parsed the proxy's last segment as a `Long`; a UUID-only path crashed it. Keep the original numeric media ID last and validate it against the token mapping. The adapter rewrites callback `photoUri` values back to the real MediaStore URI.

R12 retains mappings and grants for asynchronous completion. A production client needs request-scoped cleanup after terminal success, failure or cancellation, plus stale-map recovery. Do not revoke resources immediately after synchronous `processImgRequest` returns.

## Libraries and reusable files

| File or group | Role | Required for status test? |
| --- | --- | --- |
| Inline StatusActivity above | Explicit binding and old status RPC | Reference example |
| [Nos41UfsBridge.java](../src/java/com/anx/camera/bridge/Nos41UfsBridge.java) | Modern-to-old RPC and Parcelable translation | No |
| [PhotoOutputProvider.java](../src/java/com/anx/camera/bridge/PhotoOutputProvider.java) | Owner-side pending-photo writing/publication | No |
| [CodecInstrumentation.java](../src/java/com/anx/camera/bridge/CodecInstrumentation.java) | Device codec, metadata and output regressions | No |
| [PublicImageWriter.java](../src/java/com/anx/camera/bridge/PublicImageWriter.java) | Public metadata-buffer allocation | No |
| [MetadataCompatibility.java](../src/java/com/anx/camera/bridge/MetadataCompatibility.java) | Narrow private metadata API compatibility | No |
| [Protocol inventory](REFERENCE_FILES.md#factory-and-beta-protocol-sources) | Recreate old/new models and interfaces | No |
| [Native provenance](../provenance/native-libraries.json) | Selected ELF origins, hashes and dependencies | No |
| [Reconstruction](BUILD.md) | Recreate final decoded capture/JNI/configuration tree | No |

Do not copy an entire firmware native inventory into a new app. Identify JNI functions used, inspect `DT_NEEDED`, verify ABI and test within the app's linker namespace. Here, substituting bundled `libc++_shared.so` for `libc++.so` was invalid because required symbols differed.

Full OEM decompilations are references generated from supplied APKs, not a separately published SDK. [licenses/SCOPE.md](../licenses/SCOPE.md) records publication boundaries. Preserve JNI names in native integration. Independently implemented Binder models can follow the verified wire layout without assuming JNI class names are interchangeable.

## Reconstruction map

The public source kit replaces the historical revision-by-revision workspace with a hash-checked complete delta. Generated paths below are local outputs, not committed source or Markdown links:

```text
scripts/extract.py                           selective firmware and target extraction
scripts/reconstruct.py                       prepare/build/verify pipeline
scripts/verify_apk.py                        packaged preservation/payload comparison
patches/r12.patch                            complete original-to-r12 OEM text delta
src/java/com/anx/camera/bridge/               five authored Java helpers
src/smali/com/anx/camera/bridge/              seven exact authored smali classes
provenance/                                 input/native/tree/validation locks
licenses/                                   upstream attribution and scope
.work/inputs/NTCamera.apk                    pinned beta APK
.work/inputs/factory-camera.apk              pinned NOS 4.1 factory APK
.work/inputs/native/                         eleven selected native additions
.work/r12/decoded/                           reconstructed r12 Apktool tree
  AndroidManifest.xml                       final identity/provider/queries
  smali_classes4/com/nothing/algolib/         OEM client/capture/JNI classes
  smali_classes9/com/anx/camera/bridge/       helpers and relocated old readers
  smali_classes9/org/lsposed/                upstream compatibility classes
  lib/arm64-v8a/                            98 packaged native entries
.work/r12/stubs/                             six modern compile-only models
.work/r12/old/                               four relocated old test readers
.work/r12/stub-classes/                      compiled modern stubs
.work/r12/helper-classes/                    compiled helpers/old readers
.work/r12/helper-dex/                        helper DEX output
.work/r12/helper-disassembled/               helper disassembly staging
.work/r12/hiddenapibypass-6.1.aar             hash-checked upstream download
.work/r12/hiddenapi.jar                      classes.jar extracted from AAR
.work/r12/unsigned.apk                       assembled output
.work/r12/aligned.apk                        ZIP-aligned output
.work/references/                           optional selective JADX inspection outputs
```

Actual validation used other fresh work-directory names. `.work/r12` is the documented `--work` example; `reconstruct.py` creates these same relative outputs under whichever fresh work path you choose.

### Authored helper responsibilities

| Class | Integration point | Data it owns |
| --- | --- | --- |
| Nos41UfsBridge | UFSClient.handleServiceConnected before modern Stub.asInterface | Acquired translation handles; callback URI rewriting |
| PhotoOutputProvider | Manifest provider and final request URI delegation | Token mappings and owner-side MediaStore operations |
| PublicImageWriter | NtCameraManager.NtCamImageProvider.Factory.createWriter | Public ImageWriter construction parameters |
| MetadataCompatibility | CameraApp.attachBaseContext after superclass | One-time narrow metadata compatibility initialization |
| CodecInstrumentation | Manifest instrumentation component | Old-reader fixtures and device metadata/output checks |

Authoritative OEM integration locations in the reconstructed tree are `UFSClient.smali`, `CameraApp.smali`, `GestureRecognizer.smali` and the `NtCameraManager` family. [REFERENCE_FILES.md](REFERENCE_FILES.md#patched-smali-integration-points) lists full paths and qualified classes. DEX partitioning may differ in another APK version.

### Extracted protocol and frontend inventory

The original investigation extracted both factory and beta versions of `INtCamUfsSession`, `INtCamUfsCallback`, `NtCamUfsRequest`, `NtCamUfsImage`, `NtCamUfsBuffer`, `NtCamUfsHandle`, `NtCamUfsResult` and `INtCamJpeg`.

Factory `NtCameraManager`, `UFSManager`, `UFSService` and `UfsManagerTool` explain native session translation, file writing, message meaning, request states and lifecycle. Beta counterparts plus `NcfQcomNightNode` explain the retained capture pipeline. Device routing references include `ConfigMapAsteroids`, `ConfigMapAsteroidsPlus`, `FeatureConfig`, `DualVideoMode`, `LaunchIntentParser`, `SettingContext` and `CameraScheduler`. Their exact names and extraction origins are in [REFERENCE_FILES.md](REFERENCE_FILES.md).

JADX output can contain invalid or incomplete methods. Executable smali in the reconstructed tree remains authoritative when decompilation fails. Modern compile stubs must not replace existing OEM runtime classes in the APK.

### Exact native additions

All 87 original native entries remain unchanged. These eleven additions produce 98 total:

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
libc++.so
```

[native-libraries.json](../provenance/native-libraries.json) records every addition's hash, source and `DT_NEEDED`. The historical wider ELF graph is an inventory, not proven requirements for every mode. The final port has not resolved every optional algorithm dependency. A successful photo does not prove all panorama, HDR detection, portrait or high-resolution paths load and work.

### Revision reconstruction order

[TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md#stock-port-progression) preserves the initial-to-r12 change history and maps each stage to current public references. Apply the complete [r12.patch](../patches/r12.patch) through `reconstruct.py`; do not apply historical incremental patches over the final tree.

The pipeline compiles helpers separately and installs them in `smali_classes9`, avoiding the original classes4 method-index limit. Placing Java source beside an Apktool tree does not compile it into the APK. Upstream compatibility classes and old readers regenerate from hash-locked inputs rather than full OEM source publication.

### Prepare, build and audit r12

First obtain the inputs through [EXTRACTION.md](EXTRACTION.md), then use a fresh work directory:

```sh
uv run scripts/reconstruct.py prepare \
  --original .work/inputs/NTCamera.apk \
  --factory .work/inputs/factory-camera.apk \
  --native .work/inputs/native \
  --sdk "$ANDROID_SDK_ROOT" \
  --work .work/r12

uv run scripts/reconstruct.py build \
  --sdk "$ANDROID_SDK_ROOT" --work .work/r12

uv run scripts/reconstruct.py verify --work .work/r12

uv run scripts/verify_apk.py \
  --original .work/inputs/NTCamera.apk \
  --apk .work/r12/aligned.apk
```

Use [BUILD.md](BUILD.md#sign-with-your-own-key) for independent signing with credentials you manage locally. A new signer changes the certificate and signed APK hash. Payload equality is a separate check.

The original APK has `extractNativeLibs=false`. Keep `.so` ZIP entries uncompressed and aligned. ZIP alignment does not change ELF `PT_LOAD` alignment.

The pinned public pipeline uses Java 21, Apktool 3.0.3, JADX 1.5.6, Android API 36 and Build Tools 36.0.0. `--sdk` accepts your SDK path. Historical manual commands used Build Tools 37 in places; use the public kit's pins for its exact helper/hash checks.

`verify_apk.py` checks original assets/native hashes, selected additions, uncompressed native ZIP storage and optional reference payload equality. `reconstruct.py build` runs the ZIP alignment checks and, when signing is requested, signature verification. [patch-files.json](../provenance/patch-files.json) locks the text delta; [r12-decoded.json](../provenance/r12-decoded.json) locks the full decoded payload. Historical revision delta scripts are replaced by these current checks, not claimed to be republished.

To inspect the factory service independently:

```sh
mkdir -p .work/references
jadx --single-class com.nothing.algolib.cameraufs.UFSService \
  --single-class-output .work/references/nos41-UFSService.java \
  --no-res .work/inputs/factory-camera.apk
```

Decompiler Java is an inspection output. Preserve executable smali when a method cannot decompile and validate translated readers with real Android Parcel execution.

### What another engineer needs

For status-service recreation, provide the exact factory version, descriptor/transaction table and inline test activity/manifest. No firmware archive or native algorithms are needed.

For full stock-port recreation, obtain the pinned beta/factory APKs and eleven native additions, use the delta and authored helpers, regenerate old readers and upstream dependency, then sign and verify. [BUILD.md](BUILD.md), [EXTRACTION.md](EXTRACTION.md), [REFERENCE_FILES.md](REFERENCE_FILES.md) and provenance records specify that process.

Reconstructing an independent capture frontend also requires the OEM decision/metadata/buffer contract. This adapter does not replace that work or provide a high-level photo SDK.

## How to verify a new integration

1. Match the phone build, factory package/version, APK hash and service manifest.
2. Run the status check with no competing client. Verify binding, descriptor, old transaction 12 and reply layout.
3. Test selected readers against encoders, including null arrays/elements, booleans, size boundaries and file descriptors.
4. Verify real writer allocation, native metadata entries and serialized buffers on the device.
5. Capture a rear image with continuous local logs from before shutter through the final callback.
6. Require a published row with positive size and a valid decoded image, not a placeholder.
7. Repeat front capture, gallery return, pause/resume, cancellation and process death.
8. Test every claimed algorithm separately, including bright/dark scenes and large outputs.

Port instrumentation command:

```sh
adb shell am instrument -w \
  com.anx.camera.experimental/com.anx.camera.bridge.CodecInstrumentation
```

It passed on the tested Phone 3a. A client with a different ID needs its own component. These checks include real native metadata, HardwareBuffer/Parcel handling and invalid-JPEG pending retention. They do not emulate the full capture pipeline.

Useful tags are `Nos41UfsBridge`, `PhotoOutputProvider`, `MetadataCompatibility`, `UFSClient`, `UFSManager`, `UfsManagerTool` and `NtCameraManager`. Capture unfiltered local logs first because native-service and MediaProvider errors may use other tags. Public evidence should use selected technical measurements, as in [DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md), rather than personal media or raw device logs.

## Troubleshooting

| Symptom | Interpretation and next check |
| --- | --- |
| bindService false or SecurityException | Check visibility, enabled factory app, class, export flag and version-specific permissions. |
| Descriptor matches but reply is wrong | Check version and transaction map. Beta transaction 12 is not the old count query. |
| Native lookup denied | Bind factory Android service. Local metadata exemptions do not change SELinux. |
| Processing count stays at 1 | Inspect tracked bin, frame collection, metadata and final submission. Count is not completion. |
| RAW collected but no META_IN | Check writer creation and native metadata serialization. |
| META_IN but no process RPC | Check request IDs, input counts, settings and client exceptions. |
| Native result but JPEG stays pending | Check owner provider delegation. A raw pending-URI grant was insufficient. |
| Gallery NumberFormatException | Proxy must end with the original numeric ID. |
| Results reach another client | Single callback slot; stop competing clients and reconnect. |
| Buffer/handle leaks | Trace terminal cleanup, acquired PFDs/HardwareBuffers, grants and mappings. |

## What this does not establish

Installing the port does not give another app a high-level photo API or access to its private output provider without a per-URI grant. The demonstrated processing connection is directly to factory Camera.

UFS handles the tested offline photo pipeline. Dual-view uses the beta frontend's camera capture, composition and recording implementation. Binding UFS does not create a dual-view recorder. Public concurrency results and actual saved-video checks are in [TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md) and [DEVICE_VERIFICATION.md](DEVICE_VERIFICATION.md).

The native backend remains NOS 4.1. Successful binding or capture does not establish new NOS 5 document/tuning/watermark semantics or firmware algorithm improvements. [REFERENCE_FILES.md](REFERENCE_FILES.md) lists reference-reproduction gaps; [validation.json](../provenance/validation.json) separates host reconstruction from earlier device evidence.

## Android documentation

- [Bound services and ServiceConnection](https://developer.android.com/guide/components/bound-services).
- [Package visibility queries](https://developer.android.com/guide/topics/manifest/queries-element).
- [Shared media and pending items](https://developer.android.com/training/data-storage/shared/media).
- [Context.grantUriPermission](https://developer.android.com/reference/android/content/Context#grantUriPermission(java.lang.String,android.net.Uri,int)).
- [Binder.clearCallingIdentity](https://developer.android.com/reference/android/os/Binder#clearCallingIdentity()).

For source-kit navigation, see [FILE_MAP.md](FILE_MAP.md). For findings, see [TECHNICAL_FINDINGS.md](TECHNICAL_FINDINGS.md).
