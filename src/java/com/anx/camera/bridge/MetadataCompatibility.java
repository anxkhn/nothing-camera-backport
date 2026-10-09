package com.anx.camera.bridge;

import android.hardware.camera2.CaptureRequest;
import android.hardware.camera2.CaptureResult;
import android.util.Log;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import org.lsposed.hiddenapibypass.HiddenApiBypass;

public final class MetadataCompatibility {
    private static boolean attempted;
    private static boolean enabled;

    public static synchronized void initialize() {
        if (attempted) return;
        attempted = true;
        try {
            enabled = HiddenApiBypass.addHiddenApiExemptions(
                    "Landroid/hardware/camera2/impl/CameraMetadataNative;",
                    "Landroid/hardware/camera2/CaptureResult;",
                    "Landroid/hardware/camera2/CaptureRequest;");
            Log.i("MetadataCompatibility", "Exact camera metadata exemptions installed=" + enabled);
        } catch (RuntimeException | LinkageError error) {
            Log.e("MetadataCompatibility", "Camera metadata compatibility initialization failed", error);
        }
    }

    public static void verifyMetadata() throws Exception {
        initialize();
        if (!enabled) throw new IllegalStateException("Metadata exemptions not installed");
        Class<?> type = Class.forName("android.hardware.camera2.impl.CameraMetadataNative");
        Field results = CaptureResult.class.getDeclaredField("mResults");
        results.setAccessible(true);
        Method set = type.getMethod("set", CaptureRequest.Key.class, Object.class);
        Method pointer = type.getMethod("getMetadataPtr");
        Method count = type.getMethod("getEntryCount");
        Method empty = type.getMethod("isEmpty");
        Method close = type.getDeclaredMethod("close");
        set.setAccessible(true);
        pointer.setAccessible(true);
        count.setAccessible(true);
        empty.setAccessible(true);
        close.setAccessible(true);
        Object metadata = type.getDeclaredConstructor().newInstance();
        try {
            set.invoke(metadata, CaptureRequest.JPEG_ORIENTATION, 90);
            long address = (Long) pointer.invoke(metadata);
            int entries = (Integer) count.invoke(metadata);
            if (address == 0 || entries < 1 || (Boolean) empty.invoke(metadata)) {
                throw new AssertionError("Native metadata pointer or entries invalid");
            }
            Log.i("MetadataCompatibility", "PASS: exact methods accessible, real native pointer nonzero, entries=" + entries);
        } finally { close.invoke(metadata); }
    }
}
