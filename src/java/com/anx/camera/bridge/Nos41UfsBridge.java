package com.anx.camera.bridge;

import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import android.os.Parcelable;
import android.os.RemoteException;
import android.util.Log;
import com.nothing.algolib.cameraufs.NtCamUfsImage;
import com.nothing.algolib.cameraufs.NtCamUfsRequest;

public final class Nos41UfsBridge extends Binder {
    private static final String TAG = "Nos41UfsBridge";
    private static final String DESCRIPTOR = "com.nothing.algolib.cameraufs.INtCamUfsSession";
    private final IBinder stock;
    private final Context context;

    private Nos41UfsBridge(Context context, IBinder stock) {
        this.context = context == null ? null : context.getApplicationContext();
        this.stock = stock;
    }

    public static IBinder wrap(IBinder stock) throws RemoteException {
        return wrap(null, stock);
    }

    public static IBinder wrap(Context context, IBinder stock) throws RemoteException {
        if (!DESCRIPTOR.equals(stock.getInterfaceDescriptor())) {
            throw new RemoteException("Unexpected stock UFS Binder descriptor");
        }
        Log.i(TAG, "Using factory NOS4.1 UFS protocol adapter");
        return new Nos41UfsBridge(context, stock);
    }

    @Override protected boolean onTransact(int code, Parcel data, Parcel reply, int flags) throws RemoteException {
        if (code == INTERFACE_TRANSACTION) {
            reply.writeString(DESCRIPTOR);
            return true;
        }
        if (code < 1 || code > 14) return super.onTransact(code, data, reply, flags);
        data.enforceInterface(DESCRIPTOR);
        Log.i(TAG, "RPC_IN modern=" + code + " bytes=" + data.dataAvail() + " flags=" + flags);
        if (code == 12) {
            Bundle params = data.readTypedObject(Bundle.CREATOR);
            data.enforceNoDataAvail();
            if (params != null) {
                for (String key : params.keySet()) {
                    if (!"ncf_jpeg_max_size".equals(key)) {
                        throw new RemoteException("NOS4.1 does not support Bundle parameter " + key);
                    }
                }
                Log.w(TAG, "NOS4.1 uses its own JPEG buffer sizing; NOS5 ncf_jpeg_max_size="
                        + params.getInt("ncf_jpeg_max_size", 0) + " not applied");
            }
            reply.writeNoException();
            return true;
        }
        if (code == 14) {
            data.enforceNoDataAvail();
            Log.w(TAG, "NOS4.1 total UFS count unavailable; returning unknown -1 for exit analytics");
            reply.writeNoException();
            reply.writeInt(-1);
            return true;
        }
        Parcel request = Parcel.obtain();
        Parcel response = Parcel.obtain();
        ParcelFileDescriptor ownedPfd = null;
        NtCamUfsImage ownedImage = null;
        NtCamUfsRequest ownedCapture = null;
        NtCamUfsImage[] ownedIn = null;
        NtCamUfsImage[] ownedOut = null;
        try {
            request.writeInterfaceToken(DESCRIPTOR);
            int oldCode = code == 13 ? 12 : code;
            if (code == 3) {
                ParcelFileDescriptor pfd = data.readTypedObject(ParcelFileDescriptor.CREATOR);
                ownedPfd = pfd;
                int width = data.readInt();
                int height = data.readInt();
                int left = data.readInt();
                int top = data.readInt();
                long number = data.readLong();
                data.enforceNoDataAvail();
                if (left != 0 || top != 0) {
                    throw new RemoteException("NOS4.1 border watermark does not support nonzero offsets");
                }
                request.writeTypedObject(pfd, 0);
                request.writeInt(width);
                request.writeInt(height);
                request.writeLong(number);
            } else if (code == 5) {
                long number = data.readLong();
                NtCamUfsImage image = data.readTypedObject(NtCamUfsImage.CREATOR);
                ownedImage = image;
                boolean processingOnPause = data.readInt() != 0;
                data.enforceNoDataAvail();
                Log.i(TAG, "SAVE_IN req=" + number + " processingOnPause=" + processingOnPause + " " + imageSummary(image));
                if (processingOnPause) Log.w(TAG, "NOS4.1 saveImage has no processingOnPause argument");
                request.writeLong(number);
                writeOldImage(request, image);
            } else if (code == 6) {
                NtCamUfsRequest capture = data.readTypedObject(NtCamUfsRequest.CREATOR);
                ownedCapture = capture;
                NtCamUfsImage[] in = null;
                NtCamUfsImage[] out = null;
                in = data.createTypedArray(NtCamUfsImage.CREATOR);
                ownedIn = in;
                out = data.createTypedArray(NtCamUfsImage.CREATOR);
                ownedOut = out;
                data.enforceNoDataAvail();
                logCapture(capture, in, out);
                if (capture != null && capture.uri != null) {
                    if (context == null) throw new RemoteException("Photo URI delegation requires owner Context");
                    capture.uri = PhotoOutputProvider.delegate(context, capture.uri);
                    context.grantUriPermission("com.nothing.camera", capture.uri,
                            Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
                    Log.i(TAG, "PHOTO_URI_GRANTED req=" + capture.reqNumber + " recipient=com.nothing.camera read/write uri=" + capture.uri);
                }
                if (capture != null && (capture.isDocDetectionOn || capture.isDirectProcess
                        || capture.watermarkOptions != 0 || capture.watermarkInfos != null)) {
                    Log.w(TAG, "NOS5-only request fields have no NOS4.1 wire representation, request=" + capture.reqNumber);
                }
                writeOldRequest(request, capture);
                writeOldImages(request, in);
                writeOldImages(request, out);
                Log.i(TAG, "Forwarding photo request " + (capture == null ? "null" : capture.reqNumber));
            } else {
                // Callback/result/JPEG/buffer layouts and these scalar RPCs match NOS4.1.
                logScalar(code, data);
                if (code == 1 && context != null) {
                    IBinder callback = data.readStrongBinder();
                    request.writeStrongBinder(callback == null ? null : new OwnerCallback(context, callback));
                } else request.appendFrom(data, data.dataPosition(), data.dataAvail());
            }
            Log.i(TAG, "RPC_FORWARD modern=" + code + " old=" + oldCode + " bytes=" + request.dataSize());
            if (!stock.transact(oldCode, request, response, flags)) {
                throw new RemoteException("Factory UFS transaction unhandled: " + oldCode);
            }
            response.setDataPosition(0);
            response.readException();
            int responsePosition = response.dataPosition();
            if ((code == 5 || code == 9 || code == 13) && response.dataAvail() >= 4) {
                int value = response.readInt();
                Log.i(TAG, "RPC_RESULT modern=" + code + " old=" + oldCode + " value=" + value
                        + (code == 13 ? " factoryTotalTrackedRequests" : ""));
                response.setDataPosition(responsePosition);
            }
            Log.i(TAG, "RPC_DONE modern=" + code + " old=" + oldCode + " replyBytes=" + response.dataSize());
            if (reply != null) reply.appendFrom(response, 0, response.dataSize());
            return true;
        } catch (RemoteException | RuntimeException error) {
            Log.e(TAG, "RPC_FAIL modern=" + code, error);
            throw error;
        } finally {
            request.recycle();
            response.recycle();
            if (ownedPfd != null) try { ownedPfd.close(); } catch (java.io.IOException error) { Log.w(TAG, "PFD close", error); }
            closeImage(ownedImage);
            closeImages(ownedIn);
            closeImages(ownedOut);
            closeRequestBuffers(ownedCapture);
        }
    }

    private static final class OwnerCallback extends Binder {
        private final Context context;
        private final IBinder callback;
        OwnerCallback(Context context, IBinder callback) { this.context = context; this.callback = callback; }
        @Override protected boolean onTransact(int code, Parcel data, Parcel reply, int flags) throws RemoteException {
            if (code == INTERFACE_TRANSACTION) { if (reply != null) reply.writeString("com.nothing.algolib.cameraufs.INtCamUfsCallback"); return true; }
            if (code != 1) return callback.transact(code, data, reply, flags);
            data.enforceInterface("com.nothing.algolib.cameraufs.INtCamUfsCallback");
            com.nothing.algolib.cameraufs.NtCamUfsResult result = data.readTypedObject(com.nothing.algolib.cameraufs.NtCamUfsResult.CREATOR);
            com.nothing.algolib.cameraufs.INtCamJpeg jpeg = data.readTypedObject(com.nothing.algolib.cameraufs.INtCamJpeg.CREATOR);
            Parcel forwarded = Parcel.obtain();
            try {
                if (result != null && result.photoUri != null) {
                    result.photoUri = PhotoOutputProvider.resolve(context, android.net.Uri.parse(result.photoUri)).toString();
                }
                forwarded.writeInterfaceToken("com.nothing.algolib.cameraufs.INtCamUfsCallback");
                forwarded.writeTypedObject(result, 0);
                forwarded.writeTypedObject(jpeg, 0);
                return callback.transact(1, forwarded, reply, flags);
            } finally {
                forwarded.recycle();
                if (jpeg != null && jpeg.jpegMemory != null) jpeg.jpegMemory.close();
            }
        }
    }

    private static void logScalar(int code, Parcel data) {
        int position = data.dataPosition();
        try {
            if (code == 1) Log.i(TAG, "REGISTER_CALLBACK binder=" + data.readStrongBinder());
            if (code == 2 || code == 11) Log.i(TAG, "PARAM_IN modern=" + code + " value=" + data.readString());
            if (code == 4) {
                int count = data.readInt();
                data.setDataPosition(data.dataSize() - 8);
                Log.i(TAG, "META_IN count=" + count + " req=" + data.readLong());
            }
            if (code == 7 || code == 10) Log.i(TAG, "REQUEST_ID modern=" + code + " req=" + data.readLong());
            if (code == 9) Log.i(TAG, "CAN_CAPTURE mode=" + data.readInt());
            if (code == 8) Log.i(TAG, "CLOSE_SESSION");
        } finally { data.setDataPosition(position); }
    }

    private static String imageSummary(NtCamUfsImage image) {
        if (image == null) return "image=null";
        return "format=" + image.format + " width=" + image.width + " height=" + image.height
                + " timestamp=" + image.timestamp + " planes=" + image.planeCount
                + " slaver=" + image.slaverImage + " tuning=" + image.tuningImage
                + " crop=" + image.crop + " hardwareBuffer=" + (image.buffer != null)
                + " fence=" + (image.fence != null);
    }

    private static void logCapture(NtCamUfsRequest capture, NtCamUfsImage[] in, NtCamUfsImage[] out) {
        if (capture == null) { Log.i(TAG, "PROCESS_IN request=null"); return; }
        Log.i(TAG, "PROCESS_IN req=" + capture.reqNumber + " opmode=0x" + Integer.toHexString(capture.operationMode)
                + " logicalId=" + capture.logicalCameraId + " cameraId=" + capture.cameraId
                + " settingsBytes=" + (capture.settings == null ? -1 : capture.settings.length)
                + " inputBuffers=" + (capture.inputBuffers == null ? -1 : capture.inputBuffers.length)
                + " outputBuffers=" + (capture.outputBuffers == null ? -1 : capture.outputBuffers.length)
                + " inImages=" + (in == null ? -1 : in.length) + " outImages=" + (out == null ? -1 : out.length)
                + " burst=" + capture.isBurst + " preCapture=" + capture.isPreCapture
                + " ultraHdr=" + capture.isUltraHdrOn + " borderWatermark=" + capture.isBorderWatermarkOn
                + " livePhoto=" + capture.isLivePhoto + " doc=" + capture.isDocDetectionOn
                + " supportUfs=" + capture.isSupportUfs + " ufsSave=" + capture.isUfsSave
                + " direct=" + capture.isDirectProcess + " watermarkOptions=" + capture.watermarkOptions
                + " hasWatermarkInfos=" + (capture.watermarkInfos != null) + " uri=" + capture.uri);
        logBuffers(capture.reqNumber, "input", capture.inputBuffers);
        logBuffers(capture.reqNumber, "output", capture.outputBuffers);
        if (in != null) for (int i = 0; i < in.length; i++) Log.i(TAG, "PROCESS_IMAGE req=" + capture.reqNumber + " input=" + i + " " + imageSummary(in[i]));
        if (out != null) for (int i = 0; i < out.length; i++) Log.i(TAG, "PROCESS_IMAGE req=" + capture.reqNumber + " output=" + i + " " + imageSummary(out[i]));
    }

    private static void logBuffers(long number, String direction, com.nothing.algolib.cameraufs.NtCamUfsBuffer[] buffers) {
        if (buffers == null) return;
        for (int i = 0; i < buffers.length; i++) {
            com.nothing.algolib.cameraufs.NtCamUfsBuffer buffer = buffers[i];
            Log.i(TAG, "PROCESS_BUFFER req=" + number + " direction=" + direction + " index=" + i
                    + (buffer == null ? " null" : " format=" + buffer.format + " width=" + buffer.width
                    + " height=" + buffer.height + " phyId=" + buffer.phyCameraId + " tuningSize=" + buffer.tuningSize
                    + " strides=" + java.util.Arrays.toString(buffer.strides)
                    + " fds=" + (buffer.buffer == null || buffer.buffer.fds == null ? -1 : buffer.buffer.fds.length)));
        }
    }

    public static void writeOldImages(Parcel parcel, NtCamUfsImage[] images) {
        if (images == null) { parcel.writeInt(-1); return; }
        parcel.writeInt(images.length);
        for (NtCamUfsImage image : images) writeOldImage(parcel, image);
    }

    public static void writeOldImage(Parcel parcel, NtCamUfsImage image) {
        if (image == null) { parcel.writeInt(0); return; }
        parcel.writeInt(1);
        int start = parcel.dataPosition();
        parcel.writeInt(0);
        parcel.writeInt(image.format);
        parcel.writeInt(image.width);
        parcel.writeInt(image.height);
        parcel.writeInt(image.transform);
        parcel.writeInt(image.scalingMode);
        parcel.writeLong(image.timestamp);
        parcel.writeInt(image.planeCount);
        parcel.writeInt(image.slaverImage ? 1 : 0);
        if (image.tuningImage) Log.w(TAG, "NOS4.1 image has no tuningImage flag; buffer retained");
        parcel.writeTypedObject(image.crop, 0);
        parcel.writeTypedObject(image.buffer, 0);
        parcel.writeTypedObject(image.fence, 0);
        finishSized(parcel, start);
    }

    public static void writeOldRequest(Parcel parcel, NtCamUfsRequest capture) {
        if (capture == null) { parcel.writeInt(0); return; }
        parcel.writeInt(1);
        int start = parcel.dataPosition();
        parcel.writeInt(0);
        parcel.writeLong(capture.reqNumber);
        parcel.writeInt(capture.operationMode);
        parcel.writeInt(capture.logicalCameraId);
        parcel.writeByteArray(capture.settings);
        parcel.writeTypedArray(capture.inputBuffers, 0);
        parcel.writeTypedArray(capture.outputBuffers, 0);
        parcel.writeTypedObject(capture.uri, 0);
        parcel.writeString(capture.desc);
        parcel.writeDouble(capture.latitude);
        parcel.writeDouble(capture.longitude);
        parcel.writeString(capture.cameraId);
        parcel.writeInt(capture.flashMode);
        parcel.writeFloat(capture.focalLength);
        parcel.writeInt(capture.awbMode);
        parcel.writeLong(capture.exposureTimeUs);
        parcel.writeFloat(capture.lensAperture);
        parcel.writeInt(capture.postRawSensitivityBoost);
        parcel.writeInt(capture.iso);
        parcel.writeInt(capture.ev);
        parcel.writeInt(capture.stepDenominator);
        parcel.writeInt(capture.stepNumerator);
        parcel.writeFloat(capture.focus);
        parcel.writeInt(capture.efl35);
        parcel.writeFloat(capture.overrideEv);
        parcel.writeInt(capture.overrideIso);
        parcel.writeString(capture.makerNote);
        parcel.writeLong(capture.clickTimestamps);
        parcel.writeInt(capture.isBurst ? 1 : 0);
        parcel.writeInt(capture.isPreCapture ? 1 : 0);
        parcel.writeInt(capture.isUltraHdrOn ? 1 : 0);
        parcel.writeInt(capture.isBorderWatermarkOn ? 1 : 0);
        parcel.writeInt(capture.isLivePhoto ? 1 : 0);
        parcel.writeInt(capture.isSupportUfs ? 1 : 0);
        parcel.writeInt(capture.isUfsSave ? 1 : 0);
        finishSized(parcel, start);
    }

    private static void finishSized(Parcel parcel, int start) {
        int end = parcel.dataPosition();
        parcel.setDataPosition(start);
        parcel.writeInt(end - start);
        parcel.setDataPosition(end);
    }

    private static void closeImage(NtCamUfsImage image) {
        if (image == null) return;
        if (image.buffer != null) image.buffer.close();
        if (image.fence != null) try { image.fence.close(); } catch (java.io.IOException error) { Log.w(TAG, "Fence close", error); }
    }

    private static void closeImages(NtCamUfsImage[] images) {
        if (images != null) for (NtCamUfsImage image : images) closeImage(image);
    }

    private static void closeRequestBuffers(NtCamUfsRequest request) {
        if (request == null) return;
        if (request.inputBuffers != null) for (com.nothing.algolib.cameraufs.NtCamUfsBuffer buffer : request.inputBuffers) {
            closeBuffer(buffer);
        }
        if (request.outputBuffers != null) for (com.nothing.algolib.cameraufs.NtCamUfsBuffer buffer : request.outputBuffers) {
            closeBuffer(buffer);
        }
    }

    private static void closeBuffer(com.nothing.algolib.cameraufs.NtCamUfsBuffer buffer) {
        if (buffer == null || buffer.buffer == null || buffer.buffer.fds == null) return;
        for (ParcelFileDescriptor fd : buffer.buffer.fds) {
            if (fd != null) try { fd.close(); } catch (java.io.IOException error) { Log.w(TAG, "Buffer FD close", error); }
        }
    }
}
