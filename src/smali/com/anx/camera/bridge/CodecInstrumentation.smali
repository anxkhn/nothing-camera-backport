.class public final Lcom/anx/camera/bridge/CodecInstrumentation;
.super Landroid/app/Instrumentation;
.source "CodecInstrumentation.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 13
    invoke-direct {p0}, Landroid/app/Instrumentation;-><init>()V

    return-void
.end method

.method static synthetic access$000(ZLjava/lang/String;)V
    .locals 0

    .line 13
    invoke-static {p0, p1}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    return-void
.end method

.method private static check(ZLjava/lang/String;)V
    .locals 0

    .line 35
    if-eqz p0, :cond_0

    .line 36
    return-void

    .line 35
    :cond_0
    new-instance p0, Ljava/lang/AssertionError;

    invoke-direct {p0, p1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw p0
.end method

.method private static testImages()V
    .locals 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 171
    new-instance v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;

    invoke-direct {v1}, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;-><init>()V

    .line 172
    const/16 v0, 0x23

    iput v0, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->format:I

    .line 173
    const/16 v0, 0x40

    iput v0, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->width:I

    .line 174
    iput v0, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->height:I

    .line 175
    const-wide v2, 0x123456789L

    iput-wide v2, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->timestamp:J

    .line 176
    const/4 v2, 0x3

    iput v2, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->planeCount:I

    .line 177
    const/4 v2, 0x1

    iput-boolean v2, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->slaverImage:Z

    .line 178
    iput-boolean v2, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->tuningImage:Z

    .line 179
    new-instance v3, Landroid/graphics/Rect;

    const/16 v4, 0x1f

    const/16 v5, 0x20

    const/4 v6, 0x2

    invoke-direct {v3, v2, v6, v4, v5}, Landroid/graphics/Rect;-><init>(IIII)V

    iput-object v3, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->crop:Landroid/graphics/Rect;

    .line 180
    const/4 v10, 0x1

    const-wide/16 v11, 0x3

    const/16 v7, 0x40

    const/16 v8, 0x40

    const/4 v9, 0x1

    invoke-static/range {v7 .. v12}, Landroid/hardware/HardwareBuffer;->create(IIIIJ)Landroid/hardware/HardwareBuffer;

    move-result-object v3

    iput-object v3, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    .line 181
    invoke-static {}, Landroid/os/ParcelFileDescriptor;->createPipe()[Landroid/os/ParcelFileDescriptor;

    move-result-object v3

    .line 182
    const/4 v4, 0x0

    aget-object v5, v3, v4

    iput-object v5, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->fence:Landroid/os/ParcelFileDescriptor;

    .line 183
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v5

    .line 185
    :try_start_0
    new-array v7, v6, [Lcom/nothing/algolib/cameraufs/NtCamUfsImage;

    const/4 v8, 0x0

    aput-object v8, v7, v4

    aput-object v1, v7, v2

    invoke-static {v5, v7}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldImages(Landroid/os/Parcel;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 186
    invoke-virtual {v5, v4}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 187
    sget-object v7, Lcom/anx/camera/bridge/old/NtCamUfsImage;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v5, v7}, Landroid/os/Parcel;->createTypedArray(Landroid/os/Parcelable$Creator;)[Ljava/lang/Object;

    move-result-object v7

    check-cast v7, [Lcom/anx/camera/bridge/old/NtCamUfsImage;

    .line 188
    array-length v9, v7

    if-ne v9, v6, :cond_0

    aget-object v6, v7, v4

    if-nez v6, :cond_0

    move v6, v2

    goto :goto_0

    :cond_0
    move v6, v4

    :goto_0
    const-string v9, "Null image element"

    invoke-static {v6, v9}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 189
    aget-object v6, v7, v2

    iget-object v6, v6, Lcom/anx/camera/bridge/old/NtCamUfsImage;->crop:Landroid/graphics/Rect;

    iget-object v9, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->crop:Landroid/graphics/Rect;

    invoke-virtual {v6, v9}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_1

    aget-object v6, v7, v2

    iget v6, v6, Lcom/anx/camera/bridge/old/NtCamUfsImage;->width:I

    if-ne v6, v0, :cond_1

    aget-object v6, v7, v2

    iget-boolean v6, v6, Lcom/anx/camera/bridge/old/NtCamUfsImage;->slaverImage:Z

    if-eqz v6, :cond_1

    aget-object v6, v7, v2

    iget-wide v9, v6, Lcom/anx/camera/bridge/old/NtCamUfsImage;->timestamp:J

    iget-wide v11, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->timestamp:J

    cmp-long v6, v9, v11

    if-nez v6, :cond_1

    aget-object v6, v7, v2

    iget-object v6, v6, Lcom/anx/camera/bridge/old/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    .line 190
    invoke-virtual {v6}, Landroid/hardware/HardwareBuffer;->getWidth()I

    move-result v6

    if-ne v6, v0, :cond_1

    aget-object v0, v7, v2

    iget-object v0, v0, Lcom/anx/camera/bridge/old/NtCamUfsImage;->fence:Landroid/os/ParcelFileDescriptor;

    .line 191
    invoke-virtual {v0}, Landroid/os/ParcelFileDescriptor;->getFd()I

    move-result v0

    if-ltz v0, :cond_1

    invoke-virtual {v5}, Landroid/os/Parcel;->dataAvail()I

    move-result v0

    if-nez v0, :cond_1

    move v0, v2

    goto :goto_1

    :cond_1
    move v0, v4

    :goto_1
    const-string v6, "Image wire order/FDs"

    .line 189
    invoke-static {v0, v6}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 192
    aget-object v0, v7, v2

    iget-object v0, v0, Lcom/anx/camera/bridge/old/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    invoke-virtual {v0}, Landroid/hardware/HardwareBuffer;->close()V

    .line 193
    aget-object v0, v7, v2

    iget-object v0, v0, Lcom/anx/camera/bridge/old/NtCamUfsImage;->fence:Landroid/os/ParcelFileDescriptor;

    invoke-virtual {v0}, Landroid/os/ParcelFileDescriptor;->close()V

    .line 194
    invoke-virtual {v5, v4}, Landroid/os/Parcel;->setDataSize(I)V

    .line 195
    invoke-virtual {v5, v4}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 196
    invoke-static {v5, v8}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldImages(Landroid/os/Parcel;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 197
    invoke-virtual {v5, v4}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 198
    sget-object v0, Lcom/anx/camera/bridge/old/NtCamUfsImage;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v5, v0}, Landroid/os/Parcel;->createTypedArray(Landroid/os/Parcelable$Creator;)[Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_2

    move v0, v2

    goto :goto_2

    :cond_2
    move v0, v4

    :goto_2
    const-string v6, "Null image array"

    invoke-static {v0, v6}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 199
    invoke-virtual {v5, v4}, Landroid/os/Parcel;->setDataSize(I)V

    .line 200
    invoke-virtual {v5, v4}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 201
    invoke-static {v5, v8}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldRequest(Landroid/os/Parcel;Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;)V

    .line 202
    invoke-virtual {v5, v4}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 203
    sget-object v0, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v5, v0}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_3

    move v0, v2

    goto :goto_3

    :cond_3
    move v0, v4

    :goto_3
    const-string v6, "Null request"

    invoke-static {v0, v6}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 205
    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 206
    iget-object v0, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    invoke-virtual {v0}, Landroid/hardware/HardwareBuffer;->close()V

    .line 207
    aget-object v0, v3, v4

    invoke-virtual {v0}, Landroid/os/ParcelFileDescriptor;->close()V

    .line 208
    aget-object v0, v3, v2

    invoke-virtual {v0}, Landroid/os/ParcelFileDescriptor;->close()V

    .line 209
    nop

    .line 210
    return-void

    .line 205
    :catchall_0
    move-exception v0

    invoke-virtual {v5}, Landroid/os/Parcel;->recycle()V

    .line 206
    iget-object v1, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    invoke-virtual {v1}, Landroid/hardware/HardwareBuffer;->close()V

    .line 207
    aget-object v1, v3, v4

    invoke-virtual {v1}, Landroid/os/ParcelFileDescriptor;->close()V

    .line 208
    aget-object v1, v3, v2

    invoke-virtual {v1}, Landroid/os/ParcelFileDescriptor;->close()V

    .line 209
    throw v0
.end method

.method private static testMetadataWriter()V
    .locals 11

    .line 106
    const/16 v3, 0x1e

    const-wide/16 v4, 0x2

    const/high16 v0, 0x100000

    const/16 v1, 0x8

    const/16 v2, 0x100

    invoke-static/range {v0 .. v5}, Landroid/media/ImageReader;->newInstance(IIIIJ)Landroid/media/ImageReader;

    move-result-object v1

    .line 108
    nop

    .line 109
    nop

    .line 111
    const/4 v2, 0x0

    :try_start_0
    invoke-virtual {v1}, Landroid/media/ImageReader;->getSurface()Landroid/view/Surface;

    move-result-object v0

    const/16 v3, 0x100

    const/16 v4, 0x1e

    const/high16 v5, 0x800000

    const/4 v6, 0x1

    invoke-static {v0, v4, v3, v5, v6}, Lcom/anx/camera/bridge/PublicImageWriter;->create(Landroid/view/Surface;IIII)Landroid/media/ImageWriter;

    move-result-object v7
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 112
    :try_start_1
    invoke-virtual {v7}, Landroid/media/ImageWriter;->getWidth()I

    move-result v0

    const/4 v8, 0x0

    if-ne v0, v5, :cond_0

    invoke-virtual {v7}, Landroid/media/ImageWriter;->getHeight()I

    move-result v0

    if-ne v0, v6, :cond_0

    invoke-virtual {v7}, Landroid/media/ImageWriter;->getMaxImages()I

    move-result v0

    if-ne v0, v4, :cond_0

    .line 113
    invoke-virtual {v7}, Landroid/media/ImageWriter;->getFormat()I

    move-result v0

    if-ne v0, v3, :cond_0

    .line 114
    invoke-virtual {v7}, Landroid/media/ImageWriter;->getUsage()J

    move-result-wide v3

    const-wide/16 v9, 0x30

    cmp-long v0, v3, v9

    if-nez v0, :cond_0

    move v0, v6

    goto :goto_0

    :cond_0
    move v0, v8

    :goto_0
    const-string v3, "Metadata writer arguments"

    .line 112
    invoke-static {v0, v3}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 115
    invoke-virtual {v7}, Landroid/media/ImageWriter;->dequeueInputImage()Landroid/media/Image;

    move-result-object v2

    .line 116
    invoke-virtual {v2}, Landroid/media/Image;->getPlanes()[Landroid/media/Image$Plane;

    move-result-object v0

    array-length v0, v0

    if-ne v0, v6, :cond_1

    invoke-virtual {v2}, Landroid/media/Image;->getPlanes()[Landroid/media/Image$Plane;

    move-result-object v0

    aget-object v0, v0, v8

    invoke-virtual {v0}, Landroid/media/Image$Plane;->getBuffer()Ljava/nio/ByteBuffer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/nio/ByteBuffer;->remaining()I

    move-result v0

    if-lt v0, v5, :cond_1

    move v0, v6

    goto :goto_1

    :cond_1
    move v0, v8

    :goto_1
    const-string v3, "Metadata buffer capacity"

    invoke-static {v0, v3}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 118
    invoke-virtual {v2}, Landroid/media/Image;->getPlanes()[Landroid/media/Image$Plane;

    move-result-object v0

    aget-object v0, v0, v8

    invoke-virtual {v0}, Landroid/media/Image$Plane;->getBuffer()Ljava/nio/ByteBuffer;

    move-result-object v0

    const/16 v3, 0x5a

    invoke-virtual {v0, v8, v3}, Ljava/nio/ByteBuffer;->put(IB)Ljava/nio/ByteBuffer;

    .line 119
    invoke-virtual {v2}, Landroid/media/Image;->getPlanes()[Landroid/media/Image$Plane;

    move-result-object v0

    aget-object v0, v0, v8

    invoke-virtual {v0}, Landroid/media/Image$Plane;->getBuffer()Ljava/nio/ByteBuffer;

    move-result-object v0

    invoke-virtual {v0, v8}, Ljava/nio/ByteBuffer;->get(I)B

    move-result v0

    if-ne v0, v3, :cond_2

    goto :goto_2

    :cond_2
    move v6, v8

    :goto_2
    const-string v0, "Metadata buffer writable"

    invoke-static {v6, v0}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 121
    if-eqz v2, :cond_3

    invoke-virtual {v2}, Landroid/media/Image;->close()V

    .line 122
    :cond_3
    if-eqz v7, :cond_4

    invoke-virtual {v7}, Landroid/media/ImageWriter;->close()V

    .line 123
    :cond_4
    invoke-virtual {v1}, Landroid/media/ImageReader;->close()V

    .line 124
    nop

    .line 125
    return-void

    .line 121
    :catchall_0
    move-exception v0

    goto :goto_3

    :catchall_1
    move-exception v0

    move-object v7, v2

    :goto_3
    if-eqz v2, :cond_5

    invoke-virtual {v2}, Landroid/media/Image;->close()V

    .line 122
    :cond_5
    if-eqz v7, :cond_6

    invoke-virtual {v7}, Landroid/media/ImageWriter;->close()V

    .line 123
    :cond_6
    invoke-virtual {v1}, Landroid/media/ImageReader;->close()V

    .line 124
    throw v0
.end method

.method private testOwnerPublication()V
    .locals 21
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 59
    const-string v1, "bridge_outputs"

    invoke-virtual/range {p0 .. p0}, Lcom/anx/camera/bridge/CodecInstrumentation;->getTargetContext()Landroid/content/Context;

    move-result-object v2

    .line 60
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 61
    const-string v3, "_display_name"

    const-string v4, "bridge-owner-publication-test.jpg"

    invoke-virtual {v0, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 62
    const-string v3, "mime_type"

    const-string v4, "image/jpeg"

    invoke-virtual {v0, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 63
    const/4 v3, 0x1

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const-string v5, "is_pending"

    invoke-virtual {v0, v5, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 64
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    sget-object v6, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    invoke-virtual {v4, v6, v0}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    move-result-object v8

    .line 65
    const/4 v4, 0x0

    if-eqz v8, :cond_0

    move v0, v3

    goto :goto_0

    :cond_0
    move v0, v4

    :goto_0
    const-string v6, "Temporary pending owner row"

    invoke-static {v0, v6}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 66
    invoke-static {v2, v8}, Lcom/anx/camera/bridge/PhotoOutputProvider;->delegate(Landroid/content/Context;Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v6

    .line 67
    const-string v0, "content://media/external/images/media/1000581837"

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/anx/camera/bridge/PhotoOutputProvider;->delegate(Landroid/content/Context;Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v13

    .line 68
    invoke-static {v6}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v9

    invoke-static {v8}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v11

    cmp-long v0, v9, v11

    if-nez v0, :cond_1

    move v0, v3

    goto :goto_1

    :cond_1
    move v0, v4

    :goto_1
    const-string v7, "Numeric proxy photo ID"

    invoke-static {v0, v7}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 69
    invoke-static {v13}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v9

    const-wide/32 v11, 0x3ba3aacd

    cmp-long v0, v9, v11

    if-nez v0, :cond_2

    move v0, v3

    goto :goto_2

    :cond_2
    move v0, v4

    :goto_2
    const-string v7, "Independent numeric proxy ID"

    invoke-static {v0, v7}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 70
    invoke-virtual {v6}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    invoke-virtual {v13}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object v7

    invoke-interface {v7, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v7

    invoke-virtual {v0, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    xor-int/2addr v0, v3

    const-string v7, "Independent opaque tokens"

    invoke-static {v0, v7}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 72
    :try_start_0
    invoke-virtual {v6}, Landroid/net/Uri;->buildUpon()Landroid/net/Uri$Builder;

    move-result-object v0

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "/"

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v6}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object v9

    invoke-interface {v9, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Ljava/lang/String;

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v9, "/0"

    invoke-virtual {v7, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v7}, Landroid/net/Uri$Builder;->path(Ljava/lang/String;)Landroid/net/Uri$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/Uri$Builder;->build()Landroid/net/Uri;

    move-result-object v0

    invoke-static {v2, v0}, Lcom/anx/camera/bridge/PhotoOutputProvider;->resolve(Landroid/content/Context;Landroid/net/Uri;)Landroid/net/Uri;

    .line 73
    new-instance v0, Ljava/lang/AssertionError;

    const-string v7, "Mismatched token/photo ID accepted"

    invoke-direct {v0, v7}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw v0
    :try_end_0
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_0} :catch_0

    .line 74
    :catch_0
    move-exception v0

    .line 75
    sget-object v0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    const/16 v14, 0x10

    const/16 v15, 0xc

    invoke-static {v14, v15, v0}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v7

    .line 77
    const/4 v9, 0x0

    :try_start_1
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v10, "w"

    invoke-virtual {v0, v6, v10}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object v10
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_f

    .line 78
    const/4 v11, 0x3

    :try_start_2
    new-array v0, v11, [B

    fill-array-data v0, :array_0

    invoke-virtual {v10, v0}, Ljava/io/OutputStream;->write([B)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_c

    .line 79
    if-eqz v10, :cond_3

    :try_start_3
    invoke-virtual {v10}, Ljava/io/OutputStream;->close()V

    .line 80
    :cond_3
    new-instance v10, Landroid/content/ContentValues;

    invoke-direct {v10}, Landroid/content/ContentValues;-><init>()V

    .line 81
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v10, v5, v0}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_f

    .line 83
    :try_start_4
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, v6, v10, v9, v9}, Landroid/content/ContentResolver;->update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    .line 84
    new-instance v0, Ljava/lang/AssertionError;

    const-string v12, "Invalid JPEG published"

    invoke-direct {v0, v12}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V

    throw v0
    :try_end_4
    .catch Ljava/lang/IllegalStateException; {:try_start_4 .. :try_end_4} :catch_1
    .catchall {:try_start_4 .. :try_end_4} :catchall_f

    .line 85
    :catch_1
    move-exception v0

    .line 86
    move-object v12, v7

    :try_start_5
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v7
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_b

    move-object/from16 v16, v9

    :try_start_6
    filled-new-array {v5}, [Ljava/lang/String;

    move-result-object v9
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_a

    move/from16 v17, v11

    const/4 v11, 0x0

    move-object/from16 v18, v12

    const/4 v12, 0x0

    move-object/from16 v19, v10

    const/4 v10, 0x0

    move-object/from16 v15, v18

    move-object/from16 v14, v19

    :try_start_7
    invoke-virtual/range {v7 .. v12}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v7
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_9

    .line 87
    :try_start_8
    invoke-interface {v7}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v0
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_7

    if-eqz v0, :cond_4

    :try_start_9
    invoke-interface {v7, v4}, Landroid/database/Cursor;->getInt(I)I

    move-result v0
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_0

    if-ne v0, v3, :cond_4

    move v0, v3

    goto :goto_3

    .line 86
    :catchall_0
    move-exception v0

    move-object v3, v0

    const/4 v5, 0x0

    goto/16 :goto_8

    .line 87
    :cond_4
    move v0, v4

    :goto_3
    :try_start_a
    const-string v9, "Invalid output remains pending"

    invoke-static {v0, v9}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_7

    .line 88
    if-eqz v7, :cond_5

    :try_start_b
    invoke-interface {v7}, Landroid/database/Cursor;->close()V

    .line 89
    :cond_5
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v7, "wt"

    invoke-virtual {v0, v6, v7}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;Ljava/lang/String;)Ljava/io/OutputStream;

    move-result-object v7
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_9

    .line 90
    :try_start_c
    sget-object v0, Landroid/graphics/Bitmap$CompressFormat;->JPEG:Landroid/graphics/Bitmap$CompressFormat;

    const/16 v9, 0x5a

    invoke-virtual {v15, v0, v9, v7}, Landroid/graphics/Bitmap;->compress(Landroid/graphics/Bitmap$CompressFormat;ILjava/io/OutputStream;)Z

    move-result v0

    const-string v9, "Test JPEG encoding"

    invoke-static {v0, v9}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_c
    .catchall {:try_start_c .. :try_end_c} :catchall_5

    .line 91
    if-eqz v7, :cond_6

    :try_start_d
    invoke-virtual {v7}, Ljava/io/OutputStream;->close()V

    .line 92
    :cond_6
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0
    :try_end_d
    .catchall {:try_start_d .. :try_end_d} :catchall_9

    const/4 v7, 0x0

    :try_start_e
    invoke-virtual {v0, v6, v14, v7, v7}, Landroid/content/ContentResolver;->update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v0

    if-ne v0, v3, :cond_7

    move v0, v3

    goto :goto_4

    :cond_7
    move v0, v4

    :goto_4
    const-string v9, "Owner publish update"

    invoke-static {v0, v9}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_e
    .catchall {:try_start_e .. :try_end_e} :catchall_4

    .line 93
    move-object/from16 v20, v7

    :try_start_f
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v7

    const-string v0, "width"

    const-string v9, "height"

    const-string v10, "_size"

    filled-new-array {v5, v0, v9, v10}, [Ljava/lang/String;

    move-result-object v9
    :try_end_f
    .catchall {:try_start_f .. :try_end_f} :catchall_3

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v10, 0x0

    move-object/from16 v5, v20

    :try_start_10
    invoke-virtual/range {v7 .. v12}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v7
    :try_end_10
    .catchall {:try_start_10 .. :try_end_10} :catchall_e

    .line 94
    :try_start_11
    invoke-interface {v7}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v0

    if-eqz v0, :cond_8

    invoke-interface {v7, v4}, Landroid/database/Cursor;->getInt(I)I

    move-result v0

    if-nez v0, :cond_8

    invoke-interface {v7, v3}, Landroid/database/Cursor;->getInt(I)I

    move-result v0

    const/16 v9, 0x10

    if-ne v0, v9, :cond_8

    .line 95
    const/4 v0, 0x2

    invoke-interface {v7, v0}, Landroid/database/Cursor;->getInt(I)I

    move-result v0

    const/16 v9, 0xc

    if-ne v0, v9, :cond_8

    const/4 v9, 0x3

    invoke-interface {v7, v9}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v9

    const-wide/16 v11, 0x0

    cmp-long v0, v9, v11

    if-lez v0, :cond_8

    goto :goto_5

    :cond_8
    move v3, v4

    :goto_5
    const-string v0, "Published JPEG metadata"

    .line 94
    invoke-static {v3, v0}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_11
    .catchall {:try_start_11 .. :try_end_11} :catchall_1

    .line 96
    if-eqz v7, :cond_9

    :try_start_12
    invoke-interface {v7}, Landroid/database/Cursor;->close()V
    :try_end_12
    .catchall {:try_start_12 .. :try_end_12} :catchall_e

    .line 98
    :cond_9
    invoke-virtual {v15}, Landroid/graphics/Bitmap;->recycle()V

    .line 99
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, v8, v5, v5}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I

    .line 100
    invoke-virtual {v2, v1, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-virtual {v6}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 101
    invoke-virtual {v13}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object v1

    invoke-interface {v1, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 102
    nop

    .line 103
    return-void

    .line 93
    :catchall_1
    move-exception v0

    move-object v3, v0

    if-eqz v7, :cond_a

    :try_start_13
    invoke-interface {v7}, Landroid/database/Cursor;->close()V
    :try_end_13
    .catchall {:try_start_13 .. :try_end_13} :catchall_2

    goto :goto_6

    :catchall_2
    move-exception v0

    :try_start_14
    invoke-virtual {v3, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_a
    :goto_6
    throw v3
    :try_end_14
    .catchall {:try_start_14 .. :try_end_14} :catchall_e

    .line 98
    :catchall_3
    move-exception v0

    move-object/from16 v5, v20

    goto :goto_b

    :catchall_4
    move-exception v0

    move-object v5, v7

    goto :goto_b

    .line 89
    :catchall_5
    move-exception v0

    const/4 v5, 0x0

    move-object v3, v0

    if-eqz v7, :cond_b

    :try_start_15
    invoke-virtual {v7}, Ljava/io/OutputStream;->close()V
    :try_end_15
    .catchall {:try_start_15 .. :try_end_15} :catchall_6

    goto :goto_7

    :catchall_6
    move-exception v0

    :try_start_16
    invoke-virtual {v3, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_b
    :goto_7
    throw v3
    :try_end_16
    .catchall {:try_start_16 .. :try_end_16} :catchall_e

    .line 86
    :catchall_7
    move-exception v0

    const/4 v5, 0x0

    move-object v3, v0

    :goto_8
    if-eqz v7, :cond_c

    :try_start_17
    invoke-interface {v7}, Landroid/database/Cursor;->close()V
    :try_end_17
    .catchall {:try_start_17 .. :try_end_17} :catchall_8

    goto :goto_9

    :catchall_8
    move-exception v0

    :try_start_18
    invoke-virtual {v3, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_c
    :goto_9
    throw v3
    :try_end_18
    .catchall {:try_start_18 .. :try_end_18} :catchall_e

    .line 98
    :catchall_9
    move-exception v0

    const/4 v5, 0x0

    goto :goto_b

    :catchall_a
    move-exception v0

    move-object v15, v12

    move-object/from16 v5, v16

    goto :goto_b

    :catchall_b
    move-exception v0

    move-object v5, v9

    move-object v15, v12

    goto :goto_b

    .line 77
    :catchall_c
    move-exception v0

    move-object v15, v7

    move-object v5, v9

    move-object v3, v0

    if-eqz v10, :cond_d

    :try_start_19
    invoke-virtual {v10}, Ljava/io/OutputStream;->close()V
    :try_end_19
    .catchall {:try_start_19 .. :try_end_19} :catchall_d

    goto :goto_a

    :catchall_d
    move-exception v0

    :try_start_1a
    invoke-virtual {v3, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_d
    :goto_a
    throw v3
    :try_end_1a
    .catchall {:try_start_1a .. :try_end_1a} :catchall_e

    .line 98
    :catchall_e
    move-exception v0

    goto :goto_b

    :catchall_f
    move-exception v0

    move-object v15, v7

    move-object v5, v9

    :goto_b
    invoke-virtual {v15}, Landroid/graphics/Bitmap;->recycle()V

    .line 99
    invoke-virtual {v2}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v3

    invoke-virtual {v3, v8, v5, v5}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I

    .line 100
    invoke-virtual {v2, v1, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-virtual {v6}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 101
    invoke-virtual {v13}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-interface {v1, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 102
    throw v0

    :array_0
    .array-data 1
        0x1t
        0x2t
        0x3t
    .end array-data
.end method

.method private testPhotoUriGrant()V
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 39
    const-string v0, "com.nothing.camera"

    invoke-virtual {p0}, Lcom/anx/camera/bridge/CodecInstrumentation;->getTargetContext()Landroid/content/Context;

    move-result-object v1

    .line 40
    new-instance v2, Landroid/content/ContentValues;

    invoke-direct {v2}, Landroid/content/ContentValues;-><init>()V

    .line 41
    const-string v3, "_display_name"

    const-string v4, "bridge-uri-grant-test.jpg"

    invoke-virtual {v2, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 42
    const-string v3, "mime_type"

    const-string v4, "image/jpeg"

    invoke-virtual {v2, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 43
    const/4 v3, 0x1

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const-string v5, "is_pending"

    invoke-virtual {v2, v5, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 44
    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v4

    sget-object v5, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;

    invoke-virtual {v4, v5, v2}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;

    move-result-object v2

    .line 45
    const/4 v4, 0x0

    if-eqz v2, :cond_0

    move v5, v3

    goto :goto_0

    :cond_0
    move v5, v4

    :goto_0
    const-string v6, "Temporary owner MediaStore row"

    invoke-static {v5, v6}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 46
    nop

    .line 48
    const/4 v5, 0x0

    const/4 v6, 0x3

    :try_start_0
    invoke-virtual {v1}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v7

    invoke-virtual {v7, v0, v4}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v7

    iget v7, v7, Landroid/content/pm/ApplicationInfo;->uid:I

    .line 49
    invoke-virtual {v1, v0, v2, v6}, Landroid/content/Context;->grantUriPermission(Ljava/lang/String;Landroid/net/Uri;I)V

    .line 50
    const/4 v8, -0x1

    invoke-virtual {v1, v2, v8, v7, v6}, Landroid/content/Context;->checkUriPermission(Landroid/net/Uri;III)I

    move-result v7

    if-nez v7, :cond_1

    goto :goto_1

    :cond_1
    move v3, v4

    :goto_1
    const-string v4, "Factory UID has scoped read/write grant"

    invoke-static {v3, v4}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 53
    invoke-virtual {v1, v0, v2, v6}, Landroid/content/Context;->revokeUriPermission(Ljava/lang/String;Landroid/net/Uri;I)V

    .line 54
    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, v2, v5, v5}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I

    .line 55
    nop

    .line 56
    return-void

    .line 53
    :catchall_0
    move-exception v3

    invoke-virtual {v1, v0, v2, v6}, Landroid/content/Context;->revokeUriPermission(Ljava/lang/String;Landroid/net/Uri;I)V

    .line 54
    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, v2, v5, v5}, Landroid/content/ContentResolver;->delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I

    .line 55
    throw v3
.end method

.method private static testRequestFlags()V
    .locals 14

    .line 128
    const/4 v0, 0x0

    move v1, v0

    :goto_0
    const/16 v2, 0x200

    if-ge v1, v2, :cond_e

    .line 129
    new-instance v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;

    invoke-direct {v2}, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;-><init>()V

    .line 130
    const-wide v3, 0x123456789L

    iput-wide v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    .line 131
    const v3, 0xf004

    iput v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->operationMode:I

    .line 132
    iput v0, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->logicalCameraId:I

    .line 133
    const/4 v3, 0x3

    new-array v3, v3, [B

    fill-array-data v3, :array_0

    iput-object v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->settings:[B

    .line 134
    const-string v3, "content://media/external/images/media/123"

    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    iput-object v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    .line 135
    const-string v3, "bridge-metadata"

    iput-object v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->desc:Ljava/lang/String;

    .line 136
    const-wide v3, 0x402899999999999aL    # 12.3

    iput-wide v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->latitude:D

    .line 137
    const-wide v3, -0x3fb9333333333333L    # -45.6

    iput-wide v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->longitude:D

    .line 138
    const-string v3, "0"

    iput-object v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->cameraId:Ljava/lang/String;

    .line 139
    const/16 v3, 0x190

    iput v3, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->iso:I

    .line 140
    const/4 v4, -0x2

    iput v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->ev:I

    .line 141
    const-wide/16 v5, 0x3039

    iput-wide v5, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->exposureTimeUs:J

    .line 142
    const-string v7, "maker-note"

    iput-object v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->makerNote:Ljava/lang/String;

    .line 143
    and-int/lit8 v7, v1, 0x1

    const/4 v8, 0x1

    if-eqz v7, :cond_0

    move v7, v8

    goto :goto_1

    :cond_0
    move v7, v0

    :goto_1
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBurst:Z

    .line 144
    and-int/lit8 v7, v1, 0x2

    if-eqz v7, :cond_1

    move v7, v8

    goto :goto_2

    :cond_1
    move v7, v0

    :goto_2
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isPreCapture:Z

    .line 145
    and-int/lit8 v7, v1, 0x4

    if-eqz v7, :cond_2

    move v7, v8

    goto :goto_3

    :cond_2
    move v7, v0

    :goto_3
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUltraHdrOn:Z

    .line 146
    and-int/lit8 v7, v1, 0x8

    if-eqz v7, :cond_3

    move v7, v8

    goto :goto_4

    :cond_3
    move v7, v0

    :goto_4
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBorderWatermarkOn:Z

    .line 147
    and-int/lit8 v7, v1, 0x10

    if-eqz v7, :cond_4

    move v7, v8

    goto :goto_5

    :cond_4
    move v7, v0

    :goto_5
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isLivePhoto:Z

    .line 148
    and-int/lit8 v7, v1, 0x20

    if-eqz v7, :cond_5

    move v7, v8

    goto :goto_6

    :cond_5
    move v7, v0

    :goto_6
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isSupportUfs:Z

    .line 149
    and-int/lit8 v7, v1, 0x40

    if-eqz v7, :cond_6

    move v7, v8

    goto :goto_7

    :cond_6
    move v7, v0

    :goto_7
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUfsSave:Z

    .line 150
    and-int/lit16 v7, v1, 0x80

    if-eqz v7, :cond_7

    move v7, v8

    goto :goto_8

    :cond_7
    move v7, v0

    :goto_8
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isDocDetectionOn:Z

    .line 151
    and-int/lit16 v7, v1, 0x100

    if-eqz v7, :cond_8

    move v7, v8

    goto :goto_9

    :cond_8
    move v7, v0

    :goto_9
    iput-boolean v7, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isDirectProcess:Z

    .line 152
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v7

    .line 154
    :try_start_0
    invoke-static {v7, v2}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldRequest(Landroid/os/Parcel;Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;)V

    .line 155
    invoke-virtual {v7, v0}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 156
    sget-object v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v7, v9}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;

    .line 157
    invoke-virtual {v7}, Landroid/os/Parcel;->dataAvail()I

    move-result v10

    if-nez v10, :cond_9

    move v10, v8

    goto :goto_a

    :cond_9
    move v10, v0

    :goto_a
    const-string v11, "Request parcel boundary"

    invoke-static {v10, v11}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 158
    iget-wide v10, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->reqNumber:J

    iget-wide v12, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    cmp-long v10, v10, v12

    if-nez v10, :cond_a

    iget v10, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->operationMode:I

    iget v11, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->operationMode:I

    if-ne v10, v11, :cond_a

    move v10, v8

    goto :goto_b

    :cond_a
    move v10, v0

    :goto_b
    const-string v11, "Request IDs"

    invoke-static {v10, v11}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 159
    iget-object v10, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->settings:[B

    iget-object v11, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->settings:[B

    invoke-static {v10, v11}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v10

    if-eqz v10, :cond_b

    iget-object v10, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->uri:Landroid/net/Uri;

    iget-object v11, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    invoke-virtual {v10, v11}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_b

    move v10, v8

    goto :goto_c

    :cond_b
    move v10, v0

    :goto_c
    const-string v11, "Request payload/URI"

    invoke-static {v10, v11}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 160
    iget-wide v10, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->latitude:D

    iget-wide v12, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->latitude:D

    cmpl-double v10, v10, v12

    if-nez v10, :cond_c

    iget-wide v10, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->longitude:D

    iget-wide v12, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->longitude:D

    cmpl-double v10, v10, v12

    if-nez v10, :cond_c

    iget v10, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->iso:I

    if-ne v10, v3, :cond_c

    iget v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->ev:I

    if-ne v3, v4, :cond_c

    iget-wide v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->exposureTimeUs:J

    cmp-long v3, v3, v5

    if-nez v3, :cond_c

    iget-object v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->makerNote:Ljava/lang/String;

    iget-object v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->makerNote:Ljava/lang/String;

    .line 161
    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_c

    move v3, v8

    goto :goto_d

    :cond_c
    move v3, v0

    :goto_d
    const-string v4, "Capture metadata"

    .line 160
    invoke-static {v3, v4}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 162
    iget-boolean v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->isBrust:Z

    iget-boolean v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBurst:Z

    if-ne v3, v4, :cond_d

    iget-boolean v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->isPreCapture:Z

    iget-boolean v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isPreCapture:Z

    if-ne v3, v4, :cond_d

    iget-boolean v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->isUltraHdrOn:Z

    iget-boolean v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUltraHdrOn:Z

    if-ne v3, v4, :cond_d

    iget-boolean v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->isBorderWatermarkOn:Z

    iget-boolean v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBorderWatermarkOn:Z

    if-ne v3, v4, :cond_d

    iget-boolean v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->isLivePhoto:Z

    iget-boolean v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isLivePhoto:Z

    if-ne v3, v4, :cond_d

    iget-boolean v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->isSupportUfs:Z

    iget-boolean v4, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isSupportUfs:Z

    if-ne v3, v4, :cond_d

    iget-boolean v3, v9, Lcom/anx/camera/bridge/old/NtCamUfsRequest;->isUfsSave:Z

    iget-boolean v2, v2, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUfsSave:Z

    if-ne v3, v2, :cond_d

    goto :goto_e

    :cond_d
    move v8, v0

    :goto_e
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Old boolean field sequence "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v8, v2}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 166
    invoke-virtual {v7}, Landroid/os/Parcel;->recycle()V

    .line 128
    add-int/lit8 v1, v1, 0x1

    goto/16 :goto_0

    .line 166
    :catchall_0
    move-exception v0

    invoke-virtual {v7}, Landroid/os/Parcel;->recycle()V

    throw v0

    .line 168
    :cond_e
    return-void

    nop

    :array_0
    .array-data 1
        0x1t
        0x2t
        0x3t
    .end array-data
.end method

.method private static testRpcMapping()V
    .locals 15
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 213
    const/4 v0, 0x0

    filled-new-array {v0}, [I

    move-result-object v1

    .line 214
    new-instance v2, Lcom/anx/camera/bridge/CodecInstrumentation$1;

    invoke-direct {v2, v1}, Lcom/anx/camera/bridge/CodecInstrumentation$1;-><init>([I)V

    .line 225
    invoke-static {v2}, Lcom/anx/camera/bridge/Nos41UfsBridge;->wrap(Landroid/os/IBinder;)Landroid/os/IBinder;

    move-result-object v2

    .line 226
    const/16 v3, 0xd

    const/16 v4, 0xe

    const/16 v5, 0xc

    filled-new-array {v3, v4, v5}, [I

    move-result-object v6

    move v7, v0

    :goto_0
    const/4 v8, 0x1

    const/4 v9, 0x3

    if-ge v7, v9, :cond_5

    aget v9, v6, v7

    .line 227
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v10

    .line 228
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v11

    .line 230
    :try_start_0
    const-string v12, "com.nothing.algolib.cameraufs.INtCamUfsSession"

    invoke-virtual {v10, v12}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 231
    if-ne v9, v5, :cond_0

    .line 232
    new-instance v12, Landroid/os/Bundle;

    invoke-direct {v12}, Landroid/os/Bundle;-><init>()V

    .line 233
    const-string v13, "ncf_jpeg_max_size"

    const v14, 0x1e240

    invoke-virtual {v12, v13, v14}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 234
    invoke-virtual {v10, v12, v0}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 236
    :cond_0
    invoke-interface {v2, v9, v10, v11, v0}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result v12

    const-string v13, "Adapter transaction handled"

    invoke-static {v12, v13}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 237
    invoke-virtual {v11}, Landroid/os/Parcel;->readException()V

    .line 238
    if-ne v9, v3, :cond_2

    invoke-virtual {v11}, Landroid/os/Parcel;->readInt()I

    move-result v12

    const/4 v13, 0x7

    if-ne v12, v13, :cond_1

    move v12, v8

    goto :goto_1

    :cond_1
    move v12, v0

    :goto_1
    const-string v13, "Processing count remapped"

    invoke-static {v12, v13}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 239
    :cond_2
    if-ne v9, v4, :cond_4

    invoke-virtual {v11}, Landroid/os/Parcel;->readInt()I

    move-result v9

    const/4 v12, -0x1

    if-ne v9, v12, :cond_3

    goto :goto_2

    :cond_3
    move v8, v0

    :goto_2
    const-string v9, "Total count unknown sentinel"

    invoke-static {v8, v9}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 240
    :cond_4
    invoke-virtual {v10}, Landroid/os/Parcel;->recycle()V

    invoke-virtual {v11}, Landroid/os/Parcel;->recycle()V

    .line 226
    add-int/lit8 v7, v7, 0x1

    goto :goto_0

    .line 240
    :catchall_0
    move-exception v0

    invoke-virtual {v10}, Landroid/os/Parcel;->recycle()V

    invoke-virtual {v11}, Landroid/os/Parcel;->recycle()V

    throw v0

    .line 242
    :cond_5
    aget v1, v1, v0

    if-ne v1, v8, :cond_6

    move v0, v8

    :cond_6
    const-string v1, "Optional methods did not call incompatible old transaction"

    invoke-static {v0, v1}, Lcom/anx/camera/bridge/CodecInstrumentation;->check(ZLjava/lang/String;)V

    .line 243
    return-void
.end method


# virtual methods
.method public onCreate(Landroid/os/Bundle;)V
    .locals 0

    .line 14
    invoke-virtual {p0}, Lcom/anx/camera/bridge/CodecInstrumentation;->start()V

    return-void
.end method

.method public onStart()V
    .locals 5

    .line 17
    const-string v0, "stream"

    new-instance v1, Landroid/os/Bundle;

    invoke-direct {v1}, Landroid/os/Bundle;-><init>()V

    .line 19
    :try_start_0
    invoke-static {}, Lcom/anx/camera/bridge/CodecInstrumentation;->testRequestFlags()V

    .line 20
    invoke-static {}, Lcom/anx/camera/bridge/CodecInstrumentation;->testImages()V

    .line 21
    invoke-static {}, Lcom/anx/camera/bridge/CodecInstrumentation;->testRpcMapping()V

    .line 22
    invoke-static {}, Lcom/anx/camera/bridge/CodecInstrumentation;->testMetadataWriter()V

    .line 23
    invoke-static {}, Lcom/anx/camera/bridge/MetadataCompatibility;->verifyMetadata()V

    .line 24
    invoke-direct {p0}, Lcom/anx/camera/bridge/CodecInstrumentation;->testPhotoUriGrant()V

    .line 25
    invoke-direct {p0}, Lcom/anx/camera/bridge/CodecInstrumentation;->testOwnerPublication()V

    .line 26
    const-string v2, "PASS: old reader request flags/metadata, null arrays, HardwareBuffer/fence/crop, RPC remap, unsupported optional methods, public metadata writer allocation/dequeue, real native metadata set/pointer/entry-count, owner MediaStore URI grant to factory UID, invalid JPEG stays pending and valid JPEG publishes via owner provider\n"

    invoke-virtual {v1, v0, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 27
    const/4 v2, -0x1

    invoke-virtual {p0, v2, v1}, Lcom/anx/camera/bridge/CodecInstrumentation;->finish(ILandroid/os/Bundle;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 31
    goto :goto_0

    .line 28
    :catchall_0
    move-exception v2

    .line 29
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "FAIL: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-static {v2}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 30
    const/4 v0, 0x0

    invoke-virtual {p0, v0, v1}, Lcom/anx/camera/bridge/CodecInstrumentation;->finish(ILandroid/os/Bundle;)V

    .line 32
    :goto_0
    return-void
.end method
