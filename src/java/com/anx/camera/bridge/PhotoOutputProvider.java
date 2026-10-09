package com.anx.camera.bridge;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Binder;
import android.os.ParcelFileDescriptor;
import android.graphics.BitmapFactory;
import android.util.Log;
import java.io.FileNotFoundException;

public final class PhotoOutputProvider extends ContentProvider {
    public static final String AUTHORITY = "com.anx.camera.experimental.bridgeoutput";

    public static Uri delegate(Context context, Uri original) {
        if (!"content".equals(original.getScheme()) || !"media".equals(original.getAuthority())) {
            throw new IllegalArgumentException("Expected owner MediaStore URI");
        }
        long mediaId = android.content.ContentUris.parseId(original);
        if (mediaId < 0) throw new IllegalArgumentException("Expected numeric photo ID");
        String token = java.util.UUID.randomUUID().toString();
        if (!context.getSharedPreferences("bridge_outputs", 0).edit().putString(token, original.toString()).commit()) {
            throw new IllegalStateException("Unable to persist output mapping");
        }
        return Uri.parse("content://" + AUTHORITY + "/" + token + "/" + mediaId);
    }

    public static Uri resolve(Context context, Uri uri) {
        if (uri == null || !AUTHORITY.equals(uri.getAuthority())) return uri;
        if (uri.getPathSegments().size() != 2 || uri.getQuery() != null || uri.getFragment() != null) {
            throw new IllegalArgumentException("Invalid output token URI");
        }
        String value = context.getSharedPreferences("bridge_outputs", 0).getString(uri.getPathSegments().get(0), null);
        if (value == null) throw new IllegalArgumentException("Unknown output token");
        Uri original = Uri.parse(value);
        if (!Long.toString(android.content.ContentUris.parseId(original)).equals(uri.getLastPathSegment())) {
            throw new IllegalArgumentException("Output media ID does not match token");
        }
        return original;
    }

    @Override public boolean onCreate() { return true; }
    @Override public String getType(Uri uri) { return "image/jpeg"; }
    @Override public Cursor query(Uri uri, String[] projection, String selection, String[] args, String order) {
        long identity = Binder.clearCallingIdentity();
        try { return getContext().getContentResolver().query(resolve(getContext(), uri), projection, selection, args, order); }
        finally { Binder.restoreCallingIdentity(identity); }
    }
    @Override public ParcelFileDescriptor openFile(Uri uri, String mode) throws FileNotFoundException {
        long identity = Binder.clearCallingIdentity();
        try { return getContext().getContentResolver().openFileDescriptor(resolve(getContext(), uri), mode); }
        finally { Binder.restoreCallingIdentity(identity); }
    }
    @Override public int update(Uri uri, ContentValues values, String selection, String[] args) {
        long identity = Binder.clearCallingIdentity();
        try {
            Uri original = resolve(getContext(), uri);
            ContentValues output = new ContentValues(values);
            if (values.containsKey("is_pending") && Integer.valueOf(0).equals(values.getAsInteger("is_pending"))) {
                try (ParcelFileDescriptor fd = getContext().getContentResolver().openFileDescriptor(original, "r")) {
                    if (fd == null || fd.getStatSize() <= 0) throw new IllegalStateException("Empty final output");
                    BitmapFactory.Options bounds = new BitmapFactory.Options();
                    bounds.inJustDecodeBounds = true;
                    BitmapFactory.decodeFileDescriptor(fd.getFileDescriptor(), null, bounds);
                    if (bounds.outWidth <= 0 || bounds.outHeight <= 0) throw new IllegalStateException("Invalid final JPEG");
                    output.put("width", bounds.outWidth);
                    output.put("height", bounds.outHeight);
                    output.put("_size", fd.getStatSize());
                    Log.i("PhotoOutputProvider", "OWNER_PUBLISH uri=" + original + " size=" + fd.getStatSize()
                            + " dimensions=" + bounds.outWidth + "x" + bounds.outHeight);
                } catch (java.io.IOException error) { throw new IllegalStateException("Output validation failed", error); }
            }
            int count = getContext().getContentResolver().update(original, output, selection, args);
            getContext().getContentResolver().notifyChange(original, null);
            return count;
        } finally { Binder.restoreCallingIdentity(identity); }
    }
    @Override public Uri insert(Uri uri, ContentValues values) { throw new UnsupportedOperationException(); }
    @Override public int delete(Uri uri, String selection, String[] args) { throw new UnsupportedOperationException(); }
}
