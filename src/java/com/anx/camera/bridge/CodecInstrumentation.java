package com.anx.camera.bridge;

import android.app.Instrumentation;
import android.graphics.Rect;
import android.hardware.HardwareBuffer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import com.nothing.algolib.cameraufs.NtCamUfsImage;
import com.nothing.algolib.cameraufs.NtCamUfsRequest;

public final class CodecInstrumentation extends Instrumentation {
    @Override public void onCreate(Bundle arguments) { start(); }

    @Override public void onStart() {
        Bundle result = new Bundle();
        try {
            testRequestFlags();
            testImages();
            testRpcMapping();
            testMetadataWriter();
            MetadataCompatibility.verifyMetadata();
            testPhotoUriGrant();
            testOwnerPublication();
            result.putString("stream", "PASS: old reader request flags/metadata, null arrays, HardwareBuffer/fence/crop, RPC remap, unsupported optional methods, public metadata writer allocation/dequeue, real native metadata set/pointer/entry-count, owner MediaStore URI grant to factory UID, invalid JPEG stays pending and valid JPEG publishes via owner provider\n");
            finish(-1, result);
        } catch (Throwable error) {
            result.putString("stream", "FAIL: " + android.util.Log.getStackTraceString(error));
            finish(0, result);
        }
    }

    private static void check(boolean value, String label) {
        if (!value) throw new AssertionError(label);
    }

