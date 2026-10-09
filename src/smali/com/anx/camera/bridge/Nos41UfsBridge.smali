.class public final Lcom/anx/camera/bridge/Nos41UfsBridge;
.super Landroid/os/Binder;
.source "Nos41UfsBridge.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;
    }
.end annotation


# static fields
.field private static final DESCRIPTOR:Ljava/lang/String; = "com.nothing.algolib.cameraufs.INtCamUfsSession"

.field private static final TAG:Ljava/lang/String; = "Nos41UfsBridge"


# instance fields
.field private final context:Landroid/content/Context;

.field private final stock:Landroid/os/IBinder;


# direct methods
.method private constructor <init>(Landroid/content/Context;Landroid/os/IBinder;)V
    .locals 0

    .line 22
    invoke-direct {p0}, Landroid/os/Binder;-><init>()V

    .line 23
    if-nez p1, :cond_0

    const/4 p1, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    :goto_0
    iput-object p1, p0, Lcom/anx/camera/bridge/Nos41UfsBridge;->context:Landroid/content/Context;

    .line 24
    iput-object p2, p0, Lcom/anx/camera/bridge/Nos41UfsBridge;->stock:Landroid/os/IBinder;

    .line 25
    return-void
.end method

.method private static closeBuffer(Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;)V
    .locals 5

    .line 348
    if-eqz p0, :cond_3

    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->buffer:Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->buffer:Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;

    iget-object v0, v0, Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;->fds:[Landroid/os/ParcelFileDescriptor;

    if-nez v0, :cond_0

    goto :goto_2

    .line 349
    :cond_0
    iget-object p0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->buffer:Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;

    iget-object p0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;->fds:[Landroid/os/ParcelFileDescriptor;

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_2

    aget-object v2, p0, v1

    .line 350
    if-eqz v2, :cond_1

    :try_start_0
    invoke-virtual {v2}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v2

    const-string v3, "Nos41UfsBridge"

    const-string v4, "Buffer FD close"

    invoke-static {v3, v4, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 349
    :cond_1
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 352
    :cond_2
    return-void

    .line 348
    :cond_3
    :goto_2
    return-void
.end method

.method private static closeImage(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V
    .locals 2

    .line 328
    if-nez p0, :cond_0

    return-void

    .line 329
    :cond_0
    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    invoke-virtual {v0}, Landroid/hardware/HardwareBuffer;->close()V

    .line 330
    :cond_1
    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->fence:Landroid/os/ParcelFileDescriptor;

    if-eqz v0, :cond_2

    :try_start_0
    iget-object p0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->fence:Landroid/os/ParcelFileDescriptor;

    invoke-virtual {p0}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    const-string v0, "Nos41UfsBridge"

    const-string v1, "Fence close"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 331
    :cond_2
    :goto_0
    return-void
.end method

.method private static closeImages([Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V
    .locals 3

    .line 334
    if-eqz p0, :cond_0

    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_0

    aget-object v2, p0, v1

    invoke-static {v2}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeImage(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 335
    :cond_0
    return-void
.end method

.method private static closeRequestBuffers(Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;)V
    .locals 5

    .line 338
    if-nez p0, :cond_0

    return-void

    .line 339
    :cond_0
    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->inputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->inputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    array-length v2, v0

    move v3, v1

    :goto_0
    if-ge v3, v2, :cond_1

    aget-object v4, v0, v3

    .line 340
    invoke-static {v4}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeBuffer(Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;)V

    .line 339
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 342
    :cond_1
    iget-object v0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->outputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    if-eqz v0, :cond_2

    iget-object p0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->outputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    array-length v0, p0

    :goto_1
    if-ge v1, v0, :cond_2

    aget-object v2, p0, v1

    .line 343
    invoke-static {v2}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeBuffer(Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;)V

    .line 342
    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 345
    :cond_2
    return-void
.end method

.method private static finishSized(Landroid/os/Parcel;I)V
    .locals 1

    .line 321
    invoke-virtual {p0}, Landroid/os/Parcel;->dataPosition()I

    move-result v0

    .line 322
    invoke-virtual {p0, p1}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 323
    sub-int p1, v0, p1

    invoke-virtual {p0, p1}, Landroid/os/Parcel;->writeInt(I)V

    .line 324
    invoke-virtual {p0, v0}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 325
    return-void
.end method

.method private static imageSummary(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)Ljava/lang/String;
    .locals 4

    .line 212
    if-nez p0, :cond_0

    const-string p0, "image=null"

    return-object p0

    .line 213
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "format="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->format:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " width="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->width:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " height="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->height:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " timestamp="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->timestamp:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " planes="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->planeCount:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " slaver="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-boolean v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->slaverImage:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " tuning="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-boolean v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->tuningImage:Z

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " crop="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->crop:Landroid/graphics/Rect;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " hardwareBuffer="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_1

    move v1, v2

    goto :goto_0

    :cond_1
    move v1, v3

    :goto_0
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " fence="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object p0, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->fence:Landroid/os/ParcelFileDescriptor;

    if-eqz p0, :cond_2

    goto :goto_1

    :cond_2
    move v2, v3

    :goto_1
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static logBuffers(JLjava/lang/String;[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;)V
    .locals 5

    .line 241
    if-nez p3, :cond_0

    return-void

    .line 242
    :cond_0
    const/4 v0, 0x0

    :goto_0
    array-length v1, p3

    if-ge v0, v1, :cond_4

    .line 243
    aget-object v1, p3, v0

    .line 244
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "PROCESS_BUFFER req="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0, p1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " direction="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " index="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 245
    if-nez v1, :cond_1

    const-string v1, " null"

    goto :goto_3

    .line 248
    :cond_1
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, " format="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->format:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " width="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->width:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " height="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->height:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " phyId="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->phyCameraId:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " tuningSize="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->tuningSize:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " strides="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->strides:[I

    .line 247
    invoke-static {v4}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " fds="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 248
    iget-object v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->buffer:Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;

    if-eqz v4, :cond_3

    iget-object v4, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->buffer:Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;

    iget-object v4, v4, Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;->fds:[Landroid/os/ParcelFileDescriptor;

    if-nez v4, :cond_2

    goto :goto_1

    :cond_2
    iget-object v1, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;->buffer:Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;

    iget-object v1, v1, Lcom/nothing/algolib/cameraufs/NtCamUfsHandle;->fds:[Landroid/os/ParcelFileDescriptor;

    array-length v1, v1

    goto :goto_2

    :cond_3
    :goto_1
    const/4 v1, -0x1

    :goto_2
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_3
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 244
    const-string v2, "Nos41UfsBridge"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 242
    add-int/lit8 v0, v0, 0x1

    goto/16 :goto_0

    .line 250
    :cond_4
    return-void
.end method

.method private static logCapture(Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V
    .locals 8

    .line 221
    const-string v0, "Nos41UfsBridge"

    if-nez p0, :cond_0

    const-string p0, "PROCESS_IN request=null"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 222
    :cond_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "PROCESS_IN req="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-wide v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " opmode=0x"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->operationMode:I

    invoke-static {v2}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " logicalId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->logicalCameraId:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " cameraId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->cameraId:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " settingsBytes="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 224
    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->settings:[B

    const/4 v3, -0x1

    if-nez v2, :cond_1

    move v2, v3

    goto :goto_0

    :cond_1
    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->settings:[B

    array-length v2, v2

    :goto_0
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " inputBuffers="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 225
    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->inputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    if-nez v2, :cond_2

    move v2, v3

    goto :goto_1

    :cond_2
    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->inputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    array-length v2, v2

    :goto_1
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " outputBuffers="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 226
    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->outputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    if-nez v2, :cond_3

    move v2, v3

    goto :goto_2

    :cond_3
    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->outputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    array-length v2, v2

    :goto_2
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " inImages="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 227
    if-nez p1, :cond_4

    move v2, v3

    goto :goto_3

    :cond_4
    array-length v2, p1

    :goto_3
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " outImages="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    if-nez p2, :cond_5

    goto :goto_4

    :cond_5
    array-length v3, p2

    :goto_4
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " burst="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBurst:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " preCapture="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isPreCapture:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " ultraHdr="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUltraHdrOn:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " borderWatermark="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBorderWatermarkOn:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " livePhoto="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isLivePhoto:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " doc="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isDocDetectionOn:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " supportUfs="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isSupportUfs:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " ufsSave="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUfsSave:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " direct="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isDirectProcess:Z

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " watermarkOptions="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->watermarkOptions:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " hasWatermarkInfos="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->watermarkInfos:Ljava/lang/String;

    const/4 v3, 0x0

    if-eqz v2, :cond_6

    const/4 v2, 0x1

    goto :goto_5

    :cond_6
    move v2, v3

    :goto_5
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " uri="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 222
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 234
    iget-wide v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    const-string v4, "input"

    iget-object v5, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->inputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    invoke-static {v1, v2, v4, v5}, Lcom/anx/camera/bridge/Nos41UfsBridge;->logBuffers(JLjava/lang/String;[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;)V

    .line 235
    iget-wide v1, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    const-string v4, "output"

    iget-object v5, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->outputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    invoke-static {v1, v2, v4, v5}, Lcom/anx/camera/bridge/Nos41UfsBridge;->logBuffers(JLjava/lang/String;[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;)V

    .line 236
    const-string v1, " "

    const-string v2, "PROCESS_IMAGE req="

    if-eqz p1, :cond_7

    move v4, v3

    :goto_6
    array-length v5, p1

    if-ge v4, v5, :cond_7

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    iget-wide v6, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    invoke-virtual {v5, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, " input="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    aget-object v6, p1, v4

    invoke-static {v6}, Lcom/anx/camera/bridge/Nos41UfsBridge;->imageSummary(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    add-int/lit8 v4, v4, 0x1

    goto :goto_6

    .line 237
    :cond_7
    if-eqz p2, :cond_8

    :goto_7
    array-length p1, p2

    if-ge v3, p1, :cond_8

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-wide v4, p0, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    invoke-virtual {p1, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v4, " output="

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    aget-object v4, p2, v3

    invoke-static {v4}, Lcom/anx/camera/bridge/Nos41UfsBridge;->imageSummary(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    add-int/lit8 v3, v3, 0x1

    goto :goto_7

    .line 238
    :cond_8
    return-void
.end method

.method private static logScalar(ILandroid/os/Parcel;)V
    .locals 7

    .line 196
    invoke-virtual {p1}, Landroid/os/Parcel;->dataPosition()I

    move-result v0

    .line 198
    const/4 v1, 0x1

    const-string v2, "Nos41UfsBridge"

    if-ne p0, v1, :cond_0

    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "REGISTER_CALLBACK binder="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/os/Parcel;->readStrongBinder()Landroid/os/IBinder;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    .line 208
    :catchall_0
    move-exception p0

    goto/16 :goto_1

    .line 199
    :cond_0
    :goto_0
    const/4 v1, 0x2

    if-eq p0, v1, :cond_1

    const/16 v1, 0xb

    if-ne p0, v1, :cond_2

    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "PARAM_IN modern="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " value="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/os/Parcel;->readString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 200
    :cond_2
    const/4 v1, 0x4

    const-string v3, " req="

    const/16 v4, 0x8

    if-ne p0, v1, :cond_3

    .line 201
    :try_start_1
    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v1

    .line 202
    invoke-virtual {p1}, Landroid/os/Parcel;->dataSize()I

    move-result v5

    sub-int/2addr v5, v4

    invoke-virtual {p1, v5}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 203
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "META_IN count="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v5

    invoke-virtual {v1, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 205
    :cond_3
    const/4 v1, 0x7

    if-eq p0, v1, :cond_4

    const/16 v1, 0xa

    if-ne p0, v1, :cond_5

    :cond_4
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "REQUEST_ID modern="

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/os/Parcel;->readLong()J

    move-result-wide v5

    invoke-virtual {v1, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 206
    :cond_5
    const/16 v1, 0x9

    if-ne p0, v1, :cond_6

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "CAN_CAPTURE mode="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/os/Parcel;->readInt()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 207
    :cond_6
    if-ne p0, v4, :cond_7

    const-string p0, "CLOSE_SESSION"

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 208
    :cond_7
    invoke-virtual {p1, v0}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 209
    return-void

    .line 208
    :goto_1
    invoke-virtual {p1, v0}, Landroid/os/Parcel;->setDataPosition(I)V

    throw p0
.end method

.method public static wrap(Landroid/content/Context;Landroid/os/IBinder;)Landroid/os/IBinder;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 32
    const-string v0, "com.nothing.algolib.cameraufs.INtCamUfsSession"

    invoke-interface {p1}, Landroid/os/IBinder;->getInterfaceDescriptor()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 35
    const-string v0, "Nos41UfsBridge"

    const-string v1, "Using factory NOS4.1 UFS protocol adapter"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 36
    new-instance v0, Lcom/anx/camera/bridge/Nos41UfsBridge;

    invoke-direct {v0, p0, p1}, Lcom/anx/camera/bridge/Nos41UfsBridge;-><init>(Landroid/content/Context;Landroid/os/IBinder;)V

    return-object v0

    .line 33
    :cond_0
    new-instance p0, Landroid/os/RemoteException;

    const-string p1, "Unexpected stock UFS Binder descriptor"

    invoke-direct {p0, p1}, Landroid/os/RemoteException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static wrap(Landroid/os/IBinder;)Landroid/os/IBinder;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 28
    const/4 v0, 0x0

    invoke-static {v0, p0}, Lcom/anx/camera/bridge/Nos41UfsBridge;->wrap(Landroid/content/Context;Landroid/os/IBinder;)Landroid/os/IBinder;

    move-result-object p0

    return-object p0
.end method

.method public static writeOldImage(Landroid/os/Parcel;Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V
    .locals 4

    .line 259
    const/4 v0, 0x0

    if-nez p1, :cond_0

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    return-void

    .line 260
    :cond_0
    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Landroid/os/Parcel;->writeInt(I)V

    .line 261
    invoke-virtual {p0}, Landroid/os/Parcel;->dataPosition()I

    move-result v1

    .line 262
    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 263
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->format:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 264
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->width:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 265
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->height:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 266
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->transform:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 267
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->scalingMode:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 268
    iget-wide v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->timestamp:J

    invoke-virtual {p0, v2, v3}, Landroid/os/Parcel;->writeLong(J)V

    .line 269
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->planeCount:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 270
    iget-boolean v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->slaverImage:Z

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 271
    iget-boolean v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->tuningImage:Z

    if-eqz v2, :cond_1

    const-string v2, "Nos41UfsBridge"

    const-string v3, "NOS4.1 image has no tuningImage flag; buffer retained"

    invoke-static {v2, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 272
    :cond_1
    iget-object v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->crop:Landroid/graphics/Rect;

    invoke-virtual {p0, v2, v0}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 273
    iget-object v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->buffer:Landroid/hardware/HardwareBuffer;

    invoke-virtual {p0, v2, v0}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 274
    iget-object p1, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->fence:Landroid/os/ParcelFileDescriptor;

    invoke-virtual {p0, p1, v0}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 275
    invoke-static {p0, v1}, Lcom/anx/camera/bridge/Nos41UfsBridge;->finishSized(Landroid/os/Parcel;I)V

    .line 276
    return-void
.end method

.method public static writeOldImages(Landroid/os/Parcel;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V
    .locals 3

    .line 253
    if-nez p1, :cond_0

    const/4 p1, -0x1

    invoke-virtual {p0, p1}, Landroid/os/Parcel;->writeInt(I)V

    return-void

    .line 254
    :cond_0
    array-length v0, p1

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 255
    array-length v0, p1

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p1, v1

    invoke-static {p0, v2}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldImage(Landroid/os/Parcel;Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 256
    :cond_1
    return-void
.end method

.method public static writeOldRequest(Landroid/os/Parcel;Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;)V
    .locals 4

    .line 279
    const/4 v0, 0x0

    if-nez p1, :cond_0

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    return-void

    .line 280
    :cond_0
    const/4 v1, 0x1

    invoke-virtual {p0, v1}, Landroid/os/Parcel;->writeInt(I)V

    .line 281
    invoke-virtual {p0}, Landroid/os/Parcel;->dataPosition()I

    move-result v1

    .line 282
    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 283
    iget-wide v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    invoke-virtual {p0, v2, v3}, Landroid/os/Parcel;->writeLong(J)V

    .line 284
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->operationMode:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 285
    iget v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->logicalCameraId:I

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeInt(I)V

    .line 286
    iget-object v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->settings:[B

    invoke-virtual {p0, v2}, Landroid/os/Parcel;->writeByteArray([B)V

    .line 287
    iget-object v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->inputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    invoke-virtual {p0, v2, v0}, Landroid/os/Parcel;->writeTypedArray([Landroid/os/Parcelable;I)V

    .line 288
    iget-object v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->outputBuffers:[Lcom/nothing/algolib/cameraufs/NtCamUfsBuffer;

    invoke-virtual {p0, v2, v0}, Landroid/os/Parcel;->writeTypedArray([Landroid/os/Parcelable;I)V

    .line 289
    iget-object v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    invoke-virtual {p0, v2, v0}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 290
    iget-object v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->desc:Ljava/lang/String;

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 291
    iget-wide v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->latitude:D

    invoke-virtual {p0, v2, v3}, Landroid/os/Parcel;->writeDouble(D)V

    .line 292
    iget-wide v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->longitude:D

    invoke-virtual {p0, v2, v3}, Landroid/os/Parcel;->writeDouble(D)V

    .line 293
    iget-object v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->cameraId:Ljava/lang/String;

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 294
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->flashMode:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 295
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->focalLength:F

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeFloat(F)V

    .line 296
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->awbMode:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 297
    iget-wide v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->exposureTimeUs:J

    invoke-virtual {p0, v2, v3}, Landroid/os/Parcel;->writeLong(J)V

    .line 298
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->lensAperture:F

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeFloat(F)V

    .line 299
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->postRawSensitivityBoost:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 300
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->iso:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 301
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->ev:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 302
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->stepDenominator:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 303
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->stepNumerator:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 304
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->focus:F

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeFloat(F)V

    .line 305
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->efl35:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 306
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->overrideEv:F

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeFloat(F)V

    .line 307
    iget v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->overrideIso:I

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 308
    iget-object v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->makerNote:Ljava/lang/String;

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 309
    iget-wide v2, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->clickTimestamps:J

    invoke-virtual {p0, v2, v3}, Landroid/os/Parcel;->writeLong(J)V

    .line 310
    iget-boolean v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBurst:Z

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 311
    iget-boolean v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isPreCapture:Z

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 312
    iget-boolean v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUltraHdrOn:Z

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 313
    iget-boolean v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isBorderWatermarkOn:Z

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 314
    iget-boolean v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isLivePhoto:Z

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 315
    iget-boolean v0, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isSupportUfs:Z

    invoke-virtual {p0, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 316
    iget-boolean p1, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isUfsSave:Z

    invoke-virtual {p0, p1}, Landroid/os/Parcel;->writeInt(I)V

    .line 317
    invoke-static {p0, v1}, Lcom/anx/camera/bridge/Nos41UfsBridge;->finishSized(Landroid/os/Parcel;I)V

    .line 318
    return-void
.end method


# virtual methods
.method protected onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    .locals 21
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 40
    move-object/from16 v0, p0

    move/from16 v1, p1

    move-object/from16 v2, p2

    move-object/from16 v3, p3

    move/from16 v4, p4

    const-string v5, "PFD close"

    const-string v6, " old="

    const v7, 0x5f4e5446

    const-string v8, "com.nothing.algolib.cameraufs.INtCamUfsSession"

    const/4 v9, 0x1

    if-ne v1, v7, :cond_0

    .line 41
    invoke-virtual {v3, v8}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    .line 42
    return v9

    .line 44
    :cond_0
    if-lt v1, v9, :cond_1c

    const/16 v7, 0xe

    if-le v1, v7, :cond_1

    goto/16 :goto_24

    .line 45
    :cond_1
    invoke-virtual {v2, v8}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 46
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "RPC_IN modern="

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v11, " bytes="

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v2}, Landroid/os/Parcel;->dataAvail()I

    move-result v12

    invoke-virtual {v10, v12}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v12, " flags="

    invoke-virtual {v10, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    const-string v12, "Nos41UfsBridge"

    invoke-static {v12, v10}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 47
    const/16 v10, 0xc

    const/4 v13, 0x0

    if-ne v1, v10, :cond_5

    .line 48
    sget-object v0, Landroid/os/Bundle;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v2, v0}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/Bundle;

    .line 49
    invoke-virtual {v2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 50
    if-eqz v0, :cond_4

    .line 51
    invoke-virtual {v0}, Landroid/os/Bundle;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    const-string v4, "ncf_jpeg_max_size"

    if-eqz v2, :cond_3

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 52
    invoke-virtual {v4, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2

    .line 55
    goto :goto_0

    .line 53
    :cond_2
    new-instance v0, Landroid/os/RemoteException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "NOS4.1 does not support Bundle parameter "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/RemoteException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 56
    :cond_3
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "NOS4.1 uses its own JPEG buffer sizing; NOS5 ncf_jpeg_max_size="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 57
    invoke-virtual {v0, v4, v13}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " not applied"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 56
    invoke-static {v12, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 59
    :cond_4
    invoke-virtual {v3}, Landroid/os/Parcel;->writeNoException()V

    .line 60
    return v9

    .line 62
    :cond_5
    if-ne v1, v7, :cond_6

    .line 63
    invoke-virtual {v2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 64
    const-string v0, "NOS4.1 total UFS count unavailable; returning unknown -1 for exit analytics"

    invoke-static {v12, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 65
    invoke-virtual {v3}, Landroid/os/Parcel;->writeNoException()V

    .line 66
    const/4 v0, -0x1

    invoke-virtual {v3, v0}, Landroid/os/Parcel;->writeInt(I)V

    .line 67
    return v9

    .line 69
    :cond_6
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v7

    .line 70
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v14

    .line 71
    nop

    .line 72
    nop

    .line 73
    nop

    .line 74
    nop

    .line 75
    nop

    .line 77
    :try_start_0
    invoke-virtual {v7, v8}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V
    :try_end_0
    .catch Landroid/os/RemoteException; {:try_start_0 .. :try_end_0} :catch_f
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_f
    .catchall {:try_start_0 .. :try_end_0} :catchall_f

    .line 78
    const/16 v8, 0xd

    if-ne v1, v8, :cond_7

    goto :goto_1

    :cond_7
    move v10, v1

    .line 79
    :goto_1
    const/4 v8, 0x3

    if-ne v1, v8, :cond_9

    .line 80
    :try_start_1
    sget-object v8, Landroid/os/ParcelFileDescriptor;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v2, v8}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/os/ParcelFileDescriptor;
    :try_end_1
    .catch Landroid/os/RemoteException; {:try_start_1 .. :try_end_1} :catch_2
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_2
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    .line 81
    nop

    .line 82
    :try_start_2
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v9

    .line 83
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v15

    .line 84
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v18

    .line 85
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v19
    :try_end_2
    .catch Landroid/os/RemoteException; {:try_start_2 .. :try_end_2} :catch_1
    .catch Ljava/lang/RuntimeException; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 86
    move-object/from16 v20, v14

    :try_start_3
    invoke-virtual {v2}, Landroid/os/Parcel;->readLong()J

    move-result-wide v13

    .line 87
    invoke-virtual {v2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 88
    if-nez v18, :cond_8

    if-nez v19, :cond_8

    .line 91
    const/4 v2, 0x0

    invoke-virtual {v7, v8, v2}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 92
    invoke-virtual {v7, v9}, Landroid/os/Parcel;->writeInt(I)V

    .line 93
    invoke-virtual {v7, v15}, Landroid/os/Parcel;->writeInt(I)V

    .line 94
    invoke-virtual {v7, v13, v14}, Landroid/os/Parcel;->writeLong(J)V

    .line 95
    move-object/from16 v19, v5

    move-object v15, v8

    const/4 v9, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/16 v16, 0x0

    goto/16 :goto_10

    .line 89
    :cond_8
    new-instance v0, Landroid/os/RemoteException;

    const-string v2, "NOS4.1 border watermark does not support nonzero offsets"

    invoke-direct {v0, v2}, Landroid/os/RemoteException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_3
    .catch Landroid/os/RemoteException; {:try_start_3 .. :try_end_3} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 159
    :catchall_0
    move-exception v0

    goto :goto_2

    .line 155
    :catch_0
    move-exception v0

    goto :goto_3

    .line 159
    :catchall_1
    move-exception v0

    move-object/from16 v20, v14

    :goto_2
    move-object v1, v0

    move-object v3, v5

    move-object v15, v8

    move-object/from16 v2, v20

    const/4 v9, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    goto/16 :goto_1a

    .line 155
    :catch_1
    move-exception v0

    move-object/from16 v20, v14

    :goto_3
    move-object v3, v5

    move-object v15, v8

    move-object/from16 v2, v20

    const/4 v9, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    goto/16 :goto_1f

    .line 159
    :catchall_2
    move-exception v0

    move-object/from16 v20, v14

    :goto_4
    move-object v1, v0

    move-object v3, v5

    :goto_5
    move-object/from16 v2, v20

    goto/16 :goto_16

    .line 155
    :catch_2
    move-exception v0

    move-object/from16 v20, v14

    :goto_6
    move-object v3, v5

    :goto_7
    move-object/from16 v2, v20

    goto/16 :goto_1b

    .line 95
    :cond_9
    move-object/from16 v20, v14

    const/4 v9, 0x5

    if-ne v1, v9, :cond_c

    .line 96
    :try_start_4
    invoke-virtual {v2}, Landroid/os/Parcel;->readLong()J

    move-result-wide v8

    .line 97
    sget-object v13, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v2, v13}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;
    :try_end_4
    .catch Landroid/os/RemoteException; {:try_start_4 .. :try_end_4} :catch_4
    .catch Ljava/lang/RuntimeException; {:try_start_4 .. :try_end_4} :catch_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_4

    .line 98
    nop

    .line 99
    :try_start_5
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v14

    if-eqz v14, :cond_a

    const/4 v14, 0x1

    goto :goto_8

    :cond_a
    const/4 v14, 0x0

    .line 100
    :goto_8
    invoke-virtual {v2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 101
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v15, "SAVE_IN req="

    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v8, v9}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v15, " processingOnPause="

    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v14}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v15, " "

    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {v13}, Lcom/anx/camera/bridge/Nos41UfsBridge;->imageSummary(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)Ljava/lang/String;

    move-result-object v15

    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v12, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 102
    if-eqz v14, :cond_b

    const-string v2, "NOS4.1 saveImage has no processingOnPause argument"

    invoke-static {v12, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 103
    :cond_b
    invoke-virtual {v7, v8, v9}, Landroid/os/Parcel;->writeLong(J)V

    .line 104
    invoke-static {v7, v13}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldImage(Landroid/os/Parcel;Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V
    :try_end_5
    .catch Landroid/os/RemoteException; {:try_start_5 .. :try_end_5} :catch_3
    .catch Ljava/lang/RuntimeException; {:try_start_5 .. :try_end_5} :catch_3
    .catchall {:try_start_5 .. :try_end_5} :catchall_3

    .line 105
    move-object/from16 v19, v5

    move-object/from16 v16, v13

    const/4 v9, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    goto/16 :goto_10

    .line 159
    :catchall_3
    move-exception v0

    move-object v1, v0

    move-object v3, v5

    move-object/from16 v16, v13

    move-object/from16 v2, v20

    const/4 v9, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    goto/16 :goto_22

    .line 155
    :catch_3
    move-exception v0

    move-object v3, v5

    move-object/from16 v16, v13

    move-object/from16 v2, v20

    const/4 v9, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    goto/16 :goto_20

    .line 159
    :catchall_4
    move-exception v0

    goto/16 :goto_4

    .line 155
    :catch_4
    move-exception v0

    goto/16 :goto_6

    .line 105
    :cond_c
    const/4 v9, 0x6

    if-ne v1, v9, :cond_12

    .line 106
    :try_start_6
    sget-object v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v2, v9}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;
    :try_end_6
    .catch Landroid/os/RemoteException; {:try_start_6 .. :try_end_6} :catch_9
    .catch Ljava/lang/RuntimeException; {:try_start_6 .. :try_end_6} :catch_9
    .catchall {:try_start_6 .. :try_end_6} :catchall_9

    .line 107
    nop

    .line 108
    nop

    .line 109
    nop

    .line 110
    :try_start_7
    sget-object v13, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v2, v13}, Landroid/os/Parcel;->createTypedArray(Landroid/os/Parcelable$Creator;)[Ljava/lang/Object;

    move-result-object v13

    check-cast v13, [Lcom/nothing/algolib/cameraufs/NtCamUfsImage;
    :try_end_7
    .catch Landroid/os/RemoteException; {:try_start_7 .. :try_end_7} :catch_8
    .catch Ljava/lang/RuntimeException; {:try_start_7 .. :try_end_7} :catch_8
    .catchall {:try_start_7 .. :try_end_7} :catchall_8

    .line 111
    nop

    .line 112
    :try_start_8
    sget-object v14, Lcom/nothing/algolib/cameraufs/NtCamUfsImage;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {v2, v14}, Landroid/os/Parcel;->createTypedArray(Landroid/os/Parcelable$Creator;)[Ljava/lang/Object;

    move-result-object v14

    check-cast v14, [Lcom/nothing/algolib/cameraufs/NtCamUfsImage;
    :try_end_8
    .catch Landroid/os/RemoteException; {:try_start_8 .. :try_end_8} :catch_7
    .catch Ljava/lang/RuntimeException; {:try_start_8 .. :try_end_8} :catch_7
    .catchall {:try_start_8 .. :try_end_8} :catchall_7

    .line 113
    nop

    .line 114
    :try_start_9
    invoke-virtual {v2}, Landroid/os/Parcel;->enforceNoDataAvail()V

    .line 115
    invoke-static {v9, v13, v14}, Lcom/anx/camera/bridge/Nos41UfsBridge;->logCapture(Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 116
    if-eqz v9, :cond_e

    iget-object v2, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    if-eqz v2, :cond_e

    .line 117
    iget-object v2, v0, Lcom/anx/camera/bridge/Nos41UfsBridge;->context:Landroid/content/Context;

    if-eqz v2, :cond_d

    .line 118
    iget-object v2, v0, Lcom/anx/camera/bridge/Nos41UfsBridge;->context:Landroid/content/Context;

    iget-object v15, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    invoke-static {v2, v15}, Lcom/anx/camera/bridge/PhotoOutputProvider;->delegate(Landroid/content/Context;Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v2

    iput-object v2, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    .line 119
    iget-object v2, v0, Lcom/anx/camera/bridge/Nos41UfsBridge;->context:Landroid/content/Context;

    const-string v15, "com.nothing.camera"

    iget-object v8, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;
    :try_end_9
    .catch Landroid/os/RemoteException; {:try_start_9 .. :try_end_9} :catch_6
    .catch Ljava/lang/RuntimeException; {:try_start_9 .. :try_end_9} :catch_6
    .catchall {:try_start_9 .. :try_end_9} :catchall_6

    move-object/from16 v19, v5

    const/4 v5, 0x3

    :try_start_a
    invoke-virtual {v2, v15, v8, v5}, Landroid/content/Context;->grantUriPermission(Ljava/lang/String;Landroid/net/Uri;I)V

    .line 121
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "PHOTO_URI_GRANTED req="

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-wide v3, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    invoke-virtual {v2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " recipient=com.nothing.camera read/write uri="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->uri:Landroid/net/Uri;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v12, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_9

    .line 117
    :cond_d
    move-object/from16 v19, v5

    new-instance v0, Landroid/os/RemoteException;

    const-string v2, "Photo URI delegation requires owner Context"

    invoke-direct {v0, v2}, Landroid/os/RemoteException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 116
    :cond_e
    move-object/from16 v19, v5

    .line 123
    :goto_9
    if-eqz v9, :cond_10

    iget-boolean v2, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isDocDetectionOn:Z

    if-nez v2, :cond_f

    iget-boolean v2, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->isDirectProcess:Z

    if-nez v2, :cond_f

    iget v2, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->watermarkOptions:I

    if-nez v2, :cond_f

    iget-object v2, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->watermarkInfos:Ljava/lang/String;

    if-eqz v2, :cond_10

    .line 125
    :cond_f
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "NOS5-only request fields have no NOS4.1 wire representation, request="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-wide v3, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    invoke-virtual {v2, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v12, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 127
    :cond_10
    invoke-static {v7, v9}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldRequest(Landroid/os/Parcel;Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;)V

    .line 128
    invoke-static {v7, v13}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldImages(Landroid/os/Parcel;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 129
    invoke-static {v7, v14}, Lcom/anx/camera/bridge/Nos41UfsBridge;->writeOldImages(Landroid/os/Parcel;[Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 130
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Forwarding photo request "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    if-nez v9, :cond_11

    const-string v3, "null"

    goto :goto_a

    :cond_11
    iget-wide v3, v9, Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;->reqNumber:J

    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    :goto_a
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v12, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_a
    .catch Landroid/os/RemoteException; {:try_start_a .. :try_end_a} :catch_5
    .catch Ljava/lang/RuntimeException; {:try_start_a .. :try_end_a} :catch_5
    .catchall {:try_start_a .. :try_end_a} :catchall_5

    .line 131
    const/4 v15, 0x0

    const/16 v16, 0x0

    goto/16 :goto_10

    .line 159
    :catchall_5
    move-exception v0

    goto :goto_b

    .line 155
    :catch_5
    move-exception v0

    goto :goto_c

    .line 159
    :catchall_6
    move-exception v0

    move-object/from16 v19, v5

    :goto_b
    move-object v1, v0

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto/16 :goto_19

    .line 155
    :catch_6
    move-exception v0

    move-object/from16 v19, v5

    :goto_c
    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto/16 :goto_1e

    .line 159
    :catchall_7
    move-exception v0

    move-object/from16 v19, v5

    move-object v1, v0

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto/16 :goto_18

    .line 155
    :catch_7
    move-exception v0

    move-object/from16 v19, v5

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto/16 :goto_1d

    .line 159
    :catchall_8
    move-exception v0

    move-object/from16 v19, v5

    move-object v1, v0

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto/16 :goto_17

    .line 155
    :catch_8
    move-exception v0

    move-object/from16 v19, v5

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto/16 :goto_1c

    .line 159
    :catchall_9
    move-exception v0

    move-object/from16 v19, v5

    :goto_d
    move-object v1, v0

    move-object/from16 v3, v19

    goto/16 :goto_5

    .line 155
    :catch_9
    move-exception v0

    move-object/from16 v19, v5

    goto/16 :goto_14

    .line 133
    :cond_12
    move-object/from16 v19, v5

    :try_start_b
    invoke-static/range {p1 .. p2}, Lcom/anx/camera/bridge/Nos41UfsBridge;->logScalar(ILandroid/os/Parcel;)V
    :try_end_b
    .catch Landroid/os/RemoteException; {:try_start_b .. :try_end_b} :catch_e
    .catch Ljava/lang/RuntimeException; {:try_start_b .. :try_end_b} :catch_e
    .catchall {:try_start_b .. :try_end_b} :catchall_e

    .line 134
    const/4 v3, 0x1

    if-ne v1, v3, :cond_14

    :try_start_c
    iget-object v3, v0, Lcom/anx/camera/bridge/Nos41UfsBridge;->context:Landroid/content/Context;

    if-eqz v3, :cond_14

    .line 135
    invoke-virtual {v2}, Landroid/os/Parcel;->readStrongBinder()Landroid/os/IBinder;

    move-result-object v2

    .line 136
    if-nez v2, :cond_13

    const/4 v3, 0x0

    goto :goto_e

    :cond_13
    new-instance v3, Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;

    iget-object v4, v0, Lcom/anx/camera/bridge/Nos41UfsBridge;->context:Landroid/content/Context;

    invoke-direct {v3, v4, v2}, Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;-><init>(Landroid/content/Context;Landroid/os/IBinder;)V

    :goto_e
    invoke-virtual {v7, v3}, Landroid/os/Parcel;->writeStrongBinder(Landroid/os/IBinder;)V
    :try_end_c
    .catch Landroid/os/RemoteException; {:try_start_c .. :try_end_c} :catch_e
    .catch Ljava/lang/RuntimeException; {:try_start_c .. :try_end_c} :catch_e
    .catchall {:try_start_c .. :try_end_c} :catchall_a

    goto :goto_f

    .line 159
    :catchall_a
    move-exception v0

    goto :goto_d

    .line 137
    :cond_14
    :try_start_d
    invoke-virtual {v2}, Landroid/os/Parcel;->dataPosition()I

    move-result v3

    invoke-virtual {v2}, Landroid/os/Parcel;->dataAvail()I

    move-result v4

    invoke-virtual {v7, v2, v3, v4}, Landroid/os/Parcel;->appendFrom(Landroid/os/Parcel;II)V
    :try_end_d
    .catch Landroid/os/RemoteException; {:try_start_d .. :try_end_d} :catch_e
    .catch Ljava/lang/RuntimeException; {:try_start_d .. :try_end_d} :catch_e
    .catchall {:try_start_d .. :try_end_d} :catchall_e

    :goto_f
    nop

    .line 139
    const/4 v9, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    const/16 v16, 0x0

    :goto_10
    :try_start_e
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "RPC_FORWARD modern="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v7}, Landroid/os/Parcel;->dataSize()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v12, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 140
    iget-object v0, v0, Lcom/anx/camera/bridge/Nos41UfsBridge;->stock:Landroid/os/IBinder;
    :try_end_e
    .catch Landroid/os/RemoteException; {:try_start_e .. :try_end_e} :catch_d
    .catch Ljava/lang/RuntimeException; {:try_start_e .. :try_end_e} :catch_d
    .catchall {:try_start_e .. :try_end_e} :catchall_d

    move/from16 v4, p4

    move-object/from16 v2, v20

    :try_start_f
    invoke-interface {v0, v10, v7, v2, v4}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result v0

    if-eqz v0, :cond_1a

    .line 143
    const/4 v0, 0x0

    invoke-virtual {v2, v0}, Landroid/os/Parcel;->setDataPosition(I)V

    .line 144
    invoke-virtual {v2}, Landroid/os/Parcel;->readException()V

    .line 145
    invoke-virtual {v2}, Landroid/os/Parcel;->dataPosition()I

    move-result v0

    .line 146
    const/4 v3, 0x5

    if-eq v1, v3, :cond_15

    const/16 v3, 0x9

    if-eq v1, v3, :cond_15

    const/16 v3, 0xd

    if-ne v1, v3, :cond_17

    :cond_15
    invoke-virtual {v2}, Landroid/os/Parcel;->dataAvail()I

    move-result v3
    :try_end_f
    .catch Landroid/os/RemoteException; {:try_start_f .. :try_end_f} :catch_c
    .catch Ljava/lang/RuntimeException; {:try_start_f .. :try_end_f} :catch_c
    .catchall {:try_start_f .. :try_end_f} :catchall_c

    const/4 v4, 0x4

    if-lt v3, v4, :cond_17

    .line 147
    :try_start_10
    invoke-virtual {v2}, Landroid/os/Parcel;->readInt()I

    move-result v3

    .line 148
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "RPC_RESULT modern="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " value="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 149
    const/16 v4, 0xd

    if-ne v1, v4, :cond_16

    const-string v4, " factoryTotalTrackedRequests"

    goto :goto_11

    :cond_16
    const-string v4, ""

    :goto_11
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 148
    invoke-static {v12, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 150
    invoke-virtual {v2, v0}, Landroid/os/Parcel;->setDataPosition(I)V
    :try_end_10
    .catch Landroid/os/RemoteException; {:try_start_10 .. :try_end_10} :catch_c
    .catch Ljava/lang/RuntimeException; {:try_start_10 .. :try_end_10} :catch_c
    .catchall {:try_start_10 .. :try_end_10} :catchall_b

    goto :goto_12

    .line 159
    :catchall_b
    move-exception v0

    move-object v1, v0

    move-object/from16 v3, v19

    goto/16 :goto_22

    .line 152
    :cond_17
    :goto_12
    :try_start_11
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "RPC_DONE modern="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v3, " replyBytes="

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v2}, Landroid/os/Parcel;->dataSize()I

    move-result v3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v12, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_11
    .catch Landroid/os/RemoteException; {:try_start_11 .. :try_end_11} :catch_c
    .catch Ljava/lang/RuntimeException; {:try_start_11 .. :try_end_11} :catch_c
    .catchall {:try_start_11 .. :try_end_11} :catchall_c

    .line 153
    if-eqz p3, :cond_18

    :try_start_12
    invoke-virtual {v2}, Landroid/os/Parcel;->dataSize()I

    move-result v0

    move-object/from16 v3, p3

    const/4 v4, 0x0

    invoke-virtual {v3, v2, v4, v0}, Landroid/os/Parcel;->appendFrom(Landroid/os/Parcel;II)V
    :try_end_12
    .catch Landroid/os/RemoteException; {:try_start_12 .. :try_end_12} :catch_c
    .catch Ljava/lang/RuntimeException; {:try_start_12 .. :try_end_12} :catch_c
    .catchall {:try_start_12 .. :try_end_12} :catchall_b

    .line 154
    :cond_18
    nop

    .line 159
    invoke-virtual {v7}, Landroid/os/Parcel;->recycle()V

    .line 160
    invoke-virtual {v2}, Landroid/os/Parcel;->recycle()V

    .line 161
    if-eqz v15, :cond_19

    :try_start_13
    invoke-virtual {v15}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_13
    .catch Ljava/io/IOException; {:try_start_13 .. :try_end_13} :catch_a

    goto :goto_13

    :catch_a
    move-exception v0

    move-object/from16 v3, v19

    invoke-static {v12, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 162
    :cond_19
    :goto_13
    invoke-static/range {v16 .. v16}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeImage(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 163
    invoke-static {v13}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeImages([Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 164
    invoke-static {v14}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeImages([Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 165
    invoke-static {v9}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeRequestBuffers(Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;)V

    .line 154
    const/16 v17, 0x1

    return v17

    .line 141
    :cond_1a
    move-object/from16 v3, v19

    :try_start_14
    new-instance v0, Landroid/os/RemoteException;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Factory UFS transaction unhandled: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-direct {v0, v4}, Landroid/os/RemoteException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_14
    .catch Landroid/os/RemoteException; {:try_start_14 .. :try_end_14} :catch_b
    .catch Ljava/lang/RuntimeException; {:try_start_14 .. :try_end_14} :catch_b
    .catchall {:try_start_14 .. :try_end_14} :catchall_10

    .line 155
    :catch_b
    move-exception v0

    goto :goto_20

    .line 159
    :catchall_c
    move-exception v0

    move-object/from16 v3, v19

    goto :goto_21

    .line 155
    :catch_c
    move-exception v0

    move-object/from16 v3, v19

    goto :goto_20

    .line 159
    :catchall_d
    move-exception v0

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto :goto_21

    .line 155
    :catch_d
    move-exception v0

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto :goto_20

    .line 159
    :catchall_e
    move-exception v0

    move-object/from16 v3, v19

    move-object/from16 v2, v20

    goto :goto_15

    .line 155
    :catch_e
    move-exception v0

    :goto_14
    move-object/from16 v3, v19

    goto/16 :goto_7

    .line 159
    :catchall_f
    move-exception v0

    move-object v3, v5

    move-object v2, v14

    :goto_15
    move-object v1, v0

    :goto_16
    const/4 v9, 0x0

    :goto_17
    const/4 v13, 0x0

    :goto_18
    const/4 v14, 0x0

    :goto_19
    const/4 v15, 0x0

    :goto_1a
    const/16 v16, 0x0

    goto :goto_22

    .line 155
    :catch_f
    move-exception v0

    move-object v3, v5

    move-object v2, v14

    :goto_1b
    const/4 v9, 0x0

    :goto_1c
    const/4 v13, 0x0

    :goto_1d
    const/4 v14, 0x0

    :goto_1e
    const/4 v15, 0x0

    :goto_1f
    const/16 v16, 0x0

    .line 156
    :goto_20
    :try_start_15
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "RPC_FAIL modern="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v12, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 157
    throw v0
    :try_end_15
    .catchall {:try_start_15 .. :try_end_15} :catchall_10

    .line 159
    :catchall_10
    move-exception v0

    :goto_21
    move-object v1, v0

    :goto_22
    invoke-virtual {v7}, Landroid/os/Parcel;->recycle()V

    .line 160
    invoke-virtual {v2}, Landroid/os/Parcel;->recycle()V

    .line 161
    if-eqz v15, :cond_1b

    :try_start_16
    invoke-virtual {v15}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_16
    .catch Ljava/io/IOException; {:try_start_16 .. :try_end_16} :catch_10

    goto :goto_23

    :catch_10
    move-exception v0

    invoke-static {v12, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 162
    :cond_1b
    :goto_23
    invoke-static/range {v16 .. v16}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeImage(Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 163
    invoke-static {v13}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeImages([Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 164
    invoke-static {v14}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeImages([Lcom/nothing/algolib/cameraufs/NtCamUfsImage;)V

    .line 165
    invoke-static {v9}, Lcom/anx/camera/bridge/Nos41UfsBridge;->closeRequestBuffers(Lcom/nothing/algolib/cameraufs/NtCamUfsRequest;)V

    .line 166
    throw v1

    .line 44
    :cond_1c
    :goto_24
    invoke-super/range {p0 .. p4}, Landroid/os/Binder;->onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result v0

    return v0
.end method
