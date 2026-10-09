.class Lcom/anx/camera/bridge/CodecInstrumentation$1;
.super Landroid/os/Binder;
.source "CodecInstrumentation.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/anx/camera/bridge/CodecInstrumentation;->testRpcMapping()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$calls:[I


# direct methods
.method constructor <init>([I)V
    .locals 0

    .line 214
    iput-object p1, p0, Lcom/anx/camera/bridge/CodecInstrumentation$1;->val$calls:[I

    invoke-direct {p0}, Landroid/os/Binder;-><init>()V

    return-void
.end method


# virtual methods
.method public getInterfaceDescriptor()Ljava/lang/String;
    .locals 1

    .line 215
    const-string v0, "com.nothing.algolib.cameraufs.INtCamUfsSession"

    return-object v0
.end method

.method protected onTransact(ILandroid/os/Parcel;Landroid/os/Parcel;I)Z
    .locals 2

    .line 217
    invoke-virtual {p0}, Lcom/anx/camera/bridge/CodecInstrumentation$1;->getInterfaceDescriptor()Ljava/lang/String;

    move-result-object p4

    invoke-virtual {p2, p4}, Landroid/os/Parcel;->enforceInterface(Ljava/lang/String;)V

    .line 218
    const/16 p4, 0xc

    const/4 v0, 0x0

    const/4 v1, 0x1

    if-ne p1, p4, :cond_0

    invoke-virtual {p2}, Landroid/os/Parcel;->dataAvail()I

    move-result p1

    if-nez p1, :cond_0

    move p1, v1

    goto :goto_0

    :cond_0
    move p1, v0

    :goto_0
    const-string p2, "Only old getProcessingNumber RPC forwarded"

    invoke-static {p1, p2}, Lcom/anx/camera/bridge/CodecInstrumentation;->access$000(ZLjava/lang/String;)V

    .line 219
    iget-object p1, p0, Lcom/anx/camera/bridge/CodecInstrumentation$1;->val$calls:[I

    aget p2, p1, v0

    add-int/2addr p2, v1

    aput p2, p1, v0

    .line 220
    invoke-virtual {p3}, Landroid/os/Parcel;->writeNoException()V

    .line 221
    const/4 p1, 0x7

    invoke-virtual {p3, p1}, Landroid/os/Parcel;->writeInt(I)V

    .line 222
    return v1
.end method