    private void testPhotoUriGrant() throws Exception {
        android.content.Context context = getTargetContext();
        android.content.ContentValues values = new android.content.ContentValues();
        values.put(android.provider.MediaStore.Images.Media.DISPLAY_NAME, "bridge-uri-grant-test.jpg");
        values.put(android.provider.MediaStore.Images.Media.MIME_TYPE, "image/jpeg");
        values.put(android.provider.MediaStore.Images.Media.IS_PENDING, 1);
        Uri uri = context.getContentResolver().insert(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        check(uri != null, "Temporary owner MediaStore row");
        int modes = android.content.Intent.FLAG_GRANT_READ_URI_PERMISSION | android.content.Intent.FLAG_GRANT_WRITE_URI_PERMISSION;
        try {
            int uid = context.getPackageManager().getApplicationInfo("com.nothing.camera", 0).uid;
            context.grantUriPermission("com.nothing.camera", uri, modes);
            check(context.checkUriPermission(uri, -1, uid, modes) == android.content.pm.PackageManager.PERMISSION_GRANTED,
                    "Factory UID has scoped read/write grant");
        } finally {
            context.revokeUriPermission("com.nothing.camera", uri, modes);
            context.getContentResolver().delete(uri, null, null);
        }
    }

    private void testOwnerPublication() throws Exception {
        android.content.Context context = getTargetContext();
        android.content.ContentValues values = new android.content.ContentValues();
        values.put("_display_name", "bridge-owner-publication-test.jpg");
        values.put("mime_type", "image/jpeg");
        values.put("is_pending", 1);
        Uri original = context.getContentResolver().insert(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        check(original != null, "Temporary pending owner row");
        Uri proxy = PhotoOutputProvider.delegate(context, original);
        Uri independent = PhotoOutputProvider.delegate(context, Uri.parse("content://media/external/images/media/1000581837"));
        check(android.content.ContentUris.parseId(proxy) == android.content.ContentUris.parseId(original), "Numeric proxy photo ID");
        check(android.content.ContentUris.parseId(independent) == 1000581837L, "Independent numeric proxy ID");
        check(!proxy.getPathSegments().get(0).equals(independent.getPathSegments().get(0)), "Independent opaque tokens");
        try {
            PhotoOutputProvider.resolve(context, proxy.buildUpon().path("/" + proxy.getPathSegments().get(0) + "/0").build());
            throw new AssertionError("Mismatched token/photo ID accepted");
        } catch (IllegalArgumentException expected) { }
        android.graphics.Bitmap bitmap = android.graphics.Bitmap.createBitmap(16, 12, android.graphics.Bitmap.Config.ARGB_8888);
        try {
            try (java.io.OutputStream stream = context.getContentResolver().openOutputStream(proxy, "w")) {
                stream.write(new byte[]{1, 2, 3});
            }
            android.content.ContentValues publish = new android.content.ContentValues();
            publish.put("is_pending", 0);
            try {
                context.getContentResolver().update(proxy, publish, null, null);
                throw new AssertionError("Invalid JPEG published");
            } catch (IllegalStateException expected) { }
            try (android.database.Cursor cursor = context.getContentResolver().query(original, new String[]{"is_pending"}, null, null, null)) {
                check(cursor.moveToFirst() && cursor.getInt(0) == 1, "Invalid output remains pending");
            }
            try (java.io.OutputStream stream = context.getContentResolver().openOutputStream(proxy, "wt")) {
                check(bitmap.compress(android.graphics.Bitmap.CompressFormat.JPEG, 90, stream), "Test JPEG encoding");
            }
            check(context.getContentResolver().update(proxy, publish, null, null) == 1, "Owner publish update");
            try (android.database.Cursor cursor = context.getContentResolver().query(original, new String[]{"is_pending", "width", "height", "_size"}, null, null, null)) {
                check(cursor.moveToFirst() && cursor.getInt(0) == 0 && cursor.getInt(1) == 16
                        && cursor.getInt(2) == 12 && cursor.getLong(3) > 0, "Published JPEG metadata");
            }
        } finally {
            bitmap.recycle();
            context.getContentResolver().delete(original, null, null);
            context.getSharedPreferences("bridge_outputs", 0).edit().remove(proxy.getPathSegments().get(0))
                    .remove(independent.getPathSegments().get(0)).commit();
        }
    }

    private static void testMetadataWriter() {
        android.media.ImageReader reader = android.media.ImageReader.newInstance(
                1048576, 8, android.graphics.ImageFormat.JPEG, 30, HardwareBuffer.USAGE_CPU_READ_RARELY);
        android.media.ImageWriter writer = null;
        android.media.Image image = null;
        try {
            writer = PublicImageWriter.create(reader.getSurface(), 30, android.graphics.ImageFormat.JPEG, 8388608, 1);
            check(writer.getWidth() == 8388608 && writer.getHeight() == 1 && writer.getMaxImages() == 30
                    && writer.getFormat() == android.graphics.ImageFormat.JPEG
                    && writer.getUsage() == HardwareBuffer.USAGE_CPU_WRITE_OFTEN, "Metadata writer arguments");
            image = writer.dequeueInputImage();
            check(image.getPlanes().length == 1 && image.getPlanes()[0].getBuffer().remaining() >= 8388608,
                    "Metadata buffer capacity");
            image.getPlanes()[0].getBuffer().put(0, (byte) 0x5a);
            check(image.getPlanes()[0].getBuffer().get(0) == (byte) 0x5a, "Metadata buffer writable");
        } finally {
            if (image != null) image.close();
            if (writer != null) writer.close();
            reader.close();
        }
    }

    private static void testRequestFlags() {
        for (int flags = 0; flags < 512; flags++) {
            NtCamUfsRequest modern = new NtCamUfsRequest();
            modern.reqNumber = 0x123456789L;
            modern.operationMode = 61444;
            modern.logicalCameraId = 0;
            modern.settings = new byte[]{1, 2, 3};
            modern.uri = Uri.parse("content://media/external/images/media/123");
            modern.desc = "bridge-metadata";
            modern.latitude = 12.3;
            modern.longitude = -45.6;
            modern.cameraId = "0";
            modern.iso = 400;
            modern.ev = -2;
            modern.exposureTimeUs = 12345;
            modern.makerNote = "maker-note";
            modern.isBurst = (flags & 1) != 0;
            modern.isPreCapture = (flags & 2) != 0;
            modern.isUltraHdrOn = (flags & 4) != 0;
            modern.isBorderWatermarkOn = (flags & 8) != 0;
            modern.isLivePhoto = (flags & 16) != 0;
            modern.isSupportUfs = (flags & 32) != 0;
            modern.isUfsSave = (flags & 64) != 0;
            modern.isDocDetectionOn = (flags & 128) != 0;
            modern.isDirectProcess = (flags & 256) != 0;
            Parcel parcel = Parcel.obtain();
            try {
                Nos41UfsBridge.writeOldRequest(parcel, modern);
                parcel.setDataPosition(0);
                com.anx.camera.bridge.old.NtCamUfsRequest old = parcel.readTypedObject(com.anx.camera.bridge.old.NtCamUfsRequest.CREATOR);
                check(parcel.dataAvail() == 0, "Request parcel boundary");
                check(old.reqNumber == modern.reqNumber && old.operationMode == modern.operationMode, "Request IDs");
                check(java.util.Arrays.equals(old.settings, modern.settings) && old.uri.equals(modern.uri), "Request payload/URI");
                check(old.latitude == modern.latitude && old.longitude == modern.longitude && old.iso == 400
                        && old.ev == -2 && old.exposureTimeUs == 12345 && old.makerNote.equals(modern.makerNote), "Capture metadata");
                check(old.isBrust == modern.isBurst && old.isPreCapture == modern.isPreCapture
                        && old.isUltraHdrOn == modern.isUltraHdrOn && old.isBorderWatermarkOn == modern.isBorderWatermarkOn
                        && old.isLivePhoto == modern.isLivePhoto && old.isSupportUfs == modern.isSupportUfs
                        && old.isUfsSave == modern.isUfsSave, "Old boolean field sequence " + flags);
            } finally { parcel.recycle(); }
        }
    }

    private static void testImages() throws Exception {
        NtCamUfsImage image = new NtCamUfsImage();
        image.format = 35;
        image.width = 64;
        image.height = 64;
        image.timestamp = 0x123456789L;
        image.planeCount = 3;
        image.slaverImage = true;
        image.tuningImage = true;
        image.crop = new Rect(1, 2, 31, 32);
        image.buffer = HardwareBuffer.create(64, 64, HardwareBuffer.RGBA_8888, 1, HardwareBuffer.USAGE_CPU_READ_OFTEN);
        ParcelFileDescriptor[] pipe = ParcelFileDescriptor.createPipe();
        image.fence = pipe[0];
        Parcel parcel = Parcel.obtain();
        try {
            Nos41UfsBridge.writeOldImages(parcel, new NtCamUfsImage[]{null, image});
            parcel.setDataPosition(0);
            com.anx.camera.bridge.old.NtCamUfsImage[] old = parcel.createTypedArray(com.anx.camera.bridge.old.NtCamUfsImage.CREATOR);
            check(old.length == 2 && old[0] == null, "Null image element");
            check(old[1].crop.equals(image.crop) && old[1].width == 64 && old[1].slaverImage
                    && old[1].timestamp == image.timestamp && old[1].buffer.getWidth() == 64
                    && old[1].fence.getFd() >= 0 && parcel.dataAvail() == 0, "Image wire order/FDs");
            old[1].buffer.close();
            old[1].fence.close();
            parcel.setDataSize(0);
            parcel.setDataPosition(0);
            Nos41UfsBridge.writeOldImages(parcel, null);
            parcel.setDataPosition(0);
            check(parcel.createTypedArray(com.anx.camera.bridge.old.NtCamUfsImage.CREATOR) == null, "Null image array");
            parcel.setDataSize(0);
            parcel.setDataPosition(0);
            Nos41UfsBridge.writeOldRequest(parcel, null);
            parcel.setDataPosition(0);
            check(parcel.readTypedObject(com.anx.camera.bridge.old.NtCamUfsRequest.CREATOR) == null, "Null request");
        } finally {
            parcel.recycle();
            image.buffer.close();
            pipe[0].close();
            pipe[1].close();
        }
    }

    private static void testRpcMapping() throws Exception {
        final int[] calls = {0};
        android.os.Binder stock = new android.os.Binder() {
            @Override public String getInterfaceDescriptor() { return "com.nothing.algolib.cameraufs.INtCamUfsSession"; }
            @Override protected boolean onTransact(int code, Parcel data, Parcel reply, int flags) {
                data.enforceInterface(getInterfaceDescriptor());
                check(code == 12 && data.dataAvail() == 0, "Only old getProcessingNumber RPC forwarded");
                calls[0]++;
                reply.writeNoException();
                reply.writeInt(7);
                return true;
            }
        };
        android.os.IBinder bridge = Nos41UfsBridge.wrap(stock);
        for (int code : new int[]{13, 14, 12}) {
            Parcel request = Parcel.obtain();
            Parcel reply = Parcel.obtain();
            try {
                request.writeInterfaceToken("com.nothing.algolib.cameraufs.INtCamUfsSession");
                if (code == 12) {
                    Bundle sizing = new Bundle();
                    sizing.putInt("ncf_jpeg_max_size", 123456);
                    request.writeTypedObject(sizing, 0);
                }
                check(bridge.transact(code, request, reply, 0), "Adapter transaction handled");
                reply.readException();
                if (code == 13) check(reply.readInt() == 7, "Processing count remapped");
                if (code == 14) check(reply.readInt() == -1, "Total count unknown sentinel");
            } finally { request.recycle(); reply.recycle(); }
        }
        check(calls[0] == 1, "Optional methods did not call incompatible old transaction");
    }
}
