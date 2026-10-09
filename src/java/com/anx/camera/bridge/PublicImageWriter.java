package com.anx.camera.bridge;

import android.hardware.HardwareBuffer;
import android.media.ImageWriter;
import android.view.Surface;

public final class PublicImageWriter {
    public static ImageWriter create(Surface surface, int maxImages, int format, int width, int height) {
        return new ImageWriter.Builder(surface)
                .setMaxImages(maxImages)
                .setImageFormat(format)
                .setWidthAndHeight(width, height)
                .setUsage(HardwareBuffer.USAGE_CPU_WRITE_OFTEN)
                .build();
    }
}
