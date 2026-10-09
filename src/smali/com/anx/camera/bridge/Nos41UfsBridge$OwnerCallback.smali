.class final Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;
.super Landroid/os/Binder;
.source "Nos41UfsBridge.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/anx/camera/bridge/Nos41UfsBridge;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "OwnerCallback"
.end annotation


# instance fields
.field private final callback:Landroid/os/IBinder;

.field private final context:Landroid/content/Context;


# direct methods
.method constructor <init>(Landroid/content/Context;Landroid/os/IBinder;)V
    .locals 0

    .line 172
    invoke-direct {p0}, Landroid/os/Binder;-><init>()V

    iput-object p1, p0, Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;->context:Landroid/content/Context;

    iput-object p2, p0, Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;->callback:Landroid/os/IBinder;

    return-void
.end method


# virtual methods
.method protected onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 174
    const v0, 0x5f4e5446

    const-string v1, "com.nothing.algolib.cameraufs.INtCamUfsCallback"

    const/4 v2, 0x1

    if-ne p1, v0, :cond_1

    if-eqz p3, :cond_0

    invoke-virtual {p3, v1}, Landroid/os/Parcel;->writeString(Ljava/lang/String;)V

    :cond_0
    return v2

    .line 175
    :cond_1
    if-eq p1, v2, :cond_2

    iget-object v0, p0, Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;->callback:Landroid/os/IBinder;

    invoke-interface {v0, p1, p2, p3, p4}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result p1

    return p1

    .line 176
    :cond_2
    invoke-virtual {p2, v1}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 177
    sget-object p1, Lcom/nothing/algolib/cameraufs/NtCamUfsResult;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {p2, p1}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/nothing/algolib/cameraufs/NtCamUfsResult;

    .line 178
    sget-object v0, Lcom/nothing/algolib/cameraufs/INtCamJpeg;->CREATOR:Landroid/os/Parcelable$Creator;

    invoke-virtual {p2, v0}, Landroid/os/Parcel;->readTypedObject(Landroid/os/Parcelable$Creator;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lcom/nothing/algolib/cameraufs/INtCamJpeg;

    .line 179
    invoke-static {}, Landroid/os/Parcel;->obtain()Landroid/os/Parcel;

    move-result-object v0

    .line 181
    if-eqz p1, :cond_3

    :try_start_0
    iget-object v3, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsResult;->photoUri:Ljava/lang/String;

    if-eqz v3, :cond_3

    .line 182
    iget-object v3, p0, Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;->context:Landroid/content/Context;

    iget-object v4, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsResult;->photoUri:Ljava/lang/String;

    invoke-static {v4}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v4

    invoke-static {v3, v4}, Lcom/anx/camera/bridge/PhotoOutputProvider;->resolve(Landroid/content/Context;Landroid/net/Uri;)Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v3}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v3

    iput-object v3, p1, Lcom/nothing/algolib/cameraufs/NtCamUfsResult;->photoUri:Ljava/lang/String;

    goto :goto_0

    .line 189
    :catchall_0
    move-exception p1

    goto :goto_1

    .line 184
    :cond_3
    :goto_0
    invoke-virtual {v0, v1}, Landroid/os/Parcel;->writeInterfaceToken(Ljava/lang/String;)V

    .line 185
    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 186
    invoke-virtual {v0, p2, v1}, Landroid/os/Parcel;->writeTypedObject(Landroid/os/Parcelable;I)V

    .line 187
    iget-object p1, p0, Lcom/anx/camera/bridge/Nos41UfsBridge$OwnerCallback;->callback:Landroid/os/IBinder;

    invoke-interface {p1, v2, v0, p3, p4}, Landroid/os/IBinder;->transact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 189
    invoke-virtual {v0}, Landroid/os/Parcel;->recycle()V

    .line 190
    if-eqz p2, :cond_4

    iget-object p3, p2, Lcom/nothing/algolib/cameraufs/INtCamJpeg;->jpegMemory:Landroid/os/SharedMemory;

    if-eqz p3, :cond_4

    iget-object p2, p2, Lcom/nothing/algolib/cameraufs/INtCamJpeg;->jpegMemory:Landroid/os/SharedMemory;

    invoke-virtual {p2}, Landroid/os/SharedMemory;->close()V

    .line 187
    :cond_4
    return p1

    .line 189
    :goto_1
    invoke-virtual {v0}, Landroid/os/Parcel;->recycle()V

    .line 190
    if-eqz p2, :cond_5

    iget-object p3, p2, Lcom/nothing/algolib/cameraufs/INtCamJpeg;->jpegMemory:Landroid/os/SharedMemory;

    if-eqz p3, :cond_5

    iget-object p2, p2, Lcom/nothing/algolib/cameraufs/INtCamJpeg;->jpegMemory:Landroid/os/SharedMemory;

    invoke-virtual {p2}, Landroid/os/SharedMemory;->close()V

    .line 191
    :cond_5
    throw p1
.end method
